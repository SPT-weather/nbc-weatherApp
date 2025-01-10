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
// 새로고침한 시간 표시 라벨
private let labelColor = UIColor.label
private let backgroundColor = UIColor.systemBackground

class MainViewController: UIViewController {

    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    private let viewDidLoadPublisher = PublishSubject<Void>()
    private let refreshPublisher = PublishSubject<Void>()
    private let refreshLocationPublisher = PublishSubject<Void>()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let bounds = UIScreen.main.bounds
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
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
    private let refreshDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    private let puppyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .puppy
        return imageView
    }()
    private let footerView = MainViewFooterView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func loadView() {
        super.loadView()
        bind()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadPublisher.onNext(())
        configureUI()
        setTappedAction()
        setRefreshController()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    private func configureUI() {
        view.backgroundColor = backgroundColor

        [mapButton, locationButton, settingButton]
            .forEach { navigationView.addSubview($0) }
        [weatherSimpleView, refreshDateLabel, puppyImageView]
            .forEach { scrollView.addSubview($0) }
        [scrollView, navigationView, footerView]
            .forEach { view.addSubview($0) }

        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
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
            $0.height.equalTo(90)
        }
        refreshDateLabel.snp.makeConstraints {
            $0.top.equalTo(weatherSimpleView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
        }
        puppyImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(refreshDateLabel.snp.bottom).offset(30)
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
        let refreshLocation = refreshLocationPublisher
            .asObservable()

        let output = viewModel.transform(.init(viewDidLoad: viewDidLoad,
                                               refreshWeather: refresh,
                                               refreshLocation: refreshLocation))

        [
            output.location.bind(to: weatherSimpleView.locationLabel.rx.text),
            output.currentTemperature.bind(to: weatherSimpleView.currentTemperatureLabel.rx.text),
            output.highestTemperature.bind(to: footerView.highestTemperatureLabel.rx.text),
            output.lowestTemperature.bind(to: footerView.lowestTemperatureLabel.rx.text),
            output.microDust.bind(to: footerView.microDustValueLabel.rx.text),
            output.fineDust.bind(to: footerView.fineDustValueLabel.rx.text),
            output.refreshDate.bind(to: refreshDateLabel.rx.text)
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
        self.footerView.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func mapButtonTapped(_ sender: UIButton) {
        let searchViewController = ViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }

    @objc
    private func refreshButtonTapped(_ sender: UIButton) {
        refreshLocationPublisher.onNext(())
    }

    @objc
    private func settingButtonTapped(_ sender: UIButton) {
        let settingViewController = ViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }

    @objc
    private func footerViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state == .ended else { return }
        let detailViewController = ViewController()
        detailViewController.view.layer.cornerRadius = 30
        if let sheet = detailViewController.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in
                let bottomY = self.weatherSimpleView.frame.maxY
                let height = self.view.layer.frame.maxY
                print(bottomY, height, height - bottomY)
                // 특정 좌표를 기준으로 잡아야할 필요성이 있음
                return height - (bottomY + 100) })]
        }
        present(detailViewController, animated: true)
    }

    private func setRefreshController() {
        let refreshController = UIRefreshControl()
        self.scrollView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshScroll), for: .valueChanged)
    }

    @objc
    private func refreshScroll() {
        refreshPublisher.onNext(())
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
}

// 푸터 뷰 선택 액션 연결만 남음
// 뷰모델 로직 수정 중 2시까지 PR 예정
