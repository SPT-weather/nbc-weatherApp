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
    private let temperature: (highest: Int, lowest: Int)

    var highestTempDescription: String {
        return tempForm(style: .highest, temperature.highest)
    }

    var lowestTempDescription: String {
        return tempForm(style: .highest, temperature.highest)
    }

    private var temperatureStyle: TemperatureStyle {
        // 설정에서 저장된 값 불러오기
        return .celsius
    }

    // 기온 라벨에 적합한 형태로 반환
    private func tempForm(style: TempeatureLabelStyle, _ temp: Int) -> String {
        "\(style.korean): \(temp) \(temperatureStyle.mark)"
    }

    init(location: String,
         weather: TemporaryWeather,
         highestTemperature: Int,
         lowestTemperature: Int) {
        self.location = location
        self.weather = weather
        self.temperature = (highest: highestTemperature,
                            lowest: lowestTemperature)
    }

    // 날씨 라벨 타입 ( 최고, 최저 )
    private enum TempeatureLabelStyle {
        case highest
        case lowest

        var korean: String {
            switch self {
            case .highest: return "최고"
            case .lowest: return "최저"
            }
        }
    }
}
