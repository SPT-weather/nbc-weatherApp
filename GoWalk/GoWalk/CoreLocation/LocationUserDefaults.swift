//
//  LocationUserDefaults.swift
//  GoWalk
//
//  Created by jae hoon lee on 1/13/25.
//
import Foundation

class LocationUserDefaults {
    static let shared = LocationUserDefaults()
    private let defaults = UserDefaults.standard
    
    /// 사용자의 위치 정보를 저장
    func saveUserLocation(_ name: String, _ lat: Double, _ lon: Double) {
        defaults.set(name, forKey: "addressName")
        defaults.set(lat, forKey: "lat")
        defaults.set(lon, forKey: "lon")
    }
    
    func read() -> LocationPoint? {
        guard let addressName = defaults.string(forKey: "addressName") else { return nil }
        let lat = defaults.double(forKey: "lat")
        let lon = defaults.double(forKey: "lon")
        return LocationPoint(regionName: addressName, latitude: lat, longitude: lon)
    }
}

/// 위치 정보 저장 saveUserLocation 메서드 이용
///     LocationUserDefaults.shared.saveUserLocation (
///         AddressLocationInfo.shared.addressName,
///         AddressLocationInfo.shared.lat,
///         AddressLocationInfo.shared.lon
///     )
///
/// 위치 정보 불러오기
///        UserDefaults.standard.string(forKey: "addressName") // 옵셔널로 반환이 됩니다.
///        UserDefaults.standard.double(forKey: "lat")
///        UserDefaults.standard.double(forKey: "lon")


