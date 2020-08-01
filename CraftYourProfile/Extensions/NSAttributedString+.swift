//
//  NSAttributedString+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

extension NSAttributedString {

    static func makeHyperlinks(for couples: [(String, String)], in text: String) -> NSAttributedString {

        let nsString = NSString(string: text)
        let attributedString = NSMutableAttributedString(string: text)

        for couple in couples {
            let substringRange = nsString.range(of: couple.0)
            attributedString.addAttribute(.link, value: couple.1, range: substringRange)
        }

        return attributedString
    }
}
