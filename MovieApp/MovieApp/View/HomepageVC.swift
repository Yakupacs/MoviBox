//
//  ViewController.swift
//  MovieApp
//
//  Created by Yakup on 4.11.2023.
//

import UIKit
import SDWebImage

class HomepageVC: UIViewController, MovieViewModelOutput, UISearchResultsUpdating{
	
	private let moviesTableView = MoviesTableView(frame: .zero, style: .grouped)
	private let moviBoxImage: UIImageView = {
		let image = UIImage(named: "moviBox")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
		return imageView
	}()
	private let notMovieFoundImage: UIImageView = {
		let image = UIImage(named: "movieNotFound")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		imageView.isHidden = true
		imageView.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 100, y: UIScreen.main.bounds.height / 2 - 100, width: 200, height: 200)
		return imageView
	}()
	private let filterButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 16
		button.backgroundColor = .clear
		button.setTitleColor(.white, for: .normal)
		button.setImage(UIImage(named: "filter"), for: .normal)
		return button
	}()
	private let filterButtonBadge: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 10
		button.setTitleColor(.black, for: .normal)
		button.isHidden = true
		button.backgroundColor = .white
		button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 12)
		return button
	}()
	private let filterView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(named: "detailColor")
		view.layer.cornerRadius = 6
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOpacity = 0.3
		view.layer.shadowOffset = .zero
		view.layer.shadowRadius = 10
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 2
		view.isHidden = true
		return view
	}()
	private let filterTitleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "Avenir-Heavy", size: 24)
		label.textColor = .white
		label.text = "Filter"
		label.textAlignment = .center
		return label
	}()
	private let filterCloseButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(systemName: "xmark"), for: .normal)
		button.layer.cornerRadius = 15
		button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
		button.tintColor = .white
		return button
	}()
	private let filterTypeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "Avenir", size: 20)
		label.textColor = .white
		label.text = "Type: "
		label.textAlignment = .left
		return label
	}()
	private let movieRadioButton = FilterRadioButton(frame: .zero, kind: "Movie")
	private let serieRadioButton = FilterRadioButton(frame: .zero, kind: "Serie")
	private let episodeRadioButton = FilterRadioButton(frame: .zero, kind: "Episode")
	private let gameRadioButton = FilterRadioButton(frame: .zero, kind: "Game")
	private let clearFilterButton: UIButton = {
		let button = UIButton()
		button.setTitle("Clear", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont(name: "Avenir", size: 18)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
		button.layer.cornerRadius = 5
		return button
	}()
	private let activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.hidesWhenStopped = true
		indicator.style = .large
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.startAnimating()
		indicator.color = .white
		return indicator
	}()
	
	private let movieViewModel: MovieViewModel
	private let searchController = UISearchController(searchResultsController: nil)
	private var movies: [Movie]? = nil
	private var currentPage = 1
	private var totalPage = 0
	private var filterOpenBool = false
	private var height: CGFloat = 0
	private var selectedFilter: [FilterType] = []
	private var searchedMovieText = ""
	
	init(movieViewModel: MovieViewModel) {
		self.movieViewModel = movieViewModel
		super.init(nibName: nil, bundle: nil)
		self.movieViewModel.output = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupSearchController()
		activityIndicator.startAnimating()
		movieViewModel.searchMovie(searchText: "avatar", page: nil, filterType: nil)
		height = view.frame.size.height
	}
	// Arama yapıldığında bu delegate çıktı verir.
	func updateView(searchMovie: SearchMovie) {
		DispatchQueue.main.async{
			self.movies = searchMovie.search
			self.totalPage = Int(searchMovie.totalResults)!
			if searchMovie.search.count != 0{
				self.notMovieFoundImage.isHidden = true
				self.moviesTableView.reloadData()
			}else{
				self.notMovieFoundImage.isHidden = false
				self.moviesTableView.reloadData()
			}
			self.activityIndicator.stopAnimating()
		}
	}
	// Tableview kaydırıldığında bu delegate çıktı verir.
	func getMovieFromPagination(searchMovie: SearchMovie) {
		DispatchQueue.main.async{
			self.movies = self.movies! + searchMovie.search
			self.moviesTableView.reloadData()
		}
	}
	// Searchbar'a her text girildiğinde bu fonksiyon çalışır.
	func updateSearchResults(for searchController: UISearchController) {
		if searchController.searchBar.text != "" ,searchController.searchBar.text!.count > 2 {
			activityIndicator.startAnimating()
			currentPage = 1
			searchedMovieText = searchController.searchBar.text!
			if selectedFilter.count != 0{
				movieViewModel.searchMovie(searchText: searchController.searchBar.text!, page: nil, filterType: selectedFilter.first!)
			}else{
				movieViewModel.searchMovie(searchText: searchController.searchBar.text!, page: nil, filterType: nil)
			}
		}
	}
}

