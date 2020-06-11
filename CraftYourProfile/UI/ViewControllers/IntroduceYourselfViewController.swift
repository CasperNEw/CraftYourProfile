//
//  IntroduceYourselfViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 11.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class IntroduceYourselfViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
    }
}

// MARK: SwiftUI
import SwiftUI

struct IntroduceYourselfVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let viewController = IntroduceYourselfViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<IntroduceYourselfVCProvider.ContainerView>) -> IntroduceYourselfViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: IntroduceYourselfViewController, context: UIViewControllerRepresentableContext<IntroduceYourselfVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
