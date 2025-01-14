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
/*
 위치 불러오기 -> 위도 경도를 통해 빌더로 URL 생성 후 데이터 요청
 SearchViewControllerDelegate MainViewController 에서 채택? or MainViewModel 에서 채택?
 */
// 위치 새로고침에 대해 로직 수정 필요
class MainViewModel {
    private lazy var locationRelay: PublishRelay<LocationPoint> = {
        let locationRelay = PublishRelay<LocationPoint>()
        locationRelay
            .withUnretained(self)
            .subscribe(onNext: { owner, location in
                owner.location = location
                owner.fetchAll(location)
            }).disposed(by: disposeBag)
        return locationRelay
    }()
    // coreLocationManager 통해서 로케이션 바로 로드
    private lazy var location: LocationPoint? = .init(regionName: "", latitude: 1.1, longitude: 1.1)
    private let dailyWeatherRelay = PublishRelay<DailyWeatherDTO>()
    private let weatherRelay = PublishRelay<WeatherDTO>()
    private let airPoulltionRelay = PublishRelay<AirPollutionDTO>()
    private let refreshTimeRelay = PublishRelay<Date>()
    private let errorRelay = PublishRelay<Error>()
    private let disposeBag = DisposeBag()
    private let coreLocationManager: CoreLocationManager

    init(coreLocationManager: CoreLocationManager) {
        self.coreLocationManager = coreLocationManager
    }
    // 데이터 업데이트 ( 지역 제외 )
    private func fetchAll(_ location: LocationPoint) {
        fetchWeather(location)
        fetchDailyWeather(location)
        fetchAirPollution(location)
        fetchRefreshDate()
    }
    private func fetchRefreshLocation() {
        // 현 위치 불러오기
        let location = LocationPoint(regionName: "작동확인 \(Int.random(in: 1...100))",
                                     latitude: 10,
                                     longitude: 10)
        locationRelay.accept(location)
    }
    private func fetchWeather(_ location: LocationPoint) {
        let weatherDTO = WeatherDTO(temp: 10,
                                    id: 1,
                                    main: "main",
                                    description: "description",
                                    icon: "01")
        weatherRelay.accept(weatherDTO)
    }
    private func fetchDailyWeather(_ location: LocationPoint) {
        let dailyWeatherDTO = DailyWeatherDTO(minTemp: 10,
                                         maxTemp: -10,
                                         id: 1,
                                         main: "정상",
                                         description: "날씨 상세",
                                         icon: "01")
        dailyWeatherRelay.accept(dailyWeatherDTO)
    }
    private func fetchAirPollution(_ location: LocationPoint) {
        // 현재 날씨 불러오기
        let airPollution = AirPollutionDTO(aqi: 0, pmTwoPointFive: 100, pmTen: 20 )
        airPoulltionRelay.accept(airPollution)
    }
    private func fetchRefreshDate() {
        // 추가로 생각해본다면 요청시간을 통해 업데이트 or 응답 시간을 통해 업데이트
        refreshTimeRelay.accept(Date.now)
    }
}

extension MainViewModel {

    struct Input {
        let viewUpdate: Observable<Void>
        let refreshWeather: Observable<Void>
        let refreshLocation: Observable<Void>
    }

    struct Output {
        let location: Driver<LocationPoint>
        let weather: Driver<WeatherDTO>
        let dailyWeather: Driver<DailyWeatherDTO>
        let airPollution: Driver<AirPollutionDTO>
        let refreshDate: Driver<Date>
        let error: Driver<Error>
    }

    func transform(_ input: Input) -> Output {
        input.refreshWeather
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard let location = owner.location else { return }
                owner.fetchAll(location)
            }).disposed(by: disposeBag)

         input.refreshLocation
             .withUnretained(self)
             .subscribe(onNext: { owner, _ in
                 owner.fetchRefreshLocation()
             }).disposed(by: disposeBag)

         input.viewUpdate
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetchRefreshLocation()
            }).disposed(by: disposeBag)

        return Output(location: locationRelay.asDriver(onErrorDriveWith: .empty()),
                      weather: weatherRelay.asDriver(onErrorDriveWith: .empty()),
                      dailyWeather: dailyWeatherRelay.asDriver(onErrorDriveWith: .empty()),
                      airPollution: airPoulltionRelay.asDriver(onErrorDriveWith: .empty()),
                      refreshDate: refreshTimeRelay.asDriver(onErrorDriveWith: .empty()),
                      error: errorRelay.asDriver(onErrorDriveWith: .empty()))
    }
}
