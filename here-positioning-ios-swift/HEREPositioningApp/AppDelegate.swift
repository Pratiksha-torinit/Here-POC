/*
 * Copyright (c) 2011-2020 HERE Europe B.V.
 * All rights reserved.
 */

import UIKit
import NMAKit

// To obtain the application credentials, please register at https://developer.here.com/develop/mobile-sdks
let credentials = (
    appId: "GLKe8NgALDWzSa0kX78G",
    appCode: "SSr6e-4CHPnLY1L4d6I3-A",
    licenseKey:"KkAm9j+K98fp3FvZXXUuG6c/qvcY6BmbclaDIs9eKebVoCgFVrTZBMHn9Mg3kiQ8yTkSWABvNO4FCTGToGyzXUtMv+GFxCIadf4oexZre+1zrTtb8mBh7kJ4LpXXj00HRi3OA/lJItqaCxINeY04lORYuam6/dYs33cdNeqA7Zx9fzb6TeGqAZSCn+qmE7x3xF61ENUwha05khDseCrwL76kz9g6Sq8qdTMAyasMtjEjatzVIP8/7bzWE3BagfejelS0kocfxvwbXt/37h02zmk503wFvIik2LSjz3d0x+b8Z+0oKfQ9MxKH5CLuQ3ulEv/QQXcdKVDOiL/4at5EyYNdicqVvLExNyA6HRFevfdx1Il/2nBiC7GQzMKkZVTylS5JI6TElGEK3fu5+YaF9+xzLfUa3lRGNOL3HYEWqa14Tp5Rk5mShdp0xjm/pnFNN95feloBsof61IvBTnSNSCZ0GJyU76s7faFBc0xmxTxecTqxy0wxMEa6udRaQwtt5VKn6ZmQouflJinMmMON0vmL8qnrEUDkdg0m56q5TUQWCddovnlgmcZXgYHaKNdwBIZTAZT9rxTWti5ib11iYjGkd/EEN2ZX/aH+hhvoTf2WHgiCQCjTMlBchPdUFQlcRKRQr9J+Rxst2OEVIpIeq9OJGPaiU9FeiFPePxjM1gM="
)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //set application credentials
        NMAApplicationContext.setAppId(credentials.appId, appCode: credentials.appCode, licenseKey: credentials.licenseKey)
        return true
    }
}
