//
//  JapxObjC.swift
//  Japx
//
//  Created by Nikola Majcen on 29/01/2019.
//

import Foundation

/// ObjC bride for `JapxDecodingOptions`
@objcMembers
public class JAPXDecodingOptions: NSObject {
    
    // MARK: - Private options reference
    
    fileprivate var options: JapxDecodingOptions = .default
    
    // MARK: - Propery forwarding
    
    /// ObjC bridge for [`JAPXDecodingOptions.parseNotIncludedRelationships`](x-source-tag://parseNotIncludedRelationships)
    public var parseNotIncludedRelationships: Bool {
        get { options.parseNotIncludedRelationships }
        set { options.parseNotIncludedRelationships = newValue }
    }
}

@objcMembers
@available(swift, obsoleted: 1.0)
public class JAPXDecoder: NSObject {

    // MARK: - Lifecycle

    private override init() {
        super.init()
    }
    
    // MARK: - Decoding methods

    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter object:            JSON:API object.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           The options specifying how `JAPXDecoder` should decode JSON:API into JSON.
    ///
    /// - returns: JSON object.
    public static func jsonObject(withJSONAPIObject object: Parameters, includeList: String?, options: JAPXDecodingOptions) throws -> Parameters {
        do {
            return try Japx.Decoder.jsonObject(withJSONAPIObject: object, includeList: includeList, options: options.options)
        } catch {
            throw NSError(error: error)
        }
    }

    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter object:            JSON:API object.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           The options specifying how `JAPXDecoder` should decode JSON:API into JSON.
    ///
    /// - returns: JSON object as Data.
    public static func data(withJSONAPIObject object: Parameters, includeList: String?, options: JAPXDecodingOptions) throws -> Data {
        do {
            return try Japx.Decoder.data(withJSONAPIObject: object, includeList: includeList, options: options.options)
        } catch {
            throw NSError(error: error)
        }
    }

    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter data:              JSON:API object as Data.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           The options specifying how `JAPXDecoder` should decode JSON:API into JSON.
    ///
    /// - returns: JSON object.
    public static func jsonObject(withData data: Data, includeList: String?, options: JAPXDecodingOptions) throws -> Parameters {
        do {
            return try Japx.Decoder.jsonObject(with: data, includeList: includeList, options: options.options)
        } catch {
            throw NSError(error: error)
        }
    }

    /// Converts JSON:API object to simple flat JSON object
    ///
    /// - parameter data:              JSON:API object as Data.
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           The options specifying how `JAPXDecoder` should decode JSON:API into JSON.
    ///
    /// - returns: JSON object as Data.
    public static func data(withData data: Data, includeList: String?, options: JAPXDecodingOptions) throws -> Data {
        do {
            return try Japx.Decoder.data(with: data, includeList: includeList, options: options.options)
        } catch {
            throw NSError(error: error)
        }
    }
}

// MARK: - Encoder

/// Defines a list of methods for converting simple JSON objects to JSON:API object.
@objcMembers
@available(swift, obsoleted: 1.0)
public class JAPXEncoder: NSObject {

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
    public static func encode(data: Data, additionalParams: Parameters?) throws -> Parameters {
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
    public static func encode(jsonParameter: Parameters, additionalParams: Parameters?) throws -> Parameters {
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
    public static func encode(jsonParameters: [Parameters], additionalParams: Parameters?) throws -> Parameters {
        do {
            return try Japx.Encoder.encode(json: jsonParameters, additionalParams: additionalParams)
        } catch {
            throw NSError(error: error)
        }
    }
}
