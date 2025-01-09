//
//  WeatherSimpleView.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/8/25.
//

import UIKit
import SnapKit

// 테마를 반영하기 위한 임시 색상 값 ( + 테스트 용 )
private let stackViewBackgroundColor = UIColor.clear
private let labelBackgroundLabel = UIColor.clear
private let labelColor = UIColor.label
/// 날씨 이미지, 지역, 최저/최고 기온를 담은 뷰
///
final class WeatherSimpleView: UIView {
    // 전체 데이터를 담은 스택 뷰
    private let wholeStackVieW: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = stackViewBackgroundColor
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    // 지역, 온도를 담은 스택 뷰
    private let labelStackVieW: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = stackViewBackgroundColor
        stackView.spacing = 10
        return stackView
    }()
    // 현재 온도 라벨
    let currentTemperatureLabel: UILabel = {
        let label = temperatureLabel()
        return label
    }()
    // 날씨 이미지 뷰
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "sun.max")
        imageView.tintColor = labelColor
        return imageView
    }()
    // 지역 라벨 뷰
    let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "서울특별시"
        label.backgroundColor = labelBackgroundLabel
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 전체 UI 설정
    private func configureUI() {
        addSubview(wholeStackVieW)
        // 날씨 이미지 뷰, 지역 + 기온 스택 뷰
        [weatherImageView, labelStackVieW]
            .forEach { wholeStackVieW.addArrangedSubview($0) }
        // 지역 라벨, 기온 스택 뷰
        [locationLabel, currentTemperatureLabel]
            .forEach { labelStackVieW.addArrangedSubview($0) }
        wholeStackVieW.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        locationLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        weatherImageView.snp.makeConstraints {
            $0.width.height.equalTo(labelStackVieW.snp.height)
        }
        wholeStackVieW.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension WeatherSimpleView {
    // 기온 라벨 생성 메서드
    private static func temperatureLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.backgroundColor = labelBackgroundLabel
        label.textColor = labelColor
        label.text = "현재온도: " + TemperatureFormatter.current(10)
        return label
    }
}
