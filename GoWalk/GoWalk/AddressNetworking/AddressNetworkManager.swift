//
//  AddressNetworkManager.swift
//  GoWalk
//
//  Created by jae hoon lee on 1/8/25.
//

import Foundation
import Alamofire
import RxSwift

class AddressNetworkManager {
    static let shared = AddressNetworkManager()
    private init() {}
    let disposeBag = DisposeBag()

    // MARK: - 네트워크 요청

    func fetchData<T: Decodable> (_ url: URL, _ header: HTTPHeaders) -> Single<T> {
        return Single<T>.create { single in
            AF.request(url, headers: header).responseDecodable(of: T.self) { respones in
                switch respones.result {
                case .success(let data):
                    single(.success(data))
                case .failure(let error):
                    print("\(error.localizedDescription)")
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    // MARK: - 입력값으로 주소 api요청 메서드(search page)
    func fetchAddressData(_ inputData: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://dapi.kakao.com/v2/local/search/address.json?query=\(inputData)") else {
            print("url 빌드 오류")
            return
        }
        let header: HTTPHeaders = ["Authorization": "KakaoAK 430b247857c9b16b87d3f1a7a31d5888"]
        fetchData(url, header)
            .subscribe { (event: SingleEvent<AddressModel<String>>) in
                switch event {
                case .success(let data):
                    print("\(data)")
                    for info in data.documents {
                        AddressNameInfo.shared.update(
                            addressName: info.addressName,
                            lat: info.lat,
                            lon: info.lon
                        )
                    }
                    completion()
                    
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }.disposed(by: disposeBag)
    }

    // MARK: - 위도,경도로 주소 api요청 메서드(main page)
    func fetchRegionData(_ lat: Double, _ lon: Double, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=\(lon)&y=\(lat)") else {
            print("url 빌드 오류")
            return
        }
        let header: HTTPHeaders = ["Authorization": "KakaoAK 430b247857c9b16b87d3f1a7a31d5888"]
        fetchData(url, header)
            .subscribe { (event: SingleEvent<AddressModel<Double>>) in
                switch event {
                case .success(let data):
                    if let info = data.documents.first {
                        AddressLocationInfo.shared.update(
                            addressName: info.addressName,
                            lat: info.lat,
                            lon: info.lon
                        )
                        completion()
                    }
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }.disposed(by: disposeBag)
    }
}


extension AddressNetworkManager {
    
    func fetchUserDefaultsRegionData(_ lat: Double, _ lon: Double, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=\(lon)&y=\(lat)") else {
            print("url 빌드 오류")
            return
        }
        let locationUserDefaults = LocationUserDefaults.shared
        let header: HTTPHeaders = ["Authorization": "KakaoAK 430b247857c9b16b87d3f1a7a31d5888"]
        fetchData(url, header)
            .subscribe { [weak locationUserDefaults] (event: SingleEvent<AddressModel<Double>>) in
                switch event {
                case .success(let data):
                    guard let address = data.documents.first else { return }
                    locationUserDefaults?.saveUserLocation(address.addressName,
                                                           address.lat,
                                                           address.lon)
                    completion()
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }.disposed(by: disposeBag)
    }
}
