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

    func toKilometersPerHour() -> Double {
        return self * 3.6
    }

    func toMilesPerHour() -> Double {
        return self * 2.23694
    }

    func toMetersPerSecond() -> Double {
        return self / 3.6
    }
}
