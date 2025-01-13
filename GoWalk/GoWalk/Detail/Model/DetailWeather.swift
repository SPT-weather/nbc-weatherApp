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
        let rawTemperature: Int
        let iconUrl: URL

        var temperature: String {
            SettingsManager.shared.convertedTemperature(Double(rawTemperature))
        }
    }

    struct Weekly { // 주간 날씨
        let date: Int
        let iconUrl: URL
        let rawMinTemperature: Int
        let rawMaxTemperature: Int

        var minTemperature: String {
            SettingsManager.shared.convertedTemperature(Double(rawMinTemperature))
        }

        var maxTemperature: String {
            SettingsManager.shared.convertedTemperature(Double(rawMaxTemperature))
        }
    }
}
