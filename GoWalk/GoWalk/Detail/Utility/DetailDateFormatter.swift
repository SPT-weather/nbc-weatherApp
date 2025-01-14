//
//  DetailDateFormatter.swift
//  GoWalk
//
//  Created by seohuibaek on 1/13/25.
//

import Foundation

final class DetailDateFormatter {
    static func hourlyString(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))

        // 현재의 시간대를 구해서 출력
        if Int(Date().timeIntervalSince1970) / 3600 == timestamp / 3600 {
            return "현재"
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시"
        return formatter.string(from: date)
    }

    static func weeklyString(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let now = Date()

        // 오늘 날짜인 경우
        if Calendar.current.isDate(date, inSameDayAs: now) {
            return "오늘"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: date)
        }
    }
}
