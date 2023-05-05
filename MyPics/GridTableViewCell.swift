//
//  GridTableViewCell.swift
//  MyPics
//
//  Created by Анастасия on 05.05.2023.
//

import UIKit

class GridTableViewCell: UITableViewCell {
    
    private var gridImage: UIImage? = nil
    
    func setupCell(with gridImage: UIImage) {
        self.gridImage = gridImage
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
