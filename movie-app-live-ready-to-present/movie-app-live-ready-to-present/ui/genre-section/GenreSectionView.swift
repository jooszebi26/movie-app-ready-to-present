import SwiftUI

class GenreSectionViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    private var movieService: MoviesServiceProtocol = MoviesService()
    
    func fetchGenres() async {
        
        do {
            let request = FetchGenreRequest()
            let genres = try await movieService.fetchGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
}

struct GenreSectionView: View {
    
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.genres) { genre in
                ZStack {
                    NavigationLink(destination: Color.gray) {
                        EmptyView()
                    }
                    .opacity(0)

                    HStack {
                        Text(genre.name)
                            .font(Fonts.title)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(.rightArrow)
                    }
                    
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("genreSection.title")
        }
        .onAppear {
            Task {
                await viewModel.fetchGenres()
            }
        }
    }
}

#Preview {
    GenreSectionView()
}
