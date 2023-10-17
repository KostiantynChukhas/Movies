//
//  MoviesCollectionViewCell.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import UIKit
import Kingfisher

class MoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.roundCorners(radius: 20)
        ratingLabel.roundCorners(radius: 10)
        genresLabel.roundCorners(radius: 10)
    }
    
    func configure(with model: MoviesDTO) {
        if let url = URL(string: model.imgUrlString) {
            let placeholder =  UIImage(named: "noImage")
            imgView.kf.setImage(with: url, placeholder: placeholder)
        } 
       
        let year = model.getYearFromDate().isEmpty ? "" : ", \(model.getYearFromDate())"
        titleLabel.text = "\(model.title)\(year)"
        ratingLabel.text = "\(model.rating)"
        
        let genres = model.genre.joined(separator: ", ")
        genresLabel.isHidden = genres.isEmpty
        genresLabel.text = " \(genres) "
    }

}
