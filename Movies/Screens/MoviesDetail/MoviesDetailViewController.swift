//
//  MoviesDetailViewController.swift
//  Movies
//
//  Created by Konstantin Chukhas on 17.10.2023.
//

import UIKit
import Kingfisher

class MoviesDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: MoviesDetailViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setupUI()
    }
    
    private func bindData() {
        viewModel.onReload = { [weak self] in
            self?.hideProgressHud()
            self?.updateUI()
        }
    }
    
    private func setupUI() {
        imgView.roundCorners(radius: 20)
        rateLabel.roundCorners(radius: 10)
        genresLabel.roundCorners(radius: 10)
        genresLabel.isHidden = true
        trailerButton.isHidden = true
        title = NSLocalizedString("movies_detail_title")
        self.showProgressHud()
    }
    
    private func updateUI() {
        guard let model = viewModel.detailModel else { return }
        if let url = URL(string: model.imgUrlString) {
            let placeholder =  UIImage(named: "noImage")
            imgView.kf.setImage(with: url, placeholder: placeholder)
        }
        imgView.roundCorners(radius: 20)
       
        let year = model.getYearFromDate().isEmpty ? "" : ", \(model.getYearFromDate())"
        nameLabel.text = "\(model.name)"
        countryLabel.text = "\(model.country)\(year)"
        rateLabel.text = "\(model.getRating())"
        
        trailerButton.isHidden = model.youtubeLink.isEmpty
        
        let genres = model.genre.joined(separator: ", ")
        genresLabel.isHidden = genres.isEmpty
        genresLabel.text = genres
        
        descriptionLabel.text = model.description
    }
    
    @IBAction func trailerButtonAction(_ sender: Any) {
        guard let model = viewModel.detailModel else { return }

        let modalViewController = VideoViewController()
        modalViewController.modalPresentationStyle = .formSheet
        modalViewController.youtubeID = model.youtubeLink
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    deinit {
        print("MoviesDetailViewController - deinit")
    }
}
