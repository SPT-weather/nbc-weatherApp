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
                return "address.json"
            case .keyword:
                return "keyword.json"
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


