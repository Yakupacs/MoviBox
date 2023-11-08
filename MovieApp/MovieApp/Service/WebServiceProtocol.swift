//
//  WebServiceProtocol.swift
//  MovieApp
//
//  Created by Yakup on 5.11.2023.
//

import Foundation

protocol WebServiceProtocol{
	func searchMovies(searchText: String, page: String?, filterType: FilterType?, completion: @escaping (Result<SearchMovie, ErrorType>) -> ())
	func getDetailsMovie(imdbID: String, completion: @escaping (Result<MovieDetail, ErrorType>) -> ())
}
