//
//  SearchTVC.swift
//  MovieApp
//
//  Created by Yakup on 6.11.2023.
//

import UIKit

class SearchTVC: UITableViewCell {
	
	private let movieBackgroundView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(named: "viewColor")
		view.layer.cornerRadius = 6
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOpacity = 0.3
		view.layer.shadowOffset = .zero
		view.layer.shadowRadius = 10
		return view
	}()
	
	private let movieImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .clear
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textColor = .white
		label.font = UIFont(name: "Avenir-Heavy", size: 20)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let yearLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(named: "descriptionColor")
		label.font = UIFont(name: "Avenir-Heavy", size: 14)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let typeLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(named: "descriptionColor")
		label.font = UIFont(name: "Avenir-Heavy", size: 14)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let detailButton: UIButton = {
		let button = UIButton()
		button.titleLabel?.font = UIFont(name: "Avenir", size: 15)
		button.layer.cornerRadius = 5
		button.setTitleColor(UIColor(named: "descriptionColor"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(systemName: "eye"), for: .normal)
		button.tintColor = .white
		return button
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup(movie: Movie){
		if movie.poster != "N/A"{
			movieImageView.sd_setImage(with: URL(string: movie.poster))
		}else{
			movieImageView.image = UIImage(named: "posterNotAvailable")
		}
		titleLabel.text = movie.title
		yearLabel.text = "Year: " + movie.year
		typeLabel.text = "Type: " + movie.type.capitalized
		let bgColorView = UIView()
		bgColorView.backgroundColor = UIColor.clear
		selectedBackgroundView = bgColorView
	}
	
	private func addView(){
		backgroundColor = .clear
		movieBackgroundView.addSubview(movieImageView)
		movieBackgroundView.addSubview(titleLabel)
		movieBackgroundView.addSubview(yearLabel)
		movieBackgroundView.addSubview(typeLabel)
		movieBackgroundView.addSubview(detailButton)
		addSubview(movieBackgroundView)
		
		movieBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
		movieBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
		movieBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
		movieBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
		
		// Poster size 2000x3000
		movieImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
		movieImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
		movieImageView.leftAnchor.constraint(equalTo: movieBackgroundView.leftAnchor, constant: 10).isActive = true
		movieImageView.bottomAnchor.constraint(equalTo: movieBackgroundView.bottomAnchor, constant: -10).isActive = true
		
		titleLabel.topAnchor.constraint(equalTo: movieBackgroundView.topAnchor, constant: 15).isActive = true
		titleLabel.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 20).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: movieBackgroundView.rightAnchor, constant: -5).isActive = true
		titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
		
		yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
		yearLabel.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 20).isActive = true
		yearLabel.rightAnchor.constraint(equalTo: movieBackgroundView.rightAnchor, constant: -5).isActive = true
		
		typeLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 5).isActive = true
		typeLabel.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 20).isActive = true
		typeLabel.rightAnchor.constraint(equalTo: movieBackgroundView.rightAnchor, constant: -5).isActive = true
		
		detailButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
		detailButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
		detailButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
		detailButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
	}
}
