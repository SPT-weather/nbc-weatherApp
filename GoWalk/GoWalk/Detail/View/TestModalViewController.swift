import UIKit
import SnapKit

class TestModalViewController: UIViewController {
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Modal", for: .normal)
        button.addTarget(self, action: #selector(showModal), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func showModal() {
        let viewModel = DetailViewModel()
        let detailVC = DetailViewController(viewModel: viewModel)

        detailVC.modalPresentationStyle = .pageSheet
        detailVC.isModalInPresentation = false

        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [ // detents를 사용하여 커스텀
                .custom { [weak self] _ in
                    guard let self = self else { return 500 }
                    let buttonFrame = self.button.convert(self.button.bounds, to: self.view)
                    return self.view.frame.height - buttonFrame.maxY - 10
                }
            ]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 20
        }

        present(detailVC, animated: true)
    }
}
