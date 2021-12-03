//
//  ImageViewModel.swift
//  StarterProjectMVVM_DI
//
//  Created by Andrey Petrovskiy on 03.12.2021.
//

import Foundation

protocol ImageViewModelInput {
    func fetchImage()
}

protocol ImageViewModelOutput {
    var inProgress: (Bool) -> Void { get set }
    var imageDataLoaded: (Data) -> Void { get set }
    var onFailure: () -> Void { get set }
}

protocol ImageViewModelProtocol: ImageViewModelInput,
                                 ImageViewModelOutput {}

final class ImageViewModel: ImageViewModelProtocol {

    private let imageFetcher: ImageFetcherProtocol = ImageFethcer()

    // MARK: - Output
    var inProgress: (Bool) -> Void = {_ in}
    var imageDataLoaded: (Data) -> Void = {_ in}
    var onFailure: () -> Void = {}

    // MARK: - Input
    func fetchImage() {
        inProgress(true)
        imageFetcher.getImage {[weak self] result in
            switch result {
            case .success(let data):
                self?.imageDataLoaded(data)
                self?.inProgress(false)
            case .failure:
                self?.inProgress(false)
                self?.onFailure()
            }
        }
    }

}

