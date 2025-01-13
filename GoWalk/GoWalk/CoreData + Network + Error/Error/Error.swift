//
//  Untitled.swift
//  GoWalk
//
//  Created by 박진홍 on 1/8/25.
//
import Foundation

enum AppError: Error {
    case data(DataError)
    case network(NetworkError)

    enum DataError: Error {
        case failedToMakePersistentContainer
        case failedToSaveContext(error: Error)  // save()가 이미 error를 던져주지만 통일된 사용을 위해서 다시 AppError로 감싸도록 했습니다.
        case failedToFetch(error: Error)
    }

    enum NetworkError: Error {
        case failedToBuildURL(url: String)
        case failedToMapping
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {

        case .data(let error):
            switch error {
            case .failedToMakePersistentContainer:
                return "영구 저장소 생성 실패"
            case .failedToSaveContext(let error):
                return "Context 저장 실패. 실패 사유: \(error)"
            case .failedToFetch(let error):
                return "Fetch 요청 실패. 실패 사유: \(error)"
            }

        case .network(let error):
            switch error {
            case .failedToBuildURL(let url):
                return "URL 생성 실패. 시도한 URL: \(url)"
            case .failedToMapping:
                return "응답 데이터 매핑 실패"
            }
        }
    }
}
