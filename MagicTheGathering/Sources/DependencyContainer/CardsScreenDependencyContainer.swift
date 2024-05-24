
import Foundation

final class CardsScreenDependencyContainer {

    private let cardsRepositoryCacher = Cacher<String, [Card]>()

    func buildMagicCardsViewController(router: CardsRouter) -> MagicCardsViewController {
        let viewModel = buildViewModel()
        return .init(viewModel: viewModel, router: router)
    }

    private func buildViewModel() -> MagicCardsViewModel{
        let useCase = buildUseCase()
        return .init(useCase: useCase)
    }

    private func buildUseCase() -> CardsUseCase {
        let repository = buildRepository()
        return MagicCardsUseCase(repository: repository)
    }

    private func buildRepository() -> CardsRepository {
        let api = MagicCardsAPI()
        let session = Foundation.URLSession.shared
        let remoteRepository = RemoteCardsRepository(api: api, session: session)
        return CachedCardsRepository(repository: remoteRepository, cacher: cardsRepositoryCacher)
    }
}
