//
//  TestVC.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/9/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TestViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let currentTemperature = 12.3
    
    // UI 컴포넌트 선언
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let petImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let buttons: UIButton = {
        let button = UIButton()
        button.setTitle("테스트버튼", for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonActions() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bind()
    }
    
    // UI 설정
    private func setupUI() {
       [
            temperatureLabel,
            petImageView,
            buttons
       ].forEach { view.addSubview($0) }

        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(UIScreen.main.bounds.height / 3)
        }
        petImageView.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(temperatureLabel.snp.centerX)
            $0.width.height.equalTo(150)
        }
        
        buttons.snp.makeConstraints {
            $0.top.equalTo(petImageView.snp.bottom).offset(20)
            $0.centerX.equalTo(temperatureLabel.snp.centerX)
            $0.width.equalTo(120)
            $0.height.equalTo(30)
        }
    }
    
    // ViewModel 바인딩
    private func bind() {
        // 온도 단위 레이블 바인딩
        SettingsManager.shared.temperatureUnitSubject
            .subscribe(onNext: { unit in
                let convertedTemperature = SettingsManager.shared.convertTemperature(self.currentTemperature)
                self.temperatureLabel.text = "현재 온도: \(convertedTemperature) \(unit == .celsius ? "°C" : "°F")"
            }).disposed(by: disposeBag)
        
        SettingsManager.shared.petTypeSubject
            .map { petType -> UIImage? in
                switch petType {
                case .dog:
                    return UIImage(systemName: "pawprint") // 강아지 이미지
                case .cat:
                    return UIImage(systemName: "tortoise") // 고양이 이미지
                }
            }
            .bind(to: petImageView.rx.image)
            .disposed(by: disposeBag)
        
        SettingsManager.shared.themeModeSubject
            .subscribe(onNext: { mode in
                switch mode {
                case .light:
                    UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .forEach { windowScene in
                            windowScene.windows.forEach { window in
                                window.overrideUserInterfaceStyle = .light
                            }
                        }
                case .dark:
                    UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .forEach { windowScene in
                            windowScene.windows.forEach { window in
                                window.overrideUserInterfaceStyle = .dark
                            }
                        }
                }
            })
            
        
    }
}
