//
//  ImageModel.swift
//  MyPics
//
//  Created by Анастасия on 06.05.2023.
//

import UIKit

class ImageModel {
    
    let url: URL
    let preview: UIImage
    var fullSize: UIImage
    
    init(url: URL, preview: UIImage, fullSize: UIImage) {
        self.url = url
        self.preview = preview
        self.fullSize = fullSize
    }
}
