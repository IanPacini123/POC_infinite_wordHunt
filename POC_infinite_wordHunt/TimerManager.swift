//
//  TimerManager.swift
//  POC_infinite_wordHunt
//
//  Created by Ian Pacini on 10/07/24.
//

import SwiftUI

@Observable
class TimerManager: ObservableObject {
    var timeRemaining: TimeInterval
    var timer: Timer?

    init(initialTime: TimeInterval) {
        self.timeRemaining = initialTime
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer?.invalidate()
            timer = nil
        }
    }

    func appendTime(_ additionalTime: TimeInterval) {
        timeRemaining += additionalTime
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
