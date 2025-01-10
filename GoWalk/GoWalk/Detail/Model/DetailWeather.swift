//
//  DetailWeather.swift
//  GoWalk
//
//  Created by seohuibaek on 1/10/25.
//

import UIKit

struct DetailWeather {
    struct Hourly {
        let time: String
        let temperature: String
        let iconUrl: URL
        
        var icon: UIImage {
            return UIImage(resource: .dummyWeather).withTintColor(.label)
        }
    }
    
    struct Weekly {
        let date: Date
        let iconUrl: URL
        let minTemperature: String
        let maxTemperature: String
        
        var icon: UIImage {
            return UIImage(resource: .dummyWeather).withTintColor(.label)
        }
    }
    
    // 더미 데이터 추가
        static var dummyHourly: [Hourly] {
            return (1...8).map { hour in
                Hourly(
                    time: "오후 \(hour)시",
                    temperature: "11°",
                    iconUrl: URL(string: "https://example.com")! // 실제 URL로 대체 필요
                )
            }
        }
        
        static var dummyWeekly: [Weekly] {
            return (0...6).map { dayOffset in
                let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
                return Weekly(
                    date: date,
                    iconUrl: URL(string: "https://example.com")!, // 실제 URL로 대체 필요
                    minTemperature: "최저: -7°",
                    maxTemperature: "최고: 11°"
                )
            }
        }
}
