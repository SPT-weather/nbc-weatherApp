//
//  Untitled.swift
//  GoWalk
//
//  Created by 0-jerry on 1/9/25.
//

import Foundation

import RxSwift
import RxRelay

struct MainViewModel {
    private let weatherRelay = BehaviorRelay<WeatherSimple>(value: .default)
    private let temperatureRelay = BehaviorRelay<TemperatureModel>(value: .default)
    private let dustRelay = BehaviorRelay<TempDust>(value: .default)
    private let disposeBag = DisposeBag()

    private func fetchDust() {
        let dust = TempDust(micro: Int.random(in: 10...20), fine: Int.random(in: 100...1000))
        dustRelay.accept(dust)
        print("fetchDust")
    }

    private func fetchWeather() {
        weatherRelay.accept(TestMockData.testWeather)
        print("fetchWeather")

    }

    private func fetchTemperature() {
        temperatureRelay.accept(.init(currentTemperature: Int.random(in: 0...10),
                                      highestTemperature: Int.random(in: 0...10),
                                      lowestTemperature: Int.random(in: 0...10)))
        print("fetchTemperature")
    }

}

extension MainViewModel {

    struct Input {
        let viewDidLoad: Observable<Void>
        let refresh: Observable<Void>
    }

    struct Output {
        let weather: Observable<WeatherSimple>
        let temperature: Observable<TemperatureModel>
        let dust: Observable<TempDust>
    }

    func transform(_ input: Input) -> Output {
        [input.viewDidLoad,
         input.refresh]
            .forEach {
            $0.subscribe(onNext: {
                fetchWeather()
                fetchTemperature()
                fetchDust()
            }).disposed(by: disposeBag)
        }
        let weather = weatherRelay.asObservable()
        let temperatrue = temperatureRelay.asObservable()
        let dust = dustRelay.asObservable()
        return Output(weather: weather,
                      temperature: temperatrue,
                      dust: dust)
    }

}
