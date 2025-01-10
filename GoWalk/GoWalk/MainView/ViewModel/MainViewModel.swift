//
//  Untitled.swift
//  GoWalk
//
//  Created by 0-jerry on 1/9/25.
//

import Foundation

import RxSwift
import RxRelay

// 위치 새로고침에 대해 로직 수정 필요
class MainViewModel {
    private lazy var locationRelay: BehaviorRelay<LocationPoint> = {
        let locationRelay = BehaviorRelay<LocationPoint>(value: location)
        locationRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, location in
                owner.location = location
                owner.fetchDust()
                owner.fetchWeather()
                owner.fetchTemperature()
                owner.fetchRefreshDate()
            }).disposed(by: disposeBag)
        return locationRelay
    }()
    private let weatherRelay = PublishRelay<TemporaryWeather>()
    private let temperatureRelay = PublishRelay<TemperatureModel>()
    private let dustRelay = PublishRelay<TempDust>()
    private let refreshDateRelay = PublishRelay<Date>()
    private let disposeBag = DisposeBag()
    private var location: LocationPoint = LocationPoint(regionName: "서울특별시",
                                                        latitude: 10,
                                                        longitude: 10)

    private func fetchDust() {
        print("fetchDust")
        let dust = TempDust(micro: Int.random(in: 10...20), fine: Int.random(in: 100...1000))
        dustRelay.accept(dust)
    }

    private func fetchWeather() {
        print("fetchWeather")
        weatherRelay.accept(.cloudy)
    }

    private func fetchTemperature() {
        print("fetchTemperature")
        temperatureRelay.accept(.init(currentTemperature: Int.random(in: 0...10),
                                      highestTemperature: Int.random(in: 0...10),
                                      lowestTemperature: Int.random(in: 0...10)))
    }

    private func fetchCurrentLocation() {
        print("fetchCurrentLocation")
        let location = LocationPoint(regionName: "작동확인",
                                     latitude: 10,
                                     longitude: 10)
        locationRelay.accept(location)
        // 위치 새로고침
    }

    private func fetchRefreshDate() {
        print("fetchRefreshDate")
        refreshDateRelay.accept(Date.now)
    }
}

extension MainViewModel {

    struct Input {
        let viewDidLoad: Observable<Void>
        let refreshWeather: Observable<Void>
        let refreshLocation: Observable<Void>
    }

    struct Output {
        let currentTemperature: Observable<String>
        let highestTemperature: Observable<String>
        let lowestTemperature: Observable<String>
        let microDust: Observable<String>
        let fineDust: Observable<String>
        let location: Observable<String>
        let weather: Observable<TemporaryWeather>
        let refreshDate: Observable<String>
    }

    func transform(_ input: Input) -> Output {
        [input.refreshWeather
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetchDust()
                owner.fetchWeather()
                owner.fetchTemperature()
                owner.fetchRefreshDate()
            }),
         input.refreshLocation
             .withUnretained(self)
             .subscribe(onNext: { owner, _ in
                 owner.fetchCurrentLocation()
             }),
         input.viewDidLoad
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetchDust()
                owner.fetchWeather()
                owner.fetchTemperature()
                owner.fetchRefreshDate()
            })
        ].forEach { $0.disposed(by: disposeBag) }

        let temperatureObservable = temperatureRelay.asObservable()
        let currentTemerature = temperatureObservable.map { $0.current }
        let highestTemperature = temperatureObservable.map { $0.highest }
        let lowestTemperature = temperatureObservable.map { $0.lowest }
        let dustObservable = dustRelay.asObservable()
        let fineDust = dustObservable.map { "\($0.fine)" }
        let microDust = dustObservable.map { "\($0.micro)"}
        let location = locationRelay.map { $0.regionName }.asObservable()
        let weather = weatherRelay.asObservable()
        let refreshDate = refreshDateRelay.map { RefreshDateFormatter.korean($0) }.asObservable()

        return Output(currentTemperature: currentTemerature,
                      highestTemperature: highestTemperature,
                      lowestTemperature: lowestTemperature,
                      microDust: microDust,
                      fineDust: fineDust,
                      location: location,
                      weather: weather,
                      refreshDate: refreshDate)
    }
}
