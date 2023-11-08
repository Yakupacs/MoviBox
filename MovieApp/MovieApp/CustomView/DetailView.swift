//
//  DetailView.swift
//  MovieApp
//
//  Created by Yakup on 7.11.2023.
//

import Foundation
import UIKit

class DetailView: UIView{
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView(){
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = UIColor(named: "detailColor")
		layer.cornerRadius = 6
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.3
		layer.shadowOffset = .zero
		layer.shadowRadius = 10
	}
}
