//
//  MainViewFooterView.swift
//  GoWalk
//
//  Created by 0-jerry on 1/8/25.
//

import UIKit
import SnapKit

private let labelColor = UIColor.label
private let backgroundColor = UIColor.systemBackground

final class MainViewFooterView: UIView {
    private let weatherStackView: UIStackView = footerStackView()
    private let microDustStackView: UIStackView = footerStackView()
    private let dustStackView: UIStackView = footerStackView()
    private let weatherTitleLabel: UILabel = {
        let label = footerLabel()
        label.text = "날씨"
        return label
    }()
    private let microDustTitleLabel: UILabel = {
        let label = footerLabel()
        label.text = "초미세먼지"
        return label
    }()
    private let dustTitleLabel: UILabel = {
        let label = footerLabel()
        label.text = "미세먼지"
        return label
    }()
    private let temperatureValueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 1
        return stackView
    }()
    let highestTemperatureLabel: UILabel = {
        let label = valueLabel()
        label.textColor = .systemRed
        label.text = "10º"
        return label
    }()
    private let temperatureSeperateLabel: UILabel = {
        let label = valueLabel()
        label.text = "/"
        return label
    }()
    let lowestTemperatureLabel: UILabel = {
        let label = valueLabel()
        label.textColor = .systemBlue
        label.text = "10º"
        return label
    }()
    let microDustValueLabel: UILabel = {
        let label = valueLabel()
        label.text = "10"
        label.textColor = labelColor
        return label
    }()
    let dustValueLabel: UILabel = {
        let label = valueLabel()
        label.text = "10"
        label.textColor = labelColor
        return label
    }()
    let weatherStringLabel: UILabel = {
        let label = footerLabel()
        label.text = "맑음"
        return label
    }()
    private let microDustMarkLabel: UILabel = {
        let label = footerLabel()
        label.text = "㎍/㎥"
        return label
    }()
    private let dustMarkLabel: UILabel = {
        let label = footerLabel()
        label.text = "㎍/㎥"
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addStackView()
        backgroundColor = .lightGray
        layer.cornerRadius = 20
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureUI() {
        [temperatureValueStackView, microDustValueLabel, dustValueLabel]
            .forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40)
                $0.leading.trailing.equalToSuperview()
            }
        }
        [highestTemperatureLabel, temperatureSeperateLabel, lowestTemperatureLabel]
            .forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40)
            }
        }
        [weatherTitleLabel, weatherStringLabel, microDustTitleLabel, microDustMarkLabel, dustTitleLabel,
         dustMarkLabel]
            .forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(30)
                $0.leading.trailing.equalToSuperview()
            }
        }
        let width = (UIScreen.main.bounds.width - 60)/3
        weatherStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(30)
            $0.width.equalTo(width)
            $0.height.equalTo(120)
        }
        temperatureValueStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        microDustStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(weatherStackView.snp.trailing)
            $0.width.equalTo(width)
            $0.height.equalTo(120)
        }
        dustStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(microDustStackView.snp.trailing)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.equalTo(width)
            $0.height.equalTo(120)
        }
    }
    private func addStackView() {
        [highestTemperatureLabel,
         temperatureSeperateLabel,
         lowestTemperatureLabel]
            .forEach { temperatureValueStackView.addArrangedSubview($0) }
        [weatherTitleLabel,
         temperatureValueStackView,
         weatherStringLabel]
            .forEach { weatherStackView.addArrangedSubview($0) }
        [microDustTitleLabel,
         microDustValueLabel,
         microDustMarkLabel]
            .forEach { microDustStackView.addArrangedSubview($0) }
        [dustTitleLabel,
         dustValueLabel,
         dustMarkLabel]
            .forEach { dustStackView.addArrangedSubview($0) }
        [weatherStackView,
         microDustStackView,
         dustStackView]
            .forEach { addSubview($0) }
        configureUI()
    }
}

// MARK: - 재사용 뷰 생성 메서드

extension MainViewFooterView {
    private static func footerStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }
    private static func valueLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "00"
        return label
    }
    private static func footerLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = labelColor
        return label
    }
}
