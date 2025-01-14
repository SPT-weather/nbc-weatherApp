//
//  MainFooterView.swift
//  GoWalk
//
//  Created by 0-jerry on 1/8/25.
//

import UIKit
import SnapKit

private let labelColor = UIColor.label
private let backgroundColor = UIColor.systemBackground

final class MainFooterView: UIView {
    private let wholeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.layer.cornerRadius = 40
        stackView.clipsToBounds = true
        return stackView
    }()
    private lazy var weatherStackView = stackView(title: "날씨",
                                                  valueView: temperatureLabel,
                                                  footerView: weatherLabel)
    private lazy var microDustStackView = stackView(title: "초미세먼지",
                                                    valueView: microDustLabel,
                                                    footerView: MainFooterView.titleLabel("㎍/㎥"))
    private lazy var fineDustStackView = stackView(title: "미세먼지",
                                                   valueView: fineDustLabel,
                                                   footerView: MainFooterView.titleLabel("㎍/㎥"))
    let temperatureLabel: UILabel = {
        let label = valueLabel()
        label.text = "10/10"
        label.minimumScaleFactor = 15
        return label
    }()
    let weatherLabel: UILabel = {
        let label = MainFooterView.titleLabel("")
        label.text = "날씨"
        return label
    }()
    let microDustLabel: UILabel = {
        let label = valueLabel()
        label.text = "100"
        return label
    }()
    let fineDustLabel: UILabel = {
        let label = valueLabel()
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 40
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureUI() {
        [weatherStackView, microDustStackView, fineDustStackView]
            .forEach { wholeStackView.addArrangedSubview($0) }
        addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - 재사용 뷰 생성 메서드

extension MainFooterView {
    private func stackView(title: String, valueView: UILabel, footerView: UILabel) -> UIStackView {
        let titleLabel = MainFooterView.titleLabel(title)
        let stackView = UIStackView(arrangedSubviews: [UIView(),
                                                       titleLabel,
                                                       valueView,
                                                       footerView,
                                                       UIView()])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        return stackView
    }
    private static func valueLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }
    private static func titleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.textColor = labelColor
        label.text = text
        return label
    }
}
