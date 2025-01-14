//
//  Test.swift
//  GoWalk
//
//  Created by 박진홍 on 1/13/25.
//
//
import UIKit
import RxSwift
import RxCocoa

class Test: UIViewController {
    private let disposeBag = DisposeBag()
    private let networkManager: AbstractNetworkManager

    // UI Components
    private let kakaoCoordinatesLabel = UILabel()
    private let weatherLabel = UILabel()

    init(networkManager: AbstractNetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchKakaoData()
        fetchWeatherData()
    }

    private func setupUI() {
        view.backgroundColor = .white

        kakaoCoordinatesLabel.numberOfLines = 0
        weatherLabel.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [kakaoCoordinatesLabel, weatherLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func fetchKakaoData() {
        let kakaoAPIKey = "KakaoAK 430b247857c9b16b87d3f1a7a31d5888"
        let kakaoHeaders = ["Authorization": kakaoAPIKey]
        let kakaoURL = URLBuilder(api: KakaoAPI())
            .addPath(.adress)
            .addQueryItem(.query("강서구"))
            .build()
            .get()
        
        print("\(kakaoURL?.absoluteString)")
        guard let kakaoRequestURL = kakaoURL else {
            kakaoCoordinatesLabel.text = "Failed to build Kakao API URL"
            return
        }

        networkManager.fetchAddressData(url: kakaoRequestURL, header: kakaoHeaders)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let addressDTO):
                    if let location = addressDTO.locationPoint.first {
                        self?.kakaoCoordinatesLabel.text = """
                        Kakao Coordinates:
                        Latitude: \(location.latitude)
                        Longitude: \(location.longitude)
                        """
                    } else {
                        self?.kakaoCoordinatesLabel.text = "No results found"
                    }
                case .failure(let error):
                    self?.kakaoCoordinatesLabel.text = "Kakao API Error: \(error.localizedDescription)"
                }
            })
            .disposed(by: disposeBag)
    }

    private func fetchWeatherData() {
        let weatherURL = URLBuilder(api: OpenWeatherAPI())
            .addPath(.weather)
            .addQueryItem(.latitude(37.5665)) // 서울 위도
            .addQueryItem(.longitude(126.9780)) // 서울 경도
            .addQueryItem(.appid("902a70addad3e4cfd087a1b95fe85b06"))
            .addQueryItem(.units(.metric))
            .build()
            .get()

        guard let weatherRequestURL = weatherURL else {
            weatherLabel.text = "Failed to build OpenWeather API URL"
            return
        }

        networkManager.fetchWeatherData(url: weatherRequestURL)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let weatherDTO):
                    self?.weatherLabel.text = """
                    Weather in Seoul:
                    Temperature: \(weatherDTO.current.temp)°C
                    Description: \(weatherDTO.current.description)
                    """
                case .failure(let error):
                    self?.weatherLabel.text = "Weather API Error: \(error.localizedDescription)"
                }
            })
            .disposed(by: disposeBag)
    }
}
