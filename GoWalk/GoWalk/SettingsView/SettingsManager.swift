//
//  SettingsManager.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/11/25.
//

import Foundation

class SettingsManager {
    static let shared = SettingsManager()

    private init() {}

    // 변환된 온도 값을 반환
    func convertedTemperature(_ value: Double) -> String {
        let unit = UserDefaults.standard.temperatureUnit
        switch unit {
        case .celsius:
            return String(format: "%.1f", value) + "°C"
        case .fahrenheit:
            return String(format: "%.1f", value.toFahrenheit()) + "°F"
        }
    }

    // 현재 테마 모드 반환
    var themeMode: ThemeMode {
        return UserDefaults.standard.themeMode
    }

    // 현재 선택된 동물 이미지 종류 반환
    var petType: PetType {
        return UserDefaults.standard.petType
    }
}
