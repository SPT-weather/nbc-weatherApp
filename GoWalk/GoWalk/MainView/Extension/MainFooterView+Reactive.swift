//
//  MainFooterView+Reactive.swift
//  GoWalk
//
//  Created by 0-jerry on 1/11/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: MainFooterView {
    var dailyWeather: Binder<DailyWeatherDTO> {
        return Binder(base) { [weak base] _, model in
            let max = String(double: model.maxTemp)
            let min = String(double: model.minTemp)
            let string = max + " / " + min
            // 문자열 중 범위 특정
            // "/" 를 함께 설정하는 것은 값이 같을 경우 범위가 중복되는 경우를 방지하기 위함
            let highestRange = (string as NSString).range(of: max + " /")
            let lowestRange = (string as NSString).range(of: "/ " + min)
            let seperatorRange = (string as NSString).range(of: " / ")
            // NSMutableAttributedString 문자열을 통해 초기화
            let attributedStr = NSMutableAttributedString(string: string)
            // NSMutableAttributedString 특정 범위에 대해 속성 설정
            attributedStr.addAttribute(.foregroundColor,
                                       value: UIColor.systemRed,
                                       range: highestRange)
            attributedStr.addAttribute(.foregroundColor,
                                       value: UIColor.systemBlue,
                                       range: lowestRange)
            attributedStr.addAttribute(.foregroundColor,
                                       value: UIColor.label,
                                       range: seperatorRange)
            attributedStr.addAttribute(.font,
                                       value: UIFont.systemFont(ofSize: 20, weight: .semibold),
                                       range: seperatorRange)

            // UILabel 에 NSMutableAttributedString 적용
            base?.temperatureLabel.attributedText = attributedStr
            base?.weatherLabel.text = model.main
        }
    }

    var airPollution: Binder<AirPollutionDTO> {
        return Binder(base) { [weak base] _, model in
            base?.microDustLabel.text = String(double: model.pmTwoPointFive)
            base?.fineDustLabel.text = String(double: model.pmTen)
        }
    }
}

private extension String {
    init(double: Double) {
        self = String(Int(double))
    }
}
