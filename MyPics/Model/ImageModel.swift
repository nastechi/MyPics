//
//  ImageModel.swift
//  MyPics
//
//  Created by Анастасия on 06.05.2023.
//

import UIKit

class ImageModel {
    
    let preview: UIImage
    let fullSize: UIImage
    
    init(preview: UIImage, fullSize: UIImage) {
        self.preview = preview
        self.fullSize = fullSize
    }
}
