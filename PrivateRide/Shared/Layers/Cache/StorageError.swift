//
//  StorageError.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import Foundation

public enum StorageError: Error {
    case notFound
    case cantWrite(Error)
    case cantDelete(StorageKey)
}
