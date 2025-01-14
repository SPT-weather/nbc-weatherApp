//
//  TempDust.swift
//  GoWalk
//
//  Created by 0-jerry on 1/9/25.
//

import Foundation
// 임시 미세먼지 모델
struct TempDust {
    let micro: Int
    let fine: Int

    static let failure = TempDust(micro: 0, fine: 0)
}

struct MainWeatherModel {
    let currentTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let weather: WeatherType
    let weatherString: String
}

// swiftlint:disable identifier_name
struct MainPollutionModel: Decodable {
    let micro: Double // 초 미세먼지
    let fine: Double // 미세먼지
    
    init(from air: AirPollutionDTO) {
        self.micro = air.pmTwoPointFive
        self.fine = air.pmTen
    }
    
    init(from pollutionComponents: PollutionComponents) {
        self.micro = pollutionComponents.pm2_5
        self.fine = pollutionComponents.pm10
    }
}
