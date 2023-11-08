//
//  MoviesTableView.swift
//  MovieApp
//
//  Created by Yakup on 8.11.2023.
//

import Foundation
import UIKit

class MoviesTableView: UITableView{
	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: frame, style: style)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView(){
		translatesAutoresizingMaskIntoConstraints = false
		register(SearchTVC.self, forCellReuseIdentifier: "movieCell")
		isScrollEnabled = true
		showsVerticalScrollIndicator = false
		backgroundColor = .clear
		separatorStyle = .none
	}
}
