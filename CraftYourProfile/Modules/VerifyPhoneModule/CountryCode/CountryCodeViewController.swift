//
//  CountryCodeViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 08.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol CountryCodeViewControllerDelegate: AnyObject {
    func didSelectItem(code: CountryCode)
}

class CountryCodeViewController: UIViewController {

    // MARK: - Properties
    private enum Section: CaseIterable {
        case main
    }

    private let searchBar = UISearchBar(frame: .zero)
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, CountryCode>!
    weak var delegate: CountryCodeViewControllerDelegate?

    var networkService: NetworkServiceCountriesProtocol?

    private var countryCodes: [CountryCode] = []
    private var sourceCodes: [CountryCode] = [] {
        didSet { performQuery(with: nil) }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)

        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    // MARK: - Module function
    private func loadData() {

        networkService?
            .getCountriesInformation(completion: { [weak self] result in

            switch result {
            case .success(let data):
                self?.makeCountryCodesFromNetworkData(data)
            case .failure(let error):
                self?.showAlert(with: "Network Error", and: error.localizedDescription)
            }
        })
    }

    private func makeCountryCodesFromNetworkData(_ source: [CountryFromServer]) {

        var countryCodes: Set<CountryCode> = []

        let item = DispatchWorkItem {
            for country in source {
                for code in country.callingCodes {
                    countryCodes.insert(CountryCode(code: "+" + code,
                                                    name: country.name,
                                                    shortName: country.alpha2Code))
                }
            }
        }

        item.notify(queue: DispatchQueue.main) {
            self.sourceCodes = countryCodes.sorted { $0.name < $1.name }
            self.countryCodes = countryCodes.sorted { $0.name < $1.name }
        }

        DispatchQueue.global(qos: .userInitiated).async(execute: item)
    }
}

// MARK: - CollectionView
extension CountryCodeViewController {

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <Section, CountryCode>(collectionView: collectionView,
                                   cellProvider: { (collectionView, indexPath, countryCode) -> UICollectionViewCell? in

            let countryCodeCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: CountryCodeCell.identifier,
                                     for: indexPath) as? CountryCodeCell

            countryCodeCell?.imageService = NetworkService()
            countryCodeCell?.setupCell(code: countryCode.code,
                                       country: countryCode.name,
                                       shortCode: countryCode.shortName)

            return countryCodeCell
        })
    }

    private func configureHierarchy() {

        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(CountryCodeCell.self, forCellWithReuseIdentifier: CountryCodeCell.identifier)
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

    private func performQuery(with searchText: String?) {
        let codes = filterCodes(searchText: searchText ?? "")
        var snapshot = NSDiffableDataSourceSnapshot<Section, CountryCode>()
        snapshot.appendSections([.main])
        snapshot.appendItems(codes)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func filterCodes(searchText: String) -> [CountryCode] {

        if !searchText.isEmpty {
            countryCodes = sourceCodes.filter { $0.description.lowercased().contains(searchText.lowercased()) }
        } else {
            countryCodes = sourceCodes
        }
        return countryCodes
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

// MARK: - UISearchBarDelegate
extension CountryCodeViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}

// MARK: - UICollectionViewDelegate
extension CountryCodeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        self.dismiss(animated: true) {
            self.searchBar.resignFirstResponder()
            self.delegate?.didSelectItem(code: self.countryCodes[indexPath.row])
        }
    }
}