// MARK: - @objc functions
extension HomepageVC{
	@objc func clearFilter(){
		selectedFilter = []
		filterButtonBadge.isHidden = true
		for button in [movieRadioButton, serieRadioButton, episodeRadioButton, gameRadioButton]{
			button.isSelected = false
			button.setImage(UIImage(systemName: "circle"), for: .normal)
		}
		UIView.animate(withDuration: 1) {
			self.filterView.frame.origin.y = self.height + 200
		} completion: { _ in
			self.backNormalAppearance()
		}
	}
	@objc func filterClosed(){
		filterOpenBool = false
		UIView.animate(withDuration: 1) {
			self.filterView.frame.origin.y = self.height + 200
		} completion: { _ in
			self.backNormalAppearance()
		}
	}
	@objc func radioClicked(sender: UIButton){
		if sender == movieRadioButton {
			movieViewModel.searchMovie(searchText: searchedMovieText, page: nil, filterType: .Movie)
			selectedFilter = [.Movie]
			setButton(noSelectButtons: [serieRadioButton, episodeRadioButton, gameRadioButton], selectButton: movieRadioButton)
		} else if sender == serieRadioButton {
			movieViewModel.searchMovie(searchText: searchedMovieText, page: nil, filterType: .Serie)
			selectedFilter = [.Serie]
			setButton(noSelectButtons: [movieRadioButton, episodeRadioButton, gameRadioButton], selectButton: serieRadioButton)
		} else if sender == episodeRadioButton {
			movieViewModel.searchMovie(searchText: searchedMovieText, page: nil, filterType: .Episode)
			selectedFilter = [.Episode]
			setButton(noSelectButtons: [movieRadioButton, serieRadioButton, gameRadioButton], selectButton: episodeRadioButton)
		} else if sender == gameRadioButton {
			movieViewModel.searchMovie(searchText: searchedMovieText, page: nil, filterType: .Game)
			selectedFilter = [.Game]
			setButton(noSelectButtons: [movieRadioButton, serieRadioButton, episodeRadioButton], selectButton: gameRadioButton)
		}
		filterButtonBadge.isHidden = false
		filterButtonBadge.setTitle("1", for: .normal)
		filterOpenBool = false
		UIView.animate(withDuration: 1) {
			self.filterView.frame.origin.y = self.height + 200
		} completion: { _ in
			self.backNormalAppearance()
		}
	}
	@objc func filterClicked(){
		filterButton.isEnabled = false
		if filterOpenBool == false{
			moviesTableView.allowsSelection = false
			searchController.searchBar.isEnabled = false
			moviesTableView.isScrollEnabled = false
			filterOpenBool = true
			self.filterView.isHidden = false
			UIView.animate(withDuration: 1) {
				self.filterView.frame.origin.y -= self.height
			} completion: { _ in
				self.filterButton.isEnabled = true
			}
		}else{
			filterOpenBool = false
			UIView.animate(withDuration: 1) {
				self.filterView.frame.origin.y = self.height + 200
			} completion: { _ in
				self.backNormalAppearance()
			}
		}
	}
}

