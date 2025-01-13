//
//  TempTemperature.swift
//  GoWalk
//
//  Created by 0-jerry on 1/12/25.
//

import Foundation
// 임시 온도 모델
struct TempTemperature {
    private let currentTemperature: Int
    private let highestTemperature: Int
    private let lowestTemperature: Int

    var current: String {
        return TemperatureFormatter.current(currentTemperature)
    }
    var highest: String {
        return TemperatureFormatter.simple(highestTemperature)
    }
    var lowest: String {
        return TemperatureFormatter.simple(lowestTemperature)
    }

    init(currentTemperature: Int,
         highestTemperature: Int,
         lowestTemperature: Int) {
        self.currentTemperature = currentTemperature
        self.highestTemperature = highestTemperature
        self.lowestTemperature = lowestTemperature
    }

    static let failure = TempTemperature(currentTemperature: 0,
                                            highestTemperature: 0,
                                            lowestTemperature: 0)
}
