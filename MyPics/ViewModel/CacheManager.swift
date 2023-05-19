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
    
    func cacheImage(_ image: UIImage, link: String) {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imageUrl = url.appendingPathComponent("cache").appendingPathComponent("\(cleanLink(link: link)).png")

        fileManager.createFile(atPath: imageUrl.path(), contents: image.pngData())
    }
    
    func getCachedPreview(forLink link: String) -> UIImage? {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let imageName = "\(cleanLink(link: link))"
        let previewUrl = url.appendingPathComponent("cache").appendingPathComponent(imageName + ".png")

        guard fileManager.fileExists(atPath: previewUrl.path()) else { return nil }
        guard let preview = loadCachedImage(forUrl: previewUrl) else { return nil }

        return preview
    }
    
    func getCachedFullSize(forLink link: String) -> UIImage? {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let imageName = "\(cleanLink(link: link))"
        let fullImageUrl = url.appendingPathComponent("cache").appendingPathComponent(imageName + "full.png")
        
        guard fileManager.fileExists(atPath: fullImageUrl.path()) else {
            return nil }
        guard let fullImage = loadCachedImage(forUrl: fullImageUrl) else {
            return nil }
        
        return fullImage
    }
    
    private func loadCachedImage(forUrl url: URL) -> UIImage? {
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
