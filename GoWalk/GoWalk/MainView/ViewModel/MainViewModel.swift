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

protocol MainViewModelDelegate: AnyObject {
    func didSelectLocation(_ location: LocationPoint)
}

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
    private(set) var location: LocationPoint = .init(regionName: "서울 강남구",
                                        latitude: 127.0495556,
                                        longitude: 37.514575)
    private let dailyWeatherRelay = PublishRelay<DailyWeatherDTO>()
    private let weatherRelay = PublishRelay<WeatherDTO>()
    private let airPoulltionRelay = PublishRelay<AirPollutionDTO>()
    private let refreshTimeRelay = PublishRelay<Date>()
    private let errorRelay = PublishRelay<Error>()
    private let coreLocationManager: CoreLocationManager
    private let networkManager: AbstractNetworkManager = RXNetworkManager()
    private let disposeBag: DisposeBag
    weak var delegate: MainViewModelDelegate?
    
    init(coreLocationManager: CoreLocationManager) {
        self.coreLocationManager = coreLocationManager
        let disposeBag = DisposeBag()
        self.disposeBag = disposeBag

        coreLocationManager.locationRelay
            .withUnretained(self)
            .subscribe { owner, location in
            owner.fetchRefreshLocation()
                print(location, "메인뷰모델")
        }.disposed(by: disposeBag)
    }
    // 데이터 업데이트 ( 지역 제외 )
    private func fetchAll(_ location: LocationPoint) {
        fetchWeather(location)
        fetchAirPollution(location)
        fetchRefreshDate()
    }
    private func saveCurrentLocation() {
        coreLocationManager.locationManager.startUpdatingLocation()
    }
    // 지금의 형태라면 LocationUserDefaults 사용하지 않을수도 있음 Rx 로 통신
    private func fetchRefreshLocation() {
        // 현 위치 불러오기
        guard let location = LocationUserDefaults.shared.read() else { return }
        locationRelay.accept(location)
    }
    private func fetchWeather(_ location: LocationPoint) {
        let unit: OpenWeatherAPI.Units
        switch UserDefaults.standard.temperatureUnit {
        case .celsius: unit = .metric
        case .fahrenheit: unit = .imperial
        }

        guard let weatherURL = URLBuilder(api: OpenWeatherAPI())
            .addPath(.weather)
            .addQueryItem(.latitude(location.latitude)) // 서울 위도
            .addQueryItem(.longitude(location.longitude)) // 서울 경도
            .addQueryItem(.appid("902a70addad3e4cfd087a1b95fe85b06"))
            .addQueryItem(.units(unit))
            .build()
            .get() else { return }
        
        networkManager.fetchWeatherData(url: weatherURL)
            .withUnretained(self)
            .subscribe { owner, result in
                switch result {
                case .success(let weatherDTO):
                    let currentDTO = weatherDTO.current
                    guard let dailyWeatherDTO = weatherDTO.daily.first else { return }
                    owner.weatherRelay.accept(currentDTO)
                    owner.dailyWeatherRelay.accept(dailyWeatherDTO)
                    print(currentDTO, dailyWeatherDTO)
                case .failure(let error):
                    owner.errorRelay.accept(error)
                }
            }.disposed(by: disposeBag)
    }
    private func fetchAirPollution(_ location: LocationPoint) {
        // 현재 날씨 불러오기
        guard let airPollutionURL = URLBuilder(api: OpenWeatherAPI())
            .addPath(.airPollution)
            .addQueryItem(.latitude(location.latitude)) // 서울 위도
            .addQueryItem(.longitude(location.longitude)) // 서울 경도
            .addQueryItem(.appid("902a70addad3e4cfd087a1b95fe85b06"))
            .build()
            .get() else { return }
            
        networkManager.fetchAirPollutionData(url: airPollutionURL)
            .withUnretained(self)
            .subscribe { owner, result in
                switch result {
                case .success(let airPollution):
                    owner.airPoulltionRelay.accept(airPollution)
                    print(airPollution)
                case .failure(let error):
                    owner.errorRelay.accept(error)
                }
            }.disposed(by: disposeBag)
    }
    private func fetchRefreshDate() {
        // 추가로 생각해본다면 요청시간을 통해 업데이트 or 응답 시간을 통해 업데이트
        refreshTimeRelay.accept(Date.now)
    }
    func present() {
        self.delegate?.didSelectLocation(location)
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
                owner.fetchAll(owner.location)
            }).disposed(by: disposeBag)

         input.refreshLocation
             .withUnretained(self)
             .subscribe(onNext: { owner, _ in
                 owner.saveCurrentLocation()
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

extension MainViewModel: SearchViewControllerDelegate {
    func didSelectLocation(_ location: LocationPoint) {
        self.location = location
        locationRelay.accept(location)
    }
}
