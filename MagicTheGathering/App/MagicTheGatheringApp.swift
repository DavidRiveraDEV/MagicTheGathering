
import Foundation
import UIKit

final class MagicTheGatheringApp: UIWindow {

    private let dependencyContainer = AppDependencyContainer()

    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        rootViewController = dependencyContainer.rootViewController
        makeKeyAndVisible()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
