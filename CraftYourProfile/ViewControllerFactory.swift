//
//  ViewControllerFactory.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 09.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ViewControllerFactory {

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
