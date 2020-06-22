//
//  WelcomeModule.swift
//  CraftYourProfileTests
//
//  Created by Дмитрий Константинов on 21.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import XCTest
@testable import CraftYourProfile

class MockWelcomeViewController: WelcomeViewDelegate {
    var testTapped = [false, false, false, false]

    func letsGoButtonTapped() {
        testTapped[0] = true
    }

    func circleButtonTapped() {
        testTapped[1] = true
    }

    func safariButtonTapped() {
        testTapped[2] = true
    }

    func homeButtonTapped() {
        testTapped[3] = true
    }
}

class WelcomeModule: XCTestCase {

    var view: WelcomeView!
    var viewController: MockWelcomeViewController!

    override func setUp() {
        view = WelcomeView()
        viewController = MockWelcomeViewController()
        view.delegate = viewController
    }

    override func tearDown() {
        viewController = nil
        view = nil
    }

    func testTap() {
        view.testWelcomeViewTap()

        for tap in viewController.testTapped {
            XCTAssertTrue(tap)
        }
    }
}
