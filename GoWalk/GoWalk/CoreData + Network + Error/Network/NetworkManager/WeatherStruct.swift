//
//  WeatherProperties.swift
//  GoWalk
//
//  Created by 박진홍 on 1/13/25.
//

// MARK: - 날씨용 구조체

struct WeatherResponse: Decodable {
    let current: CurrentWeather?
    let hourly: [HourlyWeather]?
    let daily: [DailyWeather]?
}

struct CurrentWeather: Decodable {
    let temp: Double // 기온
    let weather: [Weather]
}

struct HourlyWeather: Decodable {
    let temp: Double
    let weather: [Weather]
}

struct DailyWeather: Decodable {
    let temp: Double
    let weather: [Weather]
}

struct Weather: Decodable {
    let id: Int // 날씨 상태 id
    let main: String // 날씨 그룹( Rain, Clear 등)
    let description: String // 더 상세한 날씨( light rain 등)
    let icon: String // 날씨 아이콘 이름
}

struct DailyTemperature {
    let min: Double // 최저
    let max: Double // 최고
    let day: Double // 낮
    let night: Double // 밤
    let eve: Double // 저녁
    let morn: Double // 아침
}

// MARK: - 미세먼지용 구조체

struct AirPollutionResponse {
    let list: [PollutionData]
}

struct PollutionData {
    let main: MainPollution
    let components: PollutionComponents
}

struct MainPollution {
    let aqi: Int // Air Quality Index  대기질 지수
}

struct PollutionComponents {
    let pm2_5: Double // 초 미세먼지
    let pm10: Double // 미세먼지
}
