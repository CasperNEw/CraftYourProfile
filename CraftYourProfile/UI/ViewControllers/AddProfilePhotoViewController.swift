//
//  AddProfilePhotoViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 12.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class AddProfilePhotoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemPink
    }
}

// MARK: SwiftUI
import SwiftUI

struct AddProfilePhotoVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let viewController = AddProfilePhotoViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<AddProfilePhotoVCProvider.ContainerView>) -> AddProfilePhotoViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: AddProfilePhotoViewController, context: UIViewControllerRepresentableContext<AddProfilePhotoVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
