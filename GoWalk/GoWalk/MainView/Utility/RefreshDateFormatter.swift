//
//  RefreshDateFormatter.swift
//  GoWalk
//
//  Created by 0-jerry on 1/10/25.
//

import Foundation
// 새로고침 시간 변환
enum RefreshDateFormatter {
    static func korean(_ date: Date) -> String {
        let dateString = convert(date)
        return String(format: "기준 시간: %@", dateString)
    }

    private static func convert(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH시 mm분"
        let description = dateFormatter.string(from: date)
        return description
    }
}
