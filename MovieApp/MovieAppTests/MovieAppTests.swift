//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Yakup on 4.11.2023.
//

import XCTest
@testable import MovieApp

final class MovieAppTests: XCTestCase {
	
	private var movieViewModel: MovieViewModel!
	private var detailViewModel: DetailViewModel!
	
	private var webService: MockWebService!
	
	private var movieOutput: MockMovieViewModelOutput!
	private var detailOutput: MockDetailViewModelOutput!
	
	override func setUpWithError() throws {
		webService = MockWebService()
		
		movieViewModel = MovieViewModel(webServiceProtocol: webService)
		detailViewModel = DetailViewModel(webServiceProtocol: webService)
		
		movieOutput = MockMovieViewModelOutput()
		movieViewModel.output = movieOutput
		
		detailOutput = MockDetailViewModelOutput()
		detailViewModel.output = detailOutput
	}
	
	override func tearDownWithError() throws {
		movieViewModel = nil
		detailViewModel = nil
		webService = nil
	}
	
	// MARK: - Test 1 Search Movie
	func testSearchMovie_whenAPISuccess_showsResultMovies() throws{
		let searchMovie = SearchMovie(search: [
			Movie(title: "Batman", year: "1990", imdbID: "21321", type: "Movie", poster: "N/A"),
			Movie(title: "Batman Arkham Night", year: "2000", imdbID: "21322", type: "Movie", poster: "N/A")
		], totalResults: "2", response: "True")
		
		webService.fetchSearchMovieMockResult = .success(searchMovie)
		
		movieViewModel.searchMovie(searchText: "Leon", page: nil, filterType: nil)
		
		XCTAssertEqual(movieOutput.searchMovie?.totalResults, "2")
		XCTAssertEqual(movieOutput.searchMovie?.response, "True")
		XCTAssertEqual(movieOutput.searchMovie?.search[0].title, "Batman")
		XCTAssertEqual(movieOutput.searchMovie?.search[0].type, "Movie")
		XCTAssertEqual(movieOutput.searchMovie?.search[0].year, "1990")
		XCTAssertEqual(movieOutput.searchMovie?.search[0].imdbID, "21321")
		XCTAssertEqual(movieOutput.searchMovie?.search[0].poster, "N/A")
		XCTAssertEqual(movieOutput.searchMovie?.search[1].title, "Batman Arkham Night")
		XCTAssertEqual(movieOutput.searchMovie?.search[1].type, "Movie")
		XCTAssertEqual(movieOutput.searchMovie?.search[1].year, "1990")
		XCTAssertEqual(movieOutput.searchMovie?.search[1].imdbID, "21322")
		XCTAssertEqual(movieOutput.searchMovie?.search[1].poster, "N/A")
	}
	
	// MARK: - Test 2 Pagination Search
	func testSearchPaginationMovie_whenAPISuccess_showsResultMovies() throws{
		let searchMovie = SearchMovie(search: [
			Movie(title: "Batman", year: "1990", imdbID: "21321", type: "Movie", poster: "N/A"),
			Movie(title: "Batman Arkham Night", year: "2000", imdbID: "21322", type: "Movie", poster: "N/A")
		], totalResults: "2", response: "True")
		
		webService.fetchSearchMovieMockResult = .success(searchMovie)
		
		movieViewModel.getMovieWithPage(page: "1", searchText: "Leon", filterType: nil)
		
		XCTAssertEqual(movieOutput.searchMovie?.totalResults, "2")
		XCTAssertEqual(movieOutput.searchMovie?.response, "True")
		XCTAssertEqual(movieOutput.searchMovie?.search[0].title, "Batman")
		XCTAssertEqual(movieOutput.searchMovie?.search[0].type, "Movie")
		XCTAssertEqual(movieOutput.searchMovie?.search[0].year, "1990")
		XCTAssertEqual(movieOutput.searchMovie?.search[0].imdbID, "21321")
		XCTAssertEqual(movieOutput.searchMovie?.search[0].poster, "N/A")
		XCTAssertEqual(movieOutput.searchMovie?.search[1].title, "Batman Arkham Night")
		XCTAssertEqual(movieOutput.searchMovie?.search[1].type, "Movie")
		XCTAssertEqual(movieOutput.searchMovie?.search[1].year, "1990")
		XCTAssertEqual(movieOutput.searchMovie?.search[1].imdbID, "21322")
		XCTAssertEqual(movieOutput.searchMovie?.search[1].poster, "N/A")
	}

