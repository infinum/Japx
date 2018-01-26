//
//  JsonApiParser.swift
//  JsonApiParser
//
//  Created by Vlaho Poluta on 15/01/2018.
//  Copyright © 2018 Vlaho Poluta. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public enum JSONAPIParserError: Error {
    case cantProcess(data: Any)
    case notString(data: Any, value: Any?)
    case notDictionary(data: Any, value: Any?)
    case notFoundTypeOrId(data: Any)
    case relationshipNotFound(data: Any)
    case unableToConvertNSDictionaryToParams(data: Any)
    case unableToConvertDataToJson(data: Any)
}

private struct Consts {
    
    struct APIKeys {
        static let data = "data"
        static let id = "id"
        static let type = "type"
        static let included = "included"
        static let relationships = "relationships"
        static let attributes = "attributes"
    }
    
    struct General {
        static let dictCapacity = 20
    }
}

private struct TypeIdPair {
    let type: String
    let id: String
}

public struct JSONAPIParser {
    public enum Decoder {}
    public enum Encoder {}
}

// MARK: - Public interface -

// MARK: - Decoding

public extension JSONAPIParser.Decoder {
    
    static func jsonObject(withJSONAPIObject object: Parameters, includeList: String? = nil) throws -> Parameters {
        // First check if JSON API object has `include` list since
        // parsing objects with include list is done using native
        // Swift dictionary, while objects without it use `NSDictionary`
        let decoded: Any
        if let includeList = includeList {
            decoded = try decode(jsonApiInput: object, include: includeList)
        } else {
            decoded = try decode(jsonApiInput: object as NSDictionary)
        }
        if let decodedProperties = decoded as? Parameters {
            return decodedProperties
        }
        throw JSONAPIParserError.unableToConvertNSDictionaryToParams(data: decoded)
    }
    
    static func data(withJSONAPIObject object: Parameters, includeList: String? = nil) throws -> Data {
        let decoded = try jsonObject(withJSONAPIObject: object, includeList: includeList)
        return try JSONSerialization.data(withJSONObject: decoded, options: .init(rawValue: 0))
    }
    
    static func jsonObject(with data: Data, includeList: String? = nil) throws -> Parameters {
        let jsonApiObject = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
        
        // With include list
        if let includeList = includeList {
            guard let json = jsonApiObject as? Parameters else {
                throw JSONAPIParserError.unableToConvertDataToJson(data: data)
            }
            return try decode(jsonApiInput: json, include: includeList)
        }
        
        // Without include list
        guard let json = jsonApiObject as? NSDictionary else {
            throw JSONAPIParserError.unableToConvertDataToJson(data: data)
        }
        let decoded = try decode(jsonApiInput: json as NSDictionary)
        
        if let decodedProperties = decoded as? Parameters {
            return decodedProperties
        }
        throw JSONAPIParserError.unableToConvertNSDictionaryToParams(data: decoded)
    }
    
    static func data(with data: Data, includeList: String? = nil) throws -> Data {
        let decoded = try jsonObject(with: data, includeList: includeList)
        return try JSONSerialization.data(withJSONObject: decoded, options: .init(rawValue: 0))
    }
}

// MARK: - Encoding

public extension JSONAPIParser.Encoder {
    
    static func encode(data: Data, additionalParams: Parameters? = nil) throws -> Parameters {
        let json = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
        if let jsonObject = json as? Parameters {
            return try encode(json: jsonObject, additionalParams: additionalParams)
        }
        if let jsonArray = json as? [Parameters] {
            return try encode(json: jsonArray, additionalParams: additionalParams)
        }
        throw JSONAPIParserError.unableToConvertDataToJson(data: json)
    }
    
    static func encode(json: Parameters, additionalParams: Parameters? = nil) throws -> Parameters {
        var params = additionalParams ?? [:]
        params[Consts.APIKeys.data] = try encodeAttributesAndRelationships(on: json)
        return params
    }
    
    static func encode(json: [Parameters], additionalParams: Parameters? = nil) throws -> Parameters {
        var params = additionalParams ?? [:]
        params[Consts.APIKeys.data] = try json.flatMap { try encodeAttributesAndRelationships(on: $0) as AnyObject }
        return params
    }
}

// MATK: - Private extensions -

// MARK: - Decoding

private extension JSONAPIParser.Decoder {
    
