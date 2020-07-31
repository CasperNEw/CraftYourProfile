//
//  ViewControllerFactory.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 09.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ViewControllerFactory {

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
