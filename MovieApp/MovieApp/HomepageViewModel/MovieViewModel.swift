//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Yakup on 5.11.2023.
//

import Foundation

class MovieViewModel{
	
	private let webServiceProtocol: WebServiceProtocol?
	var output: MovieViewModelOutput?
	
	init(webServiceProtocol: WebServiceProtocol? = nil) {
		self.webServiceProtocol = webServiceProtocol
	}
	
	func searchMovie(searchText: String, page: String?, filterType: FilterType?){
		webServiceProtocol?.searchMovies(searchText: searchText, page: page, filterType: filterType, completion: { result in
			switch result{
			case .success(let searchMovie):
				self.output?.updateView(searchMovie: searchMovie)
			case .failure(let error):
				switch error{
				case .serverError:
					print("Server Error!")
				case .decodingError:
					print("Decoding Error!")
				}
				self.output?.updateView(searchMovie: SearchMovie(search: [], totalResults: "0", response: "0"))
			}
		})
	}
	
	func getMovieWithPage(page: String, searchText: String, filterType: FilterType?){
		webServiceProtocol?.searchMovies(searchText: searchText, page: page, filterType: filterType, completion: { result in
			switch result{
			case .success(let searchMovie):
				self.output?.getMovieFromPagination(searchMovie: searchMovie)
			case .failure(let error):
				switch error{
				case .serverError:
					print("Server Error!")
				case .decodingError:
					print("Decoding Error!")
				}
				self.output?.getMovieFromPagination(searchMovie: SearchMovie(search: [], totalResults: "0", response: "0"))
			}
		})
	}
}
