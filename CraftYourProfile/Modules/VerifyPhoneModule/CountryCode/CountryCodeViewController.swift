//
//  CountryCodeViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 08.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol CountryCodeViewControllerDelegate: AnyObject {

    func getCountryCodes(with filter: String?) -> [CountryCode]
    func didSelectItemAt(index: Int)
}

class CountryCodeViewController: UIViewController {

    private enum Section: CaseIterable {
        case main
    }

    private let searchBar = UISearchBar(frame: .zero)
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, CountryCode>!
    weak var delegate: CountryCodeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
}

extension CountryCodeViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <Section, CountryCode>(collectionView: collectionView,
                                   cellProvider: { (collectionView, indexPath, countryCode) -> UICollectionViewCell? in
                                    // swiftlint:disable line_length
                                    guard let countryCodeCell =
                                        collectionView.dequeueReusableCell(withReuseIdentifier: CountryCodeCell.reuseIdentifier,
                                                                           for: indexPath) as? CountryCodeCell else {
                                                                            fatalError("Cannot create new cell")
                                    }
                                    // swiftlint:enable line_length

                                    let urlString = String(format: "https://www.countryflags.io/%@/flat/32.png",
                                                           countryCode.shortName)

                                    countryCodeCell.setupCell(code: countryCode.code,
                                                              country: countryCode.name,
                                                              imageUrl: urlString)
                                    return countryCodeCell
            })
    }

    private func configureHierarchy() {
        view.backgroundColor = .white
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(CountryCodeCell.self, forCellWithReuseIdentifier: CountryCodeCell.reuseIdentifier)
        view.addSubview(collectionView)
        view.addSubview(searchBar)

        let views = ["cv": collectionView, "searchBar": searchBar]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[cv]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[searchBar]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:[searchBar]-10-[cv]|", options: [], metrics: nil, views: views))
        constraints.append(searchBar.topAnchor.constraint(
            equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0))
        NSLayoutConstraint.activate(constraints)
        self.collectionView = collectionView

        collectionView.delegate = self
        searchBar.delegate = self
    }

    private func performQuery(with filter: String?) {
        guard let codes = delegate?.getCountryCodes(with: filter) else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, CountryCode>()
        snapshot.appendSections([.main])
        snapshot.appendItems(codes)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func createLayout() -> UICollectionViewLayout {
        // swiftlint:disable line_length
        let layout =
            UICollectionViewCompositionalLayout { (_ sectionIndex: Int, _ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
                // swiftlint:enable line_length
                let columns = 1
                let spacing = CGFloat(5)
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(40))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
                group.interItemSpacing = .fixed(spacing)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

                return section
        }
        return layout
    }
}

// MARK: UISearchBarDelegate
extension CountryCodeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}

// MARK: UICollectionViewDelegate
extension CountryCodeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        self.dismiss(animated: true) {
            self.searchBar.resignFirstResponder()
            self.delegate?.didSelectItemAt(index: indexPath.row)
        }
    }
}
