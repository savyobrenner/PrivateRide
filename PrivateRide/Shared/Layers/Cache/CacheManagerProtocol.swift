//
//  CacheManagerProtocol.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation

public protocol CacheManagerProtocol {
    func fetch<T: Codable>(_ type: T.Type, for key: StorageKey) throws -> T
    func fetch<T: Codable>(_ type: T.Type, for key: String) throws -> T
    func save<T: Codable>(_ value: T, for key: StorageKey) throws
    func save<T: Codable>(_ value: T, for key: String) throws
    func remove<T: Codable>(type: T.Type, for key: StorageKey) throws
    func remove<T: Codable>(type: T.Type, for key: String) throws
}
