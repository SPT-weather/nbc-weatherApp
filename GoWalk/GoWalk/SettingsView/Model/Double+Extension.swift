//
//  Double+Extension.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/9/25.
//

import Foundation

extension Double {
    func toFahrenheit() -> Double {
        return self * 9 / 5 + 32
    }

    func toCelsius() -> Double {
        return (self - 32) * 5 / 9
    }

    // 계산된 값 반올림 반환
    func toRoundedTemperature(unit: TemperatureUnit) -> Int {
        switch unit {
        case .celsius:
            return Int(self.rounded())
        case .fahrenheit:
            return Int(self.toFahrenheit().rounded())
        }
    }
}
