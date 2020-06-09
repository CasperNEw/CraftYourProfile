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

    convenience init(frame: CGRect, type: UIView.Type) {
        self.init(frame: frame)
        configure(frame: frame, type: type)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    private func configure(frame: CGRect, type: UIView.Type) {

        scrollView = UIScrollView(frame: frame)
        addMainSubviewInSafeArea(scrollView)
        view = type.init(frame: frame)
        scrollView?.addMainSubview(view)
        backgroundColor = .clear
        scrollView?.backgroundColor = .clear
        scrollView?.indicatorStyle = .white
        scrollView?.isScrollEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
