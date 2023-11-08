//
//  DetailViewModel.swift
//  MovieApp
//
//  Created by Yakup on 5.11.2023.
//

import Foundation

class DetailViewModel{
	
	private let webServiceProtocol: WebServiceProtocol?
	var output: DetailViewModelOutput?
	
	init(webServiceProtocol: WebServiceProtocol? = nil) {
		self.webServiceProtocol = webServiceProtocol
	}
	
	func fetchMovie(imdbID: String){
		webServiceProtocol?.getDetailsMovie(imdbID: imdbID, completion: { result in
			switch result{
			case .success(let movieDetail):
				self.output?.updateView(getMovie: movieDetail)
			case .failure(let error):
				switch error{
				case .serverError:
					print("Server Error!")
				case .decodingError:
					print("Decoding Error!")
				}
				self.output?.updateView(getMovie: MovieDetail(title: "", year: "", rated: "", released: "", runtime: "", genre: "", director: "", writer: "", actors: "", plot: "", language: "", country: "", awards: "", poster: "", ratings: [], metascore: "", imdbRating: "", imdbVotes: "", imdbID: "", type: "", dvd: "", boxOffice: "", production: "", website: "", response: ""))
			}
		})
	}
}
