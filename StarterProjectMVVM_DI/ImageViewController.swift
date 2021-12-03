//
//  ImageViewController.swift
//  StarterProjectMVVM_DI
//
//  Created by Andrey Petrovskiy on 03.12.2021.
//

import UIKit

import DeclarativeUIKit
import LoaderView

final class ImageViewController: UIViewController {

    // MARK: - UIComponnents
    private lazy var imageView: UIImageView = .create {
        $0.removeAutoresizing()
    }
    private lazy var button: UIButton = .create {
        $0.removeAutoresizing()
            .withTitle("DOWNLOAD")
            .withBackgorundColor(.blue)
            .applyRoundCorners()
            .withAction({[weak self] in self?.handleBtnAction()})
    }

    private lazy var label: UILabel = .create {
        $0.removeAutoresizing()
            .withFont(.systemFont(ofSize: 24))
            .withTextAlighment(.center)
            .withTextColor(.white)
            .withText("EMPTY")
    }

    // MARK: - Properties

    private var viewModel: ImageViewModelProtocol = ImageViewModel()



    override func viewDidLoad() {
        super.viewDidLoad()

        bindToViewModel()
        setupUI()
    }

    private func bindToViewModel() {
        viewModel.inProgress = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.showLoader() : self?.hideLoader()
                self?.label.text = "LOADING"
            }
        }

        viewModel.imageDataLoaded = { [weak self] imageData in
            DispatchQueue.main.async {
                let image = UIImage.init(data: imageData)
                self?.imageView.image = image
                self?.label.text = "LOADED"
            }
        }

        viewModel.onFailure = { [weak self] in
            DispatchQueue.main.async {
                self?.label.text = "ERROR"
            }
        }
    }


    private func setupUI() {
        layoutImageView()
        layoutButton()
        layoutLabel()
    }

    private func handleBtnAction() {
        viewModel.fetchImage()
    }

}

// MARK: - Layout
extension ImageViewController {
    private func layoutImageView() {
        view.addSubview(imageView)
        imageView.clipToSuperview()
    }

    private func layoutButton() {
        view.layoutSubview(button) { [
            $0.bottomAnchor(relativeTo: view.bottomAnchor, -58),
            $0.leftAnchor(relativeTo: view.leftAnchor, 16),
            $0.rightAnchor(relativeTo: view.rightAnchor, -16),
            $0.height(equalTo: 58)
        ] }
    }

    private func layoutLabel() {
        view.layoutSubview(label) { [
            $0.bottomAnchor(relativeTo: button.topAnchor, -58),
            $0.leftAnchor(relativeTo: view.leftAnchor, 16),
            $0.rightAnchor(relativeTo: view.rightAnchor, -16)
        ] }
    }
}
