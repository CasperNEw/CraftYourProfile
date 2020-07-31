//
//  ScrollViewContainer.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 09.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ScrollViewContainer: UIView {

    var scrollView: UIScrollView?
    var view: UIView?

    lazy var scrollService: ResizeScrollViewService = {
        let service = ResizeScrollViewService(view: self)
        return service
    }()

    convenience init(with view: UIView) {
        self.init(frame: UIScreen.main.bounds)
        self.view = view
        configure(with: view)
        scrollService.setupKeyboard()

        self.backgroundColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    private func configure(with view: UIView) {

        scrollView = UIScrollView()
        addMainSubviewInSafeArea(scrollView)
        scrollView?.addMainSubview(view)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            view.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor)
        ])

        backgroundColor = .clear
        scrollView?.backgroundColor = .clear
        scrollView?.indicatorStyle = .white
        scrollView?.isScrollEnabled = true
     }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
