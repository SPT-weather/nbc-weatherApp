//
//  DetailViewModel.swift
//  GoWalk
//
//  Created by seohuibaek on 1/8/25.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
    // Input 구조체: 뷰에서 ViewModel로 전달되는 이벤트 정의
    struct Input {
        let viewDidLoad: Observable<Void> // View가 Load 되었을 때 이벤트 전달
        let refresh: Observable<Void> // 새로고침 됐을 때
    }

    // Output 구조체: ViewModel에서 뷰로 전달할 데이터 스트림 정의
    // Driver: UI 바인딩을 위해 특별히 설계된 Observable 시퀀스 (메인 스레드에서만 이벤트 전달)
    struct Output {
        let hourlyWeather: Driver<[DetailWeather.Hourly]> // 시간별 날씨 데이터 스트림
        let weeklyWeather: Driver<[DetailWeather.Weekly]> // 날짜별 날씨 데이터 스트림
        let error: Driver<Error>
    }

    // PublishRelay: Subject처럼 새로운 값만 구독자에게 전달
    // BehaviorRelay: 초기값을 가지며, 새로운 구독자에게 최신 값을 즉시 전달
    private let hourlyWeatherRelay = BehaviorRelay<[DetailWeather.Hourly]>(value: []) // 시간별 날씨 데이터 저장
    private let weeklyWeatherRelay = BehaviorRelay<[DetailWeather.Weekly]>(value: []) // 주간 날씨 데이터 저장
    private let errorRelay = PublishRelay<Error>() // 에러 (추후 예외 처리용)

    private let disposeBag = DisposeBag()

    private let networkManager: AbstractNetworkManager

    init(networkManager: AbstractNetworkManager = RXNetworkManager()) {
        self.networkManager = networkManager
    }

    // 저장된 위치 좌표를 반환
    private func getLocationCoordinates() -> (latitude: Double, longitude: Double) {
        let latitude = UserDefaults.standard.double(forKey: "lat")
        let longitude = UserDefaults.standard.double(forKey: "lon")

        // UserDefaults에 저장된 값이 없거나 유효하지 않은 경우 기본값 사용
        if latitude == 0 || longitude == 0 {
            return (37.5666791, 126.9782914) // 서울시청 좌표
        }
        return (latitude, longitude)
    }

    // 날씨 데이터를 API에서 가져오는 Observable 반환
    private func fetchWeatherData() -> Observable<Result<TotalWeatherDTO, AppError>> {
        let coordinates = getLocationCoordinates()
        print(coordinates.latitude, coordinates.longitude)

        guard let url = URLBuilder(api: OpenWeatherAPI())
            .addPath(.weather)
            .addQueryItem(.latitude(coordinates.latitude))
            .addQueryItem(.longitude(coordinates.longitude))
            .addQueryItem(.appid("902a70addad3e4cfd087a1b95fe85b06"))
            .addQueryItem(.units(.metric))
            .addQueryItem(.language(.kr))
            .build().get() else {
            return .just(.failure(.network(.failedToBuildURL(url: "Weather API URL"))))
        }

        return networkManager.fetchWeatherData(url: url)
            .observe(on: MainScheduler.instance)
            .retry(2) // 실패시 2번 재시도
            .catch { error in
                return .just(.failure(.network(.dataTaskError(error: error))))
            }
    }

    // Input을 받아 Output으로 반환
    func transform(input: Input) -> Output {
        Observable.merge(input.viewDidLoad, input.refresh)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                self.fetchWeatherData()
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] result in
                        guard let self = self else { return }

                        switch result {
                        case .success(let weatherDTO):
                            let now = Date()
                            let calendar = Calendar.current

                            // 시간별 날씨 데이터 변환
                            let hourlyData = weatherDTO.hourly.prefix(24).enumerated().map { index, hourly in
                                let hourDate = calendar.date(byAdding: .hour, value: index, to: now) ?? now
                                return DetailWeather.Hourly(
                                    time: Int(hourDate.timeIntervalSince1970),
                                    rawTemperature: Int(round(hourly.temp)),
                                    iconUrl: URL(string: "https://openweathermap.org/img/wn/\(hourly.icon)@2x.png")!
                                )
                            }
                            self.hourlyWeatherRelay.accept(Array(hourlyData))

                            // 주간 날씨 데이터 변환
                            let weeklyData = weatherDTO.daily.enumerated().map { index, daily in
                                let dayDate = calendar.date(byAdding: .day, value: index, to: now) ?? now
                                return DetailWeather.Weekly(
                                    date: Int(dayDate.timeIntervalSince1970),
                                    iconUrl: URL(string: "https://openweathermap.org/img/wn/\(daily.icon)@2x.png")!,
                                    rawMinTemperature: Int(round(daily.minTemp)),
                                    rawMaxTemperature: Int(round(daily.maxTemp))
                                )
                            }
                            self.weeklyWeatherRelay.accept(weeklyData)

                        case .failure(let error):
                            self.errorRelay.accept(error)
                        }
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        // Relay -> Driver : UI 작업의 안전성 보장 (메인 스레드)
        return Output(
            hourlyWeather: hourlyWeatherRelay.asDriver(),
            weeklyWeather: weeklyWeatherRelay.asDriver(),
            error: errorRelay.asDriver(onErrorDriveWith: .empty()) // 빈 값으로 대체
        )
    }
}
