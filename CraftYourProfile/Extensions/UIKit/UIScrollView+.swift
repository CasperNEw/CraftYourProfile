//
//  UIScrollView+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 09.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIScrollView {

    func getContentInset() -> UIEdgeInsets? {
        return self.contentInset
    }

    func setContentInset(_ contentInset: UIEdgeInsets?) {
        guard let contentInset = contentInset else { return }
        self.contentInset = contentInset
    }
}