// MARK: - TableView
extension HomepageVC: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movies?.count ?? 0
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let movies else { return UITableViewCell() }
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! SearchTVC
		cell.setup(movie: movies[indexPath.row])
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let movies else { return }
		
		SelectedMovie.shared.movie = movies[indexPath.row]
		let webServiceProtocol: WebServiceProtocol = WebService()
		let detailViewModel = DetailViewModel(webServiceProtocol: webServiceProtocol)
		let detailVC = DetailVC(detailViewModel: detailViewModel)
		detailVC.modalPresentationStyle = .fullScreen
		present(detailVC, animated: true)
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 220
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		view.endEditing(true)
		let lastItem = self.movies!.count - 1
		if movieRadioButton.isSelected {
			getSelectFilter(indexPath: indexPath, lastItem: lastItem, filterType: .Movie)
		}else if serieRadioButton.isSelected {
			getSelectFilter(indexPath: indexPath, lastItem: lastItem, filterType: .Serie)
		}else if episodeRadioButton.isSelected {
			getSelectFilter(indexPath: indexPath, lastItem: lastItem, filterType: .Episode)
		}else if gameRadioButton.isSelected {
			getSelectFilter(indexPath: indexPath, lastItem: lastItem, filterType: .Game)
		}else{
			getSelectFilter(indexPath: indexPath, lastItem: lastItem, filterType: nil)
		}
	}
	func getSelectFilter(indexPath: IndexPath, lastItem: Int, filterType: FilterType?){
		if indexPath.row == lastItem {
			if currentPage < totalPage {
				currentPage += 1
				movieViewModel.getMovieWithPage(page: String(currentPage), searchText: searchedMovieText, filterType: filterType)
			}
		}
	}
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		searchController.dismiss(animated: true)
	}
}

