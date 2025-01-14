//
//  DetailWeather.swift
//  GoWalk
//
//  Created by seohuibaek on 1/10/25.
//

import UIKit

struct DetailWeather {
    struct Hourly { // 시간별 날씨
        let time: Int
        let rawTemperature: Double
        let iconName: String

        var temperature: String {
            SettingsManager.shared.convertedTemperature(rawTemperature)
        }
    }

    struct Weekly { // 주간 날씨
        let date: Int
        let iconName: String
        let rawMinTemperature: Double
        let rawMaxTemperature: Double

        var minTemperature: String {
            SettingsManager.shared.convertedTemperature(rawMinTemperature)
        }

        var maxTemperature: String {
            SettingsManager.shared.convertedTemperature(rawMaxTemperature)
        }
    }
}
