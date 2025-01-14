//
//  WeatherSimpleView+Reactive.swift
//  GoWalk
//
//  Created by 0-jerry on 1/12/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: MainWeatherView {
    var location: Binder<LocationPoint> {
        return Binder(base) { [weak base] _, model in
            guard let regionName = model.regionName.components(separatedBy: " ").last else { return }
            base?.locationLabel.text = regionName
        }
    }

    var weather: Binder<WeatherDTO> {
        return Binder(base) { [weak base] _, model in
            guard let weatherIcon = WeatherAssetTranslator.resourceIcon(from: model) else { return }
            base?.temperatureLabel.text = TemperatureFormatter.current(Int(model.temp))
            base?.weatherImageView.image = weatherIcon
        }
    }
}
