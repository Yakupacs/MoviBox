//
//  DetailVC.swift
//  MovieApp
//
//  Created by Yakup on 6.11.2023.
//

import UIKit
import SDWebImage

class DetailVC: UIViewController, DetailViewModelOutput, UIScrollViewDelegate {

	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()
	private let contentView = UIView()
	private let backButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
		button.layer.cornerRadius = 20
		button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
		button.tintColor = .white
		return button
	}()
	private let moviePosterImage = UIImageView()
	private let titleView = DetailView()
	private let movieTitleLabel = DetailTitleLabel(frame: .zero, title: "            ", size: 26, textColor: .white)
	private let movieRateLabel = DetailTitleLabel(frame: .zero, title: "            ", size: 20, textColor: .systemYellow)
	private let starsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 5
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
		stackView.alignment = .center
		return stackView
	}()
	private let movieDescriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "Avenir-Heavy", size: 14)
		label.textColor = UIColor(named: "descriptionColor")
		label.numberOfLines = 4
		label.textAlignment = .left
		let attributedString = NSMutableAttributedString(string: "")
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 6
		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
		label.attributedText = attributedString
		return label
	}()
	private let activityIndicator = ActivityIndicator(frame: .zero, color: .black)
	private let actorView = DetailView()
	private let actorTitleLabel = DetailTitleLabel(frame: .zero, title: "Actors", size: 24, textColor: .white)
	private let actorCollectionView = ActorCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private let movieDetailView = DetailView()
	private let detailTitleLabel = DetailTitleLabel(frame: .zero, title: "Details", size: 24, textColor: .white)
	private let movieDirectorLabel = MovieDetailLabel(frame: .zero, feature: "              ")
	private let movieYearLabel = MovieDetailLabel(frame: .zero, feature: "            ")
	private let movieReleasedLabel = MovieDetailLabel(frame: .zero, feature: "          ")
	private let movieRuntimeLabel = MovieDetailLabel(frame: .zero, feature: "             ")
	private let movieLanguageLabel = MovieDetailLabel(frame: .zero, feature: "                ")
	private let movieBoxOfficeLabel = MovieDetailLabel(frame: .zero, feature: "          ")
	private let movieGenreLabel = MovieDetailLabel(frame: .zero, feature: "                ")
	private let movieCountryLabel = MovieDetailLabel(frame: .zero, feature: "          ")
	private let movieAwardsLabel = MovieDetailLabel(frame: .zero, feature: "                  ")
	private let movieWritersLabel = MovieDetailLabel(frame: .zero, feature: "              ")
	
	private let scrollViewHeight : CGFloat = 1440
	private let detailViewModel: DetailViewModel
	private var actors = [String.SubSequence]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		waitingDataSkeleton()
		setupViews()
		activityIndicator.startAnimating()
		detailViewModel.fetchMovie(imdbID: SelectedMovie.shared.movie!.imdbID)
	}
	
	init(detailViewModel: DetailViewModel) {
		self.detailViewModel = detailViewModel
		super.init(nibName: nil, bundle: nil)
		self.detailViewModel.output = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// ID ile istek atıldığında bu fonksiyon çıktısı çalışır.
	func updateView(getMovie: MovieDetail) {
		DispatchQueue.main.async{
			self.movieTitleLabel.text = getMovie.title
			if getMovie.imdbRating != "N/A"{
				self.movieRateLabel.text = getMovie.imdbRating
				self.setupMovieStar(getMovie.imdbRating!)
			}else{
				self.movieRateLabel.text = "No rate information found."
			}
			self.movieDescriptionLabel.text = "\(getMovie.plot ?? "No description information found.")"
			self.movieYearLabel.text = "Year: \(getMovie.year ?? "N/A")"
			self.movieDirectorLabel.text = "Director: \(getMovie.director ?? "N/A")"
			self.movieRuntimeLabel.text = "Runtime: \(getMovie.runtime ?? "N/A")"
			self.movieLanguageLabel.text = "Language: \(getMovie.language ?? "N/A")"
			self.movieBoxOfficeLabel.text = "Box Office: \(getMovie.boxOffice ?? "N/A")"
			self.movieReleasedLabel.text = "Released Date: \(getMovie.released ?? "N/A")"
			self.movieGenreLabel.text = "Genre: \(getMovie.genre ?? "N/A")"
			self.movieWritersLabel.text = "Writers: \(getMovie.writer ?? "N/A")"
			self.movieCountryLabel.text = "Country: \(getMovie.country ?? "N/A")"
			self.movieAwardsLabel.text = "Awards: \(getMovie.awards ?? "N/A")"
			if getMovie.poster != "N/A"{
				self.moviePosterImage.sd_setImage(with: URL(string: getMovie.poster!))
			}else{
				self.moviePosterImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
				self.moviePosterImage.sd_setImage(with: URL(string: "https://images.template.net/wp-content/uploads/2017/02/22192223/Movie-Icons.jpg"))
			}
			
			let movieActors = getMovie.actors!.split(separator: ",")
			self.actors = movieActors
			self.actorCollectionView.reloadData()
			self.cameDataSkeleton()
			self.activityIndicator.stopAnimating()
		}
	}
	// Puanına göre yıldız sayısı hesaplar.
	func setupMovieStar(_ rating: String){
		if let ratingFloat = Float(rating){
			addStar(ratingFloat.getStarCount())
		}
	}
	// Gelen yıldız sayısına göre yıldızları dolu ve boş olarak stackview'e ekler.
	func addStar(_ count: Int){
		// Star Fill
		for _ in 0..<count {
			let star = UIImageView()
			star.image = UIImage(systemName: "star.fill")
			star.tintColor = .systemYellow
			starsStackView.addArrangedSubview(star)
		}
		// Star
		for _ in 0..<5-count {
			let star = UIImageView()
			star.image = UIImage(systemName: "star")
			star.tintColor = .systemYellow
			starsStackView.addArrangedSubview(star)
		}
	}
}

