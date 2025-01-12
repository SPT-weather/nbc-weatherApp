//
//  AddressModel.swift
//  GoWalk
//
//  Created by jae hoon lee on 1/8/25.
//
import Foundation

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
