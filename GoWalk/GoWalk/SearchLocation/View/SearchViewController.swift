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

protocol SearchViewControllerDelegate: AnyObject {
    func didSelectLocation(_ location: LocationPoint)
}

final class SearchViewController: UIViewController {
    
    private let viewModel = SearchLocationViewModel()
    
    private let disposeBag = DisposeBag()
    private weak var delegate: SearchViewControllerDelegate?
    
    private var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .minimal
        search.searchTextField.backgroundColor = .white
        search.searchTextField.textColor = .black
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
        tableView.rowHeight = 70
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyTheme()
    }
    
    // 네비바 셋업
    private func setNavigationBar() {
        navigationItem.title = "Today"
    }
    
    let searchTextRelay = BehaviorRelay<String>(value: "")
    // 바인딩 메서드
    private func bind() {
        
        // searchBar 텍스트 바인딩
        searchBar.rx.text.orEmpty
            .bind(to: searchTextRelay)
            .disposed(by: disposeBag)
        
        let input = SearchLocationViewModel.Input(searchText: searchTextRelay.asObservable())
        let output = viewModel.transform(input)
        
        // 테이블뷰 데이터 바인딩
        output.tableViewData
            .drive(locationTableVIew.rx.items(
                cellIdentifier: LocationTableViewCell.id,
                cellType: LocationTableViewCell.self)) { index, cellData, cell in
                    switch cellData.cellType {
                    case .coreData(let locationName, let temperature, let icon):
                        // 코어데이터 바인딩
                        cell.configureForCoreData(locationName, temperature, icon)
                    case .searchResult(let locationName, let latitude, let longitude):
                        // api 검색 결과 데이터 바인딩
                        cell.configureForSearchResult(locationName, latitude, longitude)
                    }
                }
                .disposed(by: disposeBag)
        
        // 셀 선택 이벤트 처리
        locationTableVIew.rx.modelSelected(WeatherCellData.self)
            .subscribe(onNext: { [weak self] cellData in
                guard let self = self else { return }
                switch cellData.cellType {
                case .coreData(let locationName, _, _):
                    // 코어데이터에서 locationName에 해당하는 LocationPoint 찾기
                    if let location = CoreDataStack.shared.fetchLocationPointList()
                        .first(where: { $0.regionName == locationName }) {
                        // 델리게이트를 통해 메인 뷰에 데이터 전달
                        self.delegate?.didSelectLocation(location)
                        self.navigationController?.popViewController(animated: true)
                    }
                case .searchResult(let regionName, let latitude, let longitude):
                    // 검색 결과를 코어데이터에 저장
                    let newLocation = LocationPoint(
                        regionName: regionName,
                        latitude: latitude,
                        longitude: longitude
                    )
                    print("newLocation: \(newLocation)")
                    // 코어데이터에 저장
                    CoreDataStack.shared.addLocation(at: newLocation)
                    
                    // 검색 텍스트 초기화
                    self.searchBar.text = ""
                    self.searchTextRelay.accept("")
                }
            })
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
