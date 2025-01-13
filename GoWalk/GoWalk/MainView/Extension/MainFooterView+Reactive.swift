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
            base?.highestTemperatureLabel.text = model.highest
            base?.lowestTemperatureLabel.text = model.lowest
        }
    }

    var dust: Binder<TempDust> {
        return Binder(base) { [weak base] _, model in
            base?.microDustValueLabel.text = String(model.micro)
            base?.fineDustValueLabel.text = String(model.fine)
        }
    }

    var weather: Binder<TempWeather> {
        return Binder(base) { [weak base] _, model in
            base?.weatherStringLabel.text = model.korean
        }
    }
}
