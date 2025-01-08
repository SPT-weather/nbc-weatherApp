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
//    // 온도를 담은 스택 뷰
//    private let temperatureStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.backgroundColor = stackViewBackgroundColor
//        stackView.spacing = 8
//        return stackView
//    }()

    let currentTemperatureLabel: UILabel = {
        let label = temperatureLabel()
        return label
    }()
    // 날씨 이미지 뷰
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "sun.min")
        return imageView
    }()
    // 지역 라벨 뷰
    let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "서울특별시"
        label.backgroundColor = labelBackgroundLabel
        return label
    }()
//    // 높은 온도 라벨 뷰
//    let highestTemperatureLabel: UILabel = temperatureLabel()
//    // 낮은 온도 라벨 뷰
//    let lowestTemperatureLabel: UILabel = temperatureLabel()

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
        [imageView, labelStackVieW]
            .forEach { wholeStackVieW.addArrangedSubview($0) }
        // 지역 라벨, 기온 스택 뷰
        [locationLabel, currentTemperatureLabel]
            .forEach { labelStackVieW.addArrangedSubview($0) }
//        // 최고 온도, 최저 온도, 공백
//        [highestTemperatureLabel, lowestTemperatureLabel, UIView()]
//            .forEach { temperatureStackView.addArrangedSubview($0) }

        wholeStackVieW.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        locationLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        imageView.snp.makeConstraints {
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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.backgroundColor = labelBackgroundLabel
        label.text = "현재온도: -- ℃"
        return label
    }
}
