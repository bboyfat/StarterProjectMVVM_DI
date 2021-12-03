//
//  ImageViewController.swift
//  StarterProjectMVVM_DI
//
//  Created by Andrey Petrovskiy on 03.12.2021.
//

import UIKit


final class ImageViewController: UIViewController {

    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("DOWNLOAD", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(handleBtnAction), for: .touchUpInside)
        return btn
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }


    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(button)
        view.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -58),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),

            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -50)

        ])
    }

    @objc private func handleBtnAction() {
        downloadImage()
    }


    private func downloadImage() {
        let url = URL(string: "https://wallpaperaccess.com/full/2930870.jpg")!
        let session = URLSession.shared

        session.dataTask(with: url) {[unowned self] data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.imageView.image = image
                }
            }
        }.resume()
    }
}
