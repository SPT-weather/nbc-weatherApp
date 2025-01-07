//
//  WeatherSimpleView.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/8/25.
//

import UIKit
import SnapKit

private let stackViewBackgroundColor = UIColor.clear
private let labelBackgroundLabel = UIColor.clear

final class WeatherSimpleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    private let stackVieW: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = stackViewBackgroundColor
        stackView.spacing = 10
        return stackView
    }()
    // 온도를 담은 스택 뷰
    private let temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = stackViewBackgroundColor
        stackView.spacing = 8
        return stackView
    }()
    // 날씨 이미지 뷰
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "sun.min")
        return imageView
    }()
    // 지역 라벨 뷰
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "서울특별시"
        label.backgroundColor = labelBackgroundLabel
        return label
    }()
    // 높은 온도 라벨 뷰
    private let highestTemperatureLabel: UILabel = temperatureLabel(.highest)
    // 낮은 온도 라벨 뷰
    private let lowestTemperatureLabel: UILabel = temperatureLabel(.lowest)
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    // 전체 UI 설정
    private func configureUI() {
        [highestTemperatureLabel, lowestTemperatureLabel, emptyView]
            .forEach { temperatureStackView.addArrangedSubview($0) }
        [locationLabel,
         temperatureStackView]
            .forEach { stackVieW.addArrangedSubview($0) }
        [imageView, stackVieW]
            .forEach { wholeStackVieW.addArrangedSubview($0) }
        addSubview(wholeStackVieW)
        wholeStackVieW.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        locationLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(stackVieW.snp.height)
        }
        wholeStackVieW.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func configure(by model: WeathetSimpleModel) {
        self.highestTemperatureLabel.text = tempForm(style: .highest, model.temperature.highest)
        self.lowestTemperatureLabel.text = tempForm(style: .lowest, model.temperature.lowest)
        self.locationLabel.text = model.location
        self.imageView.image = UIImage(systemName: model.weather.assetName)
    }
}

extension WeatherSimpleView {
    private static let temperatureMark: String = "℃"
    private static func temperatureLabel(_ style: TempeatureLabelStyle) -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "\(style.korean): 00 \(temperatureMark)"
        label.backgroundColor = labelBackgroundLabel
        return label
    }
    private func tempForm(style: TempeatureLabelStyle, _ temp: Int) -> String {
        "\(style.korean): \(temp) \(WeatherSimpleView.temperatureMark)"
    }
    private enum TempeatureLabelStyle {
        case highest
        case lowest
        var korean: String {
            switch self {
            case .highest: return "최고"
            case .lowest: return "최저"
            }
        }
    }
}

enum Weather {
    case sunny
    case cloudy
    var assetName: String {
        switch self {
        case .sunny: return "sun.min"
        case .cloudy: return "cloud.fill"
        }
    }
}

struct WeathetSimpleModel {
    let location: String
    let weather: Weather
    let temperature: (highest: Int, lowest: Int)
    init(location: String,
         weather: Weather,
         highestTemperature: Int,
         lowestTemperature: Int) {
        self.location = location
        self.weather = weather
        self.temperature = (highest: highestTemperature,
                            lowest: lowestTemperature)
    }
}
