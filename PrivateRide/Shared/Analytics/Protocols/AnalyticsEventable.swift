//
//  AnalyticsEventable.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

protocol AnalyticsEventable {
    var name: String { get }
    var parameters: [String: Any]? { get }
}

protocol AnalyticsCollectible {
    func collect(event: AnalyticsEventable)
}
