//
//  Weather.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/8/25.
//

import Foundation

// 날씨 타입 ( 이후 API 를 기반해 데이터 추가 설정 )
enum WeatherType {
    case clearSky
    case fewClouds
    case scatteredClouds
    case brokenClouds
    case showerRain
    case rain
    case thunderstorm
    case snow
    case mist

    var korean: String {
        switch self {
        case .clearSky:
            "맑음"
        case .fewClouds:
            "구름 약간"
        case .scatteredClouds:
            "구름"
        case .brokenClouds:
            "구름 많음"
        case .showerRain:
            "소나기"
        case .rain:
            "비"
        case .thunderstorm:
            "뇌우"
        case .snow:
            "눈"
        case .mist:
            "안개"
        }
    }

    init?(iconID: String) {
        guard let id = Int(iconID.filter {$0.isNumber}) else { return nil }
        switch id {
        case 1: self = .clearSky
        case 2: self = .fewClouds
        case 3: self = .scatteredClouds
        case 4: self = .brokenClouds
        case 9: self = .showerRain
        case 10: self = .rain
        case 11: self = .thunderstorm
        case 13: self = .snow
        case 50: self = .mist
        default: return nil
        }
    }
}
