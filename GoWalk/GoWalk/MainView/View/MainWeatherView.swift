//
//  WeatherSimpleView.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/8/25.
//

import UIKit
import SnapKit

// 테마를 반영하기 위한 임시 색상 값 ( + 테스트 용 )
private let tempBackgroundColor = UIColor.systemBackground
private let labelColor = UIColor.label
/// 날씨 이미지, 지역, 최저/최고 기온를 담은 뷰
///
final class MainWeatherView: UIView {
    // 날씨 이미지 뷰
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "sun.max")
        imageView.tintColor = labelColor
        return imageView
    }()
    // 지역 라벨
    let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "서울특별시"
        return label
    }()
    private let temperatureTitleLabel: UILabel = {
        let label = customLabel()
        label.text = "현재온도: "
        return label
    }()
    // 현재 온도 라벨
    let temperatureLabel: UILabel = {
        let label = customLabel()
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
        let temperatureStackView = UIStackView(arrangedSubviews: [temperatureTitleLabel,
                                                                  temperatureLabel])
        temperatureStackView.axis = .horizontal
        temperatureStackView.alignment = .leading

        let labelStackView = UIStackView(arrangedSubviews: [locationLabel,
                                                            temperatureStackView])
        labelStackView.axis = .vertical
        labelStackView.spacing = 10

        [weatherImageView, labelStackView].forEach { addSubview($0) }

        weatherImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.height.equalTo(self.snp.height)
        }
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(weatherImageView.snp.trailing).offset(10)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
}

extension MainWeatherView {
    // 기온 라벨 생성 메서드
    private static func customLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = labelColor
        label.text = TemperatureFormatter.current(0)
        return label
    }
}
