//
//  NetworkManager.swift
//  GoWalk
//
//  Created by 박진홍 on 1/13/25.
//

import Foundation
import RxSwift

protocol AbstractNetworkManager {
    // TODO: 추상화 고민해보기
}

class RXNetworkManager: AbstractNetworkManager {
    private let successRange: Range = (200..<300)

    func fetchData<ResponseType: Decodable, DTOType> (
        url: URL,
        responseType: ResponseType.Type,
        dtoMapper: @escaping (ResponseType) -> Result<DTOType, AppError>
    ) -> Observable<Result<DTOType, AppError>> {
        return Observable.create { observer in
            let request: URLRequest = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onNext(.failure(.network(.dataTaskError(error: error))))
                    observer.onCompleted()
                    return
                }

                if let response = response as? HTTPURLResponse {
                    guard self.successRange.contains(response.statusCode) else {
                        observer.onNext(.failure(.network(.invalidResponse(code: response.statusCode))))
                        observer.onCompleted()
                        return
                    }
                } else {
                    observer.onNext(.failure(.network(.noResponse)))
                    observer.onCompleted()
                    return
                }

                guard let data = data else {
                    observer.onNext(.failure(.network(.noData)))
                    observer.onCompleted()
                    return
                }

                do {
                    let decodedData: ResponseType = try JSONDecoder().decode(ResponseType.self, from: data)
                    let result = dtoMapper(decodedData)
                    observer.onNext(result)
                } catch {
                    observer.onNext(.failure(.network(.failedToMapping)))
                }
                observer.onCompleted()
            }.resume()

            return Disposables.create()
        }
    }
}
