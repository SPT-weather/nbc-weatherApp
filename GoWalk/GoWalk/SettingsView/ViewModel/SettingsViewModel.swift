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

    private let settingsManager = SettingsManager.shared

    var themeMode: BehaviorRelay<ThemeMode> {
        return settingsManager.themeMode
    }

    var temperatureUnit: BehaviorRelay<TemperatureUnit> {
        return settingsManager.temperatureUnit
    }

    var windSpeedUinit: BehaviorRelay<WindSpeedUnit> {
        return settingsManager.windSpeedUnit
    }

    func toggleMode(to mode: ThemeMode) {
        settingsManager.updateMode(to: mode)
    }

    func tapTemperature(to unit: TemperatureUnit) {
        settingsManager.updateTemperatureUnit(to: unit)
    }

    func tapWindSpeed(to unit: WindSpeedUnit) {
        settingsManager.updateWidnSpeedUnit(to: unit)
    }

}

