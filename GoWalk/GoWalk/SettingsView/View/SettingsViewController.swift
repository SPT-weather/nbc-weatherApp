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
        // MARK: - 버튼 탭 이벤트 처리
        // 각각의 버튼 탭 이벤트를 구독하여 적절한 뷰모델의 메서드 호출

        // 라이트 모드 버튼 탭 이벤트를 구독하여 모드를 라이트로 변경
        lightModeButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.toggleMode(to: .light)
            }.disposed(by: disposeBag)

        // 다크 모드 버튼 탭 이벤트를 구독하여 모드를 다크로 변경
        darkModeButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.toggleMode(to: .dark)
            }.disposed(by: disposeBag)

        // 섭씨 단위 버튼 탭 이벤트를 구독하여 온도 단위를 섭씨로 변경
        celsiusButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.tapTemperature(to: .celsius)
            }.disposed(by: disposeBag)

        // 화씨 단위 버튼 탭 이벤트를 구독하여 온도 단위를 화씨로 변경
        fahrenheitButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.tapTemperature(to: .fahrenheit)
            }.disposed(by: disposeBag)

        // 강아지 버튼 탭 이벤트를 구독하여 동물 타입을 강아지로 변경
        dogButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.tapPetType(to: .dog)
            }.disposed(by: disposeBag)

        // 고양이 버튼 탭 이벤트를 구독하여 동물 타입을 고양이로 변경
        catButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.tapPetType(to: .cat)
            }.disposed(by: disposeBag)
        
        // MARK: -  뷰모델의 BehaviorRelay를 옵저빙하여 UI 업데이트
        // 각각의 BehaviorRelay를 구독하여 값이 변경될 때마다 UI 업데이트 메서드 호출
        
        // 테마 모드 변경 사항을 구독하여 업데이트
        viewModel.themeMode
            .subscribe(onNext: { [weak self] mode in
                guard let self = self else { return }
                self.updateMode(mode)
            }).disposed(by: disposeBag)

        // 온도 단위 변경 사항을 구독하여 업데이트
        viewModel.temperatureUnit
            .subscribe(onNext: { [weak self] unit in
                guard let self = self else { return }
                self.updateTemperatureUnit(unit)
            }).disposed(by: disposeBag)

        // 동물 타입 변경 사항을 구독하여 업데이트
        viewModel.petType
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                self.updatePetType(type)
            }).disposed(by: disposeBag)
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
