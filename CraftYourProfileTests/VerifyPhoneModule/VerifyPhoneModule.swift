//
//  VerifyPhoneModule.swift
//  CraftYourProfileTests
//
//  Created by Дмитрий Константинов on 22.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import XCTest
@testable import CraftYourProfile

class MockVerifyPhoneView: VerifyPhoneViewUpdater {

    var code: String = ""

    func setNewValue(string: String) {
        code = string
    }
}

class MockVerifyPhoneModelController: VerifyPhoneModelControllerProtocol {

    var data: [CountryCode] = []

    func networkErrorChecking(completion: (Error?) -> Void) {
        completion(NSError(domain: "", code: 113, userInfo: nil))
    }

    func reloadData() {
        data = [CountryCode(code: "+7", name: "Russia", shortName: "RU")]
    }

    func isValid(phone: String?, completion: @escaping (Error?) -> Void) -> Bool {
        return false
    }

    func getFormattedPhoneNumber(phone: String, completion: @escaping (Error?) -> Void) -> String {
        return "formatted"
    }

    func getCountryCodes(with filter: String?) -> [CountryCode] {
        return data
    }

    func getTheSelectedCode(at index: Int) -> String {
        if (index > 0) && (index < data.count) {
            return data[index].code
        }
        return ""
    }
}

class VerifyPhoneModule: XCTestCase {

    var factory: ViewControllerFactory!
    var model: MockVerifyPhoneModelController!
    var view: UIView!
    var viewUpdater: MockVerifyPhoneView!
    var viewController: VerifyPhoneViewController!
    var popOver: CountryCodeViewController!

    var networkService: NetworkService!
    var validationService: ValidationService!

    override func setUp() {
        factory = ViewControllerFactory()
        model = MockVerifyPhoneModelController()
        view = UIView()
        viewUpdater = MockVerifyPhoneView()
        viewController = VerifyPhoneViewController(factory: factory,
                                                   model: model,
                                                   view: view,
                                                   viewUpdater: viewUpdater)

        popOver = CountryCodeViewController(delegate: viewController)
        viewController.popOver = popOver

        networkService = NetworkService()
        validationService = ValidationService()
    }

    override func tearDown() {
        factory = nil
        model = nil
        view = nil
        viewUpdater = nil
        popOver = nil
        viewController = nil
        networkService = nil
        validationService = nil
    }

    func testModule() {

        XCTAssertEqual(model.data, [])
        model.reloadData()
        XCTAssertNotNil(viewController.getCountryCodes(with: ""))
        model.networkErrorChecking { error in
            XCTAssertTrue(error != nil)
        }
        XCTAssertNotNil(viewController.popOver)

        viewController.viewUpdater.setNewValue(string: "Foo")
        XCTAssertEqual(viewUpdater.code, "Foo")

        networkService.getCountriesInformation { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }

        validationService.isValid(phone: "9119119191", region: "+7") { result in
            switch result {
            case .success(let data):
                XCTAssertTrue(data)
            case .failure(let error):
                print(error)
            }
        }

        validationService.isValid(phone: "", region: "RU") { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }

        validationService.isValid(phone: "911911", region: "RU") { result in
            switch result {
            case .success(let data):
                XCTAssertTrue(!data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
