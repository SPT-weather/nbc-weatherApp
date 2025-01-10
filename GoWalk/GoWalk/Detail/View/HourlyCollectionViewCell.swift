//
//  HourlyCollectionViewCell.swift
//  GoWalk
//
//  Created by seohuibaek on 1/8/25.
//

import UIKit
import SnapKit

class HourlyCollectionViewCell: UICollectionViewCell {
    static let identifier = "HourlyCollectionViewCell"
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.text = "오후 1시"
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .dummyWeather).withTintColor(.label)
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.text = "1도"
        return label
    }()
    
    private lazy var stackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconImageView, temperatureLabel])
        stackView.axis = .vertical
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
            make.top.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    func configure(with model: DetailWeather.Hourly) {
        timeLabel.text = model.time
        temperatureLabel.text = model.temperature
        iconImageView.image = model.icon
    }
}
