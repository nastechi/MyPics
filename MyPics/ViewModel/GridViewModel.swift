//
//  ImageManager.swift
//  MyPics
//
//  Created by Анастасия on 05.05.2023.
//

import UIKit
import Combine

class GridViewModel {
    
    @Published var images = [UIImage]()
    
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
            self?.loadImages(links: linksArray)
        }
        task.resume()
    }
    
    private func loadImages(links: [String]) {
        
        var loadedImages = [UIImage]()
        
        defer {
            self.images = loadedImages
        }
        
        let session = URLSession(configuration: .default)
        
        for link in links {
            guard let url = URL(string: link) else { return }
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { data, response, error in
                guard error == nil else { return }
                guard let data = data else { return }
                if let image = UIImage(data: data) {
                    loadedImages.append(image)
                }
            }
            task.resume()
        }
    }
}
