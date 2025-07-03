import Swinject
import Foundation
import Combine

class ViewModelAssembly: Assembly {

    func assemble(container: Container) {
        container.register((any MovieListViewModelProtocol).self) { _ in
                return MovieListViewModel()
            }.inObjectScope(.transient)
        
        container.register((any GenreSectionViewModelProtocol).self) { _ in
            return GenreSectionViewModel()
        }.inObjectScope(.container)
    }
}
