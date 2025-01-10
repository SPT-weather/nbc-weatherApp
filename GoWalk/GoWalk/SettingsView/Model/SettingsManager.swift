//
//  SettingsManager.swift
//  GoWalk
//
//  Created by 박민석 on 1/9/25.
//

import Foundation
import RxSwift
import RxCocoa

class SettingsManager {
    
    static let shared = SettingsManager()
    
    var themeModeSubject = BehaviorRelay<ThemeMode>(value: UserDefaults.standard.themeMode)
    var temperatureUnitSubject = BehaviorRelay<TemperatureUnit>(value: UserDefaults.standard.temperatureUnit)
    var petTypeSubject = BehaviorRelay<PetType>(value: UserDefaults.standard.petType)
    
    private init() {
        // Subject의 값이 변경될 때마다 UserDefaults에 저장
        themeModeSubject
            .subscribe(onNext: { mode in
                UserDefaults.standard.themeMode = mode
            })
            .disposed(by: disposeBag)
        
        temperatureUnitSubject
            .subscribe(onNext: { unit in
                UserDefaults.standard.temperatureUnit = unit
            })
            .disposed(by: disposeBag)
        
        petTypeSubject
            .subscribe(onNext: { type in
                UserDefaults.standard.petType = type
            })
            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    // 온도 단위 변환 클래스
    func convertTemperature(_ value: Double) -> String {
        let currentUnit = temperatureUnitSubject.value
        switch currentUnit {
        case .celsius:
            return String(format: "%.1f", value)
        case .fahrenheit:
            return String(format: "%.1f", value.toFahrenheit())
        }
    }
}
