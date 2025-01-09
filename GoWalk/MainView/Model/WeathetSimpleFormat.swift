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
    private let currentTemperature: Int
    private let temperature: (highest: Int, lowest: Int)
    var currentTempDescription: String {
        return "현재온도: " + TemperatureFormatter.current(currentTemperature)
    }
    var highestTempDescription: String {
        return TemperatureFormatter.simple(temperature.highest)
    }
    var lowestTempDescription: String {
        return TemperatureFormatter.simple(temperature.lowest)
    }
    init(location: String,
         weather: TemporaryWeather,
         currentTemperature: Int,
         highestTemperature: Int,
         lowestTemperature: Int) {
        self.location = location
        self.weather = weather
        self.currentTemperature = currentTemperature
        self.temperature = (highest: highestTemperature,
                            lowest: lowestTemperature)
    }
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
}