// MARK: - @objc functions
extension DetailVC{
	@objc func backFunc(){
		self.dismiss(animated: true)
	}
}

// MARK: - Collection View
extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return actors.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actorCell", for: indexPath) as! ActorsCVC
		cell.setup(indexPath: indexPath, actors: actors)
		return cell
	}
}

// MARK: - Setup Views
extension DetailVC{
	func waitingDataSkeleton(){
		movieDescriptionLabel.text = "                                                                    "
		moviePosterImage.backgroundColor = .systemGray4
		movieDescriptionLabel.backgroundColor = .systemGray4
		movieRateLabel.backgroundColor = .systemGray4
		movieDirectorLabel.backgroundColor = .systemGray4
		movieYearLabel.backgroundColor = .systemGray4
		movieRuntimeLabel.backgroundColor = .systemGray4
		movieLanguageLabel.backgroundColor = .systemGray4
		movieBoxOfficeLabel.backgroundColor = .systemGray4
		movieReleasedLabel.backgroundColor = .systemGray4
		movieGenreLabel.backgroundColor = .systemGray4
		movieAwardsLabel.backgroundColor = .systemGray4
		movieCountryLabel.backgroundColor = .systemGray4
		movieWritersLabel.backgroundColor = .systemGray4
	}
	func cameDataSkeleton(){
		moviePosterImage.backgroundColor = .clear
		movieRateLabel.backgroundColor = .clear
		movieDescriptionLabel.backgroundColor = .clear
		movieDirectorLabel.backgroundColor = .clear
		movieYearLabel.backgroundColor = .clear
		movieRuntimeLabel.backgroundColor = .clear
		movieLanguageLabel.backgroundColor = .clear
		movieBoxOfficeLabel.backgroundColor = .clear
		movieReleasedLabel.backgroundColor = .clear
		movieGenreLabel.backgroundColor = .clear
		movieAwardsLabel.backgroundColor = .clear
		movieCountryLabel.backgroundColor = .clear
		movieWritersLabel.backgroundColor = .clear
	}
	func setupViews(){
		view.backgroundColor = UIColor(named: "backgroundColor")
		addViews()
		setZPositions()
		backButton.addTarget(self, action: #selector(backFunc), for: .touchUpInside)
		setConstraints()
	}
	func addViews(){
		moviePosterImage.translatesAutoresizingMaskIntoConstraints = false
		contentView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.delegate = self
		scrollView.addSubview(contentView)
		view.addSubview(scrollView)
		view.addSubview(backButton)
		view.addSubview(activityIndicator)
		contentView.addSubview(moviePosterImage)
		contentView.addSubview(titleView)
		contentView.addSubview(actorView)
		
		titleView.addSubview(movieTitleLabel)
		titleView.addSubview(movieRateLabel)
		titleView.addSubview(starsStackView)
		titleView.addSubview(movieDescriptionLabel)
		
		actorCollectionView.dataSource = self
		actorCollectionView.delegate = self
		actorView.addSubview(actorTitleLabel)
		actorView.addSubview(actorCollectionView)
		
		contentView.addSubview(movieDetailView)
		movieDetailView.addSubview(detailTitleLabel)
		movieDetailView.addSubview(movieYearLabel)
		movieDetailView.addSubview(movieRuntimeLabel)
		movieDetailView.addSubview(movieDirectorLabel)
		movieDetailView.addSubview(movieLanguageLabel)
		movieDetailView.addSubview(movieReleasedLabel)
		movieDetailView.addSubview(movieBoxOfficeLabel)
		movieDetailView.addSubview(movieGenreLabel)
		movieDetailView.addSubview(movieAwardsLabel)
		movieDetailView.addSubview(movieWritersLabel)
		movieDetailView.addSubview(movieCountryLabel)
	}
	func setZPositions(){
		backButton.layer.zPosition = 0.7
		titleView.layer.zPosition = 0.6
		actorView.layer.zPosition = 0.6
		moviePosterImage.layer.zPosition = 0.5
	}
	func setConstraints(){
		// Poster size 2000x3000
		let width = view.frame.size.width
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -50),
			scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
			scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
			contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			contentView.heightAnchor.constraint(equalToConstant: scrollViewHeight),
			
			moviePosterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
			moviePosterImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
			moviePosterImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
			moviePosterImage.heightAnchor.constraint(equalToConstant: width * 1.5),
			
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.heightAnchor.constraint(equalToConstant: 50),
			activityIndicator.widthAnchor.constraint(equalToConstant: 50),
			
			titleView.topAnchor.constraint(equalTo: moviePosterImage.bottomAnchor, constant: -30),
			titleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
			titleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
			titleView.heightAnchor.constraint(equalToConstant: 230),
			
			backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
			backButton.heightAnchor.constraint(equalToConstant: 40),
			backButton.widthAnchor.constraint(equalToConstant: 40),
			
			movieTitleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 30),
			movieTitleLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 16),
			movieTitleLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -16),
			
			movieRateLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 10),
			movieRateLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 16),
			
			starsStackView.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 13),
			starsStackView.leftAnchor.constraint(equalTo: movieRateLabel.rightAnchor, constant: 10),

			movieDescriptionLabel.topAnchor.constraint(equalTo: movieRateLabel.bottomAnchor, constant: 8),
			movieDescriptionLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 16),
			movieDescriptionLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -16),

			actorView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
			actorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
			actorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
			actorView.heightAnchor.constraint(equalToConstant: 155),
			
			actorTitleLabel.topAnchor.constraint(equalTo: actorView.topAnchor, constant: 25),
			actorTitleLabel.leftAnchor.constraint(equalTo: actorView.leftAnchor, constant: 16),
			
			actorCollectionView.topAnchor.constraint(equalTo: actorTitleLabel.bottomAnchor, constant: 5),
			actorCollectionView.leftAnchor.constraint(equalTo: actorView.leftAnchor, constant: 16),
			actorCollectionView.rightAnchor.constraint(equalTo: actorView.rightAnchor, constant: -16),
			actorCollectionView.bottomAnchor.constraint(equalTo: actorView.bottomAnchor),
			
			movieDetailView.topAnchor.constraint(equalTo: actorView.bottomAnchor, constant: 20),
			movieDetailView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
			movieDetailView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
			movieDetailView.heightAnchor.constraint(equalToConstant: 370),
			
			detailTitleLabel.topAnchor.constraint(equalTo: movieDetailView.topAnchor, constant: 25),
			detailTitleLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			
			movieDirectorLabel.topAnchor.constraint(equalTo: detailTitleLabel.bottomAnchor, constant: 16),
			movieDirectorLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			movieDirectorLabel.rightAnchor.constraint(equalTo: movieDetailView.rightAnchor, constant: -16),
			
			movieYearLabel.topAnchor.constraint(equalTo: movieDirectorLabel.bottomAnchor, constant: 8),
			movieYearLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			movieYearLabel.rightAnchor.constraint(equalTo: movieDetailView.rightAnchor, constant: -16),
			
			movieRuntimeLabel.topAnchor.constraint(equalTo: movieYearLabel.bottomAnchor, constant: 8),
			movieRuntimeLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			movieRuntimeLabel.rightAnchor.constraint(equalTo: movieDetailView.rightAnchor, constant: -16),
			
			movieLanguageLabel.topAnchor.constraint(equalTo: movieRuntimeLabel.bottomAnchor, constant: 8),
			movieLanguageLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			movieLanguageLabel.rightAnchor.constraint(equalTo: movieDetailView.rightAnchor, constant: -16),
			
			movieBoxOfficeLabel.topAnchor.constraint(equalTo: movieLanguageLabel.bottomAnchor, constant: 8),
			movieBoxOfficeLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			movieBoxOfficeLabel.rightAnchor.constraint(equalTo: movieDetailView.rightAnchor, constant: -16),
			
			movieReleasedLabel.topAnchor.constraint(equalTo: movieBoxOfficeLabel.bottomAnchor, constant: 8),
			movieReleasedLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			movieReleasedLabel.rightAnchor.constraint(equalTo: movieDetailView.rightAnchor, constant: -16),
			
			movieGenreLabel.topAnchor.constraint(equalTo: movieReleasedLabel.bottomAnchor, constant: 8),
			movieGenreLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			movieGenreLabel.rightAnchor.constraint(equalTo: movieDetailView.rightAnchor, constant: -16),
			
			movieAwardsLabel.topAnchor.constraint(equalTo: movieGenreLabel.bottomAnchor, constant: 8),
			movieAwardsLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			movieAwardsLabel.rightAnchor.constraint(equalTo: movieDetailView.rightAnchor, constant: -16),
			
			movieCountryLabel.topAnchor.constraint(equalTo: movieAwardsLabel.bottomAnchor, constant: 8),
			movieCountryLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			movieCountryLabel.rightAnchor.constraint(equalTo: movieDetailView.rightAnchor, constant: -16),
			
			movieWritersLabel.topAnchor.constraint(equalTo: movieCountryLabel.bottomAnchor, constant: 8),
			movieWritersLabel.leftAnchor.constraint(equalTo: movieDetailView.leftAnchor, constant: 16),
			movieWritersLabel.rightAnchor.constraint(equalTo: movieDetailView.rightAnchor, constant: -16),
		])
	}
}
