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

    static var currentTimer: Timer?
    var timerCompletion: ((TimerStatus) -> Void)?

    // MARK: - Public function
    public func startTimer(with duration: Int) {

        TimerService.currentTimer?.invalidate()

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
        TimerService.currentTimer = timer
        RunLoop.current.add(timer, forMode: .common)
    }
}
