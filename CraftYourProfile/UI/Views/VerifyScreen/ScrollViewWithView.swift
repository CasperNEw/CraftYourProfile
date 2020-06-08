//
//  ScrollViewWithView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 03.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ScrollViewWithView: UIScrollView {

    var view: VerifyPhoneView?

    override init(frame: CGRect) {
        super.init(frame: frame)

        view = VerifyPhoneView(frame: frame)
        addMainSubview(view)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        backgroundColor = .clear
        indicatorStyle = .white
        isScrollEnabled = true
    }
}
