//
//  DTO.swift
//  GoWalk
//
//  Created by 박진홍 on 1/13/25.
//

// MARK: - 날씨, 미세먼지 DTO

struct TotalWeatherDTO {
    let current: WeatherDTO
    let hourly: [WeatherDTO]
    let daily: [DailyWeatherDTO]
}
struct WeatherDTO {
    let temp: Double // 온도
    let id: Int // 날씨 상태 id
    let main: String // 날씨 그룹( Rain, Clear 등)
    let description: String // 더 상세한 날씨( light rain 등)
    let icon: String // 날씨 아이콘 이름
}

struct DailyWeatherDTO {
    let minTemp: Double // 최저
    let maxTemp: Double // 최고
    let id: Int // 날씨 상태 id
    let main: String // 날씨 그룹( Rain, Clear 등)
    let description: String // 더 상세한 날씨( light rain 등)
    let icon: String // 날씨 아이콘 이름
}

struct AirPollutionDTO {
    let aqi: Int
    let pmTwoPointFive: Double // pm2.5
    let pmTen: Double // pm10
}

// MARK: - DTO 매핑

class DTOMapper {
    static func mapToWeatherDTO(from response: WeatherResponse) -> Result<TotalWeatherDTO, AppError> {
        guard let current = response.current,
              let hourly = response.hourly,
              let daily = response.daily
        else { return .failure(AppError.network(.failedToMapping))}

        // current weahter mapping
        guard let currentWeather = current.weather.first
        else { return .failure(AppError.network(.failedToMapping))}
        let currentDTO: WeatherDTO = WeatherDTO(
            temp: current.temp,
            id: currentWeather.id,
            main: currentWeather.main,
            description: currentWeather.description,
            icon: currentWeather.icon
        )

        // houlry weather mapping
        let hourlyDTO: [WeatherDTO]
        do {
            hourlyDTO = try hourly.map { hourlyWeather in
                guard let weather = hourlyWeather.weather.first else {
                    throw AppError.network(.failedToMapping)
                }
                return WeatherDTO(
                    temp: hourlyWeather.temp,
                    id: weather.id,
                    main: weather.main,
                    description: weather.description,
                    icon: weather.icon
                )
            }
        } catch {
            return .failure(AppError.network(.failedToMapping))
        }

        // daily weather mapping
        let dailyDTO: [DailyWeatherDTO]
        do {
            dailyDTO = try daily.map { dailyWeather in
                guard let weather = dailyWeather.weather.first else {
                    throw AppError.network(.failedToMapping)
                }
                return DailyWeatherDTO(
                    minTemp: dailyWeather.temp.min,
                    maxTemp: dailyWeather.temp.max,
                    id: weather.id,
                    main: weather.main,
                    description: weather.description,
                    icon: weather.icon)
            }
        } catch {
            return .failure(AppError.network(.failedToMapping))
        }

        return .success(TotalWeatherDTO(current: currentDTO, hourly: hourlyDTO, daily: dailyDTO))
    }

    static func mapToAirPollutionDTO(from response: AirPollutionResponse) -> Result<AirPollutionDTO, AppError> {
        guard let data = response.list?.first else {
            return .failure(AppError.network(.failedToMapping))
        }

        return .success(AirPollutionDTO(aqi: data.main.aqi, pmTwoPointFive: data.components.pm2_5, pmTen: data.components.pm10))
    }
}
