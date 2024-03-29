//
//  JapxRxMoya.swift
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

    /// Maps data received from the signal and decodes JSON:API object into requested type. If the conversion fails, the signal errors.
    ///
    /// - parameter failsOnEmptyData: A boolean value determining whether the mapping should fail if the data is empty.
    /// - parameter includeList: The include list for deserializing JSON:API relationships.
    /// - parameter options: The options specifying how `JapxKit.Decoder` should decode JSON:API into JSON.
    ///
    ///
    /// - returns: `Observable` of JSON:API object.
    public func mapJSONAPI(
        failsOnEmptyData: Bool = true,
        includeList: String? = nil,
        options: JapxKit.Decoder.Options = .default
    ) -> Observable<Any> {
        return map {
            try $0.mapJSONAPI(failsOnEmptyData: failsOnEmptyData, includeList: includeList)
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    /// Maps data received from the signal and decodes JSON:API object into requested type. If the conversion fails, the signal errors.
    ///
    /// - parameter failsOnEmptyData: A boolean value determining whether the mapping should fail if the data is empty.
    /// - parameter includeList: The include list for deserializing JSON:API relationships.
    /// - parameter options: The options specifying how `JapxKit.Decoder` should decode JSON:API into JSON.
    ///
    ///
    /// - returns: `Single` of JSON:API object.
    public func mapJSONAPI(
        failsOnEmptyData: Bool = true,
        includeList: String? = nil,
        options: JapxKit.Decoder.Options = .default
    ) -> Single<Any> {
        return map {
            try $0.mapJSONAPI(failsOnEmptyData: failsOnEmptyData, includeList: includeList)
        }
    }
}

#endif
