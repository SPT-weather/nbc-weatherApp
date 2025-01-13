//
//  TestViewController.swift
//  GoWalk
//
//  Created by jae hoon lee on 1/12/25.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {

    private let button1: UIButton = {
        let button = UIButton()
        button.setTitle("위치 조회", for: .normal)
        button.backgroundColor = .gray
        return button
    }()

    private let button2: UIButton = {
        let button = UIButton()
        button.setTitle("다른위치 조회", for: .normal)
        button.backgroundColor = .gray
        return button
    }()

    private let label1: UILabel = {
        let label = UILabel()
        label.text = "위도 검색 결과"
        label.numberOfLines = 0
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.text = "주소 검색 결과"
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupUi()
        CoreLocationManager.shared.delegate = self
    }

    func setupUi() {
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(label1)
        view.addSubview(label2)

        button1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }

        button2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(button1.snp.top).offset(130)
            make.height.equalTo(50)
        }

        label1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button2.snp.bottom).offset(30)
            make.height.equalTo(70)
        }

        label2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label1.snp.bottom).offset(30)
            make.height.equalTo(70)
            make.width.equalToSuperview().inset(30)
        }

        button1.addTarget(self, action: #selector(tappedButton1), for: .touchUpInside)
        button2.addTarget(self, action: #selector(tappedButton2), for: .touchUpInside)
    }

    @objc func tappedButton1() {
        CoreLocationManager.shared.locationManager.startUpdatingLocation()

        // 테스트 코드(위도,경도 -> 주소)
        AddressNetworkManager.shared.fetchRegionData(129.148399576019, 35.1727271517264) {
            DispatchQueue.main.async {
                self.label1.text = "\(AddressLocationInfo.shared.addressName),\n \(AddressLocationInfo.shared.lat),\n \(AddressLocationInfo.shared.lon)"
            }
        }
    }

    @objc func tappedButton2() {
        CoreLocationManager.shared.locationManager.startUpdatingLocation()

        // 테스트 코드(검색 -> 주소, 위도, 경도 )
        AddressNetworkManager.shared.fetchAddressData("우동") {
            DispatchQueue.main.async {
                self.label2.text = "\(AddressNameInfo.shared.addressList[0].addressName),\n\(AddressNameInfo.shared.addressList[1].addressName),\n\(AddressNameInfo.shared.addressList[2].addressName)"
            }
        }
    }
}

extension TestViewController: CoreLocationAlertDelegate {

    // 위치서비스 요청 알림
    func requestLocationServiceAlert(title: String, message: String, preferredStyle: UIAlertController.Style) {
        let requestLocationAlert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { _ in
            print("cancel")
        }
        requestLocationAlert.addAction(cancel)
        requestLocationAlert.addAction(goSetting)
        present(requestLocationAlert, animated: true)
    }
}
