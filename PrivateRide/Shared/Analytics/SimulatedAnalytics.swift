//
//  SimulatedAnalytics.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

struct SimulatedAnalytics: AnalyticsCollectible {
    
    func collect(event: AnalyticsEventable) {
        let analyticsEnabled = AppEnvironment.isDebug // This should be disabled for Debug mode, but since this app will only run in Debug mode, I’ve modified the standard market logic.
        
        guard analyticsEnabled else { return }
        
        debugPrint("Analytics collected: \(event.name)")
    }
}
