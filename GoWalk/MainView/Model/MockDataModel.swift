//
//  MockDataModel.swift
//  GoWalk
//
//  Created by 0-jerry on 1/9/25.
//

import Foundation

struct MockDataModel {
    static let temperatureFormatter = TemperatureModel(currentTemperature: 13,
                                                       highestTemperature: 15,
                                                       lowestTemperature: -11)
    static let weather = WeatherSimple(location: "서울특별시",
                                       weather: .cloudy,
                                       currentTemperature: 10,
                                       highestTemperature: 12,
                                       lowestTemperature: 0)
}
