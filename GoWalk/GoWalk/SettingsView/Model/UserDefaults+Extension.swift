//
//  UserDefaults+Extension.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/9/25.
//

import Foundation

//  UserDefaults에 저장된 값을 읽고 쓸 수 있도록 하는 extension
//  get 접근자로 UserDefaults에 저장된 정수 값을 읽고 해당 값을 커스텀 타입(ThemeMode, TemperatureUnit, PetType)으로 반환
//  set 접근자로 커스텀 타입의 값을 받아, 이를 정수 값으로 변환하여 UserDefaults에 저장

extension UserDefaults {
    private enum Keys {
        static let themeMode = "themeMode"
        static let temperatureUnit = "temperatureUnit"
        static let petType = "petType"
    }

    var themeMode: ThemeMode {
        get {
            let rawValue = integer(forKey: Keys.themeMode)
            return ThemeMode(rawValue: rawValue) ?? .system
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

    var petType: PetType {
        get {
            let rawValue = integer(forKey: Keys.petType)
            return PetType(rawValue: rawValue) ?? .dog
        }
        set {
            set(newValue.rawValue, forKey: Keys.petType)
        }
    }
}

enum TemperatureUnit: Int {
    case celsius = 0
    case fahrenheit
}

enum PetType: Int {
    case dog = 0
    case cat
}

enum ThemeMode: Int {
    case system = 0
    case light
    case dark
}
