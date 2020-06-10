//
//  SceneDelegate.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var viewControllerFactory: ViewControllerFactory!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        viewControllerFactory = ViewControllerFactory()
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
//        let rootViewController = viewControllerFactory.makeRootViewController()
//        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = viewControllerFactory.makeVerifyPinCodeViewController()
        window?.makeKeyAndVisible()
    }
}
