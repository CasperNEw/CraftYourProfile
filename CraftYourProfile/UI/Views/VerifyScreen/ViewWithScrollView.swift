//
//  ViewWithScrollView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 04.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ViewWithScrollView: UIView {

    var scrollView: ScrollViewWithView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        scrollView = ScrollViewWithView(frame: frame)
        addMainSubviewInSafeArea(scrollView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
