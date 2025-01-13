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
        case defaultPath
        case adress
        case keyword

        var path: String {
            switch self {
            case .defaultPath:
                return "/v2/local/search"
            case .adress:
                return "/address.json"
            case .keyword:
                return "/keyword.json"
            }
        }
    }

    enum QueryItem: APIQueryItem {
        case query(String)

        var queryItem: URLQueryItem {
            switch self {
            case .query(let value):
                return URLQueryItem(name: "query", value: value)
            }
        }
    }
}

// 날씨 api
struct OpenWeatherAPI: API {
    var baseURL: String = "https://api.openweathermap.org"
    enum Path: APIPath {
        case oneCall
        case freeModel
        
        var path: String {
            switch self {
            case .oneCall:
                return "/data/3.0/onecall"
            case .freeModel:
                return "/data/2.5/weather"
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
    
    // 언어
    enum Language: String {
        case kr
        case en
    }
}
