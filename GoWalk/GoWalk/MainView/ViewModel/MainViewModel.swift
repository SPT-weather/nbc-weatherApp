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

enum MainViewType {
    case `default`
    case selected
}
/*
 위치 불러오기 -> 위도 경도를 통해 빌더로 URL 생성 후 데이터 요청
 
 */

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
    private var location: LocationPoint
    private let weatherRelay = PublishRelay<DailyWeatherDTO>()
    private let airPoulltionRelay = PublishRelay<AirPollutionDTO>()
    private let refreshTimeRelay = PublishRelay<Date>()
    private let errorRelay = PublishRelay<Error>()
    private let disposeBag = DisposeBag()
    
    init(location: LocationPoint = TestMockData.seoul) {
        self.location = location
    }
    // 데이터 업데이트 ( 지역 제외 )
    private func fetchAll() {
        fetchWeather()
        fetchAirPollution()
        fetchRefreshDate()
    }
    
    private func fetchSelectedLocation() {
        
    }
    private func fetchRefreshLocation() {
        // 현 위치 불러오기
        let location = LocationPoint(regionName: "작동확인",
                                     latitude: 10,
                                     longitude: 10)
        locationRelay.accept(location)
    }
    private func fetchWeather() {
        let weatherDTO = DailyWeatherDTO(minTemp: 0,
                                         maxTemp: 0,
                                         id: 1,
                                         main: "정상",
                                         description: "날씨 상세",
                                         icon: "01")
        weatherRelay.accept(weatherDTO)
    }
    private func fetchAirPollution() {
        // 현재 날씨 불러오기
        let airPollution = AirPollutionDTO(aqi: 0, pmTwoPointFive: 0, pmTen: 0  )
        airPoulltionRelay.accept(airPollution)
    }
    private func fetchRefreshDate() {
        // 추가로 생각해본다면 요청시간을 통해 업데이트 or 응답 시간을 통해 업데이트
        refreshTimeRelay.accept(Date.now)
    }
}

extension MainViewModel {

    struct Input {
        let viewDidLoad: Observable<Void>
        let refreshWeather: Observable<Void>
        let refreshLocation: Observable<Void>?
    }

    struct Output {
        let location: Driver<LocationPoint>
        let weather: Driver<DailyWeatherDTO>
        let airPollution: Driver<AirPollutionDTO>
        let refreshDate: Driver<Date>
        let error: Driver<Error>
    }

    func transform(_ input: Input) -> Output {
        input.refreshWeather
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetchAll()
            }).disposed(by: disposeBag)

         input.refreshLocation?
             .withUnretained(self)
             .subscribe(onNext: { owner, _ in
                 owner.fetchRefreshLocation()
             }).disposed(by: disposeBag)

         input.viewDidLoad
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetchRefreshLocation()
            }).disposed(by: disposeBag)

        return Output(location: locationRelay.asDriver(),
                      weather: weatherRelay.asDriver(onErrorDriveWith: .empty()),
                      airPollution: airPoulltionRelay.asDriver(onErrorDriveWith: .empty()),
                      refreshDate: refreshTimeRelay.asDriver(onErrorDriveWith: .empty()),
                      error: errorRelay.asDriver(onErrorDriveWith: .empty()))
    }
}
