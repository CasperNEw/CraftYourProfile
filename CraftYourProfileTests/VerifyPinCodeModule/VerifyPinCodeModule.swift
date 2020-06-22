//
//  VerifyPinCodeModule.swift
//  CraftYourProfileTests
//
//  Created by Дмитрий Константинов on 22.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import XCTest
@testable import CraftYourProfile

class MockVerifyPinCodeView: VerifyPinCodeViewUpdater {

    var tested = [false, false, false, false, false]

    func updateResendCodeLabel(with timer: Int) {
        tested[0] = true
    }

    func updateResendCodeLabel(with text: String) {
        tested[1] = true
    }

    func hideResendCodeLabel() {
        tested[2] = true
    }

    func hideResendCodeButton() {
        tested[3] = true
    }

    func shakePinCodeView() {
        tested[4] = true
    }
}

class MockVerifyPinCodeViewController: VerifyPinCodeViewDelegate {

    var tested = [false, false, false]

    func backButtonTapped() {
        tested[0] = true
    }

    func resendCodeButtonTapped() {
        tested[1] = true
    }

    func didFinishedEnterCode(_ code: String) {
        tested[2] = true
    }
}

class VerifyPinCodeModule: XCTestCase {

    var factory: ViewControllerFactory!
    var view: UIView!
    var viewUpdater: MockVerifyPinCodeView!
    var viewController: VerifyPinCodeViewController!

    var verifyPinCodeView: VerifyPinCodeView!
    var mockViewController: MockVerifyPinCodeViewController!

    override func setUp() {

        factory = ViewControllerFactory()
        view = UIView()
        viewUpdater = MockVerifyPinCodeView()
        viewController = VerifyPinCodeViewController(factory: factory,
                                                     view: view,
                                                     viewUpdater: viewUpdater)

        mockViewController = MockVerifyPinCodeViewController()
        verifyPinCodeView = VerifyPinCodeView()
        verifyPinCodeView.delegate = mockViewController
    }

    override func tearDown() {
        factory = nil
        view = nil
        viewUpdater = nil
        viewController = nil
    }

    func testModule() {

        viewController.viewDidAppear(true)
        XCTAssertTrue(viewUpdater.tested[4])
        viewController.viewDidDisappear(true)
        XCTAssertTrue(viewUpdater.tested[3])
        XCTAssertTrue(!viewUpdater.tested[0])

        verifyPinCodeView.backButtonTapped()
        verifyPinCodeView.resendCodeButtonTapped()

        XCTAssertTrue(mockViewController.tested[0])
        XCTAssertTrue(mockViewController.tested[1])
        XCTAssertTrue(!mockViewController.tested[2])
    }
}
