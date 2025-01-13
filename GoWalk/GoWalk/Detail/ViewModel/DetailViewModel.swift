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
        let hourlyWeather: Driver<[DetailWeather.Hourly]>
        let weeklyWeather: Driver<[DetailWeather.Weekly]>
        let error: Driver<Error>
    }

    // PublishRelay: Subject처럼 새로운 값만 구독자에게 전달
    // BehaviorRelay: 초기값을 가지며, 새로운 구독자에게 최신 값을 즉시 전달
    private let hourlyWeatherRelay = BehaviorRelay<[DetailWeather.Hourly]>(value: []) // 시간별 날씨 데이터 저장
    private let weeklyWeatherRelay = BehaviorRelay<[DetailWeather.Weekly]>(value: []) // 주간 날씨 데이터 저장
    private let errorRelay = PublishRelay<Error>() // 에러 (추후 예외 처리용)

    private let disposeBag = DisposeBag()

    // Input을 받아 Output으로 변환
    func transform(input: Input) -> Output {
        // viewDidLoad와 refresh 이벤트를 하나의 스트림으로 병합
        Observable.merge(input.viewDidLoad, input.refresh)
            .subscribe(onNext: { [weak self] _ in
                // 시간별 날씨 더미 데이터
                let hourlyData = (1...8).map { hour in
                    let date = Calendar.current.date(bySettingHour: hour + 12, minute: 0, second: 0, of: Date())!
                    return DetailWeather.Hourly(
                        time: Int(date.timeIntervalSince1970), //timeStamp로 변환
                        temperature: "11°C",
                        iconUrl: URL(string: "https://velog.velcdn.com/images/soycong/post/d1d8f6c2-cf93-480a-8bf4-a58b55cfc407/image.png")!
                    )
                }
                self?.hourlyWeatherRelay.accept(hourlyData) // 생성된 데이터를 Relay에 전달

                // 주간 날씨 더미 데이터
                let weeklyData = (0...6).map { dayOffset in
                    let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
                    return DetailWeather.Weekly(
                        date: Int(date.timeIntervalSince1970),
                        iconUrl: URL(string: "https://velog.velcdn.com/images/soycong/post/d1d8f6c2-cf93-480a-8bf4-a58b55cfc407/image.png")!,
                        minTemperature: " -7°C",
                        maxTemperature: "11°C"
                    )
                }
                self?.weeklyWeatherRelay.accept(weeklyData)
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
