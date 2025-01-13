//
//  AddressModel.swift
//  GoWalk
//
//  Created by jae hoon lee on 1/8/25.
//
import Foundation

/// JSON 형태가 같으나 타입이 달라 제네릭으로 변경
struct AddressModel<T: Codable>: Codable {
    let documents: [Data<T>]
}

extension AddressModel {
    struct Data<T: Codable>: Codable {
        let addressName: String
        let lat: T
        let lon: T
        
        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case lat = "x"
            case lon = "y"
        }
    }
}
