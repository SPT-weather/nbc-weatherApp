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
        let toggleMode: Observable<ThemeMode> // 모드 변경 (라이트/다크)
        let tapTemperature: Observable<TemperatureUnit> // 온도 단위 선택
        let tapPetType: Observable<PetType> // 동물 이미지 종류 선택
    }
    
    // Output: ViewModel에서 View로 전달되는 데이터
    // View가 UI를 업데이트 할 수 있도록 제공되는 데이터를 관리하는 구조체
    struct Output {
        let themeMode: Driver<ThemeMode> // 현재 테마 상태
        let temperatureUnit: Driver<TemperatureUnit> // 현재 온도 단위
        let petType: Driver<PetType> // 현재 선택된 동물 이미지 종류
    }
    
    private let settingsModel: SettingsModel
    private let disposeBag = DisposeBag()
    
    init(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
    }
    
    // transform 메서드: Input의 이벤트를 구독하고, 데이터 업데이트해서 Output으로 반환하는 역할
    // Input: View에서 발생한 이벤트(toggleMode, tapTempurature, tapPetType)
    // Output: View에서 바인딩할 데이터 스트림
    func transform(_ input: Input) -> Output {
        // Input 처리: View에서 받은 이벤트를 Model의 메서드를 호출하여 Relay 값을 업데이트
        input.toggleMode
            .subscribe(onNext: { [weak self] mode in
                self?.settingsModel.updateThemeMode(mode) // 모드 변경
            })
            .disposed(by: disposeBag)
        
        input.tapTemperature
            .subscribe(onNext: { [weak self] unit in
                self?.settingsModel.updateTemperature(unit) // 온도 단위 변경
            })
            .disposed(by: disposeBag)
        
        input.tapPetType
            .subscribe(onNext: { [weak self] type in
                self?.settingsModel.updatePetType(type) // 동물 이미지 종류 변경
            })
            .disposed(by: disposeBag)
        
        // Output 생성: Model의 Observable을 Driver로 변환하여 UI에서 사용
        let themeMode = settingsModel.themeModeObservable
            .asDriver(onErrorJustReturn: .light) // onErrorJustReturn: 에러 발생 시 기본값 반환
        
        let temperatureUnit = settingsModel.temperatureObservable
            .asDriver(onErrorJustReturn: .celsius)
        
        let petType = settingsModel.petTypeObservable
            .asDriver(onErrorJustReturn: .dog)
        
        return Output(themeMode: themeMode, temperatureUnit: temperatureUnit, petType: petType)
    }
}
