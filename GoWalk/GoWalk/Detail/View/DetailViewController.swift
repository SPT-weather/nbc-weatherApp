//
//  DetailViewController.swift
//  GoWalk
//
//  Created by seohuibaek on 1/8/25.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    private lazy var hourlyTitleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = .black
            label.textAlignment = .left
            label.text = "시간별 날씨"
            return label
        }()

        private lazy var weeklyTitleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = .black
            label.textAlignment = .left
            label.text = "요일별 날씨"
            return label
        }()

    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 100)
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 16
        collectionView.clipsToBounds = true
        return collectionView
    }()

    private lazy var weeklyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 50) // 주간 예보 셀 크기
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WeeklyCollectionViewCell.self, forCellWithReuseIdentifier: WeeklyCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 16
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
        view.backgroundColor = .systemGray6
        
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        
        weeklyCollectionView.dataSource = self
        weeklyCollectionView.delegate = self
        
        setupUI()
    }
}

extension DetailViewController {
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
        hourlyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hourlyTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
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

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyCollectionView {
            return 10
        } else if collectionView == weeklyCollectionView {
            return 7
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath)
                    as? HourlyCollectionViewCell else {
                return UICollectionViewCell()
            }
            //cell.timeLabel.text = "오후 \(indexPath.item + 1)시"
            //cell.temperatureLabel.text = "\(indexPath.item)도"
            return cell
        } else if collectionView == weeklyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCollectionViewCell.identifier, for: indexPath)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension DetailViewController: UICollectionViewDelegate {

}
