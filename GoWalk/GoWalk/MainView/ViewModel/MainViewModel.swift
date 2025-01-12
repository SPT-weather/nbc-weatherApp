//
//  Untitled.swift
//  GoWalk
//
//  Created by 0-jerry on 1/9/25.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa

// 위치 새로고침에 대해 로직 수정 필요
class MainViewModel {
    private lazy var locationRelay: BehaviorRelay<LocationPoint> = {
        let locationRelay = BehaviorRelay<LocationPoint>(value: location)
        locationRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, location in
                owner.location = location
                owner.fetchAll()
            }).disposed(by: disposeBag)
        return locationRelay
    }()
    private let weatherRelay = PublishRelay<TempWeather>()
    private let temperatureRelay = PublishRelay<TempTemperature>()
    private let dustRelay = PublishRelay<TempDust>()
    private let refreshDateRelay = PublishRelay<Date>()
    private let disposeBag = DisposeBag()
    private var location: LocationPoint

    init(location: LocationPoint) {
        self.location = location
    }
    // 데이터 업데이트 ( 지역 제외 )
    private func fetchAll() {
        fetchDust()
        fetchWeather()
        fetchTemperature()
        fetchRefreshDate()
    }

    private func fetchDust() {
        let dust = TempDust(micro: Int.random(in: 10...20), fine: Int.random(in: 100...1000))
        dustRelay.accept(dust)
    }

    private func fetchWeather() {
        weatherRelay.accept(.cloudy)
    }

    private func fetchTemperature() {
        temperatureRelay.accept(.init(currentTemperature: Int.random(in: 0...10),
                                      highestTemperature: Int.random(in: 0...10),
                                      lowestTemperature: Int.random(in: 0...10)))
    }

    private func fetchCurrentLocation() {
        let location = LocationPoint(regionName: "작동확인",
                                     latitude: 10,
                                     longitude: 10)
        locationRelay.accept(location)
    }

    private func fetchRefreshDate() {
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
        let temperature: Driver<TempTemperature>
        let dust: Driver<TempDust>
        let location: Driver<LocationPoint>
        let weather: Driver<TempWeather>
        let refreshDate: Driver<Date>
    }

    func transform(_ input: Input) -> Output {
        input.refreshWeather
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetchAll()
            }).disposed(by: disposeBag)

         input.refreshLocation
             .withUnretained(self)
             .subscribe(onNext: { owner, _ in
                 owner.fetchCurrentLocation()
             }).disposed(by: disposeBag)

         input.viewDidLoad
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetchAll()
            }).disposed(by: disposeBag)

        let temperature = temperatureRelay.asDriver(onErrorJustReturn: .failure)
        let dust = dustRelay.asDriver(onErrorJustReturn: .failure)
        let location = locationRelay.asDriver(onErrorJustReturn: .init(regionName: "실패", latitude: 0, longitude: 0))
        let weather = weatherRelay.asDriver(onErrorJustReturn: .cloudy)
        let refreshDate = refreshDateRelay.asDriver(onErrorJustReturn: .now)

        return Output(temperature: temperature,
                      dust: dust,
                      location: location,
                      weather: weather,
                      refreshDate: refreshDate)
    }
}
