//
//  WeatherSimple.swift
//  GoWalk
//
//  Created by 0-jerry on 1/8/25.
//

import Foundation

struct WeatherSimple {
    let location: String
    let weather: TempWeather

    static let failure = WeatherSimple(location: "업데이트 실패",
                                         weather: .sunny)

}
