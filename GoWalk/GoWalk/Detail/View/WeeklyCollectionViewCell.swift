//
//  WeeklyCollectionViewCell.swift
//  GoWalk
//
//  Created by seohuibaek on 1/8/25.
//

import UIKit
import SnapKit

class WeeklyCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeeklyCollectionViewCell"

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .dummyWeather).withTintColor(.label)
        return imageView
    }()

    private let maxTemperatureTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.text = "최고: "
        return label
    }()

    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let minTemperatureTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.text = "최저: "
        return label
    }()

    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()

    private lazy var temperatureStackView = {
        let stackView = UIStackView(arrangedSubviews: [maxTemperatureTitleLabel, maxTemperatureLabel,
                                                       minTemperatureTitleLabel, minTemperatureLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var stackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, iconImageView,
                                                       temperatureStackView, minTemperatureLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
        }

        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }

        dateLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
        }

        maxTemperatureLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(80)
        }

        minTemperatureLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(80)
        }
    }

    // Date Formatter 추후 분리 예정
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()

    func configure(with model: DetailWeather.Weekly) {
        dateLabel.text = Self.dateFormatter.string(from: model.date)
        maxTemperatureLabel.text = model.maxTemperature
        minTemperatureLabel.text = model.minTemperature

        WeatherImageLoader.loadImage(from: model.iconUrl) { [weak self] image in
            self?.iconImageView.image = image
        }
    }
}
