//
//  WeatherSimple.swift
//  GoWalk
//
//  Created by 0-jerry on 1/8/25.
//

import Foundation
// 삭제예정 데이터 
struct WeatherSimple {
    let location: String
    let weather: WeatherType

    static let failure = WeatherSimple(location: "업데이트 실패",
                                       weather: .clearSky)

}
