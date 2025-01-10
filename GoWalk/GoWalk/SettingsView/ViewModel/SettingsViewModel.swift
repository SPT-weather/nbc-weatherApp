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

    private let settingsManager = SettingsManager.shared
    private let disposeBag = DisposeBag()
    
    var themeMode: BehaviorRelay<ThemeMode> {
        return settingsManager.themeModeSubject
    }
    
    var temperatureUnit: BehaviorRelay<TemperatureUnit> {
        return settingsManager.temperatureUnitSubject
    }
    
    var petType: BehaviorRelay<PetType> {
        return settingsManager.petTypeSubject
    }
    
    func toggleMode(to mode: ThemeMode) {
        settingsManager.themeModeSubject.accept(mode)
    }
    
    func tapTemperature(to unit: TemperatureUnit) {
        settingsManager.temperatureUnitSubject.accept(unit)
    }
    
    func tapPetType(to type: PetType) {
        settingsManager.petTypeSubject.accept(type)
    }
    
}
