//
//  SearchViewController.swift
//  GoWalk
//
//  Created by 박민석 on 1/12/25.
//

// SearchBar의 입력값 Input과 테이블뷰의 상태 Output
// SearchBar 입력값이 없을 때는 CoreData를 보여주고, 입력값이 있으면 API를 호출

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: UIViewController {
    
    private let viewModel = SearchLocationViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var searchBar : UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .minimal
        search.searchTextField.backgroundColor = .white
        search.searchTextField.borderStyle = .none
        search.searchTextField.layer.cornerRadius = 16
        search.searchTextField.layer.borderColor = UIColor.gray.cgColor
        search.searchTextField.layer.borderWidth = 1.0
        search.searchTextField.layer.masksToBounds = true
        return search
    }()
    
    private lazy var locationTableVIew: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        setNavigationBar()
        setupUI()
        bind()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        applyTheme()
//    }
    
    // 네비바 셋업
    private func setNavigationBar() {
        navigationItem.title = "Today"
    }
   
    // 바인딩 메서드
    private func bind() {
        let searchTextRelay = PublishRelay<String>()
        
        searchBar.rx.text.orEmpty
            .bind(to: searchTextRelay)
            .disposed(by: disposeBag)
        
        let input = SearchLocationViewModel.Input(searchText: searchTextRelay.asObservable())
        let output = viewModel.transform(input)
        
        output.tableViewData
            .drive(locationTableVIew.rx.items(
                cellIdentifier: LocationTableViewCell.id,
                cellType: LocationTableViewCell.self)) { index, cellData, cell in
                    switch cellData.cellType {
                    case .coreData(let locationName, let temperature, let icon):
                        cell.configureForCoreData(locationName, temperature, icon)
                    case .searchResult(let locationName):
                        cell.configureForSearchResult(locationName)
                    }
                }
                .disposed(by: disposeBag)
    }
    
    // UI 셋업 메서드
    private func setupUI() {
        [
            searchBar,
            locationTableVIew
        ].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }
        
        locationTableVIew.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
    }
    
}
