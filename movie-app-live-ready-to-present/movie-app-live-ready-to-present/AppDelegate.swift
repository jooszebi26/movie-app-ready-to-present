import UIKit
import InjectPropertyWrapper
import Swinject

class AppDelegate: NSObject, UIApplicationDelegate {
    let assembler: MainAssembler
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        print("AppDelegate - App launched")
        return true
    }
    
    override init() {
        assembler = MainAssembler.create(withAssemblies: [
            ServiceAssembly(),
            ViewModelAssembly()
        ])
        InjectSettings.resolver = assembler.container
    }
}

