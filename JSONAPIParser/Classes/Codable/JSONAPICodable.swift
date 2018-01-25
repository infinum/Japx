//
//  JSONAPICodable.swift
//  JSONAPIParser
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Foundation

public protocol JSONAPIDecodable: Decodable {
    var type: String { get }
    var id: String { get }
}

public protocol JSONAPIEncodable: Encodable {
    var type: String { get }
}

typealias JSONAPICodable = JSONAPIDecodable & JSONAPIEncodable


public final class JSONAPIEncoder {
    
    public let jsonEncoder = JSONEncoder()
    
    public init() {}
    
    public func encode<T>(_ value: T) throws -> Parameters where T : JSONAPIEncodable {
        let data = try jsonEncoder.encode(value)
        return try JSONAPIParser.Encoder.encode(data: data)
    }
    
}

public final class JSONAPIDecoder {
    
    public let jsonDecoder = JSONDecoder()
    
    public init() {}
    
    public func decode<T>(_ type: T.Type, from json: Parameters, includeList: String? = nil) throws -> T where T : JSONAPIDecodable {
        let data = try JSONAPIParser.Decoder.data(withJSONAPIObject: json, includeList: includeList)
        return try jsonDecoder.decode(type, from: data)
    }
    
    public func decode<T>(_ type: T.Type, from data: Data, includeList: String? = nil) throws -> T where T : JSONAPIDecodable {
        let data = try JSONAPIParser.Decoder.data(with: data, includeList: includeList)
        return try jsonDecoder.decode(type, from: data)
    }
    
}
