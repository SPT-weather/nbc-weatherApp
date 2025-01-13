//
//  URLBuilder.swift
//  GoWalk
//
//  Created by 박진홍 on 1/13/25.
//

import Foundation

class URLBuilder<APIType: API> {
    private var baseURL: String
    private var paths: [APIType.Path] = []
    private var quertyItems: [APIType.QueryItem] = []

    init (api: APIType) {
        self.baseURL = api.baseURL
    }

    func addPath(_ path: APIType.Path) -> Self {
        paths.append(path)
        return self
    }

    func addQueryItem(_ item: APIType.QueryItem) -> Self {
        quertyItems.append(item)
        return self
    }

    func build() -> Result<URL, AppError> {
        guard var components = URLComponents(string: self.baseURL) else {
            return .failure(AppError.network(.failedToBuildURL(url: self.baseURL)))
        }

        components.path = paths.map { $0.path }.joined()
        components.queryItems = quertyItems.map { $0.queryItem }

        guard let url = components.url else {
            return .failure(AppError.network(.failedToBuildURL(url: components.url?.absoluteString ?? "Unknown url")))
        }

        return .success(url)
    }
}

extension Result {
    func get() -> Success? {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            print(error.localizedDescription)
            return nil
        }
    }
}
