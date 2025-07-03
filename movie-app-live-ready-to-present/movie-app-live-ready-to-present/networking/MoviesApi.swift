import Foundation
import Moya

enum MoviesApi {
    case fetchGenres(req: FetchGenreRequest)
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
          }
      }
      
      var method: Moya.Method {
          switch self {
          case .fetchGenres:
              return .get
          }
      }
      
      // TODO: Másik encoding
      var task: Task {
          switch self {
          case .fetchGenres(let req):
              return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
          }
      }
      
      var headers: [String : String]? {
          switch self {
          case let .fetchGenres(req):
              return ["Authorization": req.accessToken]
          }
      }
      
  }
