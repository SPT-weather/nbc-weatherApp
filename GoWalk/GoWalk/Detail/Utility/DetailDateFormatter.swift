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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시"
        return formatter.string(from: date)
    }

    static func weeklyString(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}
