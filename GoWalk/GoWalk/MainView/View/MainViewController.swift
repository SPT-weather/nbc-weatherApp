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

final class MainViewController: UIViewController {
    private lazy var viewModel: MainViewModel = {
        let coreLocationManager = CoreLocationManager.shared
        coreLocationManager.delegate = self
        return MainViewModel(coreLocationManager: coreLocationManager)
    }()
    private let disposeBag = DisposeBag()
    // 새로고침 컨트롤러
    private let refreshController = UIRefreshControl()
    // 지역 목록 버튼
    private let locationListButton: UIButton = mainViewButton(UIImage(systemName: "list.bullet"))
    // 지역 재설정 버튼
    private let refreshLocationButton: UIButton = mainViewButton(UIImage(systemName: "scope"))
    // 설정 버튼
    private let settingButton: UIButton = mainViewButton(UIImage(systemName: "gearshape"))
    // 날씨 아이콘, 지역, 현재온도 뷰
    private let weatherView = MainWeatherView()
    // 새로고침 기준 시간 라벨
    let refreshDateLabel = dateLabel()
    // 동물 이미지 뷰
    let animalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    // 배경 이미지 뷰
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    // 푸터 뷰
    private let footerView = {
        let footerView = MainFooterView()
        footerView.layer.cornerRadius = 40
        return footerView
    }()
}

// MARK: - Life Cycle + configureUI

extension MainViewController {

    override func loadView() {
        super.loadView()
        bind()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setActions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    // UI 설정
    private func configureUI() {
        view.backgroundColor = UIColor.mainBackground
        let navigationView = UIView()
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.refreshControl = refreshController

        [locationListButton, refreshLocationButton, settingButton]
            .forEach { navigationView.addSubview($0) }
        [weatherView, animalImageView, backgroundImageView]
            .forEach { view.addSubview($0) }
        [scrollView, navigationView, footerView]
            .forEach { view.addSubview($0) }
        navigationView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        locationListButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(60)
        }
        refreshLocationButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(settingButton.snp.leading).offset(-10)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        settingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        weatherView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom).offset(5)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(90)
        }
        let dateLabel = MainViewController.dateLabel("기준 시간: ")
        let refreshDateStackView = UIStackView(arrangedSubviews: [dateLabel, refreshDateLabel])
        refreshDateStackView.axis = .horizontal
        refreshDateStackView.spacing = 5
        view.addSubview(refreshDateStackView)
        refreshDateStackView.snp.makeConstraints {
            $0.top.equalTo(weatherView.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        animalImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(refreshDateLabel.snp.bottom).offset(30)
            $0.bottom.equalTo(footerView.snp.top)
        }
        backgroundImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(refreshDateLabel.snp.bottom).offset(30)
            $0.bottom.equalTo(footerView.snp.top)
        }
        footerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
    }
}

// MARK: - ViewModel Bind

extension MainViewController {
    // viewModel 바인드
    private func bind() {
        let viewDidLoad = rx.viewDidLoad
        let viewWillAppear = rx.viewWillAppear
        let refresh = refreshController.rx.controlEvent(.valueChanged).asObservable()
        let refreshLocation = refreshLocationButton.rx.tap.asObservable()
        let input = MainViewModel.Input(viewDidLoad: viewDidLoad,
                                        viewWillAppear: viewWillAppear,
                                        refreshWeather: refresh,
                                        refreshLocation: refreshLocation)
        let output = viewModel.transform(input)

        output.weather
            .drive(rx.weather)
            .disposed(by: disposeBag)
        output.refreshDate
            .drive(rx.refreshDate)
            .disposed(by: disposeBag)

        output.location
            .drive(weatherView.rx.location)
            .disposed(by: disposeBag)
        output.weather
            .drive(weatherView.rx.weather)
            .disposed(by: disposeBag)

        output.dailyWeather
            .drive(footerView.rx.dailyWeather)
            .disposed(by: disposeBag)
        output.airPollution
            .drive(footerView.rx.airPollution)
            .disposed(by: disposeBag)

        // 전체 요청 응답에 대한 구독
        Observable.merge(output.weather.asObservable().map { _ in () },
                         output.dailyWeather.asObservable().map { _ in () },
                         output.airPollution.asObservable().map { _ in () },
                         output.refreshDate.asObservable().map { _ in () })
        .subscribe(on: MainScheduler.instance)
        .withUnretained(self).subscribe(onNext: { owner, _ in
            owner.updateComplete() })
        .disposed(by: disposeBag)
    }
}

// MARK: - Action

extension MainViewController {
    // 액션 설정
    private func setActions() {
        // 지역 목록 버튼 설정
        locationListButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.locationListButtonTapped()
            }.disposed(by: disposeBag)
        // 설정 버튼 설정
        settingButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.settingButtonTapped()
            }.disposed(by: disposeBag)
        // 푸터뷰 탭 설정
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.rx.event
            .withUnretained(self)
            .bind { owner, gestureRecognizer in
                owner.presentDetailViewModal(gestureRecognizer)
            }.disposed(by: disposeBag)
        self.footerView.addGestureRecognizer(gestureRecognizer)
    }
    // 지역 목록 버튼 액션
    private func locationListButtonTapped() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    // 설정 버튼 액션
    private func settingButtonTapped() {
        let viewController = SettingsViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    // 상세 뷰 모달 액션
    private func presentDetailViewModal(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state == .ended else { return }
        let detailViewModel = DetailViewModel()
        let detailViewControllerModal = DetailViewController(viewModel: detailViewModel)
        if let sheet = detailViewControllerModal.sheetPresentationController {
            // 원하는 뷰의 높이를 계산
            let targetHeight = weatherView.frame.maxY
            let height = self.view.safeAreaLayoutGuide.layoutFrame.height
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return height - targetHeight
            }
            sheet.detents = [customDetent]
        }
        detailViewControllerModal.view.layer.cornerRadius = 30
        detailViewControllerModal.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        present(detailViewControllerModal, animated: true)
    }
    // 새로고침 성공 액션
    private func updateComplete() {
        refreshController.endRefreshing()
    }
}

// MARK: - 컴포넌트 생성 메서드
extension MainViewController {
    // 메인 뷰 버튼
    private static func mainViewButton(_ image: UIImage?) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 20)
        let button = UIButton(type: .custom)
        button.configuration = configuration
        button.tintColor = labelColor
        button.setImage(image, for: .normal)
        return button
    }
    // 기준 시간 라벨 생성 메서드
    private static func dateLabel(_ text: String? = nil) -> UILabel {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.text = text
        return label
    }
}

extension MainViewController: CoreLocationAlertDelegate {
    // 위치서비스 요청 알림
    func requestLocationServiceAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        let requestLocationAlert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { _ in
            print("cancel")
        }
        requestLocationAlert.addAction(cancel)
        requestLocationAlert.addAction(goSetting)
        present(requestLocationAlert, animated: true)
    }
}
