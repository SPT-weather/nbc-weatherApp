//
//  SettingsViewModel.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/8/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SettingsViewModel {
    
    var themeMode = BehaviorRelay<ThemeMode>(value: .light)
    
    func toggleMode(to mode: ThemeMode) {
            themeMode.accept(mode)
        }
    
    
}

enum TemperatureUnit: Int {
    case celsius = 0
    case fahrenheit
}

enum WindSpeedUnit: Int {
    case metersPerSecond = 0
    case kilometersPerHour
    case milesPerHour
}

enum ThemeMode: Int {
    case light = 0
    case dark
}

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