	// MARK: - Test 3 Movie Detail Success
	func testFetchMovieDetail_whenAPISuccess_showsMovieDetail() throws{
		let movieDetail = MovieDetail(title: "Batman", year: "2000", rated: "9.0", released: "Yes", runtime: "120 minute", genre: "N/A", director: "Christopher Nolan", writer: "Frank Miller", actors: "", plot: "", language: "", country: "", awards: "", poster: "", ratings: [], metascore: "", imdbRating: "", imdbVotes: "", imdbID: "1", type: "", dvd: "", boxOffice: "", production: "", website: "", response: "")
		
		webService.fetchMovieDetailMockResult = .success(movieDetail)
		
		detailViewModel.fetchMovie(imdbID: "1")
		
		XCTAssertEqual(detailOutput.movie?.title, "Batman")
		XCTAssertEqual(detailOutput.movie?.year, "2000")
		XCTAssertEqual(detailOutput.movie?.rated, "9.0")
		XCTAssertEqual(detailOutput.movie?.released, "Yes")
		XCTAssertEqual(detailOutput.movie?.imdbID, "1")
		XCTAssertEqual(detailOutput.movie?.runtime, "120 minute")
		XCTAssertEqual(detailOutput.movie?.genre, "N/A")
		XCTAssertEqual(detailOutput.movie?.director, "Christopher Nolan")
		XCTAssertEqual(detailOutput.movie?.writer, "Frank Miller")
	}
	// MARK: - Test 4 Movie Detail Fail
	func testFetchMovieDetail_whenAPIFailure_showsMovieDetail() throws{
		let serverError = ErrorType.serverError
		
		webService.fetchMovieDetailMockResult = .failure(serverError)
		
		detailViewModel.fetchMovie(imdbID: "1")
		
		XCTAssertEqual(detailOutput.movie?.title, "")
		XCTAssertEqual(detailOutput.movie?.imdbRating, "")
		XCTAssertEqual(detailOutput.movie?.released, "")
		XCTAssertEqual(detailOutput.movie?.actors, "")
		XCTAssertEqual(detailOutput.movie?.director, "")
	}
}


class MockWebService: WebServiceProtocol{
	var fetchSearchMovieMockResult: Result<SearchMovie, ErrorType>?
	var fetchMovieDetailMockResult: Result<MovieDetail, ErrorType>?
	
	func searchMovies(searchText: String, page: String?, filterType: MovieApp.FilterType?, completion: @escaping (Result<MovieApp.SearchMovie, MovieApp.ErrorType>) -> ()) {
		if let result = fetchSearchMovieMockResult{
			completion(result)
		}
	}
	
	func getDetailsMovie(imdbID: String, completion: @escaping (Result<MovieApp.MovieDetail, MovieApp.ErrorType>) -> ()) {
		if let result = fetchMovieDetailMockResult{
			completion(result)
		}
	}
}

class MockMovieViewModelOutput: MovieViewModelOutput{
	var searchMovie: SearchMovie?
	
	func updateView(searchMovie: MovieApp.SearchMovie) {
		self.searchMovie = searchMovie
	}
	
	func getMovieFromPagination(searchMovie: MovieApp.SearchMovie) {
		self.searchMovie = searchMovie
	}
}

class MockDetailViewModelOutput: DetailViewModelOutput{
	var movie: MovieDetail?
	
	func updateView(getMovie: MovieApp.MovieDetail) {
		self.movie = getMovie
	}
}
