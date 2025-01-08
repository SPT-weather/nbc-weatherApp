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
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.text = "10/11"
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "DummyWeather")
        return imageView
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.text = "최고: 0℃ 최저: -7℃"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // 셀 배경색 및 스타일 설정
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        // UI 요소 추가
        contentView.addSubview(dateLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(temperatureLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(50)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.size.equalTo(24)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }
    }

//    func configure(with model: HourlyForecast) {
//        timeLabel.text = model.time
//        temperatureLabel.text = model.temperature
//        iconImageView.image = UIImage(systemName: model.icon)
//    }
}
