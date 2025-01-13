//
//  SearchLocationViewModel.swift
//  GoWalk
//
//  Created by 박민석 on 1/12/25.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

// 검색어가 없을 때: CoreDataStack.fetchLocationPointList()를 사용해서 CoreData가져오기
// 검색어가 있을 때: AddressNetworkManager.shared.fetchData()를 사용해서 API 호출 데이터 가져오기

enum WeatherCellType {
    case coreData(locationName: String, temperature: String?, icon: UIImage?)
    case searchResult(locationName: String)
}

struct WeatherCellData {
    let cellType: WeatherCellType
}

class SearchLocationViewModel {
    struct Input {
        let searchText: Observable<String>
    }
    
    // 하나의 테이블 뷰를 활용할 예정이라 하나의 Output을 사용
    struct Output {
        let tableViewData: Driver<[WeatherCellData]>
    }
    
    private let weatherRelay = PublishRelay<[WeatherCellData]>()
    private let disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        input.searchText
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[WeatherCellData]> in
                if query.isEmpty {
                    // coreData에서 데이터 가져오기
                    let coreDataList = CoreDataStack.shared.fetchLocationPointList()
                    let cells = coreDataList.map { point in
                        WeatherCellData(
                            cellType: .coreData(
                                locationName: point.regionName,
                                temperature: nil,
                                icon: nil
                            )
                        )
                    }
                    return Observable.just(cells)
                } else {
                    // api에서 데이터 가져오기
                    AddressNetworkManager.shared.fetchAddressData(query)
                        .map { addressData in
                            addressData.map { (name, _, _) in
                                WeatherCellData(
                                    cellType: .searchResult(locationName: name)
                                )
                            }
                        }
                        .catchAndReturn([])
                }
            }
            .bind(to: weatherRelay)
            .disposed(by: disposeBag)
        
        return Output(tableViewData: weatherRelay.asDriver(onErrorRecover: []))
    }
}
