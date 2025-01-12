//
//  TestViewController.swift
//  GoWalk
//
//  Created by jae hoon lee on 1/12/25.
//

import UIKit

class TestViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("위치 조회", for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupUi()
        CoreLocationManager.shared.delegate = self
    }
    
    func setupUi() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    @objc func tappedButton() {
        CoreLocationManager.shared.locationManager.startUpdatingLocation()
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
