//
//  TemperatureFormatter.swift
//  GoWalk
//
//  Created by 0-jerry on 1/9/25.
//

import Foundation

/// 온도 형태 변환
enum TemperatureFormatter {
    // 현재 기온에 적합한 형태로 반환
    static func current(_ temperature: Int) -> String {
        // 설정된 방식을 불러와 사용
        let temperatureUnit = UserDefaults.standard.temperatureUnit
        let mark = temperatureUnit == .celsius ? "℃" : "℉"
        return String(format: "%d %@", temperature, mark)
    }
    // 섭씨
    static func celsius(_ temperature: Int) -> String {
        let mark = "℃"
        return String(format: "%d %@", temperature, mark)
    }
    // 화씨 형태
    static func fahrenheit(_ temperature: Int) -> String {
        let mark = "℉"
        return String(format: "%d %@", temperature, mark)
    }
    // 간단한 형태 00º
    static func simple(_ temperature: Double) -> String {
        let temperature = Int(temperature.rounded())
        return String(format: "%dº", temperature)
    }
}
