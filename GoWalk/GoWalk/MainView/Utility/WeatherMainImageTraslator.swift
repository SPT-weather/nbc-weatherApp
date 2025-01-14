//
//  AnimalWeatherAssetTraslator.swift
//  GoWalk
//
//  Created by 0-jerry on 1/12/25.
//

import UIKit.UIImage
// 날씨 -> 동물 이미지 변환
enum WeatherMainImageTraslator {
    static func animal() -> UIImage {
        return UserDefaults.standard.petType == .dog ? .dog : .cat
    }

    static func background(_ weatherDTO: WeatherDTO) -> UIImage? {
        guard let icon = Int(weatherDTO.icon.filter { $0.isNumber }) else { return nil }
        switch icon {
        case 1: return .sunny
        case 2, 3, 4: return .cloud
        case 9, 10: return .rain
        case 11: return .thunder
        case 13: return .snow
        case 50: return .mist
        default: return .yellowDust
        }
    }
}
