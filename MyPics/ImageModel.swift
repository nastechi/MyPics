//
//  ImageModel.swift
//  MyPics
//
//  Created by Анастасия on 18.05.2023.
//

import UIKit

struct ImageModel {
    let link: String
    let preview: UIImage
    var fullSize: UIImage?
    
    init(link: String, preview: UIImage, fullSize: UIImage? = nil) {
        self.link = link
        self.preview = preview
        self.fullSize = fullSize
    }
}
