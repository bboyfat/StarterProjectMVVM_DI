//
//  ImageFetcher.swift
//  StarterProjectMVVM_DI
//
//  Created by Andrey Petrovskiy on 03.12.2021.
//

import Foundation

enum ImageFetchingError: Error {
    case emptyData
}

protocol ImageFetcherProtocol {
    func getImage(completion: @escaping (Result<Data, Error>) -> Void)
}

final class ImageFethcer: ImageFetcherProtocol {

    private var url: URL {
        return URL(string: "https://wallpaperaccess.com/full/2930870.jpg")!
    }

    func getImage(completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(ImageFetchingError.emptyData))
            }
        }.resume()
    }
}
