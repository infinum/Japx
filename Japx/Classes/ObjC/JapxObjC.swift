//
//  JapxObjC.swift
//  Japx
//
//  Created by Nikola Majcen on 29/01/2019.
//

import Foundation
#if canImport(JapxCore)
import JapxCore
#endif

/// ObjC bride for `Japx.Decoder.Options`
@objcMembers
@objc(JAPXDecodingOptions)
public class _JAPXOBjCDecodingOptions: NSObject {
    
    // MARK: - Private options reference
    
    fileprivate var options: Japx.Decoder.Options = .default
    
    // MARK: - Propery forwarding
    
    /// ObjC bridge for [`Japx.Decoder.Options.parseNotIncludedRelationships`](x-source-tag://parseNotIncludedRelationships)
    public var parseNotIncludedRelationships: Bool {
        get { options.parseNotIncludedRelationships }
        set { options.parseNotIncludedRelationships = newValue }
    }
}

/// ObjC bride for `Japx.Encoder.Options`
@objcMembers
@objc(JAPXEncodingOptions)
public class _JAPXOBjCEncodingOptions: NSObject {
    
    // MARK: - Private options reference
    
    fileprivate var options: Japx.Encoder.Options = .default
    
    // MARK: - Propery forwarding
    
    /// ObjC bridge for [`Japx.Encoder.Options.includeMetaToCommonNamespce`](x-source-tag://includeMetaToCommonNamespce)
    public var includeMetaToCommonNamespce: Bool {
        get { options.includeMetaToCommonNamespce }
        set { options.includeMetaToCommonNamespce = newValue }
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
    public static func jsonObject(withJSONAPIObject object: Parameters, includeList: String?, options: _JAPXOBjCDecodingOptions) throws -> Parameters {
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
    public static func data(withJSONAPIObject object: Parameters, includeList: String?, options: _JAPXOBjCDecodingOptions) throws -> Data {
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
    public static func jsonObject(withData data: Data, includeList: String?, options: _JAPXOBjCDecodingOptions) throws -> Parameters {
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
    public static func data(withData data: Data, includeList: String?, options: _JAPXOBjCDecodingOptions) throws -> Data {
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
    /// - parameter options:           The options specifying how `JAPXEncoder` should encode JSON into JSON:API.
    ///
    /// - returns: JSON:API object.
    public static func encode(data: Data, additionalParams: Parameters?, options: _JAPXOBjCEncodingOptions) throws -> Parameters {
        do {
            return try Japx.Encoder.encode(data: data, additionalParams: additionalParams, options: options.options)
        } catch {
            throw NSError(error: error)
        }
    }

    /// Converts simple flat JSON object to JSON:API object.
    ///
    /// - parameter json:              JSON object.
    /// - parameter additionalParams:  Additional [String: Any] to add with `data` to JSON:API object.
    /// - parameter options:           The options specifying how `JAPXEncoder` should encode JSON into JSON:API.
    ///
    /// - returns: JSON:API object.
    public static func encode(jsonParameter: Parameters, additionalParams: Parameters?, options: _JAPXOBjCEncodingOptions) throws -> Parameters {
        do {
            return try Japx.Encoder.encode(json: jsonParameter, additionalParams: additionalParams, options: options.options)
        } catch {
            throw NSError(error: error)
        }
    }

    /// Converts simple flat JSON object to JSON:API object.
    ///
    /// - parameter json:              JSON objects represented as Array.
    /// - parameter additionalParams:  Additional [String: Any] to add with `data` to JSON:API object.
    /// - parameter options:           The options specifying how `JAPXEncoder` should encode JSON into JSON:API.
    ///
    /// - returns: JSON:API object.
    public static func encode(jsonParameters: [Parameters], additionalParams: Parameters?, options: _JAPXOBjCEncodingOptions) throws -> Parameters {
        do {
            return try Japx.Encoder.encode(json: jsonParameters, additionalParams: additionalParams, options: options.options)
        } catch {
            throw NSError(error: error)
        }
    }
}
