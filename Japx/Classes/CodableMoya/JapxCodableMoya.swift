//
//  JapxCodableMoya.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Moya
import Foundation
#if canImport(JapxCore)
import JapxCore
#endif
#if canImport(JapxCodable)
import JapxCodable
#endif
#if canImport(JapxMoya)
import JapxMoya
#endif

extension Response {
    
    /// Maps data received from the signal and decodes JSON:API object into requested type.
    ///
    /// - parameter includeList: The include list for deserializing JSON:API relationships.
    /// - parameter keyPath:     The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:     The decoder that performs decoding on parsed JSON into requested type.
    ///
    /// - returns: JSON:API object.
    public func mapCodableJSONAPI<T: Decodable>(
        includeList: String? = nil,
        keyPath: String? = nil,
        decoder: JapxDecoder = JapxDecoder()
    ) throws -> T {
        guard data.count > 0 else {
            throw MoyaError.jsonMapping(self)
        }

        do {
            guard let keyPath = keyPath, !keyPath.isEmpty else  {
                let decodable = try decoder.decode(T.self, from: data, includeList: includeList)
                return decodable
            }

            let json = try Japx.Decoder.jsonObject(with: data, includeList: includeList, options: decoder.options)
            guard let jsonForKeyPath = (json as AnyObject).value(forKeyPath: keyPath) else {
                throw JapxMoyaError.invalidKeyPath(keyPath: keyPath)
            }
            let jsonApiData = try JSONSerialization.data(withJSONObject: jsonForKeyPath)

            let decodable = try decoder.jsonDecoder.decode(T.self, from: jsonApiData)
            return decodable

        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
}
