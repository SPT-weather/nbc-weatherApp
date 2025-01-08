//
//  TemperatrueStyle.swift
//  GoWalk
//
//  Created by 0-jerry on 1/8/25.
//

import Foundation
// 온도 형태
enum TemperatureStyle {

    case celsius
    case fahrenheit

    var mark: String {
        switch self {
        case .celsius:
            return "℃"
        case .fahrenheit:
            return "℉"
        }
    }
}
