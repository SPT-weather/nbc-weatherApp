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
    var petType = BehaviorRelay<PetType>(value: UserDefaults.standard.petType)

    func updateMode(to mode: ThemeMode) {
        themeMode.accept(mode)
        UserDefaults.standard.themeMode = mode
    }

    func updateTemperatureUnit(to unit: TemperatureUnit) {
        temperatureUnit.accept(unit)
        UserDefaults.standard.temperatureUnit = unit
    }

    func updatePetType(to type: PetType) {
        petType.accept(type)
        UserDefaults.standard.petType = type
    }

    // 온도 단위 변환 클래스
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
