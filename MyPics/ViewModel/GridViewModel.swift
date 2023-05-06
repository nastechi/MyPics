//
//  ImageManager.swift
//  MyPics
//
//  Created by Анастасия on 05.05.2023.
//

import UIKit
import Combine

class GridViewModel {
    
    @Published var images = [ImageModel]()
    
    func fetchImages() {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: K.fileLink) else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else { return }
            guard let dataString = String(data: data, encoding: .utf8) else { return }
            let linksArray = dataString.split(whereSeparator: \.isNewline).map { String($0) }
            self?.loadImages(links: linksArray) { images in
                self?.images = images
            }
        }
        task.resume()
    }
    
    private func loadImages(links: [String], complition: @escaping ([ImageModel]) -> Void) {
        
        var loadedImages = [ImageModel]()
        let queue = OperationQueue()
        
        for link in links {
            let operation = BlockOperation { [weak self] in
                self?.loadImage(link: link) { image in
                    loadedImages.append(image)
                }
            }
            queue.addOperation(operation)
        }
        
        queue.addBarrierBlock {
            complition(loadedImages)
        }
    }
    
    private func loadImage(link: String, complition: (ImageModel) -> Void) {
        
        guard let url = URL(string: link) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        guard let image = UIImage(data: data) else { return }
        guard let preview = getPreview(for: image) else { return }
        
        let imageModel = ImageModel(url: url, preview: preview, fullSize: image)
        complition(imageModel)
    }
    
    func getPreview(for image: UIImage) -> UIImage? {
        
        let width = UIScreen.main.bounds.width / 3 - 20
        let multiplier = width / image.size.width
        
        let size = CGSize(width: width, height: image.size.height * multiplier)
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
