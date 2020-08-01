//
//  ScrollViewContainer.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 09.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ScrollViewContainer: UIView {

    // MARK: - Properties
    public let scrollView: UIScrollView = {

        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.indicatorStyle = .white
        scrollView.isScrollEnabled = true
        return scrollView
    }()

    private var view: UIView?

    lazy var scrollService: ResizeScrollViewService = {
        let service = ResizeScrollViewService(view: self)
        return service
    }()

    // MARK: - Initialization
    convenience init(with view: UIView) {
        self.init()

        self.view = view
        setupConstraints(with: view)
        scrollService.setupKeyboard()
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    // MARK: - Module function
    private func setupConstraints(with view: UIView) {

        addSubviews([scrollView])
        scrollView.addSubviews([view])

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            view.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            view.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            view.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            view.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor)
        ])
     }
}
