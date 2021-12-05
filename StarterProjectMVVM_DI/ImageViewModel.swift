//
//  ImageViewModel.swift
//  StarterProjectMVVM_DI
//
//  Created by Andrey Petrovskiy on 03.12.2021.
//

import Combine
import Foundation


protocol ImageViewModelInput {
    func fetchImage()
}

protocol ImageViewModelOutput {
    var inProgress: Published<Bool>.Publisher { get }
    var imageDataLoaded: Published<Data>.Publisher { get }
    var onFailure: Published<String>.Publisher { get }
}

protocol ImageViewModelProtocol: ImageViewModelInput,
                                 ImageViewModelOutput {}

final class ImageViewModel: ImageViewModelProtocol {

    // MARK: - Private properties
    private let imageFetcher: ImageFetcherProtocol = ImageFethcer()

    @Published private var wrappedInProgress: Bool = Bool()
    @Published private var wrappedImageDataLoaded: Data = Data()
    @Published private var wrappedOnFailure: String = String()


    // MARK: - Output
    var inProgress: Published<Bool>.Publisher { $wrappedInProgress }
    var imageDataLoaded: Published<Data>.Publisher { $wrappedImageDataLoaded }
    var onFailure: Published<String>.Publisher { $wrappedOnFailure }


    // MARK: - Input
    func fetchImage() {
        wrappedInProgress = true
        imageFetcher.getImage {[weak self] result in
            switch result {
            case .success(let data):
                self?.wrappedImageDataLoaded = data
                self?.wrappedInProgress = false
            case .failure(let error):
                self?.wrappedInProgress = false
                self?.wrappedOnFailure = error.localizedDescription
            }
        }
    }

}

