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
                    print("success")
                    single(.success(data))
                case .failure(let error):
                    print("\(error.localizedDescription)")
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    // MARK: - 입력값으로 주소 api요청 메서드

    func fetchAddressData(_ inputData: String) {
        guard let url = URL(
            string: "https://dapi.kakao.com/v2/local/search/address.json?query=\(inputData)"
        ) else { return }
        let header: HTTPHeaders = ["Authorization": "KakaoAK 430b247857c9b16b87d3f1a7a31d5888"]
        fetchData(url, header)
            .subscribe { (event: SingleEvent<AddressModel>) in
                switch event {
                case .success(let data):
                    print("\(data)")
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }.disposed(by: disposeBag)
    }
}
