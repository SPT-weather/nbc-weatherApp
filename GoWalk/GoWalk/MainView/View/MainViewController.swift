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
    // 새로고침 컨트롤러
    private let refreshController = UIRefreshControl()
    // 새로고침용 스크롤 뷰
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let bounds = UIScreen.main.bounds
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    // 지역 목록 버튼
    private let locationListButton: UIButton = {
        let button = mainViewButton()
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        return button
    }()
    // 지역 재설정 버튼
    private let refreshLocationButton: UIButton = {
        let button = mainViewButton()
        button.setImage(UIImage(systemName: "scope"), for: .normal)
        return button
    }()
    // 설정 버튼
    private let settingButton: UIButton = {
        let button = mainViewButton()
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        return button
    }()
    // 날씨 아이콘, 지역, 현재온도 뷰
    private let weatherSimpleView = WeatherSimpleView()
    // 새로고침 기준 시간 라벨
    let refreshDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    // 동물 이미지 뷰.
    private let animalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .puppy
        return imageView
    }()
    // 푸터 뷰
    private let footerView = {
        let footerView = MainFooterView()
        footerView.layer.cornerRadius = 30
        footerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return footerView
    }()
    // Life Cycle
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
        view.backgroundColor = backgroundColor
        let navigationView = UIView()
        [locationListButton, refreshLocationButton, settingButton]
            .forEach { navigationView.addSubview($0) }
        [weatherSimpleView, refreshDateLabel, animalImageView]
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
        animalImageView.snp.makeConstraints {
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
    // 메인 뷰 버튼
    private static func mainViewButton() -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 20)
        let button = UIButton(type: .custom)
        button.configuration = configuration
        button.tintColor = labelColor
        return button
    }
    // viewModel 바인드
    private func bind() {
        let viewDidLoad = rx.viewDidLoad
        let refresh = refreshController.rx.controlEvent(.valueChanged).asObservable()
        let refreshLocation = refreshLocationButton.rx.tap.asObservable()

        let output = viewModel.transform(.init(viewDidLoad: viewDidLoad,
                                               refreshWeather: refresh,
                                               refreshLocation: refreshLocation))

        output.location
            .drive(weatherSimpleView.rx.location)
            .disposed(by: disposeBag)
        output.dust
            .drive(footerView.rx.dust)
            .disposed(by: disposeBag)
        output.refreshDate
            .drive(self.rx.refreshDate)
            .disposed(by: disposeBag)
        output.temperature
            .drive(weatherSimpleView.rx.temperatrue)
            .disposed(by: disposeBag)
        output.temperature
            .drive(footerView.rx.temperature)
            .disposed(by: disposeBag)
        output.weather
            .drive(weatherSimpleView.rx.weather)
            .disposed(by: disposeBag)
        output.weather
            .drive(footerView.rx.weather)
            .disposed(by: disposeBag)
        output.weather
            .map { WeatherAnimalAssetTraslator.transform($0) }
            .drive(animalImageView.rx.image)
            .disposed(by: disposeBag)
    }
    // 액션 설정
    private func setActions() {
        // 지역 목록 버튼 설정
        locationListButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.locationListButtonTapped()
            }.disposed(by: disposeBag)
        // 위치 재설정 버튼 설정
        refreshLocationButton.rx.tap
            .withUnretained(self)
            .bind {  owner, _ in
                owner.refreshScroll()
            }.disposed(by: disposeBag)
        // 설정 버튼 설정
        settingButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.settingButtonTapped()
            }.disposed(by: disposeBag)
        // 스크롤 새로고침 설정
        scrollView.refreshControl = refreshController
        refreshController.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind { owner, _ in
                owner.refreshScroll()
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
        let viewController = ViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    // 설정 버튼 액션
    private func settingButtonTapped() {
        let viewController = ViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    // 상세 뷰 모달 액션
    func presentDetailViewModal(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state == .ended else { return }

        let detailViewControllerModal = ViewController()
        if let sheet = detailViewControllerModal.sheetPresentationController {
            // 원하는 뷰의 높이를 계산
            let targetHeight = weatherSimpleView.frame.maxY
            let height = self.view.safeAreaLayoutGuide.layoutFrame.maxY - self.view.safeAreaLayoutGuide.layoutFrame.minY
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return height - targetHeight
            }
            sheet.detents = [customDetent]
        }
        detailViewControllerModal.view.layer.cornerRadius = 30
        detailViewControllerModal.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        present(detailViewControllerModal, animated: true)
    }
    // 새로고침 스크롤 액션
    private func refreshScroll() {
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
}
