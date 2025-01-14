//
//  WeatherAssetTranslator.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/8/25.
//

import UIKit.UIImage
// 날씨 이미지 변환
enum WeatherAssetTranslator {
    static func resourceIcon(from weather: WeatherDTO) -> UIImage? {
        guard let iconID = Int(weather.icon.filter { $0.isNumber }) else { return nil }
        switch iconID {
        default: return UIImage(systemName: "sun.max")
        }
    }
}
