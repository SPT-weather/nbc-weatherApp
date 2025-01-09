//
//  MainViewController.swift
//  GoWalk
//
//  Created by t2023-m0072 on 1/7/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let labelColor = UIColor.label
private let backgroundColor = UIColor.systemBackground

class MainViewController: UIViewController {

    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    private let viewDidLoadPublisher = PublishSubject<Void>()
    private let refreshPublisher = PublishSubject<Void>()

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
        imageView.contentMode = .scaleAspectFit
        imageView.contentMode = .scaleAspectFill
        imageView.image = .puppy
        return imageView
    }()
    private let footerView = MainViewFooterView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        refreshPublisher.onNext(())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setTappedAction()
        bind()
    }

    private func configureUI() {
        view.backgroundColor = backgroundColor
        [mapButton, locationButton, settingButton]
            .forEach { navigationView.addSubview($0) }
        [navigationView, weatherSimpleView, puppyImageView, footerView]
            .forEach { view.addSubview($0) }
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
            $0.top.equalTo(navigationView.snp.bottom).offset(5)
            $0.height.equalTo(100)
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

    private static func mainViewButton() -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 20)
        let button = UIButton(type: .custom)
        button.configuration = configuration
        button.tintColor = labelColor
        return button
    }

    private func bind() {
        let viewDidLoad = viewDidLoadPublisher.asObservable()
        let refresh = refreshPublisher.asObservable()

        let output = viewModel.transform(.init(viewDidLoad: viewDidLoad,
                                               refresh: refresh))

        [
            output.weather
                .map { $0.location }
                .bind(to: self.weatherSimpleView.locationLabel.rx.text ),
            output.weather
                .compactMap { WeatherAssetTranslator.resourceImage(from: $0.weather) }
                .bind(to: self.weatherSimpleView.weatherImageView.rx.image),
            output.weather
                .map { $0.weather.korean }
                .bind(to: self.footerView.weatherStringLabel.rx.text)
        ].forEach { $0.disposed(by: disposeBag) }

        [
            output.temperature
                .map { $0.current }
                .bind(to: self.weatherSimpleView.currentTemperatureLabel.rx.text),
            output.temperature
                .map { $0.highest }
                .bind(to: self.footerView.highestTemperatureLabel.rx.text),
            output.temperature
                .map { $0.lowest }
                .bind(to: self.footerView.lowestTemperatureLabel.rx.text)
        ].forEach { $0.disposed(by: disposeBag) }

        [
            output.dust
                .map { String($0.micro) }
                .bind(to: self.footerView.microDustValueLabel.rx.text),
            output.dust
                .map { String($0.fine) }
                .bind(to: self.footerView.dustValueLabel.rx.text)
        ].forEach { $0.disposed(by: disposeBag) }
    }

    private func setTappedAction() {
        mapButton.addTarget(self,
                            action: #selector(mapButtonTapped),
                            for: .touchUpInside)
        locationButton.addTarget(self,
                                 action: #selector(refreshButtonTapped),
                                 for: .touchUpInside)
        settingButton.addTarget(self,
                                action: #selector(settingButtonTapped),
                                for: .touchUpInside)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(footerViewTapped))
        self.view.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func mapButtonTapped(_ sender: UIButton) {
        let searchViewController = ViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }

    @objc
    private func refreshButtonTapped(_ sender: UIButton) {
        refreshPublisher.onNext(())
    }

    @objc
    private func settingButtonTapped(_ sender: UIButton) {
        let settingViewController = ViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }

    @objc
    private func footerViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state == .ended else { return }
        print("11")
        let detailViewController = ViewController()
        detailViewController.view.layer.cornerRadius = 30
        if let sheet = detailViewController.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in
                let bottomY = self.weatherSimpleView.frame.maxY
                let height = UIScreen.main.bounds.height
                print(bottomY, height, height - bottomY)
                return height - bottomY - 40 })]
        }
        present(detailViewController, animated: true)
    }
}

// 푸터 뷰 선택 액션 연결만 남음
