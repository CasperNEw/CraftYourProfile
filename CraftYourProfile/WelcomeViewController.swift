//
//  WelcomeViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        // Do any additional setup after loading the view.
    }
}

// MARK: SwiftUI
import SwiftUI

struct WelcomeVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let welcomeVC = WelcomeViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<WelcomeVCProvider.ContainerView>) -> WelcomeViewController {
            return welcomeVC
        }
        func updateUIViewController(_ uiViewController: WelcomeVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<WelcomeVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
