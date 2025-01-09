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

    let viewModel = SettingsViewModel()
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

    // 풍속 단위 설정 레이블
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "WIND SPEED"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    // m/s 버튼
    private let meterPerSecondButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemCyan
        button.setTitle("m/s", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 8
        return button
    }()

    // km/h 버튼
    private let kiloMeterPerHourButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.setTitle("km/h", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 8
        return button
    }()
    // mph 버튼
    private let milePerHoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.setTitle("mph", for: .normal)
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
        
        print("모드 저장값: \(UserDefaults.standard.themeMode)")
        print("온도 단위 저장값: \(UserDefaults.standard.temperatureUnit)")
        print("풍속 단위 저장값: \(UserDefaults.standard.windSpeedUnit)")
        
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
        viewModel.themeMode
            .subscribe(onNext: { [weak self] mode in
                guard let self = self else { return }
                self.updateMode(mode)
            }).disposed(by: disposeBag)
        
        viewModel.temperature
            .subscribe(onNext: { [weak self] unit in
                guard let self = self else { return }
                self.updateTemperatureUnit(unit)
            }).disposed(by: disposeBag)
        
        viewModel.windSpeed
            .subscribe(onNext: { [weak self] unit in
                guard let self = self else { return }
                self.updateWindSpeedUnit(unit)
            }).disposed(by: disposeBag)
        
        lightModeButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.toggleMode(to: .light)
            }.disposed(by: disposeBag)
        
        darkModeButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.toggleMode(to: .dark)
            }.disposed(by: disposeBag)
        
        celsiusButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.tapTemperature(to: .celsius)
            }.disposed(by: disposeBag)
        
        fahrenheitButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.tapTemperature(to: .fahrenheit)
            }.disposed(by: disposeBag)
        
        meterPerSecondButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.tapWindSpeed(to: .metersPerSecond)
            }.disposed(by: disposeBag)
        
        kiloMeterPerHourButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.tapWindSpeed(to: .kilometersPerHour)
            }.disposed(by: disposeBag)
        
        milePerHoutButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.tapWindSpeed(to: .milesPerHour)
            }.disposed(by: disposeBag)
    }
    
    // 라이트모드/다크모드 적용
    private func updateMode(_ mode: ThemeMode) {
        switch mode {
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
    
    // 풍속 설정 UI 반영
    private func updateWindSpeedUnit(_ unit: WindSpeedUnit) {
        switch unit {
        case .metersPerSecond:
            meterPerSecondButton.backgroundColor = .systemCyan
            kiloMeterPerHourButton.backgroundColor = .systemGray4
            milePerHoutButton.backgroundColor = .systemGray4
        case .kilometersPerHour:
            meterPerSecondButton.backgroundColor = .systemGray4
            kiloMeterPerHourButton.backgroundColor = .systemCyan
            milePerHoutButton.backgroundColor = .systemGray4
        case .milesPerHour:
            meterPerSecondButton.backgroundColor = .systemGray4
            kiloMeterPerHourButton.backgroundColor = .systemGray4
            milePerHoutButton.backgroundColor = .systemCyan
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
            meterPerSecondButton,
            kiloMeterPerHourButton,
            milePerHoutButton,
            underLineView,
            modeLabel,
            lightModeButton,
            darkModeButton,
            checkImageView
        ].forEach { view.addSubview($0) }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
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
        
        meterPerSecondButton.snp.makeConstraints {
            $0.top.equalTo(windSpeedLabel.snp.bottom).offset(10)
            $0.leading.equalTo(temperatureLabel.snp.leading)
            $0.width.equalTo(85)
            $0.height.equalTo(35)
        }
        
        kiloMeterPerHourButton.snp.makeConstraints {
            $0.top.equalTo(meterPerSecondButton.snp.top)
            $0.leading.equalTo(meterPerSecondButton.snp.trailing).offset(10)
            $0.width.equalTo(85)
            $0.height.equalTo(35)
        }
        
        milePerHoutButton.snp.makeConstraints {
            $0.top.equalTo(meterPerSecondButton.snp.top)
            $0.leading.equalTo(kiloMeterPerHourButton.snp.trailing).offset(10)
            $0.width.equalTo(85)
            $0.height.equalTo(35)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(meterPerSecondButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(2)
        }
        
        modeLabel.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(20)
            $0.leading.equalTo(temperatureLabel.snp.leading)
        }
        
        lightModeButton.snp.makeConstraints {
            $0.top.equalTo(modeLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(checkImageView.snp.leading)
            $0.height.equalTo(30)
        }
        
        darkModeButton.snp.makeConstraints {
            $0.top.equalTo(lightModeButton.snp.bottom).offset(10)
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
