//
//  DTO.swift
//  GoWalk
//
//  Created by 박진홍 on 1/13/25.
//

protocol Mappable: Decodable {
    associatedtype ResponseType: Decodable
    static func map(from response: ResponseType) -> Result<Self, AppError>
}

// MARK: - 날씨, 미세먼지 DTO

struct TotalWeatherDTO: Mappable {
    let current: WeatherDTO
    let hourly: [WeatherDTO]
    let daily: [DailyWeatherDTO]

    static func map(from response: WeatherResponse) -> Result<TotalWeatherDTO, AppError> {
        guard let current = response.current,
              let hourly = response.hourly,
              let daily = response.daily
        else { return .failure(AppError.network(.failedToMapping))}

        // current weahter mapping
        guard let currentWeather = current.weather.first else {
            return .failure(AppError.network(.failedToMapping))
        }

        let currentDTO: WeatherDTO = WeatherDTO(
            temp: current.temp,
            id: currentWeather.id,
            main: currentWeather.main,
            description: currentWeather.description,
            icon: currentWeather.icon
        )

        do {
            // houlry weather mapping
            let hourlyDTO: [WeatherDTO] = try hourly.map { hourlyWeather in
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
            // daily weather mapping
            let dailyDTO: [DailyWeatherDTO] = try daily.map { dailyWeather in
                guard let weather = dailyWeather.weather.first else {
                    throw AppError.network(.failedToMapping)
                }
                return DailyWeatherDTO(
                    minTemp: dailyWeather.temp.min,
                    maxTemp: dailyWeather.temp.max,
                    id: weather.id,
                    main: weather.main,
                    description: weather.description,
                    icon: weather.icon
                )
            }
            return .success(TotalWeatherDTO(current: currentDTO, hourly: hourlyDTO, daily: dailyDTO))
        } catch {
            return .failure(AppError.network(.failedToMapping))
        }
    }
}

struct WeatherDTO: Decodable {
    let temp: Double // 온도
    let id: Int // 날씨 상태 id
    let main: String // 날씨 그룹( Rain, Clear 등)
    let description: String // 더 상세한 날씨( light rain 등)
    let icon: String // 날씨 아이콘 이름
}

struct DailyWeatherDTO: Decodable {
    let minTemp: Double // 최저
    let maxTemp: Double // 최고
    let id: Int // 날씨 상태 id
    let main: String // 날씨 그룹( Rain, Clear 등)
    let description: String // 더 상세한 날씨( light rain 등)
    let icon: String // 날씨 아이콘 이름
}

// MARK: - 대기질 DTO 매퍼
struct AirPollutionDTO: Mappable {
    let aqi: Int
    let pmTwoPointFive: Double // pm2.5
    let pmTen: Double // pm10

    static func map(from response: AirPollutionResponse) -> Result<AirPollutionDTO, AppError> {
        guard let data = response.list?.first else {
            return .failure(AppError.network(.failedToMapping))
        }

        return .success(
            AirPollutionDTO(
                aqi: data.main.aqi,
                pmTwoPointFive: data.components.pm2_5,
                pmTen: data.components.pm10
            )
        )
    }
}

// MARK: - 주소 DTO
struct AddressDTO: Mappable { // Search page에서 사용
    let locationPoint: [LocationDTO]

    static func map(from response: AddressModel<String>) -> Result<AddressDTO, AppError> {
        let addresses = response.documents.map { data in
            LocationDTO(
                regionName: data.addressName,
                latitude: Double(data.lat) ?? 0,
                longitude: Double(data.lon) ?? 0
            )
        }
        return .success(AddressDTO(locationPoint: addresses))
    }
}

struct RegionDTO: Mappable { // use in main page
    let locationPoint: LocationDTO

    static func map(from response: AddressModel<Double>) -> Result<RegionDTO, AppError> {
        guard let document = response.documents.first
        else {
            return .failure(.network(.failedToMapping))
        }

        let locationDTO: LocationDTO = LocationDTO(
            regionName: document.addressName,
            latitude: document.lat,
            longitude: document.lon
        )

        return .success(RegionDTO(locationPoint: locationDTO))
    }
}

struct LocationDTO: Decodable {
    let regionName: String
    let latitude: Double
    let longitude: Double
}
