//
//  MainViewController+Reactive.swift
//  GoWalk
//
//  Created by 0-jerry on 1/11/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: MainViewController {
    var viewDidLoad: Observable<Void> {
        // methodInvoked 특정 메서드의 호출을 관찰 rx.viewDidLoad 바인딩
        return methodInvoked(#selector(base.viewDidLoad))
            .map { _ in }
    }

    var viewWillAppear: Observable<Void> {
        return methodInvoked(#selector(base.viewDidLoad)).map { _ in }
    }

    var refreshDate: Binder<Date> {
        return Binder(base) { [weak base] _, model in
            base?.refreshDateLabel.text = WeatherDateFormatter.hhmm(model)
        }
    }

    var weather: Binder<WeatherDTO> {
        return Binder(base) { [weak base] _, model in
            base?.animalImageView.image = WeatherAnimalAssetTraslator.transform(model)
        }
    }
}
