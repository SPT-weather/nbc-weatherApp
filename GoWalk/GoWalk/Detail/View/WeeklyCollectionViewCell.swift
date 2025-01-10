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
        label.text = "10/11"
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .dummyWeather).withTintColor(.label)
        return imageView
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.text = "최고: 0℃"
        return label
    }()
    
    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.text = "최저: -7℃"
        return label
    }()
    
    private lazy var stackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, iconImageView, maxTemperatureLabel, minTemperatureLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
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
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
        
    func configure(with model: DetailWeather.Weekly) {
        dateLabel.text = Self.dateFormatter.string(from: model.date)
        iconImageView.image = model.icon
//        maxTemperatureLabel.text = "최고: \(model.maxTemperature)"
//        minTemperatureLabel.text = "최저: \(model.minTemperature)"
        maxTemperatureLabel.text =   model.maxTemperature
        minTemperatureLabel.text = model.minTemperature
        
    }
}

