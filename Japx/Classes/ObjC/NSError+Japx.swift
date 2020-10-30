//
//  NSError+Japx.swift
//  Japx
//
//  Created by Nikola Majcen on 29/01/2019.
//

import Foundation
#if canImport(JapxCore)
import JapxCore
#endif

fileprivate enum JapxErrorCode: Int {
    /// - Returned when provided error is not an JapxError
    case undefined = 1000
    /// - Returned when `data` is not [String: Any] or [[String: Any]]
    case cantProcess = 1001
    /// - Returned when `value` in `data` is not [String: Any], when it should be [String: Any]
    case notDictionary = 1002
    /// - Returned when `type` or `id` are not found in `data`, when they were both supposed to be present.
    case notFoundTypeOrId = 1003
    /// - Returned when `relationship` isn't [String: Any], it should be [String: Any]
    case relationshipNotFound = 1004
    /// - Returned when conversion from NSDictionary to [String: Any] is unsuccessful.
    case unableToConvertNSDictionaryToParams = 1005
    /// - Returned when conversion from Data to [String: Any] is unsuccessful.
    case unableToConvertDataToJson = 1006
}

extension JapxError: CustomNSError {

    public static let errorDomain: String = "co.infinum.japx"

    public var errorCode: Int {
        let code: JapxErrorCode
        switch self {
        case .cantProcess:
            code = .cantProcess
        case .notDictionary:
            code = .notDictionary
        case .notFoundTypeOrId:
            code = .notFoundTypeOrId
        case .relationshipNotFound:
            code = .relationshipNotFound
        case .unableToConvertNSDictionaryToParams:
            code = .unableToConvertNSDictionaryToParams
        case .unableToConvertDataToJson:
            code = .unableToConvertDataToJson
        }
        return code.rawValue
    }

    public var errorUserInfo: [String : Any] {
        let userInfo: Any
        switch self {
        case .cantProcess(data: let data):
            userInfo = data
        case .notDictionary(data: let data, value: _):
            userInfo = data
        case .notFoundTypeOrId(data: let data):
            userInfo = data
        case .relationshipNotFound(data: let data):
            userInfo = data
        case .unableToConvertNSDictionaryToParams(data: let data):
            userInfo = data
        case .unableToConvertDataToJson(data: let data):
            userInfo = data
        }
        return ["data": userInfo]
    }
}

extension NSError {

    convenience init(error: Error) {
        guard let error = error as? JapxError else {
            self.init(domain: JapxError.errorDomain, code: JapxErrorCode.undefined.rawValue, userInfo: nil)
            return
        }
        self.init(domain: JapxError.errorDomain, code: error.errorCode, userInfo: error.errorUserInfo)
    }
}

