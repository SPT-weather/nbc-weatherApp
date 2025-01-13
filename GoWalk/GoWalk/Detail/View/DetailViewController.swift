//
//  DetailViewController.swift
//  GoWalk
//
//  Created by seohuibaek on 1/8/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private var disposeBag = DisposeBag()
    
    private lazy var hourlyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "시간별 날씨"
        return label
    }()

    private lazy var weeklyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "요일별 날씨"
        return label
    }()

    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(named: "SectionBgColor")
        collectionView.layer.cornerRadius = 16
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = true
        return collectionView
    }()

    private lazy var weeklyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 10, bottom: 0, right: 10)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WeeklyCollectionViewCell.self, forCellWithReuseIdentifier: WeeklyCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(named: "SectionBgColor")
        collectionView.layer.cornerRadius = 16
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = true
        return collectionView
    }()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named:"ModalBgColor")
        setupUI()
        bind()
    }
}

extension DetailViewController {
    private func bind() {
        let input = DetailViewModel.Input(
            viewDidLoad: Observable.just(()),  // 화면이 로드될 때 한 번만 발생
            refresh: Observable.never()  // refresh 기능은 아직 미구현
        )

        let output = viewModel.transform(input: input)

        output.hourlyWeather
            .drive(hourlyCollectionView.rx.items(
                cellIdentifier: HourlyCollectionViewCell.identifier,
                cellType: HourlyCollectionViewCell.self)
            ) { _, item, cell in
                cell.configure(with: item) // 셀에 데이터를 전달하여 UI 업데이트
            }
            .disposed(by: disposeBag)

        output.weeklyWeather
            .drive(weeklyCollectionView.rx.items(
                cellIdentifier: WeeklyCollectionViewCell.identifier,
                cellType: WeeklyCollectionViewCell.self)
            ) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)

        // 에러 처리 (임시)
        output.error
            .drive(onNext: { [weak self] (error: Error) in
                let alert = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        [hourlyTitleLabel, hourlyCollectionView,
         weeklyTitleLabel, weeklyCollectionView]
            .forEach { view.addSubview($0) }

        hourlyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        let contentLayoutGuide = view.layoutMarginsGuide

        hourlyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hourlyTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(contentLayoutGuide)
            make.height.equalTo(120)
        }

        weeklyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(hourlyCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        weeklyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weeklyTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
