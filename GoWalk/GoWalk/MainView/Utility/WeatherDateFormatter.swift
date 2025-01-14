//
//  RefreshDateFormatter.swift
//  GoWalk
//
//  Created by 0-jerry on 1/10/25.
//

import Foundation
// 새로고침 시간 변환
enum WeatherDateFormatter {
    static func hhmm(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH시 mm분"
        let description = dateFormatter.string(from: date)
        return description
    }
}
