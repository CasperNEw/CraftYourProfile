//
//  IntroduceYourselfViewDelegate.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 12.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol IntroduceYourselfViewDelegate: AnyObject {
    func backButtonTapped()
    func nextButtonTapped(_ nameTextField: UITextField, _ birthdayTextField: UITextField, _ date: Date)
}
