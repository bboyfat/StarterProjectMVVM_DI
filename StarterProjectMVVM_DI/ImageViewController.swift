//
//  ImageViewController.swift
//  StarterProjectMVVM_DI
//
//  Created by Andrey Petrovskiy on 03.12.2021.
//

import Combine
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

    private var subscriptions = Set<AnyCancellable>()



    override func viewDidLoad() {
        super.viewDidLoad()

        bindToViewModel()
        setupUI()
    }

    private func bindToViewModel() {
        subscriptions = [
            inProgressSubsribtion(),
            imageDataSubscription(),
            onFailureSubscription()
        ]
    }

    private func inProgressSubsribtion() -> AnyCancellable {
        return viewModel.inProgress.sink {[weak self] inProgress in
            DispatchQueue.main.async {
                inProgress ? self?.showLoader() : self?.hideLoader()
                self?.label.text = "LOADING"
            }
        }
    }

    private func imageDataSubscription() -> AnyCancellable {
        return viewModel.imageDataLoaded
            .receive(on: DispatchQueue.main)
            .compactMap({$0})
            .map({UIImage(data: $0)})
            .assign(to: \.image, on: imageView)
    }

    private func onFailureSubscription() -> AnyCancellable {
        return viewModel.onFailure
            .receive(on: DispatchQueue.main)
            .compactMap({$0})
            .assign(to: \.text, on: label)
    }

    private func setupUI() {
        layoutImageView()
        layoutButton()
        layoutLabel()
    }

    private func handleBtnAction() {
        viewModel.fetchImage()
    }

    deinit {
        subscriptions.forEach({$0.cancel()})
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





