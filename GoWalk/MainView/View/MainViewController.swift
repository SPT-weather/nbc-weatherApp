//
//  MainViewController.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/7/25.
//

import UIKit
import SnapKit

private let labelColor = UIColor.label
private let backgroundColor = UIColor.systemBackground

class MainViewController: UIViewController {

    private let navigationView: UIView = {
        let view = UIView()
        return view
    }()

    private let mapButton: UIButton = {
        let button = mainViewButton()
        button.setImage(UIImage(systemName: "map"), for: .normal)
        return button
    }()
    private let locationButton: UIButton = {
        let button = mainViewButton()
        button.setImage(UIImage(systemName: "scope"), for: .normal)
        return button
    }()
    private let settingButton: UIButton = {
        let button = mainViewButton()
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        return button
    }()
    private let weatherSimpleView = WeatherSimpleView()
    private let puppyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let footerView = MainViewFooterView()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    private func configureUI() {
        view.backgroundColor = backgroundColor
        [mapButton, locationButton, settingButton].forEach { navigationView.addSubview($0) }
        [navigationView, weatherSimpleView, puppyImageView, footerView].forEach { view.addSubview($0) }

        navigationView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
        mapButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(60)
        }
        locationButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(settingButton.snp.leading).offset(-10)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        settingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        weatherSimpleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom).offset(15)
        }
        puppyImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.top.equalTo(weatherSimpleView.snp.bottom).offset(30)
            $0.bottom.equalTo(footerView.snp.top)
        }
        footerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(180)
        }
    }
    func forTest() {
        let weatherViewModel = WeatherSimple(location: "내일배움캠프",
                                              weather: .cloudy,
                                             highestTemperature: 10,
                                             lowestTemperature: 3)

        weatherSimpleView.imageView.image = WeatherAssetTranslator.resourceImage(from: weatherViewModel.weather)
        weatherSimpleView.locationLabel.text = weatherViewModel.location
//        weatherSimpleView.highestTemperatureLabel.text = weatherViewModel.highestTempDescription
//        weatherSimpleView.lowestTemperatureLabel.text = weatherViewModel.lowestTempDescription
    }

    private static func mainViewButton() -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 20)
        let button = UIButton(type: .custom)
        button.configuration = configuration
        button.tintColor = labelColor
        return button
    }
}