    static func decode(jsonApiInput: Parameters, include: String) throws -> Parameters {
        let params = include
            .split(separator: ",")
            .map { $0.split(separator: ".") }
        
        let paramsDict = NSMutableDictionary(capacity: Consts.General.dictCapacity)
        for lineArray in params {
            var dict: NSMutableDictionary = paramsDict
            for param in lineArray {
                if let newDict = dict[param] as? NSMutableDictionary {
                    dict = newDict
                } else {
                    let newDict = NSMutableDictionary(capacity: Consts.General.dictCapacity)
                    dict.setObject(newDict, forKey: param as NSCopying)
                    dict = newDict
                }
            }
        }
        
        let dataObjectsArray = try jsonApiInput.array(from: Consts.APIKeys.data) ?? []
        let includedObjectsArray = (try? jsonApiInput.array(from: Consts.APIKeys.included) ?? []) ?? []
        let allObjectsArray = dataObjectsArray + includedObjectsArray
        let allObjects = try allObjectsArray.reduce(into: [TypeIdPair: Parameters]()) { (result, object) in
            result[try object.extractTypeIdPair()] = object
        }
        
        let objects = try dataObjectsArray.map { (dataObject) -> Parameters in
            return try resolve(object: dataObject, allObjects: allObjects, paramsDict: paramsDict)
        }
        
        var jsonApi = jsonApiInput
        let isObject = jsonApiInput[Consts.APIKeys.data].map { $0 is Parameters } ?? false
        jsonApi[Consts.APIKeys.data] = (objects.count == 1 && isObject) ? objects[0] : objects
        jsonApi.removeValue(forKey: Consts.APIKeys.included)
        return jsonApi
    }
    
    static func decode(jsonApiInput: NSDictionary) throws -> NSDictionary {
        let jsonApi = jsonApiInput.mutable
        
        let dataObjectsArray = try jsonApi.array(from: Consts.APIKeys.data) ?? []
        let includedObjectsArray = (try? jsonApi.array(from: Consts.APIKeys.included) ?? []) ?? []
        
        var dataObjects = [TypeIdPair]()
        var objects = [TypeIdPair: NSMutableDictionary]()
        dataObjects.reserveCapacity(dataObjectsArray.count)
        objects.reserveCapacity(dataObjectsArray.count + includedObjectsArray.count)
        
        for dic in dataObjectsArray {
            let typeId = try dic.extractTypeIdPair()
            dataObjects.append(typeId)
            objects[typeId] = dic.mutable
        }
        for dic in includedObjectsArray {
            let typeId = try dic.extractTypeIdPair()
            objects[typeId] = dic.mutable
        }
        
        try resolveAttributes(from: objects)
        try resolveRelationships(from: objects)
        
        jsonApi.setObject(dataObjects.map { objects[$0]! }, forKey: Consts.APIKeys.data as NSCopying)
        jsonApi.removeObject(forKey: Consts.APIKeys.included)
        return jsonApi
    }
}

// MARK: - Decoding helper functions

private extension JSONAPIParser.Decoder {
 
    private static func resolve(object: Parameters, allObjects: [TypeIdPair: Parameters], paramsDict: NSDictionary) throws -> Parameters {
        var attributes = (try? object.dictionary(for: Consts.APIKeys.attributes)) ?? Parameters()
        attributes[Consts.APIKeys.type] = object[Consts.APIKeys.type]
        attributes[Consts.APIKeys.id] = object[Consts.APIKeys.id]
        
        let relationshipsReferences = object.asDictionary(from: Consts.APIKeys.relationships) ?? Parameters()
        
        let relationships = try paramsDict.allKeys.map({ $0 as! String }).reduce(into: Parameters(), { (result, relationshipsKey) in
            guard let relationship = relationshipsReferences.asDictionary(from: relationshipsKey) else { return }
            guard let otherObjectsData = try relationship.array(from: Consts.APIKeys.data) else {
                result[relationshipsKey] = NSNull()
                return
            }
            let otherObjects = try otherObjectsData
                .map { try $0.extractTypeIdPair() }
                .flatMap { allObjects[$0] }
                .map {  try resolve(object: $0,
                                    allObjects: allObjects,
                                    paramsDict: try paramsDict.dictionary(for: relationshipsKey)) }
            if otherObjects.isEmpty { return }
            let isObject = relationship[Consts.APIKeys.data].map { $0 is Parameters } ?? false
            result[relationshipsKey] = (isObject && otherObjects.count == 1) ? otherObjects[0] : otherObjects
        })
        
        return attributes.merging(relationships) { $1 }
    }
    
    static func resolveAttributes(from objects: [TypeIdPair: NSMutableDictionary]) throws {
        objects.values.forEach { (object) in
            let attributes = try? object.dictionary(for: Consts.APIKeys.attributes)
            attributes?.forEach { object[$0] = $1 }
            object.removeObject(forKey: Consts.APIKeys.attributes)
        }
    }
    
    static func resolveRelationships(from objects: [TypeIdPair: NSMutableDictionary]) throws {
        try objects.values.forEach { (object) in
            
            try object.dictionary(for: Consts.APIKeys.relationships, defaultDict: NSDictionary()).forEach { (relationship) in
                
                guard let relationshipParams = relationship.value as? NSDictionary else {
                    throw JSONAPIParserError.relationshipNotFound(data: relationship)
                }
                
                // Extract type-id pair from single object / array
                guard let others = try relationshipParams.array(from: Consts.APIKeys.data) else {
                    object.setObject(NSNull(), forKey: relationship.key as! NSCopying)
                    return
                }
                
                // Fetch those object from `objects`
                let othersObjects = try others
                    .map { try $0.extractTypeIdPair() }
                    .flatMap { objects[$0] }
                
                // Store relationships
                let isObject = relationshipParams
                    .object(forKey: Consts.APIKeys.data)
                    .map { $0 is NSDictionary } ?? false
                
                if others.count == 1 && isObject {
                    object.setObject(othersObjects.first as Any, forKey: relationship.key as! NSCopying)
                } else {
                    object.setObject(othersObjects, forKey: relationship.key as! NSCopying)
                }
            }
            object.removeObject(forKey: Consts.APIKeys.relationships)
        }
    }
}

