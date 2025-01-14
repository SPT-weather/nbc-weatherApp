//
//  AnimalWeatherAssetTraslator.swift
//  GoWalk
//
//  Created by 0-jerry on 1/12/25.
//

import UIKit.UIImage
// 날씨 -> 동물 이미지 변환
enum WeatherAnimalAssetTraslator {
    static func transform(_ weatherDTO: WeatherDTO) -> UIImage {
        let weather = WeatherType(iconID: weatherDTO.icon)
        switch weather {
        default: return .puppy
        }
    }
}
