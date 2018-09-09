//
//  JapxRxMoya.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Moya
import RxSwift
import Foundation

extension ObservableType where E == Response {

    /// Maps data received from the signal and decode JSON:API object into requested type. If the conversion fails, the signal errors.
    ///
    /// - parameter failsOnEmptyData: A Boolean value determining whether the mapping should fail if the data is empty.
    /// - parameter includeList: The include list for deserializing JSON:API relationships.
    ///
    ///
    /// - returns: `Observable` of JSON:API object.
    public func mapJSONAPI(failsOnEmptyData: Bool = true, includeList: String? = nil) -> Observable<Any> {
        return map { try $0.mapJSONAPI(failsOnEmptyData: failsOnEmptyData, includeList: includeList) }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {

    /// Maps data received from the signal and decode JSON:API object into requested type. If the conversion fails, the signal errors.
    ///
    /// - parameter failsOnEmptyData: A Boolean value determining whether the mapping should fail if the data is empty.
    /// - parameter includeList: The include list for deserializing JSON:API relationships.
    ///
    ///
    /// - returns: `Single` of JSON:API object.
    public func mapJSONAPI(failsOnEmptyData: Bool = true, includeList: String? = nil) -> Single<Any> {
        return map { try $0.mapJSONAPI(failsOnEmptyData: failsOnEmptyData, includeList: includeList) }
    }
}
