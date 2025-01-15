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
        guard let image = UIImage(named: weather.icon)?.withTintColor(.label) else {
            return ._01D }
        return image
    }
}
