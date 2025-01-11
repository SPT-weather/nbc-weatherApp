// swiftlint:disable trailing_whitespace
//
//  SettingsViewModel.swift
//  GoWalk
//
//  Created by 박민석 on 1/8/25.
//

import Foundation
import RxSwift
import RxCocoa

class SettingsViewModel {
    
    // Input: View에서 ViewModel로 전달되는 사용자 입력
    // 사용자가 버튼을 눌렀을 때 발생하는 이벤트를 관리하는 구조체
    struct Input {
        let toggleMode: Observable<ThemeMode>
        let tapTemperature: Observable<TemperatureUnit>
        let tapPetType: Observable<PetType>
    }
    
    // Output: ViewModel에서 View로 전달되는 데이터
    // View가 UI를 업데이트 할 수 있도록 제공되는 데이터를 관리하는 구조체
    struct Output {
        let themeMode: Driver<ThemeMode>
        let temperatureUnit: Driver<TemperatureUnit>
        let petType: Driver<PetType>
    }
    
    private let settingsModel = SettingsModel.shared
    private let disposeBag = DisposeBag()
    
    
    // transform 메서드: Input의 이벤트를 구독하고, 데이터 업데이트해서 Output으로 반환하는 역할
    // input으로 toggleMode, tapTempurature, tapPetType를 받고, Model의 Relay에 바인딩하여 업데이트
    // Model의 BehaviorRelay를 Driver로 변환하여 Output을 생성하고 반환
    func transform(_ input: Input) -> Output {
        // Input 처리
        input.toggleMode
            .subscribe(onNext: { [weak self] mode in
                self?.settingsModel.updateThemeMode(mode)
            })
            .disposed(by: disposeBag)
        
        input.tapTemperature
            .subscribe(onNext: { [weak self] unit in
                self?.settingsModel.updateTemperature(unit)
            })
            .disposed(by: disposeBag)
        
        input.tapPetType
            .subscribe(onNext: { [weak self] type in
                self?.settingsModel.updatePetType(type)
            })
            .disposed(by: disposeBag)
        
        // output 생성
        let themeMode = settingsModel.themeModeObservable
            .asDriver(onErrorJustReturn: .light) // 에러 발생 시 기본값 반환
        
        let temperatureUnit = settingsModel.temperatureObservable
            .asDriver(onErrorJustReturn: .celsius)
        
        let petType = settingsModel.petTypeObservable
            .asDriver(onErrorJustReturn: .dog)
        
        return Output(themeMode: themeMode, temperatureUnit: temperatureUnit, petType: petType)
    }
}
