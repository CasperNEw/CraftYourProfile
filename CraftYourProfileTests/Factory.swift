//
//  Factory.swift
//  CraftYourProfileTests
//
//  Created by Дмитрий Константинов on 22.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import XCTest
@testable import CraftYourProfile

class MockViewController: CountryCodeViewControllerDelegate {
    func getCountryCodes(with filter: String?) -> [CountryCode] {
        return []
    }

    func didSelectItemAt(index: Int) {
        return
    }
}

class Factory: XCTestCase {

    var factory: ViewControllerFactory!
    var mockViewController: MockViewController!

    override func setUp() {
        factory = ViewControllerFactory()
        mockViewController = MockViewController()
    }

    override func tearDown() {
        factory = nil
        mockViewController = nil
    }

    func testСonformity() {
        let welcomeVC = factory.makeRootViewController()
        let verifyPhoneVC = factory.makeVerifyPhoneViewController()
        let countryCodeVC = factory.makeCountryCodeViewController(mockViewController)
        let verifyPinCodeVC = factory.makeVerifyPinCodeViewController()
        let introduceYourselfVC = factory.makeIntroduceYourselfViewController()
        let addProfilePhotoVC = factory.makeAddProfilePhotoViewController()

        XCTAssertTrue(welcomeVC is WelcomeViewController)
        XCTAssertTrue(welcomeVC.view is WelcomeView)
        XCTAssertNotNil((welcomeVC.view as? WelcomeView)?.delegate)

        XCTAssertTrue(verifyPhoneVC is VerifyPhoneViewController)
        XCTAssertTrue(verifyPhoneVC.view is ScrollViewContainer)
        XCTAssertNotNil(((verifyPhoneVC.view as? ScrollViewContainer)?.view as? VerifyPhoneView)?.delegate)

        XCTAssertTrue(countryCodeVC is CountryCodeViewController)

        XCTAssertTrue(verifyPinCodeVC is VerifyPinCodeViewController)
        XCTAssertTrue(verifyPinCodeVC.view is ScrollViewContainer)
        XCTAssertNotNil(((verifyPinCodeVC.view as? ScrollViewContainer)?.view as? VerifyPinCodeView)?.delegate)

        XCTAssertTrue(introduceYourselfVC is IntroduceYourselfViewController)
        XCTAssertTrue(introduceYourselfVC.view is ScrollViewContainer)
        XCTAssertNotNil(((introduceYourselfVC.view as? ScrollViewContainer)?.view as? IntroduceYourselfView)?.delegate)

        XCTAssertTrue(addProfilePhotoVC is AddProfilePhotoViewController)
        XCTAssertTrue(addProfilePhotoVC.view is AddProfilePhotoView)
        XCTAssertNotNil((addProfilePhotoVC.view as? AddProfilePhotoView)?.delegate)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil((verifyPhoneVC as? VerifyPhoneViewController)?.popOver)
            XCTAssertNotNil((addProfilePhotoVC as? AddProfilePhotoViewController)?.imagePicker)
        }
    }
}
