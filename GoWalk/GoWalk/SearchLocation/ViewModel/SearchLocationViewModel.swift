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
    case coreData(locationName: String, temperature: Double?, icon: String?)
    case searchResult(locationName: String, latitude: Double, longitude: Double)
}

struct WeatherCellData {
    let cellType: WeatherCellType
}

class SearchLocationViewModel {
    struct Input {
        let searchText: Observable<String>
        let deleteCell: Observable<IndexPath>
    }
    
    // 하나의 테이블 뷰를 활용할 예정이라 하나의 Output을 사용
    struct Output {
        let tableViewData: Driver<[WeatherCellData]>
        let selectedLocation: PublishRelay<LocationPoint> // 선택된 지역 데이터
    }
    
    private let weatherRelay = PublishRelay<[WeatherCellData]>()
    private let selectedLocationRelay = PublishRelay<LocationPoint>()
    private let disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        input.searchText
            .flatMapLatest { query -> Observable<[WeatherCellData]> in
                if query.isEmpty {
                    // coreData에서 데이터 가져오기
                    let coreDataList = CoreDataStack.shared.fetchLocationPointList()
                    
                    // CoreData의 위치 데이터를 기반으로 날씨 API 호출
                    let weatherDataObservables = coreDataList.map { point -> Observable<WeatherCellData> in
                        // URLBuilder로 URL 생성
                        let weatherURLResult = URLBuilder(api: OpenWeatherAPI())
                            .addPath(.weather)
                            .addQueryItem(.latitude(point.latitude))
                            .addQueryItem(.longitude(point.longitude))
                            .addQueryItem(.units(.metric))
                            .addQueryItem(.language(.kr))
                            .addQueryItem(.appid("902a70addad3e4cfd087a1b95fe85b06"))
                            .build()
                            .get()
                        guard let weatherURL = weatherURLResult else {
                            print("url 생성 실패")
                            // URL 생성 실패시 지역명만 반환
                            return Observable.just(
                                WeatherCellData(
                                    cellType: .coreData(
                                        locationName: point.regionName,
                                        temperature: nil,
                                        icon: nil
                                    )
                                )
                            )
                        }
                        return RXNetworkManager().fetchWeatherData(url: weatherURL)
                            .map { result in
                                switch result {
                                case .success(let weatherDTO):
                                    return WeatherCellData(
                                        cellType: .coreData(
                                            locationName: point.regionName,
                                            temperature: weatherDTO.current.temp,
                                            icon: weatherDTO.current.icon
                                        )
                                    )
                                case .failure(let error):
                                    print("RxNetworkManger failure: \(error)")
                                    return WeatherCellData(
                                        cellType: .coreData(
                                            locationName: point.regionName,
                                            temperature: nil,
                                            icon: nil
                                        )
                                    )
                                }
                            }
                            .catchAndReturn(
                                WeatherCellData(
                                    cellType: .coreData(
                                        locationName: point.regionName,
                                        temperature: nil,
                                        icon: nil
                                    )
                                )
                            )
                    }
                    return Observable.combineLatest(weatherDataObservables)
                } else {
                    // addressList 초기화
                    AddressNameInfo.shared.clearAddresses()
                    
                    // api에서 데이터 가져오기
                    return Observable<[WeatherCellData]>.create { observer in
                        AddressNetworkManager.shared.fetchAddressData(query) {
                            let addressList = AddressNameInfo.shared.addressList.map { addressData in
                                WeatherCellData(
                                    cellType: .searchResult(
                                        locationName: addressData.addressName,
                                        latitude: Double(addressData.lat) ?? 0.0,
                                        longitude: Double(addressData.lon) ?? 0.0
                                    )
                                )
                            }
                            observer.onNext(addressList)
                            observer.onCompleted()
                        }
                        return Disposables.create()
                    }
                }
            }
            .bind(to: weatherRelay)
            .disposed(by: disposeBag)
        
        // 삭제 처리
        input.deleteCell
            .withLatestFrom(weatherRelay) { (indexPath, data) -> [WeatherCellData] in
            var updateData = data
                let cellData = updateData[indexPath.row]
            if case .coreData(let regionName, _, _) = cellData.cellType {
                    if let location = CoreDataStack.shared.fetchLocationPointList()
                        .first(where: { $0.regionName == regionName }), let id = location.id {
                        CoreDataStack.shared.deleteLocation(of: id)
                        updateData.remove(at: indexPath.row)
                    }
                }
                return updateData
            }
            .bind(to: weatherRelay)
            .disposed(by: disposeBag)
        
        return Output(
            tableViewData: weatherRelay.asDriver(onErrorJustReturn: []),
            selectedLocation: selectedLocationRelay
        )
    }
}
