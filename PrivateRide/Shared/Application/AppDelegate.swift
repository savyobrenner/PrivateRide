//
//  AppDelegate.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import IQKeyboardManagerSwift
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureApp(application)

        return true
    }

    func configureApp(_ application: UIApplication) {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}
