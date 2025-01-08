//
//  SettingsViewModel.swift
//  GoWalk
//
//  Created by 박민석 on 1/8/25.
//

import Foundation
import RxSwift
import RxCocoa

class SettingsViewModel {

    var themeMode = BehaviorRelay<ThemeMode>(value: UserDefaults.standard.themeMode)
    var temperature = BehaviorRelay<TemperatureUnit>(value: UserDefaults.standard.temperatureUnit)
    var windSpeed = BehaviorRelay<WindSpeedUnit>(value: UserDefaults.standard.windSpeedUnit)

    func toggleMode(to mode: ThemeMode) {
        themeMode.accept(mode)
        UserDefaults.standard.themeMode = mode
    }

    func tapTemperature(to unit: TemperatureUnit) {
        temperature.accept(unit)
        UserDefaults.standard.temperatureUnit = unit
    }

    func tapWindSpeed(to unit: WindSpeedUnit) {
        windSpeed.accept(unit)
        UserDefaults.standard.windSpeedUnit = unit
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
