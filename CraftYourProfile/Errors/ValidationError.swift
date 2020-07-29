//
//  ValidationError.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 29.07.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

enum ValidationError: Error {
    case serverError(error: Error)
}

extension ValidationError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .serverError(let error):
            return "Server error - \(error.localizedDescription)"
        }
    }
}
