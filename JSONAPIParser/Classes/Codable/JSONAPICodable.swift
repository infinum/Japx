//
//  JSONAPICodable.swift
//  JSONAPIParser
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Foundation

/// Protocol that extends Decodable with required properties for JSON:API objects
public protocol JSONAPIDecodable: Decodable {
    var type: String { get }
    var id: String { get }
}

/// Protocol that extends Encodable with required properties for JSON:API objects
public protocol JSONAPIEncodable: Encodable {
    var type: String { get }
}

typealias JSONAPICodable = JSONAPIDecodable & JSONAPIEncodable

/// Wrapper around JSONEncoder capable of encoding normal objects into JSON:API dictionaries
public final class JSONAPIEncoder {
    
    // Underlaying JSONEncoder, can be used to add date formats, ...
    public let jsonEncoder: JSONEncoder
    
    /// Initializes `self` with underlaying `JSONEncoder` instance
    public init(jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.jsonEncoder = jsonEncoder
    }
    
    /// Encodes the given top-level value and returns its JSON:API representation.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `[String: Any]` value containing the encoded JSON:API data.
    /// - throws: An error if any value throws an error during encoding.
    public func encode<T>(_ value: T) throws -> Parameters where T : JSONAPIEncodable {
        let data = try jsonEncoder.encode(value)
        return try JSONAPIParser.Encoder.encode(data: data)
    }
}

/// Wrapper around JSONDecoder capable of decoding JSON:API objects into normal objects
public final class JSONAPIDecoder {
    
    /// Underlaying JSONDecoder, can be used to add date formats, ...
    public let jsonDecoder: JSONDecoder
    
    /// Initializes `self` with underlaying `JSONDecoder` instance
    public init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
    }
    
    /// Decodes a top-level value of the given type from the given JSON:API representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter json: The JSON:API dictionary to decode from.
    /// - returns: A value of the requested type.
    /// - throws: An error if any value throws an error during decoding.
    public func decode<T>(_ type: T.Type, from json: Parameters, includeList: String? = nil) throws -> T where T : JSONAPIDecodable {
        let data = try JSONAPIParser.Decoder.data(withJSONAPIObject: json, includeList: includeList)
        return try jsonDecoder.decode(type, from: data)
    }
    
    /// Decodes a top-level value of the given type from the given JSON:API representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The JSON:API formated data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: An error if any value throws an error during decoding.
    public func decode<T>(_ type: T.Type, from data: Data, includeList: String? = nil) throws -> T where T : JSONAPIDecodable {
        let data = try JSONAPIParser.Decoder.data(with: data, includeList: includeList)
        return try jsonDecoder.decode(type, from: data)
    }
}
