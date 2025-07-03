import Foundation
import InjectPropertyWrapper

protocol MovieListViewModelProtocol: ObservableObject {
    
}

class MovieListViewModel: MovieListViewModelProtocol {
    @Published var movies: [Movie] = []
    
    @Inject
    private var service: MoviesServiceProtocol
    
    func loadMovies(by genreId: Int) async {
        do {
            let request = FetchMoviesRequest(genreId: genreId)
            let movies = try await service.fetchMovies(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
}

