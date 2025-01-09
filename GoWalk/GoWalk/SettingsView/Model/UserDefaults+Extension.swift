//
//  UserDefaults+Extension.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/9/25.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let themeMode = "themeMode"
        static let temperatureUnit = "temperatureUnit"
        static let windSpeedUnit = "windSpeedUnit"
    }

    var themeMode: ThemeMode {
        get {
            let rawValue = integer(forKey: Keys.themeMode)
            return ThemeMode(rawValue: rawValue) ?? .light
        }
        set {
            set(newValue.rawValue, forKey: Keys.themeMode)
        }
    }

    var temperatureUnit: TemperatureUnit {
        get {
            let rawValue = integer(forKey: Keys.temperatureUnit)
            return TemperatureUnit(rawValue: rawValue) ?? .celsius
        }
        set {
            set(newValue.rawValue, forKey: Keys.temperatureUnit)
        }
    }

    var windSpeedUnit: WindSpeedUnit {
        get {
            let rawValue = integer(forKey: Keys.windSpeedUnit)
            return WindSpeedUnit(rawValue: rawValue) ?? .metersPerSecond
        }
        set {
            set(newValue.rawValue, forKey: Keys.windSpeedUnit)
        }
    }
}
