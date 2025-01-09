//
//  SettingsManager.swift
//  GoWalk
//
//  Created by 박민석 on 1/9/25.
//

import Foundation
import RxSwift
import RxCocoa

class SettingsManager {

    static let shared = SettingsManager()

    private init() {}

    var themeMode = BehaviorRelay<ThemeMode>(value: UserDefaults.standard.themeMode)
    var temperatureUnit = BehaviorRelay<TemperatureUnit>(value: UserDefaults.standard.temperatureUnit)
    var windSpeedUnit = BehaviorRelay<WindSpeedUnit>(value: UserDefaults.standard.windSpeedUnit)

    func updateMode(to mode: ThemeMode) {
        themeMode.accept(mode)
        UserDefaults.standard.themeMode = mode
    }

    func updateTemperatureUnit(to unit: TemperatureUnit) {
        temperatureUnit.accept(unit)
        UserDefaults.standard.temperatureUnit = unit
    }

    func updateWidnSpeedUnit(to unit: WindSpeedUnit) {
        windSpeedUnit.accept(unit)
        UserDefaults.standard.windSpeedUnit = unit
    }

    func convertTemperature(_ value: Double) -> String {
        let currentUnit = temperatureUnit.value
        switch currentUnit {
        case .celsius:
            return String(format: "%.1f", value)
        case .fahrenheit:
            return String(format: "%.1f", value.toFahrenheit())
        }
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
