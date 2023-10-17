//
//  MoviesViewController.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import UIKit
import SwiftUI

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: MoviesViewModelType!
    
    private var refreshControl: UIRefreshControl!
    private var selectedFilterValue = FilterType.popularityDescending.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("movies_title")
        
        setupCollectionView()
        setupRefreshControl()
        bindData()
        setupUI()
        setupNavigationBarItems()
        setupSearchBar()
    }
    
    private func setupUI() {
        collectionView.contentOffset.y = 0
        showProgressHud()
        viewModel.setup()
    }
    
    private func setupNavigationBarItems() {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(filtersTapped))
        button.tintColor = .white
        navigationItem.rightBarButtonItem = button
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("movies_search_placeholder")
        searchBar.backgroundColor = #colorLiteral(red: 0.09659101814, green: 0.0818265453, blue: 0.09498836845, alpha: 1)
        searchBar.backgroundImage = UIImage()
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.backgroundColor = UIColor.gray
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    @objc func refreshPulled(refreshControl: UIRefreshControl) {
        viewModel.refresh()
        collectionView.sendSubviewToBack(refreshControl)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register([MoviesCollectionViewCell.identifier])
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func bindData() {
        viewModel.onReload = { [weak self] in
            self?.collectionView.reloadData()
            self?.hideProgressHud()
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc private func filtersTapped() {
        searchBar.endEditing(true)
        let tuples: [(String, String)] = [
            (FilterType.popularityDescending.title, FilterType.popularityDescending.title),
            (FilterType.popularityAscending.title, FilterType.popularityAscending.title),
            (FilterType.ratingDescending.title, FilterType.ratingDescending.title),
            (FilterType.ratingAscending.title, FilterType.ratingAscending.title),
            (FilterType.releaseDateDescending.title, FilterType.releaseDateDescending.title),
            (FilterType.releaseDateAscending.title, FilterType.releaseDateAscending.title)
        ]
        
        let action = UIAlertController.actionSheetWithItems(items: tuples, currentSelection: selectedFilterValue, action: { [weak self] value in
            self?.selectedFilterValue = value
            self?.viewModel.filter(text: value)
        })
        
        action.addAction(UIAlertAction.init(title: NSLocalizedString("cancel"), style: .cancel, handler: nil))
        self.present(action, animated: true, completion: nil)
    }
    
    deinit {
        print("MoviesViewController - deinit")
    }
}


extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(id: MoviesCollectionViewCell.self, for: indexPath)
        let model = viewModel.moviesList[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.moviesList[indexPath.row]
        viewModel.showDetail(with: model.id)
        searchBar.endEditing(true)
    }
}

//MARK: - UIScrollViewDelegate -

extension MoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height - 2000 {
            self.viewModel.addNextPaginationPage()
        }
    }
}


extension MoviesViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let inset: CGFloat = 10
            
            // Items
            let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: .zero, bottom: inset, trailing: .zero)
            
            // Nested Group
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [smallItem])
            
            // Section
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
            
            return section
        }
        
        return compositionalLayout
    }
}

// MARK: - UISearchBarDelegate
extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(self.search(text:)), with: searchText, afterDelay: 1)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setupUI()
    }
    
    @objc private func search(text: String?) {
        showProgressHud()
        viewModel.search(text: text ?? "")
        collectionView.contentOffset.y = 0
    }
}


