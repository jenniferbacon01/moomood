import UIKit
import ApiAI
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let apiai = ApiAI.shared()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let config = ParseClientConfiguration { (theConfig) in
            theConfig.applicationId = "moomoodisawesome"
            theConfig.server = "http://moomoodserver.herokuapp.com/parse"
            theConfig.clientKey = "moomoodtrackingisimportant"
        }
        
        Parse.initialize(with: config)
        
        // parse-dashboard --appId moomoodisawesome --masterKey moomoodtrackingisimportant --serverURL "http://moomoodserver.herokuapp.com/parse"
        
        let configuration: AIConfiguration = AIDefaultConfiguration()
        configuration.clientAccessToken = "35ecc1b83c7e4cd3befe0022444ffd23"
        apiai.configuration = configuration
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

