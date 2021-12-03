//
//  ImageViewController.swift
//  StarterProjectMVVM_DI
//
//  Created by Andrey Petrovskiy on 03.12.2021.
//

import UIKit

import DeclarativeUIKit


final class ImageViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }


    private func setupUI() {
        layoutImageView()
        layoutButton()
        layoutLabel()
    }

    private func handleBtnAction() {
        downloadImage()
    }
    private func downloadImage() {
        let url = URL(string: "https://wallpaperaccess.com/full/2930870.jpg")!
        let session = URLSession.shared
        label.text = "EMPTY"
        self.imageView.image = nil
        label.text = "DOWNLOADING"

        session.dataTask(with: url) {[unowned self] data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.imageView.image = image
                    self.label.text = "LOADED"
                }
            }
        }.resume()
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
