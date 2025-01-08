//
//  DetailViewController.swift
//  GoWalk
//
//  Created by seohuibaek on 1/8/25.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    private var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 100)
        layout.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var weeklyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 50) // 주간 예보 셀 크기
        layout.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension DetailViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        hourlyCollectionView.backgroundColor = .systemGray6
        weeklyCollectionView.backgroundColor = .systemGray6
        
//        hourlyCollectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
//        weeklyCollectionView.register(WeeklyCollectionViewCell.self, forCellWithReuseIdentifier: WeeklyCollectionViewCell.identifier)
        
        view.addSubview(hourlyCollectionView)
        view.addSubview(weeklyCollectionView)
        
        hourlyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        weeklyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hourlyCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}

