//
//  TimerService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 31.07.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

class TimerService {

    // MARK: - Properties
    enum TimerStatus {
        case fire(_ value: Int)
        case expired
    }

    var timerCompletion: ((TimerStatus) -> Void)?
    private var currentDuration: Int = 20

    // MARK: - Public function
    public func startTimer(with duration: Int) {

        var seconds = duration
        let timer = Timer(timeInterval: 1, repeats: true) { timer in

            seconds -= 1
            if seconds == 0 {
                self.timerCompletion?(.expired)
                timer.invalidate()
                return
            }
            self.timerCompletion?(.fire(seconds))
        }

        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }
}
