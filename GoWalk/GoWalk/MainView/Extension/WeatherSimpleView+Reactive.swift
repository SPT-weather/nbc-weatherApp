//
//  WeatherSimpleView.swift
//  GoWalk
//
//  Created by 0-jerry on 1/12/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: MainWeatherView {
    var temperatrue: Binder<TempTemperature> {
        return Binder(base) { [weak base] _, model in
            base?.temperatureLabel.text = model.current
        }
    }

    var location: Binder<LocationPoint> {
        return Binder(base) { [weak base] _, model in
            base?.locationLabel.text = model.regionName
        }
    }

    var weather: Binder<TempWeather> {
        return Binder(base) { [weak base] _, model in
            base?.weatherImageView.image = WeatherAssetTranslator.resourceImage(from: model)
        }
    }
}
