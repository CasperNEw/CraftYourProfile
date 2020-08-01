//
//  UIViewController+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 08.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(with title: String,
                   and message: String,
                   completion: @escaping () -> Void = { }) {

        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }

        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
