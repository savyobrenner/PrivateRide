//
//  RouteResponse.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 11/12/24.
//

import Foundation

struct RouteResponse: Codable {
    let origin: Location
    let destination: Location
    let distance: Double
    let duration: Int
    let options: [Option]
    let routeResponse: RouteDetails?

    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }

    struct Option: Codable {
        let id: Int
        let name: String
        let description: String
        let vehicle: String
        let review: Review?
        let value: Double

        struct Review: Codable {
            let rating: Double
            let comment: String
        }
    }

    struct RouteDetails: Codable {
        let routes: [Route]

        struct Route: Codable {
            let legs: [Leg]
            let distanceMeters: Int
            let duration: String
            let staticDuration: String
            let polyline: Polyline
            let description: String
            let warnings: [String]
            let localizedValues: LocalizedValues

            struct Leg: Codable {
                let startLocation: LatLng
                let endLocation: LatLng
            }
        }

        struct Polyline: Codable {
            let encodedPolyline: String
        }

        struct LocalizedValues: Codable {
            let distance: TextValue
            let duration: TextValue
            let staticDuration: TextValue

            struct TextValue: Codable {
                let text: String
            }
        }

        struct LatLng: Codable {
            let latLng: Location
        }
        
        enum CodingKeys: CodingKey {
            case routes
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        origin = try container.decode(Location.self, forKey: .origin)
        destination = try container.decode(Location.self, forKey: .destination)
        distance = try container.decode(Double.self, forKey: .distance)
        duration = try container.decode(Int.self, forKey: .duration)
        options = try container.decode([Option].self, forKey: .options)

        let routeResponseContainer = try? container.nestedContainer(
            keyedBy: RouteDetails.CodingKeys.self, forKey: .routeResponse
        )
        
        if let routeResponseContainer, !routeResponseContainer.allKeys.isEmpty {
            routeResponse = try container.decodeIfPresent(RouteDetails.self, forKey: .routeResponse)
        } else {
            routeResponse = nil
        }
    }
}
