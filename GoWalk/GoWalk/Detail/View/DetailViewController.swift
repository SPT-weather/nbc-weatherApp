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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named:"ModalBgColor")
        
        //hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        
        //weeklyCollectionView.dataSource = self
        weeklyCollectionView.delegate = self
        
        setupUI()
        bind()
    }
}

struct DummyDetailModel {
    let time: String
    let temperature: String
    let icon: UIImage
    let date: Date
    let minTemperature: String
    let maxTemperature: String
}

extension DummyDetailModel {
    static var dummy: [DummyDetailModel] {
        return [
            DummyDetailModel(time: "오후 1시", temperature: "11도", icon: UIImage(resource: .dummyWeather).withTintColor(.label), date: Date(), minTemperature: "40℃", maxTemperature: "-0℃"),
            DummyDetailModel(time: "오후 2시", temperature: "11도", icon: UIImage(resource: .dummyWeather).withTintColor(.label), date: Date(), minTemperature: "40℃", maxTemperature: "-0℃"),
            DummyDetailModel(time: "오후 3시", temperature: "11도", icon: UIImage(resource: .dummyWeather).withTintColor(.label), date: Date(), minTemperature: "40℃", maxTemperature: "-0℃"),
            DummyDetailModel(time: "오후 4시", temperature: "11도", icon: UIImage(resource: .dummyWeather).withTintColor(.label), date: Date(), minTemperature: "40℃", maxTemperature: "-0℃"),
            DummyDetailModel(time: "오후 5시", temperature: "11도", icon: UIImage(resource: .dummyWeather).withTintColor(.label), date: Date(), minTemperature: "40℃", maxTemperature: "-0℃"),
            DummyDetailModel(time: "오후 6시", temperature: "11도", icon: UIImage(resource: .dummyWeather).withTintColor(.label), date: Date(), minTemperature: "40℃", maxTemperature: "-0℃"),
            DummyDetailModel(time: "오후 7시", temperature: "11도", icon: UIImage(resource: .dummyWeather).withTintColor(.label), date: Date(), minTemperature: "40℃", maxTemperature: "-0℃"),
            DummyDetailModel(time: "오후 8시", temperature: "11도", icon: UIImage(resource: .dummyWeather).withTintColor(.label), date: Date(), minTemperature: "40℃", maxTemperature: "-0℃")
        ]
    }
}

extension DetailViewController {
    private func bind() {
        Observable.just(DetailWeather.dummyHourly)
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(to: hourlyCollectionView.rx.items(
                cellIdentifier: HourlyCollectionViewCell.identifier,
                cellType: HourlyCollectionViewCell.self
            )) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        Observable.just(DetailWeather.dummyWeekly)
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(to: weeklyCollectionView.rx.items(
                cellIdentifier: WeeklyCollectionViewCell.identifier,
                cellType: WeeklyCollectionViewCell.self
            )) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        [hourlyTitleLabel, hourlyCollectionView,
         weeklyTitleLabel, weeklyCollectionView]
            .forEach { view.addSubview($0) }
        
        view.addSubview(hourlyTitleLabel)
        hourlyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(hourlyCollectionView)

        let contentLayoutGuide = view.layoutMarginsGuide

        hourlyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hourlyTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(contentLayoutGuide)
            make.height.equalTo(120)
        }
        view.addSubview(weeklyTitleLabel)
        weeklyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(hourlyCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(weeklyCollectionView)
        weeklyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weeklyTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}

//extension DetailViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == hourlyCollectionView {
//            return 10
//        } else if collectionView == weeklyCollectionView {
//            return 7
//        }
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == hourlyCollectionView {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath)
//                    as? HourlyCollectionViewCell else {
//                return UICollectionViewCell()
//            }
//            //cell.timeLabel.text = "오후 \(indexPath.item + 1)시"
//            //cell.temperatureLabel.text = "\(indexPath.item)도"
//            return cell
//        } else if collectionView == weeklyCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCollectionViewCell.identifier, for: indexPath)
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//}

extension DetailViewController: UICollectionViewDelegate {

}
