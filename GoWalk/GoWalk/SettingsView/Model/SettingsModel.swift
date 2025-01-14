// swiftlint:disable trailing_whitespace
//
//  SettingsModel.swift
//  GoWalk
//
//  Created by 박민석 on 1/9/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsModel {
    
    private let disposeBag = DisposeBag()
    
    private let themeModeRelay = BehaviorRelay<ThemeMode>(value: UserDefaults.standard.themeMode)
    private let temperatureUnitRelay = BehaviorRelay<TemperatureUnit>(value: UserDefaults.standard.temperatureUnit)
    private let petTypeRelay = BehaviorRelay<PetType>(value: UserDefaults.standard.petType)
    
    init() {
        // Relay의 값이 변경될 때마다 UserDefaults에 저장
        themeModeRelay
            .subscribe(onNext: { mode in
                UserDefaults.standard.themeMode = mode
            })
            .disposed(by: disposeBag)
        
        temperatureUnitRelay
            .subscribe(onNext: { unit in
                UserDefaults.standard.temperatureUnit = unit
            })
            .disposed(by: disposeBag)
        
        petTypeRelay
            .subscribe(onNext: { type in
                UserDefaults.standard.petType = type
            })
            .disposed(by: disposeBag)
    }
    
    // Observable로 접근 제공
    var themeModeObservable: Observable<ThemeMode> {
        return themeModeRelay.asObservable()
    }
    
    var temperatureObservable: Observable<TemperatureUnit> {
        return temperatureUnitRelay.asObservable()
    }
    
    var petTypeObservable: Observable<PetType> {
        return petTypeRelay.asObservable()
    }
    
    // Relay 값 변경을 위한 메서드
    func updateThemeMode(_ mode: ThemeMode) {
        themeModeRelay.accept(mode)
    }
    
    func updateTemperature(_ unit: TemperatureUnit) {
        temperatureUnitRelay.accept(unit)
    }
    
    func updatePetType(_ type: PetType) {
        petTypeRelay.accept(type)
    }
}
