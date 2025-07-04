import Foundation
import Moya

enum MoviesApi {
    case fetchGenres(req: FetchGenreRequest)
    case fetchTVGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMoviesRequest)
    case searchMovies(req: SearchMovieRequest)
    case fetchFavoriteMovies(req: FetchFavoriteMovieRequest)
}

extension MoviesApi: TargetType {
    var baseURL: URL {
        // TODO: Másik baseurl
        let baseUrl = "https://api.themoviedb.org/3/"
        guard let baseUrl = URL(string: baseUrl) else {
            preconditionFailure("Base url not valid url")
        }
        return baseUrl
    }
    
    var path: String {
          switch self {
          case .fetchGenres:
              return "genre/movie/list"
          case .fetchTVGenres:
              return "genre/tv/list"
          case .fetchMovies:
              return "discover/movie"
          case .searchMovies:
              return "search/movie"
          case let .fetchFavoriteMovies(req):
              return "account/\(req.accountId)/favorite/movies"
              
          }
      }
      
      var method: Moya.Method {
          switch self {
          case .fetchGenres, .fetchTVGenres, .fetchMovies, .searchMovies, .fetchFavoriteMovies:
              return .get
          }
      }
      
      // TODO: Másik encoding
      var task: Task {
          switch self {
          case .fetchGenres(let req):
              return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
          case .fetchTVGenres(let req):
              return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
          case let .fetchMovies(req):
              return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
          case let .searchMovies(req):
                      return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
          case let .fetchFavoriteMovies(req):
              return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)

          }
      }
      
      var headers: [String : String]? {
          switch self {
          case let .fetchGenres(req):
              return ["Authorization": req.accessToken]
          case let .fetchTVGenres(req):
                return ["Authorization": req.accessToken]
            case let .fetchMovies(req):
                return ["Authorization": req.accessToken]
          case let .searchMovies(req):
              return [
                  "Authorization": req.accessToken,
                  "accept": "application/json"
              ]
          case let .fetchFavoriteMovies(req):
              return ["Authorization": req.accessToken]
          }
      }
      
  }
