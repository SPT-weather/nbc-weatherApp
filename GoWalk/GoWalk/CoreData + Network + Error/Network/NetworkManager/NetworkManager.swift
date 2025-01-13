//
//  NetworkManager.swift
//  GoWalk
//
//  Created by 박진홍 on 1/13/25.
//

import Foundation
import RxSwift

protocol AbstractNetworkManager {
    func fetchData<DTO: Mappable>(
        url: URL,
        responseType: DTO.ResponseType.Type
    ) -> Observable<Result<DTO, AppError>>
    func fetchWeatherData(url: URL) -> Observable<Result<TotalWeatherDTO, AppError>>
    func fetchAirPollutionData(url: URL) -> Observable<Result<AirPollutionDTO, AppError>>
}

class RXNetworkManager: AbstractNetworkManager {
    private let successRange: Range = (200..<300)

    func fetchData<DTO: Mappable> (
        url: URL,
        responseType: DTO.ResponseType.Type
    ) -> Observable<Result<DTO, AppError>> {
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
                    let decodedData: DTO.ResponseType = try JSONDecoder().decode(DTO.ResponseType.self, from: data)
                    let result = DTO.map(from: decodedData)
                    observer.onNext(result)
                } catch {
                    observer.onNext(.failure(.network(.failedToMapping)))
                }
                observer.onCompleted()
            }.resume()

            return Disposables.create()
        }
    }

    func fetchWeatherData(url: URL) -> Observable<Result<TotalWeatherDTO, AppError>> {
        return fetchData(url: url, responseType: TotalWeatherDTO.ResponseType.self)
    }

    func fetchAirPollutionData(url: URL) -> Observable<Result<AirPollutionDTO, AppError>> {
        return fetchData(url: url, responseType: AirPollutionDTO.ResponseType.self)
    }

}
