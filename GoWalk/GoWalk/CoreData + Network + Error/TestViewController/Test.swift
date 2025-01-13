//
//  Test.swift
//  GoWalk
//
//  Created by 박진홍 on 1/13/25.
//
import UIKit
import RxSwift

class Test: UIViewController {
    // MARK: - UI 요소
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Fetching weather data..."
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - 네트워크 매니저 및 DisposeBag
    private let networkManager: AbstractNetworkManager
    private let disposeBag = DisposeBag()

    // MARK: - 생성자
    init(networkManager: AbstractNetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchWeather()
    }

    // MARK: - UI 설정
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(weatherLabel)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            weatherLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 20)
        ])
    }

    // MARK: - 날씨 데이터 요청
    private func fetchWeather() {
        activityIndicator.startAnimating()

        // URLBuilder로 URL 생성
        let urlBuilder = URLBuilder(api: OpenWeatherAPI())
        guard let url = urlBuilder
            .addPath(.weather)
            .addQueryItem(.latitude(37.5665))
            .addQueryItem(.longitude(126.9780))
            .addQueryItem(.appid("902a70addad3e4cfd087a1b95fe85b06"))
            .addQueryItem(.units(.metric))
            .build()
            .get() else {
                weatherLabel.text = "Failed to build URL"
                activityIndicator.stopAnimating()
                return
            }

        // 네트워크 요청
        networkManager.fetchWeatherData(url: url)
        .subscribe(onNext: { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success(let dto):
                    self?.updateUI(with: dto)
                case .failure(let error):
                    self?.weatherLabel.text = "Error: \(error.localizedDescription)"
                }
            }
        }).disposed(by: disposeBag)
    }

    // MARK: - UI 업데이트
    private func updateUI(with weatherDTO: TotalWeatherDTO) {
        weatherLabel.text = """
        Current Temperature: \(weatherDTO.current.temp)°C
        Weather: \(weatherDTO.current.main)
        Description: \(weatherDTO.current.description)
        """
    }
}
