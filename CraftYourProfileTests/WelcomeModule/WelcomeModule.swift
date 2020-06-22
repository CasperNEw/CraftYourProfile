//
//  WelcomeModule.swift
//  CraftYourProfileTests
//
//  Created by Дмитрий Константинов on 21.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import XCTest
@testable import CraftYourProfile

class WelcomeModule: XCTestCase {

    var viewControllerFactory: ViewControllerFactory!
    var view: WelcomeView!
    var viewController: WelcomeViewController!

    override func setUp() {
        viewControllerFactory = ViewControllerFactory()
        viewController = WelcomeViewController(viewControllerFactory)
        view = WelcomeView(delegate: viewController)
        viewController.view = view
    }

    override func tearDown() {
        viewControllerFactory = nil
        viewController = nil
        view = nil
    }

    func testModuleIsNotNil() {
        XCTAssertNotNil(viewControllerFactory, "factory is not nil")
        XCTAssertNotNil(view, "view is not nil")
        XCTAssertNotNil(viewController, "viewController is not nil")
    }

    func testCorrectView() {
        XCTAssertEqual(viewController.view, view, "viewController received the correct view")
    }
}
