//
//  URLBuilder.swift
//  GoWalk
//
//  Created by 박진홍 on 1/10/25.
//
import Foundation

// MARK: - API 관련 프로토콜 정의

protocol API {
    var baseURL: String { get }
    associatedtype Path: APIPath
    associatedtype QueryItem: APIQueryItem
}

protocol APIPath {
    var path: String { get }
}

protocol APIQueryItem {
    var queryItem: URLQueryItem { get }
}

// MARK: - 구체적인 API URL 구성 정의

// 카카오 api
struct KakaoAPI: API {
    var baseURL: String = "https://dapi.kakao.com"
    enum Path: APIPath {
        case adress
        case region

        var path: String {
            switch self {
            case .adress:
                return "/v2/local/search/address.json"
            case .region:
                return "/v2/local/local/geo/coord2regioncode.json"
            }
        }
    }
//swiftlint: disable identifier_name
    enum QueryItem: APIQueryItem {
        case query(String)
        case x(String)
        case y(String)
        
        var queryItem: URLQueryItem {
            switch self {
            case .query(let value):
                return URLQueryItem(name: "query", value: value)
            case .x(let value):
                return URLQueryItem(name: "x", value: value)
            case .y(let value):
                return URLQueryItem(name: "y", value: value)
            }
        }
    }
}
//swiftlint: enable idetifier_name

// 날씨 api
struct OpenWeatherAPI: API {
    var baseURL: String = "https://api.openweathermap.org"
    enum Path: APIPath {
        case weather
        case airPollution

        var path: String {
            switch self {
            case .weather:
                return "/data/3.0/onecall"
            case .airPollution:
                return "/data/2.5/air_pollution"
            }
        }
    }

    enum QueryItem: APIQueryItem {
        case latitude(Double)
        case longitude(Double)
        case exclude(ExcludeItem)
        case appid(String)
        case units(Units)
        case language(Language)

        var queryItem: URLQueryItem {
            switch self {
            case .latitude(let value):
                return URLQueryItem(name: "lat", value: String(value))
            case .longitude(let value):
                return URLQueryItem(name: "lon", value: String(value))
            case .exclude(let item):
                return URLQueryItem(name: "exclude", value: item.rawValue)
            case .appid(let value):
                return URLQueryItem(name: "appid", value: value)
            case .units(let unit):
                return URLQueryItem(name: "units", value: unit.rawValue)
            case .language(let language):
                return URLQueryItem(name: "lang", value: language.rawValue)
            }
        }
    }

    // 제외할 응답 정보를 선택하여 추가적인 성능 최적화 가능
    enum ExcludeItem: String {
        case current // 현재 날씨 정보
        case minutely // 1시간 동안의 분단위 예보
        case houly // 48시간 동안의 1시간 단위 예보
        case daily // 7일간의 하루별 예보
        case alerts // 날씨 경보
    }

    // 섭씨, 화씨 단위. 기본은 켈빈
    enum Units: String {
        case standard
        case metric
        case imperial
    }

    // swiftlint: disable identifier_name
    // 언어
    enum Language: String {
        case kr
        case en
    }
    // swiftlint: enable identifier_name
}
