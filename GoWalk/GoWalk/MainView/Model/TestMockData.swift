//
//  MockDataModel.swift
//  GoWalk
//
//  Created by 0-jerry on 1/9/25.
//

import Foundation
// 테스트용 데이터 
struct TestMockData {
    static let dust = TempDust(micro: 100,
                               fine: 100)
    static let temperatureFormatter = TempTemperature(currentTemperature: 13,
                                                       highestTemperature: 15,
                                                       lowestTemperature: -11)
    static let weather = WeatherSimple(location: "서울특별시",
                                       weather: .cloudy)
    static let testWeather = WeatherSimple(location: "작동확인",
                                           weather: .cloudy)
}
