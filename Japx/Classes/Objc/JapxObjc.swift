//
//  JapxWrapper.swift
//  Japx
//
//  Created by Nikola Majcen on 29/01/2019.
//

import Foundation

/// `JapxErrorType` is the error type returned by Japx.
public enum JapxErrorType: Int {
    /// - cantProcess(data:): Returned when `data` is not [String: Any] or [[String: Any]]
    case cantProcess
    /// - notDictionary(data:,value:): Returned when `value` in `data` is not [String: Any], when it should be [String: Any]
    case notDictionary
    /// - notFoundTypeOrId(data:): Returned when `type` or `id` are not found in `data`, when they were both supposed to be present.
    case notFoundTypeOrId
    /// - relationshipNotFound(data:): Returned when `relationship` isn't [String: Any], it should be [String: Any]
    case relationshipNotFound
    /// - unableToConvertNSDictionaryToParams(data:): Returned when conversion from NSDictionary to [String: Any] is unsuccessful.
    case unableToConvertNSDictionaryToParams
    /// - unableToConvertDataToJson(data:): Returned when conversion from Data to [String: Any] is unsuccessful.
    case unableToConvertDataToJson
    /// - undefined: Returned when error is not defined as Japx error.
    case undefined
}

@objc public class JAPXDecoder: NSObject {

    // MARK: - Lifecycle

    private override init() {
        super.init()
    }
    
    // MARK: - Decoding methods

    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter object:            JSON:API object.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    ///
    /// - returns: JSON object.
    @objc public static func jsonObject(withJSONAPIObject object: Parameters, includeList: String? = nil) throws -> Parameters {
        do {
            return try Japx.Decoder.jsonObject(withJSONAPIObject: object, includeList: includeList)
        } catch {
            throw NSError(error: error)
        }
    }

    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter object:            JSON:API object.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    ///
    /// - returns: JSON object as Data.
    @objc public static func data(withJSONAPIObject object: Parameters, includeList: String? = nil) throws -> Data {
        do {
            return try Japx.Decoder.data(withJSONAPIObject: object, includeList: includeList)
        } catch {
            throw NSError(error: error)
        }
    }

    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter data:              JSON:API object as Data.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    ///
    /// - returns: JSON object.
    @objc public static func jsonObject(withData data: Data, includeList: String? = nil) throws -> Parameters {
        do {
            return try Japx.Decoder.jsonObject(with: data, includeList: includeList)
        } catch {
            throw NSError(error: error)
        }
    }

    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter data:              JSON:API object as Data.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    ///
    /// - returns: JSON object as Data.
    @objc public static func data(withData data: Data, includeList: String? = nil) throws -> Data {
        do {
            return try Japx.Decoder.data(with: data, includeList: includeList)
        } catch {
            throw NSError(error: error)
        }
    }
}

// MARK: - Encoder

/// Defines a list of methods for converting simple JSON objects to JSON:API object.
@objc public class JAPXEncoder: NSObject {

    // MARK: - Lifecycle

    private override init() {
        super.init()
    }

    // MARK: - Encoding methods

    /// Converts simple flat JSON object to JSON:API object.
    ///
    /// - parameter data:              JSON object as Data.
    /// - parameter additionalParams:  Additional [String: Any] to add with `data` to JSON:API object.
    ///
    /// - returns: JSON:API object.
    @objc public static func encode(data: Data, additionalParams: Parameters? = nil) throws -> Parameters {
        do {
            return try Japx.Encoder.encode(data: data, additionalParams: additionalParams)
        } catch {
            throw NSError(error: error)
        }
    }

    /// Converts simple flat JSON object to JSON:API object.
    ///
    /// - parameter json:              JSON object.
    /// - parameter additionalParams:  Additional [String: Any] to add with `data` to JSON:API object.
    ///
    /// - returns: JSON:API object.
    @objc public static func encode(jsonParameter: Parameters, additionalParams: Parameters? = nil) throws -> Parameters {
        do {
            return try Japx.Encoder.encode(json: jsonParameter, additionalParams: additionalParams)
        } catch {
            throw NSError(error: error)
        }
    }

    /// Converts simple flat JSON object to JSON:API object.
    ///
    /// - parameter json:              JSON objects represented as Array.
    /// - parameter additionalParams:  Additional [String: Any] to add with `data` to JSON:API object.
    ///
    /// - returns: JSON:API object.
    @objc public static func encode(jsonParameters: [Parameters], additionalParams: Parameters? = nil) throws -> Parameters {
        do {
            return try Japx.Encoder.encode(json: jsonParameters, additionalParams: additionalParams)
        } catch {
            throw NSError(error: error)
        }
    }
}
