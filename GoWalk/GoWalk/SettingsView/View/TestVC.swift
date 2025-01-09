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
        bindViewModel()
    }
    
    // UI 설정
    private func setupUI() {
       [
            temperatureLabel,
            buttons
       ].forEach { view.addSubview($0) }

        temperatureLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        buttons.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(temperatureLabel.snp.centerX)
            $0.width.equalTo(120)
            $0.height.equalTo(30)
        }
    }
    
    // ViewModel 바인딩
    private func bindViewModel() {
        // 온도 단위 레이블 바인딩
        SettingsManager.shared.temperatureUnit
            .subscribe(onNext: { unit in
                let convertedTemperature = SettingsManager.shared.convertTemperature(self.currentTemperature)
                self.temperatureLabel.text = "현재 온도: \(convertedTemperature) \(unit == .celsius ? "°C" : "°F")"
            }).disposed(by: disposeBag)
        
    }
}
