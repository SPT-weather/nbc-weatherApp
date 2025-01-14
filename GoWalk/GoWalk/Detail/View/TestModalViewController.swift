// 삭제예정

import UIKit
import SnapKit

class TestModalViewController: UIViewController {
    private let networkManager: AbstractNetworkManager
    
    init(networkManager: AbstractNetworkManager = RXNetworkManager()) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var modalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Modal", for: .normal)
        button.addTarget(self, action: #selector(showModal), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Settings", for: .normal)
        button.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [modalButton, settingsButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func showModal() {
        let viewModel = DetailViewModel(networkManager: networkManager)
        let detailVC = DetailViewController(viewModel: viewModel)
        
        detailVC.modalPresentationStyle = .pageSheet
        detailVC.isModalInPresentation = false
        
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [
                .custom { [weak self] _ in
                    guard let self = self else { return 500 }
                    let buttonFrame = self.modalButton.convert(self.modalButton.bounds, to: self.view)
                    return self.view.frame.height - buttonFrame.maxY - 10
                }
            ]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 20
        }
        
        present(detailVC, animated: true)
    }
    
    @objc private func showSettings() {
        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.modalPresentationStyle = .popover
        present(settingsNav, animated: true)
    }
}
