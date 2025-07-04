import Foundation
import Moya
import InjectPropertyWrapper
import Combine
import Alamofire

protocol MoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie]
    func searchMovies(req: SearchMovieRequest) async throws -> [Movie]
}

class MoviesService: MoviesServiceProtocol {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { MediaItemPage(dto: $0) }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) -> AnyPublisher<Output, MovieError> {
        let future = Future<Output, MovieError> { future in
            self.moya.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            future(.success(output))
                        } catch {
                            future(.failure(MovieError.mappingError(message: error.localizedDescription)))
                        }
                    case 400..<500:
                        future(.failure(MovieError.clientError))
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                future(.failure(MovieError.invalidApiKeyError(message: apiError.statusMessage)))
                            } else {
                                future(.failure(MovieError.unexpectedError))
                            }
                        } else {
                            future(.failure(MovieError.unexpectedError))
                        }
                    }
                case .failure(let error):
                    if error.isNoInternetError {
                        future(.failure(MovieError.noInternetError))
                    } else {
                        future(.failure(MovieError.unexpectedError))
                    }
                    
                }
            }
        }
        return future
            .eraseToAnyPublisher()
            
    }
}
