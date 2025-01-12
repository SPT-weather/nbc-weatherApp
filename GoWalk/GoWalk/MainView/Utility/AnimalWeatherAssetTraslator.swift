//
//  AnimalWeatherAssetTraslator.swift
//  GoWalk
//
//  Created by 0-jerry on 1/12/25.
//

import UIKit.UIImage

enum AnimalWeatherAssetTraslator {
    static func transform(_ weather: TempWeather) -> UIImage {
//        let animal =
        switch weather {
        case .cloudy: return .puppy
        case .sunny: return .puppy
        }
    }
}
