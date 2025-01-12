//
//  CoreLocationManager.swift
//  GoWalk
//
//  Created by jae hoon lee on 1/10/25.
//

import CoreLocation
import UIKit

protocol CoreLocationAlertDelegate: AnyObject {
    func requestLocationServiceAlert(title: String, message: String, preferredStyle: UIAlertController.Style)
}

class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = CoreLocationManager()
    
    var locationManager = CLLocationManager()
    private var location: CLLocationCoordinate2D?
    weak var delegate: CoreLocationAlertDelegate?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        checkUserDeviceLocationServiceAuthorizationStatus()
    }
    
    /// 사용자가 디바이스의 위치서비스를 활성화한 상태인지 확인
    /// 위치서비스가 활성화인지 확인 후 권한요청
    func checkUserDeviceLocationServiceAuthorizationStatus() {
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스가 활성화 상태입니다.")
            let authorizationStatus = locationManager.authorizationStatus
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 비활성화 상태입니다.") // 권한이 denied로 변경됨
        }
    }
    
    /// 사용자가 위치 서비스 권한 상태가 변경될 때 호출되는 메서드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    /// 사용자 앱에 대한 권한 상태에 따른 분기처리
    func checkUserCurrentLocationAuthorization( _ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("not determind")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("restricted, denied")
            delegate?.requestLocationServiceAlert(
                title: "위치 서비스 권한 필요",
                message: "위치 서비스 권한을 허용해주세요.\n설정 > 앱 이름에서 위치 서비스를 허용해주세요.",
                preferredStyle: .alert
            )
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            locationManager.startUpdatingLocation()
        default:
            print("All other case")
        }
    }
    
    /// 업데이트 된 위치 정보를 반환(시작시 반환)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = manager.location?.coordinate
        if let locationInfo = location {
            print("사용자 위치: \(locationInfo.latitude), \(locationInfo.longitude)")
            
            // 위치 데이터를 받으면 즉시 업데이트 중지
            locationManager.stopUpdatingLocation()
            // 테스트 코드(위,경도 -> 주소, 주소 -> 위경도)
            AddressNetworkManager.shared.fetchRegionData(127.1086228, 37.4012191)
            AddressNetworkManager.shared.fetchAddressData("구로")
        }
    }
    
    /// 에러 발생 시 에러 반환
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        delegate?.requestLocationServiceAlert(
            title: "위치 서비스 에러",
            message: "위치 정보를 가져오는 중 문제가 발생했습니다: \(error.localizedDescription)\n 위치 권한을 확인해주세요.",
            preferredStyle: .alert)
    }
}
