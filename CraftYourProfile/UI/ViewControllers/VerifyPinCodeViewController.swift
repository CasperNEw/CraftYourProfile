//
//  VerifyPinCodeViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class VerifyPinCodeViewController: UIViewController {

// MARK: Init
    private var mainView: ScrollViewContainer? { return self.view as? ScrollViewContainer }
    private var viewControllerFactory: ViewControllerFactory?

    lazy var resizeScrollView: ResizeScrollViewService = {
        let resizeScrollView = ResizeScrollViewService(view: self.view)
        return resizeScrollView
    }()

    init(_ factory: ViewControllerFactory? = nil) {

        self.viewControllerFactory = factory

        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: lifeCycle
    override func loadView() {
        self.view = ScrollViewContainer(frame: UIScreen.main.bounds, type: VerifyPinCodeView.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resizeScrollView.setupKeyboard()
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
