//
//  AddressModel.swift
//  GoWalk
//
//  Created by jae hoon lee on 1/8/25.
//
import Foundation

struct AddressModel: Codable {
    let documents: [Data]
}

extension AddressModel {
    struct Data: Codable {
        let addressName: String
        let lat: String
        let lon: String
        
        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case lat = "x"
            case lon = "y"
        }
    }
}
