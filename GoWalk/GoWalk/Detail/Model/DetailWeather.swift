//
//  DetailWeather.swift
//  GoWalk
//
//  Created by seohuibaek on 1/10/25.
//

import UIKit

struct DetailWeather {
    struct Hourly { // 시간별 날씨
        let time: String
        let temperature: String
        let iconUrl: URL
    }

    struct Weekly { // 주간 날씨
        let date: Date
        let iconUrl: URL
        let minTemperature: String
        let maxTemperature: String
    }
}
