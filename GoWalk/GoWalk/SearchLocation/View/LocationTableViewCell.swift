//
//  LocationTableViewCell.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/13/25.
//

import UIKit
import SnapKit

final class LocationTableViewCell: UITableViewCell {
    
    static let id = "LocationCell"
    
    // 지명 레이블
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    // 온도 레이블
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "10°C"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    // 날씨 아이콘 이미지뷰
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        applyTheme()
        [
            locationLabel,
            temperatureLabel,
            weatherIconImageView
        ].forEach { contentView.addSubview($0) }
        
        locationLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(temperatureLabel.snp.leading).offset(-20)
            $0.height.equalTo(30)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-70)
            $0.width.equalTo(60)
            $0.height.equalTo(locationLabel.snp.height)
        }
        
        weatherIconImageView.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(temperatureLabel.snp.trailing).offset(12)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.width.height.equalTo(30)
        }
    }
    
    // 코어데이터 로드시 ui 재설정
    func configureForCoreData(_ locationName: String, _ temperature: Double?, _ icon: String?) {
        locationLabel.text = locationName
        if let temperatureValue = temperature {
            temperatureLabel.text = SettingsManager.shared.convertedTemperature(temperatureValue)
            temperatureLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        } else {
            temperatureLabel.text = "N/A"
        }
        locationLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        locationLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(temperatureLabel.snp.leading).offset(-20)
            $0.height.equalTo(30)
        }
        
        if let iconName = icon, let image = UIImage(named: iconName)?.withTintColor(.label) {
            weatherIconImageView.image = image
        } else {
            weatherIconImageView.image = UIImage(named: "DummyWeather")?.withTintColor(.label)
        }
        // 온도 레이블 및 아이콘 보이기
        temperatureLabel.isHidden = false
        weatherIconImageView.isHidden = false
        
    }
    
    // api 데이터 로드시 ui 재설정
    func configureForSearchResult(_ locationName: String, _ latitude: Double, _ longitude: Double) {
        locationLabel.text = locationName
        locationLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        // 온도 레이블 및 아이콘 숨기기
        temperatureLabel.isHidden = true
        weatherIconImageView.isHidden = true
        
        // 검색 결과 상태의 제약조건으로 업데이트
        locationLabel.snp.remakeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.height.equalTo(30)
        }
    }
    // 화면 테마모드 적용
    private func applyTheme() {
        let theme = SettingsManager.shared.themeMode
        switch theme {
        case .light:
            overrideUserInterfaceStyle = .light
        case .dark:
            overrideUserInterfaceStyle = .dark
        case .system:
            overrideUserInterfaceStyle = .unspecified
        }
        contentView.backgroundColor = UIColor(resource: .mainBackground)
    }
    
}
