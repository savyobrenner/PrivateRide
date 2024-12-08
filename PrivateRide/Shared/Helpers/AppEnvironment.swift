//
//  AppEnvironment.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation

enum AppEnvironment {
    
    static var websiteURL: String {
        return "https://google.com.br"
    }
    
    static var baseURL: String {
        return "https://google.com.br"
    }
    
    static var isDebug: Bool {
    #if DEBUG
        true
    #else
        false
    #endif
    }
    
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
    }
    
    static var appBuildVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
    }
}


