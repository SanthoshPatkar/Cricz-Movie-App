//
//  ImageCache.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import Foundation
import Combine
import SwiftUI

//Image Shared Class
class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}

// image View display and Loader
struct AsyncImageView: View {
    let url: URL?
    @StateObject var loader: AsyncImageLoader

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if loader.loadFailed {
                Image(systemName: "movieclapper")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loader.loadImage(from: url)
        }
    }
}

class AsyncImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var loadFailed = false
    private var cancellable: AnyCancellable?
    
    func loadImage(from url: URL?) {
        guard let url = url else { return }
        
        // Check cache first
        if let cachedImage = ImageCache.shared.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }
    
        // Download the image and storage the image in the NSCahe.
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .sink { [weak self] downloadedImage in
                guard let self = self, let image = downloadedImage else {
                    self?.loadFailed = true
                    return
                }
                
                ImageCache.shared.setObject(image, forKey: url as NSURL)
                self.image = image
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
