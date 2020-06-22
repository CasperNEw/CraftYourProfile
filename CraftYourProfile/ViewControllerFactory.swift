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
        let view = WelcomeView()
        let viewController = WelcomeViewController(factory: self, view: view)
        view.delegate = viewController
        return viewController
    }

    func makeVerifyPhoneViewController() -> UIViewController {
        let modelController = VerifyPhoneModelController()
        let view = VerifyPhoneView()
        let mainView = ScrollViewContainer(with: view)
        let viewConroller = VerifyPhoneViewController(factory: self,
                                                      model: modelController,
                                                      view: mainView,
                                                      viewUpdater: view)
        view.delegate = viewConroller

        DispatchQueue.main.async {
            viewConroller.popOver = self.makeCountryCodeViewController(viewConroller)
        }

        return viewConroller
    }

    func makeCountryCodeViewController(_ delegate: CountryCodeViewControllerDelegate) -> UIViewController {
        let viewController = CountryCodeViewController(delegate: delegate)
        return viewController
    }

    func makeVerifyPinCodeViewController() -> UIViewController {
        let view = VerifyPinCodeView()
        let mainView = ScrollViewContainer(with: view)
        let viewController = VerifyPinCodeViewController(factory: self,
                                                         view: mainView,
                                                         viewUpdater: view)
        view.delegate = viewController
        return viewController
    }

    func makeIntroduceYourselfViewController() -> UIViewController {
        let view = IntroduceYourselfView()
        let mainView = ScrollViewContainer(with: view)
        let viewController = IntroduceYourselfViewController(factory: self,
                                                             view: mainView,
                                                             viewUpdater: view)
        view.delegate = viewController
        return viewController
    }

    func makeAddProfilePhotoViewController() -> UIViewController {
        let view = AddProfilePhotoView()
        let viewController = AddProfilePhotoViewController(factory: self,
                                                           view: view,
                                                           viewUpdater: view)
        view.delegate = viewController

        DispatchQueue.main.async {
            viewController.imagePicker = ImagePicker(presentationController: viewController,
                                                    delegate: viewController)
        }

        return viewController
    }
}
