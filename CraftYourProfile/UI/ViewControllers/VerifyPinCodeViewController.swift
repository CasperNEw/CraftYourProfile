//
//  VerifyPinCodeViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class VerifyPinCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
    }
}

// MARK: SwiftUI
import SwiftUI

struct VerifyPinCodeVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let verifyPinCodeVC = VerifyPinCodeViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<VerifyPinCodeVCProvider.ContainerView>) -> VerifyPinCodeViewController {
            return verifyPinCodeVC
        }
        func updateUIViewController(_ uiViewController: VerifyPinCodeVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<VerifyPinCodeVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
