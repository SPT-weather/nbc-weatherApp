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

final class SearchLocationViewModel {
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
    let alertMessageRelay = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    // MARK: - transform 메서드
    
    func transform(_ input: Input) -> Output {
        input.searchText
            .flatMapLatest { query in
                return query.isEmpty ? self.fetchCoreData() : self.fetchSearchResult(query)
            }
            .bind(to: weatherRelay)
            .disposed(by: disposeBag)
        
        // 삭제 처리
        input.deleteCell
            .withLatestFrom(weatherRelay) { (indexPath, data) -> [WeatherCellData] in
                // 첫 번째 셀인지 확인
                guard indexPath.row != 0 else {
                    // Alert 메시지 전송
                    self.alertMessageRelay.accept("기본 위치는 삭제할 수 없습니다!")
                    return data // 기존 데이터를 그대로 반환 (삭제 처리 안 함)
                }
                
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
    
    // MARK: - transform에서 호출 될 메서드들
    
    /// 검색 없을 경우 코어데이터에서 저장된 지역 정보 불러오는 메서드
    /// - Returns: 셀에 띄울 정보 - 지역이름, 기온, 날씨아이콘
    private func fetchCoreData() -> Observable<[WeatherCellData]> {
        let coreDataList = CoreDataStack.shared.fetchLocationPointList()
        let weatherDataObservables = coreDataList.map { point -> Observable<WeatherCellData> in
            self.fetchWeatherData(point)
        }
        return Observable.combineLatest(weatherDataObservables)
    }
    
    /// 검색 시 api 요청으로 지역명과 위도, 경도 불러오는 메서드
    /// - Parameter query: 검색 할 지역명
    /// - Returns: 셀에 띄울 정보 - SearchBar에 입력한 값이 포함된 지역명 리스트
    private func fetchSearchResult(_ query: String) -> Observable<[WeatherCellData]> {
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
    
    /// 날씨 데이터 가져오는 메서드
    /// - Parameter point: 날씨를 띄울 지역의 정보
    /// - Returns: 셀에 띄울 정보 - 지역 이름, 기온, 날씨 아이콘
    private func fetchWeatherData(_ point: LocationPoint) -> Observable<WeatherCellData> {
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
        // 생성된 URL로 날씨 데이터 반환
        return RXNetworkManager().fetchWeatherData(url: weatherURL)
            .map { result in
                switch result {
                // fetchWeatherData 메서드 응답 성공 시 지역명, 기온 정보, 날씨 아이콘 값 반환
                case .success(let weatherDTO):
                    return WeatherCellData(
                        cellType: .coreData(
                            locationName: point.regionName,
                            temperature: weatherDTO.current.temp,
                            icon: weatherDTO.current.icon
                        )
                    )
                // fetchWeatherData 메서드 응답 실패시 지역명만 반환
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
}
