//
//  WeatherAssetTranslator.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/8/25.
//

import UIKit.UIImage

enum WeatherAssetTranslator {
    static func resourceImage(from weather: TempWeather) -> UIImage? {
        switch weather {
        case .sunny:
            return UIImage(systemName: "sun.max")
        case .cloudy:
            return UIImage(systemName: "cloud.fill")
        }
    }
}