// MARK: - Encoding

private extension JSONAPIParser.Encoder {
    
    static func encodeAttributesAndRelationships(on jsonObject: Parameters) throws -> Parameters {
        var object = jsonObject
        var attributes = Parameters()
        var relationships = Parameters()
        let objectKeys = object.keys
        
        for key in objectKeys where key != Consts.APIKeys.type && key != Consts.APIKeys.id {
            if let array = object.asArray(from: key) {
                let isArrayOfRelationships = array.first?.containsTypeAndId() ?? false
                if !isArrayOfRelationships {
                    // Handle attributes array
                    attributes[key] = array
                    object.removeValue(forKey: key)
                    continue
                }
                let dataArray = try array.map { try $0.asDataWithTypeAndId() }
                // Handle relationships array
                relationships[key] = [Consts.APIKeys.data: dataArray]
                object.removeValue(forKey: key)
                continue
            }
            if let obj = object.asDictionary(from: key) {
                if !obj.containsTypeAndId() {
                    // Handle attributes object
                    attributes[key] = obj
                    object.removeValue(forKey: key)
                    continue
                }
                let dataObj = try obj.asDataWithTypeAndId()
                // Handle relationship object
                relationships[key] = [Consts.APIKeys.data: dataObj]
                object.removeValue(forKey: key)
                continue
            }
            attributes[key] = object[key]
            object.removeValue(forKey: key)
        }
        object[Consts.APIKeys.attributes] = attributes
        object[Consts.APIKeys.relationships] = relationships
        return object
    }
}

// MARK: - General helper extensions -

extension TypeIdPair: Hashable, Equatable {
    
    var hashValue: Int {
        return (type + id).hashValue
    }
    
    static func == (lhs: TypeIdPair, rhs: TypeIdPair) -> Bool {
        return lhs.type == rhs.type && lhs.id == rhs.id
    }
}

private extension Dictionary where Key == String {
    
    func containsTypeAndId() -> Bool {
        return keys.contains(Consts.APIKeys.type) && keys.contains(Consts.APIKeys.id)
    }
    
    func asDataWithTypeAndId() throws -> Parameters {
        guard let type = self[Consts.APIKeys.type], let id = self[Consts.APIKeys.id] else {
            throw JSONAPIParserError.notFoundTypeOrId(data: self)
        }
        return [Consts.APIKeys.type: type, Consts.APIKeys.id: id]
    }
    
    func extractTypeIdPair() throws -> TypeIdPair {
        if let id = self[Consts.APIKeys.id] as? String, let type = self[Consts.APIKeys.type] as? String {
            return TypeIdPair(type: type, id: id)
        }
        throw JSONAPIParserError.notFoundTypeOrId(data: self)
    }
    
    func asDictionary(from key: String) -> Parameters? {
        return self[key] as? Parameters
    }
    
    func dictionary(for key: String) throws -> Parameters {
        if let value = self[key] as? Parameters {
            return value
        }
        throw JSONAPIParserError.notDictionary(data: self, value: self[key])
    }
    
    func asArray(from key: String) -> [Parameters]? {
        return self[key] as? [Parameters]
    }
    
    func array(from key: String) throws -> [Parameters]? {
        let value = self[key]
        if let array = value as? [Parameters] {
            return array
        }
        if let dict = value as? Parameters {
            return [dict]
        }
        if value == nil || value is NSNull {
            return nil
        }
        throw JSONAPIParserError.cantProcess(data: self)
    }
}

private extension NSDictionary {
    
    var mutable: NSMutableDictionary {
        return self as? NSMutableDictionary ?? self.mutableCopy() as! NSMutableDictionary
    }
    
    func extractTypeIdPair() throws -> TypeIdPair {
        if let id = self.object(forKey: Consts.APIKeys.id) as? String, let type = self.object(forKey: Consts.APIKeys.type) as? String {
            return TypeIdPair(type: type, id: id)
        }
        throw JSONAPIParserError.notFoundTypeOrId(data: self)
    }
    
    func dictionary(for key: String, defaultDict: NSDictionary) -> NSDictionary {
        return (self.object(forKey: key) as? NSDictionary) ?? defaultDict
    }
    
    func dictionary(for key: String) throws -> NSDictionary {
        if let value = self.object(forKey: key) as? NSDictionary {
            return value
        }
        throw JSONAPIParserError.notDictionary(data: self, value: self[key])
    }
    
    func array(from key: String) throws -> [NSDictionary]? {
        let value = self.object(forKey: key)
        if let array = value as? [NSDictionary] {
            return array
        }
        if let dict = value as? NSDictionary {
            return [dict]
        }
        if value == nil || value is NSNull {
            return nil
        }
        throw JSONAPIParserError.cantProcess(data: self)
    }
}
