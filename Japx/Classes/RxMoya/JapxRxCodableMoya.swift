//
//  JapxRxCodableMoya.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

#if canImport(Moya) && canImport(RxSwift)

import Foundation
import Moya
import RxSwift

#if !COCOAPODS
import Japx
import JapxMoya
#endif

extension ObservableType where Element == Response {

    /// Maps data received from the signal into a JSON:API object. If the conversion fails, the signal errors.
    ///
    /// - parameter includeList: The include list for deserializing JSON:API relationships.
    /// - parameter keyPath:     The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:     The decoder that performs decoding on parsed JSON into requested type.
    ///
    ///
    /// - returns: `Observable` of JSON:API object.
    public func mapCodableJSONAPI<T: Decodable>(
        includeList: String? = nil,
        keyPath: String? = nil,
        decoder: JapxDecoder = JapxDecoder()
    ) -> Observable<T> {
        return map {
            try $0.mapCodableJSONAPI(includeList: includeList, keyPath: keyPath, decoder: decoder)
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    /// Maps data received from the signal into a JSON:API object. If the conversion fails, the signal errors.
    ///
    /// - parameter includeList: The include list for deserializing JSON:API relationships.
    /// - parameter keyPath:     The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:     The decoder that performs decoding on parsed JSON into requested type.
    ///
    /// - returns: `Single` of JSON:API object.
    public func mapCodableJSONAPI<T: Decodable>(
        includeList: String? = nil,
        keyPath: String? = nil,
        decoder: JapxDecoder = JapxDecoder()
    ) -> Single<T> {
        return map {
            try $0.mapCodableJSONAPI(includeList: includeList, keyPath: keyPath, decoder: decoder)
        }
    }
}

#endif