// MARK: - Setup Views
extension HomepageVC{
	private func setupViews(){
		view.backgroundColor = UIColor(named: "backgroundColor")
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: moviBoxImage)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
		moviesTableView.dataSource = self
		moviesTableView.delegate = self
		setAddViews()
		setAddTargets()
		setConstraints()
	}
	private func setAddViews(){
		view.addSubview(moviesTableView)
		view.addSubview(notMovieFoundImage)
		view.addSubview(filterButton)
		view.addSubview(filterView)
		moviesTableView.addSubview(activityIndicator)
		filterButton.addSubview(filterButtonBadge)
		filterView.addSubview(filterTitleLabel)
		filterView.addSubview(filterCloseButton)
		filterView.addSubview(filterTypeLabel)
		filterView.addSubview(movieRadioButton)
		filterView.addSubview(serieRadioButton)
		filterView.addSubview(episodeRadioButton)
		filterView.addSubview(gameRadioButton)
		filterView.addSubview(clearFilterButton)
	}
	private func setAddTargets(){
		filterButton.addTarget(self, action: #selector(filterClicked), for: .touchUpInside)
		filterCloseButton.addTarget(self, action: #selector(filterClosed), for: .touchUpInside)
		movieRadioButton.addTarget(self, action: #selector(radioClicked), for: .touchUpInside)
		serieRadioButton.addTarget(self, action: #selector(radioClicked), for: .touchUpInside)
		episodeRadioButton.addTarget(self, action: #selector(radioClicked), for: .touchUpInside)
		gameRadioButton.addTarget(self, action: #selector(radioClicked), for: .touchUpInside)
		clearFilterButton.addTarget(self, action: #selector(clearFilter), for: .touchUpInside)
	}
	
	private func setConstraints(){
		NSLayoutConstraint.activate([
			moviesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			moviesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
			moviesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
			moviesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -8),
			
			notMovieFoundImage.centerXAnchor.constraint(equalTo: moviesTableView.centerXAnchor),
			notMovieFoundImage.centerYAnchor.constraint(equalTo: moviesTableView.centerYAnchor),
			notMovieFoundImage.heightAnchor.constraint(equalToConstant: 150),
			notMovieFoundImage.widthAnchor.constraint(equalToConstant: 150),
			
			filterButton.heightAnchor.constraint(equalToConstant: 28),
			filterButton.widthAnchor.constraint(equalToConstant: 28),
			
			filterButtonBadge.topAnchor.constraint(equalTo: filterButton.topAnchor, constant: -7),
			filterButtonBadge.leftAnchor.constraint(equalTo: filterButton.rightAnchor, constant: -15),
			filterButtonBadge.heightAnchor.constraint(equalToConstant: 20),
			filterButtonBadge.widthAnchor.constraint(equalToConstant: 20),
			
			moviBoxImage.widthAnchor.constraint(equalToConstant: 145),
			moviBoxImage.heightAnchor.constraint(equalToConstant: 45),
			
			filterView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 200),
			filterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			filterView.heightAnchor.constraint(equalToConstant: 270),
			filterView.widthAnchor.constraint(equalToConstant: 250),
			
			filterTitleLabel.topAnchor.constraint(equalTo: filterView.topAnchor, constant: 20),
			filterTitleLabel.centerXAnchor.constraint(equalTo: filterView.centerXAnchor),
			
			filterCloseButton.topAnchor.constraint(equalTo: filterView.topAnchor, constant: 20),
			filterCloseButton.rightAnchor.constraint(equalTo: filterView.rightAnchor, constant: -15),
			filterCloseButton.heightAnchor.constraint(equalToConstant: 30),
			filterCloseButton.widthAnchor.constraint(equalToConstant: 30),
			
			filterTypeLabel.topAnchor.constraint(equalTo: filterTitleLabel.bottomAnchor, constant: 10),
			filterTypeLabel.leftAnchor.constraint(equalTo: filterView.leftAnchor, constant: 16),
			
			movieRadioButton.topAnchor.constraint(equalTo: filterTypeLabel.bottomAnchor, constant: 10),
			movieRadioButton.leftAnchor.constraint(equalTo: filterView.leftAnchor, constant: 16),
			
			serieRadioButton.topAnchor.constraint(equalTo: movieRadioButton.bottomAnchor, constant: 5),
			serieRadioButton.leftAnchor.constraint(equalTo: filterView.leftAnchor, constant: 16),
			
			episodeRadioButton.topAnchor.constraint(equalTo: serieRadioButton.bottomAnchor, constant: 5),
			episodeRadioButton.leftAnchor.constraint(equalTo: filterView.leftAnchor, constant: 16),
			
			gameRadioButton.topAnchor.constraint(equalTo: episodeRadioButton.bottomAnchor, constant: 5),
			gameRadioButton.leftAnchor.constraint(equalTo: filterView.leftAnchor, constant: 16),
			
			clearFilterButton.centerXAnchor.constraint(equalTo: filterView.centerXAnchor),
			clearFilterButton.topAnchor.constraint(equalTo: gameRadioButton.bottomAnchor, constant: 20),
			clearFilterButton.heightAnchor.constraint(equalToConstant: 30),
			clearFilterButton.widthAnchor.constraint(equalToConstant: 80),
			
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	private func setupSearchController() {
		searchController.searchBar.searchTextPositionAdjustment = .init(horizontal: 5, vertical: 0)
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Movie"
		searchController.searchBar.clipsToBounds = true
		searchController.searchBar.searchTextField.backgroundColor = .white
		searchController.searchBar.tintColor = .black
		searchController.searchBar.searchTextField.leftView?.tintColor = .black
		searchController.searchBar.searchTextField.backgroundColor = .white
		searchController.searchBar.searchBarStyle = .minimal
		UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
		if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
			textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [
				NSAttributedString.Key.font : UIFont(name: "Avenir", size: 16)!,
				NSAttributedString.Key.foregroundColor: UIColor.gray])
		}
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	private func backNormalAppearance(){
		self.filterView.isHidden = true
		self.filterButton.isEnabled = true
		self.moviesTableView.allowsSelection = true
		self.searchController.searchBar.isEnabled = true
		self.moviesTableView.isScrollEnabled = true
	}
	func setButton(noSelectButtons: [UIButton], selectButton: UIButton){
		for button in noSelectButtons{
			button.isSelected = false
			button.setImage(UIImage(systemName: "circle"), for: .normal)
		}
		selectButton.isSelected = true
		selectButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
	}
}
