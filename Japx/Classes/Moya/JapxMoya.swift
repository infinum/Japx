//
//  JapxMoya.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Moya
import Foundation
#if canImport(JapxCore)
import JapxCore
#endif

/// `JapxMoyaError` is the error type returned by JapxMoya subspec.
public enum JapxMoyaError: Error {
    
    /// - invalidKeyPath: Returned when a nested JSON object doesn't exist in parsed JSON:API response by provided `keyPath`.
    case invalidKeyPath(keyPath: String)
}

extension JapxMoyaError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .invalidKeyPath(keyPath: keyPath): return "Nested JSON doesn't exist by keyPath: \(keyPath)."
        }
    }
}

extension Response {
    
    /// Maps data received from the signal into a JSON:API object.
    ///
    /// - parameter includeList: The include list for deserializing JSON:API relationships.
    /// - parameter options: The options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    /// - parameter failsOnEmptyData: A boolean value determining whether the mapping should fail if the data is empty.
    ///
    /// - returns: JSON:API object.
    public func mapJSONAPI(
        failsOnEmptyData: Bool = true,
        includeList: String? = nil,
        options: Japx.Decoder.Options = .default
    ) throws -> Any {
        do {
            return try Japx.Decoder.jsonObject(with: data, includeList: includeList, options: options)
        } catch {
            if data.count < 1 && !failsOnEmptyData {
                return NSNull()
            }
            throw MoyaError.jsonMapping(self)
        }
    }
}
