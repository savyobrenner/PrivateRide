//
//  PRAnalyticsEvents.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

enum PRAnalyticsEvents: AnalyticsEventable {
    
    case appLaunch
    
    case homeScreen
    case homeScreenTime(duration: Double)
    case locateUser
    case searchRide(userId: String)
    case cancelRide(userId: String)
    case confirmRide(userId: String)
    
    case navigateToTripHistory
    case tripHistoryScreen
    case tripHistoryScreenTime(duration: Double)
    case tripHistoryBackButton
    
    var name: String {
        switch self {
        case .appLaunch: return "app_launch"
        case .homeScreen: return "home_screen"
        case .homeScreenTime: return "home_screen_time"
        case .locateUser: return "locate_user"
        case .searchRide: return "search_ride"
        case .cancelRide: return "cancel_ride"
        case .confirmRide: return "confirm_ride"
        case .navigateToTripHistory: return "navigate_to_trip_history"
        case .tripHistoryScreen: return "trip_history_screen"
        case .tripHistoryScreenTime: return "trip_history_screen_time"
        case .tripHistoryBackButton: return "trip_history_back_button"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .appLaunch, .homeScreen, .locateUser, .navigateToTripHistory, .tripHistoryScreen, .tripHistoryBackButton:
            return nil
        case let .homeScreenTime(duration), let .tripHistoryScreenTime(duration):
            return ["screen_time": duration]
        case let .searchRide(userId), let .cancelRide(userId), let .confirmRide(userId):
            return ["user_id": userId]
        }
    }
}
