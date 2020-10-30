//
//  JapxRxMoya.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Moya
import RxSwift
import Foundation
#if canImport(JapxCore)
import JapxCore
#endif
#if canImport(JapxMoya)
import JapxMoya
#endif

extension ObservableType where Element == Response {

    /// Maps data received from the signal and decodes JSON:API object into requested type. If the conversion fails, the signal errors.
    ///
    /// - parameter failsOnEmptyData: A boolean value determining whether the mapping should fail if the data is empty.
    /// - parameter includeList: The include list for deserializing JSON:API relationships.
    /// - parameter options: The options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    ///
    ///
    /// - returns: `Observable` of JSON:API object.
    public func mapJSONAPI(
        failsOnEmptyData: Bool = true,
        includeList: String? = nil,
        options: Japx.Decoder.Options = .default
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
    /// - parameter options: The options specifying how `Japx.Decoder` should decode JSON:API into JSON.
    ///
    ///
    /// - returns: `Single` of JSON:API object.
    public func mapJSONAPI(
        failsOnEmptyData: Bool = true,
        includeList: String? = nil,
        options: Japx.Decoder.Options = .default
    ) -> Single<Any> {
        return map {
            try $0.mapJSONAPI(failsOnEmptyData: failsOnEmptyData, includeList: includeList)
        }
    }
}
