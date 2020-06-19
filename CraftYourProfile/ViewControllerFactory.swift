//
//  ViewControllerFactory.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 09.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ViewControllerFactory {

    func makeRootViewController() -> UIViewController {
        let viewController = WelcomeViewController(self)
        return viewController
    }

    func makeVerifyPhoneViewController() -> UIViewController {
        let viewConroller = VerifyPhoneViewController(self)
        return viewConroller
    }

    func makeCountryCodeViewController(_ delegate: CountryCodeViewControllerDelegate) -> UIViewController {
        let viewController = CountryCodeViewController(delegate: delegate)
        return viewController
    }

    func makeVerifyPinCodeViewController() -> UIViewController {
        let viewController = VerifyPinCodeViewController(self)
        return viewController
    }

    func makeIntroduceYourselfViewController() -> UIViewController {
        let viewController = IntroduceYourselfViewController(self)
        return viewController
    }

    func makeAddProfilePhotoViewController() -> UIViewController {
        let viewController = AddProfilePhotoViewController()
        return viewController
    }
}
