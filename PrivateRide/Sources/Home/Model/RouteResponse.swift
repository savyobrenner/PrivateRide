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
    let distance: Int
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
            let rating: Int
            let comment: String
        }
    }

    struct RouteDetails: Codable {
        let routes: [Route]
        let distanceMeters: Int
        let duration: String
        let staticDuration: String
        let polyline: Polyline

        struct Route: Codable {
            let legs: [Leg]
            let distanceMeters: Int
            let duration: String
            let staticDuration: String
            let polyline: Polyline
            let startLocation: LatLng
            let endLocation: LatLng
            let localizedValues: LocalizedValues
            let travelMode: String

            struct Leg: Codable {
                let distanceMeters: Int
                let duration: String
                let staticDuration: String
                let polyline: Polyline
                let startLocation: LatLng
                let endLocation: LatLng
                let steps: [Step]
                let localizedValues: LocalizedValues

                struct Step: Codable {
                    let distanceMeters: Int
                    let staticDuration: String
                    let polyline: Polyline
                    let startLocation: LatLng
                    let endLocation: LatLng
                    let navigationInstruction: NavigationInstruction
                    let localizedValues: LocalizedValues
                    let travelMode: String

                    struct NavigationInstruction: Codable {
                        let maneuver: String
                        let instructions: String
                    }

                    struct LocalizedValues: Codable {
                        let distance: TextValue
                        let staticDuration: TextValue

                        struct TextValue: Codable {
                            let text: String
                        }
                    }
                }
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
            let latitude: Double
            let longitude: Double
        }
        
        enum CodingKeys: String, CodingKey {
            case routes
            case distanceMeters
            case duration
            case staticDuration
            case polyline
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        origin = try container.decode(Location.self, forKey: .origin)
        destination = try container.decode(Location.self, forKey: .destination)
        distance = try container.decode(Int.self, forKey: .distance)
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
