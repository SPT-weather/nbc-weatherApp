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
    var temperature: Binder<TempTemperature> {
        return Binder(base) { [weak base] _, model in
            let string = model.highest + " / " + model.lowest
            // 문자열 중 범위 특정
            // "/" 를 함께 설정하는 것은 값이 같을 경우 범위가 중복되는 경우를 방지하기 위함
            let highestRange = (string as NSString).range(of: model.highest + " /")
            let lowestRange = (string as NSString).range(of: "/ " + model.lowest)
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
        }
    }

    var dust: Binder<TempDust> {
        return Binder(base) { [weak base] _, model in
            base?.microDustLabel.text = String(model.micro)
            base?.fineDustLabel.text = String(model.fine)
        }
    }

    var weather: Binder<TempWeather> {
        return Binder(base) { [weak base] _, model in
            base?.weatherLabel.text = model.korean
        }
    }
}
