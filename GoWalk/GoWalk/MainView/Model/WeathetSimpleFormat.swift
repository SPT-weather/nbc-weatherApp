//
//  WeathetSimpleModel.swift
//  GoWalk
//
//  Created by 0-jerry on 1/8/25.
//

import Foundation

struct WeatherSimple {
    let location: String
    let weather: TemporaryWeather

    static let `default` = WeatherSimple(location: "",
                                         weather: .sunny)

}

struct TemperatureModel {
    private let currentTemperature: Int
    private let highestTemperature: Int
    private let lowestTemperature: Int

    var current: String {
        return "현재온도: " + TemperatureFormatter.current(currentTemperature)
    }
    var highest: String {
        return TemperatureFormatter.simple(highestTemperature)
    }
    var lowest: String {
        return TemperatureFormatter.simple(lowestTemperature)
    }

    init(currentTemperature: Int,
         highestTemperature: Int,
         lowestTemperature: Int) {
        self.currentTemperature = currentTemperature
        self.highestTemperature = highestTemperature
        self.lowestTemperature = lowestTemperature
    }

    static let `default` = TemperatureModel(currentTemperature: 0,
                                            highestTemperature: 0,
                                            lowestTemperature: 0)
}
