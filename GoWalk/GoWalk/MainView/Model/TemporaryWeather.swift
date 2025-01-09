//
//  Weather.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/8/25.
//

import Foundation

// 날씨 타입 ( 이후 API 를 기반해 데이터 추가 설정 )
enum TemporaryWeather {
    case sunny
    case cloudy

    var korean: String {
        switch self {
        case .sunny: return "맑음"
        case .cloudy: return "구름"
        }
    }
}
