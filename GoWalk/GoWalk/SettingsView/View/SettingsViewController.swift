// swiftlint:disable trailing_whitespace
//
//  SettingsViewController.swift
//  GoWalk
//
//  Created by 박민석 on 1/8/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    let viewModel: SettingsViewModel = .init(settingsModel: SettingsModel())
    let disposeBag = DisposeBag()
    
    // MARK: - UI 컴포넌트 선언
    
    // 온도 단위 설정 레이블
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "TEMPERATURE"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    // 섭씨 버튼
    private let celsiusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemCyan
        button.setTitle("°C", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // 화씨 버튼
    private let fahrenheitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.setTitle("°F", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // 동물 이미지 설정 레이블
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "PET"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    // 강아지 버튼
    private let dogButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemCyan
        button.setTitle("Dog", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // 고양이 버튼
    private let catButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.setTitle("Cat", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // 구분선
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    // 화면 모드 설정 레이블
    private let modeLabel: UILabel = {
        let label = UILabel()
        label.text = "Mode"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    // 시스템 설정 모드 버튼
    private let systemModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("기기 설정 사용", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    // 라이트 모드 버튼
    private let lightModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("라이트 모드", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    // 다크 모드 버튼
    private let darkModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("다크 모드", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    // 체크 마크 이미지뷰
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .label
        imageView.isHidden = false
        return imageView
    }()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 다크 모드와 라이트 모드 모두에서 적절한 배경 색상 설정
        view.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        
        setNavigationBar()
        setupUI()
        bind()
    }
    
    // MARK: - UI 업데이트 메서드
    
    // 바인딩 메서드
    private func bind() {
        
        // input 생성
        let input = SettingsViewModel.Input(
            toggleMode: Observable.merge(
                systemModeButton.rx.tap.map { ThemeMode.system},
                lightModeButton.rx.tap.map { ThemeMode.light },
                darkModeButton.rx.tap.map { ThemeMode.dark }
            ),
            tapTemperature: Observable.merge(
                celsiusButton.rx.tap.map { TemperatureUnit.celsius },
                fahrenheitButton.rx.tap.map { TemperatureUnit.fahrenheit }
            ),
            tapPetType: Observable.merge(
                dogButton.rx.tap.map { PetType.dog },
                catButton.rx.tap.map { PetType.cat }
            )
        )
        
        // output 생성
        let output = viewModel.transform(input)
        
        // output 구독하여 UI 업데이트
        output.themeMode
            .drive(onNext: { [weak self] mode in
                self?.updateMode(mode)
            }).disposed(by: disposeBag)
        
        output.temperatureUnit
            .drive(onNext: { [weak self] unit in
                self?.updateTemperatureUnit(unit)
            }).disposed(by: disposeBag)
        
        output.petType
            .drive(onNext: { [weak self] type in
                self?.updatePetType(type)
            }).disposed(by: disposeBag)
    }
    
    // 라이트모드/다크모드 적용
    private func updateMode(_ mode: ThemeMode) {
        switch mode {
        case .system:
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .forEach { windowScene in
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .unspecified
                    }
                }
            updateCheckMaker(systemModeButton)
            
        case .light:
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .forEach { windowScene in
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            updateCheckMaker(lightModeButton)
            
        case .dark:
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .forEach { windowScene in
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .dark
                    }
                }
            updateCheckMaker(darkModeButton)
        }
    }
    
    // 온도 설정 UI 반영
    private func updateTemperatureUnit(_ unit: TemperatureUnit) {
        switch unit {
        case .celsius:
            celsiusButton.backgroundColor = .systemCyan
            fahrenheitButton.backgroundColor = .systemGray4
        case .fahrenheit:
            celsiusButton.backgroundColor = .systemGray4
            fahrenheitButton.backgroundColor = .systemCyan
        }
    }
    
    // 동물 설정 UI 반영
    private func updatePetType(_ type: PetType) {
        switch type {
        case .dog:
            dogButton.backgroundColor = .systemCyan
            catButton.backgroundColor = .systemGray4
        case .cat:
            dogButton.backgroundColor = .systemGray4
            catButton.backgroundColor = .systemCyan
        }
    }
    
    // 체크 마크 위치 업데이트
    private func updateCheckMaker(_ button: UIButton) {
        checkImageView.isHidden = false
        checkImageView.snp.remakeConstraints {
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().offset(-30)
            $0.centerY.equalTo(button.snp.centerY)
        }
    }
    
    // MARK: - 셋업 메서드
    
    // 네비바 셋업
    private func setNavigationBar() {
        navigationItem.title = "Settings"
    }
    
    // UI 셋업
    private func setupUI() {
        [
            temperatureLabel,
            windSpeedLabel,
            celsiusButton,
            fahrenheitButton,
            dogButton,
            catButton,
            underLineView,
            modeLabel,
            systemModeButton,
            lightModeButton,
            darkModeButton,
            checkImageView
        ].forEach { view.addSubview($0) }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        celsiusButton.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(10)
            $0.leading.equalTo(temperatureLabel.snp.leading)
            $0.width.equalTo(85)
            $0.height.equalTo(35)
        }
        
        fahrenheitButton.snp.makeConstraints {
            $0.top.equalTo(celsiusButton.snp.top)
            $0.leading.equalTo(celsiusButton.snp.trailing).offset(10)
            $0.width.equalTo(85)
            $0.height.equalTo(35)
        }
        
        windSpeedLabel.snp.makeConstraints {
            $0.top.equalTo(celsiusButton.snp.bottom).offset(20)
            $0.leading.equalTo(temperatureLabel.snp.leading)
        }
        
        dogButton.snp.makeConstraints {
            $0.top.equalTo(windSpeedLabel.snp.bottom).offset(10)
            $0.leading.equalTo(temperatureLabel.snp.leading)
            $0.width.equalTo(85)
            $0.height.equalTo(35)
        }
        
        catButton.snp.makeConstraints {
            $0.top.equalTo(dogButton.snp.top)
            $0.leading.equalTo(dogButton.snp.trailing).offset(10)
            $0.width.equalTo(85)
            $0.height.equalTo(35)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(dogButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(2)
        }
        
        modeLabel.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(20)
            $0.leading.equalTo(temperatureLabel.snp.leading)
        }
        
        systemModeButton.snp.makeConstraints {
            $0.top.equalTo(modeLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(checkImageView.snp.leading)
            $0.height.equalTo(30)
        }
        
        darkModeButton.snp.makeConstraints {
            $0.top.equalTo(systemModeButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(checkImageView.snp.leading)
            $0.height.equalTo(30)
        }
        
        lightModeButton.snp.makeConstraints {
            $0.top.equalTo(systemModeButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(checkImageView.snp.leading)
            $0.height.equalTo(30)
        }
        
        checkImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().offset(-30)
            $0.centerY.equalTo(lightModeButton.snp.centerY)
        }
    }
}
