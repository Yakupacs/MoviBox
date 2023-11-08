//
//  SelectedMovie.swift
//  MovieApp
//
//  Created by Yakup on 6.11.2023.
//

import Foundation

class SelectedMovie{
	static let shared = SelectedMovie()
	var movie: Movie?
	private init(movie: Movie? = nil) {
		self.movie = movie
	}
}
