//
//  CacheManager.swift
//  MyPics
//
//  Created by Анастасия on 08.05.2023.
//

import UIKit

class CacheManager {
    
    private let fileManager = FileManager.default
    
    init() {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let cacheUrl = url.appendingPathComponent("cache")
        if !fileManager.fileExists(atPath: cacheUrl.path()) {
            try? fileManager.createDirectory(at: cacheUrl, withIntermediateDirectories: true)
        }
    }
    
    func cacheImage(imageModel: ImageModel, link: String) {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fullImageUrl = url.appendingPathComponent("cache").appendingPathComponent("\(cleanLink(link: link)).png")
        let previewUrl = url.appendingPathComponent("cache").appendingPathComponent("\(cleanLink(link: link))_preview.png")
        
        fileManager.createFile(atPath: fullImageUrl.path(), contents: imageModel.fullSize.pngData())
        fileManager.createFile(atPath: previewUrl.path(), contents: imageModel.preview.pngData())
    }
    
    func getCachedImage(forLink link: String) -> ImageModel? {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fullImageUrl = url.appendingPathComponent("cache").appendingPathComponent("\(cleanLink(link: link)).png")
        let previewUrl = url.appendingPathComponent("cache").appendingPathComponent("\(cleanLink(link: link))_preview.png")
        
        guard fileManager.fileExists(atPath: fullImageUrl.path()) else { return nil }
        guard let fullImage = loadImage(forUrl: fullImageUrl), let preview = loadImage(forUrl: previewUrl) else { return nil }
        
        return ImageModel(preview: preview, fullSize: fullImage)
    }
    
    private func loadImage(forUrl url: URL) -> UIImage? {
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    private func cleanLink(link: String) -> String {
        
        var result = ""
        
        for char in link {
            if char.isLetter || char.isNumber {
                result.append(char)
            }
        }
        
        return result
    }
}
