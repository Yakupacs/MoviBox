//
//  MovieViewModelOutput.swift
//  MovieApp
//
//  Created by Yakup on 5.11.2023.
//

import Foundation

protocol MovieViewModelOutput{
	func updateView(searchMovie: SearchMovie)
	func getMovieFromPagination(searchMovie: SearchMovie)
}
