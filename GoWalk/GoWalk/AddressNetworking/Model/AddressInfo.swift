//
//  AddressInfo.swift
//  GoWalk
//
//  Created by jae hoon lee on 1/13/25.
//

/// 주소 검색 API DTO
struct AddressData {
    let addressName: String
    let lat: String
    let lon: String
}

class AddressNameInfo {
    static let shared = AddressNameInfo()
    
    var addressList: [AddressData] = []
    
    private init() {}
    
    func update(addressName: String, lat: String, lon: String) {
        let newAddress = AddressData(addressName: addressName, lat: lat, lon: lon)
        addressList.append(newAddress)
    }
    
    func clearAddresses() {
        addressList.removeAll()
    }
}

/// 위도,경도 검색 API DTO
class AddressLocationInfo {
    static let shared = AddressLocationInfo()
    
    var addressName: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    private init() {}
    
    func update(addressName: String, lat: Double, lon: Double) {
        self.addressName = addressName
        self.lat = lat
        self.lon = lon
    }
}
