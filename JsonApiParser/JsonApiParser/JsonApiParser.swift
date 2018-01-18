//
//  JsonApiParser.swift
//  JsonApiParser
//
//  Created by Vlaho Poluta on 15/01/2018.
//  Copyright © 2018 Vlaho Poluta. All rights reserved.
//

import UIKit

typealias Parameters = [String: Any]

enum JsonApiUnboxError: Error {
    case cantProcess(data: Any)
    case notString(data: Any, value: Any?)
    case notDictionary(data: Any, value: Any?)
    case notFoundTypeOrId(data: Any)
    case relationshipNotFound(data: Any)
    case unableToConvertNSDictionaryToParams(data: Any)
    case unableToConvertDataToJson(data: Any)
}

fileprivate struct Consts {
    static let data = "data"
    static let id = "id"
    static let type = "type"
    static let included = "included"
    static let relationships = "relationships"
    static let attributes = "attributes"
}

fileprivate struct TypeIdPair {
    let type: String
    let id: String
}

struct JsonApiParser {}

//MARK: - Unbox -

extension JsonApiParser {
    
    static func jsonObject(withJSONObject object: Parameters, includeList: String? = nil) throws -> Parameters {
        //with include list
        if let includeList = includeList {
            return try unbox(jsonApiInput: object, include: includeList)
        }
        // without include list
        let unboxed = try unbox(jsonApiInput: object as NSDictionary)
        
        if  let unboxedProperties = unboxed as? Parameters {
            return unboxedProperties
        }
        throw JsonApiUnboxError.unableToConvertNSDictionaryToParams(data: unboxed)
        
    }

    static func data(withJSONObject object: Parameters, includeList: String? = nil) throws -> Data {
        //with include list
        if let includeList = includeList {
            let unboxed = try unbox(jsonApiInput: object, include: includeList)
            return try JSONSerialization.data(withJSONObject: unboxed, options: .init(rawValue: 0))
        }
        // without include list
        let unboxed = try unbox(jsonApiInput: object as NSDictionary)
        return try JSONSerialization.data(withJSONObject: unboxed, options: .init(rawValue: 0))
    }
    
    static func jsonObject(with data: Data, includeList: String? = nil) throws -> Parameters {
        //with include list
        if let includeList = includeList {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as? Parameters else {
                throw JsonApiUnboxError.unableToConvertDataToJson(data: data)
            }
            return try unbox(jsonApiInput: json, include: includeList)
        }
        // without include list
        guard let json = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as? NSDictionary else {
            throw JsonApiUnboxError.unableToConvertDataToJson(data: data)
        }
        let unboxed = try unbox(jsonApiInput: json as NSDictionary)
        
        if  let unboxedProperties = unboxed as? Parameters {
            return unboxedProperties
        }
        throw JsonApiUnboxError.unableToConvertNSDictionaryToParams(data: unboxed)
    }

    static func data(with data: Data, includeList: String? = nil) throws -> Data {
        //with include list
        if let includeList = includeList {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as? Parameters else {
                throw JsonApiUnboxError.unableToConvertDataToJson(data: data)
            }
            let unboxed = try unbox(jsonApiInput: json, include: includeList)
            return try JSONSerialization.data(withJSONObject: unboxed, options: .init(rawValue: 0))
        }
        // without include list
        guard let json = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as? NSDictionary else {
            throw JsonApiUnboxError.unableToConvertDataToJson(data: data)
        }
        let unboxed = try unbox(jsonApiInput: json)
        return try JSONSerialization.data(withJSONObject: unboxed, options: .init(rawValue: 0))
    }
    
}

//MARK: Unbox main functions

private extension JsonApiParser {
    
    static func unbox(jsonApiInput: Parameters, include: String) throws -> Parameters {
        
        let params = include
            .split(separator: ",")
            .map { $0.split(separator: ".") }
        
        let paramsDict = NSMutableDictionary(capacity: 20)
        for lineArray in params {
            var dict: NSMutableDictionary = paramsDict
            for param in lineArray {
                if let newDict = dict[param] as? NSMutableDictionary {
                    dict = newDict
                } else {
                    let newDict = NSMutableDictionary(capacity: 20)
                    dict.setObject(newDict, forKey: param as NSCopying)
                    dict = newDict
                }
            }
        }
        
        let dataObjectsArray = try jsonApiInput.array(from: Consts.data) ?? []
        let includedObjectsArray = (try? jsonApiInput.array(from: Consts.included) ?? []) ?? []
        let allObjectsArray = dataObjectsArray + includedObjectsArray
        let allObjects = try allObjectsArray.reduce(into: [TypeIdPair: Parameters]()) { (result, object) in
            result[try object.extractTypeIdPair()] = object
        }
        
        let objects = try dataObjectsArray.map { (dataObject) -> Parameters in
            return try resolve(object: dataObject, allObjects: allObjects, paramsDict: paramsDict)
        }
        
        var jsonApi = jsonApiInput
        let isObject = jsonApiInput[Consts.data].map { $0 is Parameters } ?? false
        jsonApi[Consts.data] = (objects.count == 1 && isObject) ? objects[0] : objects
        jsonApi.removeValue(forKey: Consts.included)
        return jsonApi
    }
    
    
    static func unbox(jsonApiInput: NSDictionary) throws -> NSDictionary {
        let jsonApi = jsonApiInput.mutable
        
        let dataObjectsArray = try jsonApi.array(from: Consts.data) ?? []
        let includedObjectsArray = (try? jsonApi.array(from: Consts.included) ?? []) ?? []
        
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
        
        jsonApi.setObject(dataObjects.map { objects[$0]! }, forKey: Consts.data as NSCopying)
        jsonApi.removeObject(forKey: Consts.included)
        return jsonApi
    }
    
}

//MARK: Unbox extra functions

private extension JsonApiParser {
 
    private static func resolve(object: Parameters, allObjects: [TypeIdPair: Parameters], paramsDict: NSDictionary) throws -> Parameters {
        
        var attributes = (try? object.dictionary(for: Consts.attributes)) ?? Parameters()
        attributes[Consts.type] = object[Consts.type]
        attributes[Consts.id] = object[Consts.id]
        
        let relationshipsReferences = object.asDictionaty(from: Consts.relationships) ?? Parameters()
        
        let relationships = try paramsDict.allKeys.map({ $0 as! String }).reduce(into: Parameters(), { (result, relationshipsKey) in
            guard let relationship = relationshipsReferences.asDictionaty(from: relationshipsKey) else { return }
            guard let otherObjectsData = try relationship.array(from: Consts.data) else {
                result[relationshipsKey] = NSNull()
                return
            }
            let otherObjects = try otherObjectsData
                .map { try $0.extractTypeIdPair() }
                .flatMap { allObjects[$0] }
                .map {  try resolve(object: $0, allObjects: allObjects, paramsDict: try paramsDict.dictionary(for: relationshipsKey)) }
            
            
            if otherObjects.isEmpty { return }
            let isObject = relationship[Consts.data].map { $0 is Parameters } ?? false
            result[relationshipsKey] = (isObject && otherObjects.count == 1) ? otherObjects[0] : otherObjects
        })
        
        return attributes.merging(relationships) { $1 }
    }
    
}

private extension JsonApiParser {
    
    static func resolveAttributes(from objects: [TypeIdPair: NSMutableDictionary]) throws {
        
        objects.values.forEach { (object) in
            let attributes = try? object.dictionary(for: Consts.attributes)
            attributes?.forEach { object[$0] = $1 }
            object.removeObject(forKey: Consts.attributes)
        }
        
    }
    
    static func resolveRelationships(from objects: [TypeIdPair: NSMutableDictionary]) throws {
        
        try objects.values.forEach { (object) in
            
            try object.dictionary(for: Consts.relationships, defaultDict: NSDictionary()).forEach { (relationship) in
                
                guard let relationshipParams = relationship.value as? NSDictionary else {
                    throw JsonApiUnboxError.relationshipNotFound(data: relationship)
                }
                
                //Extract typy id from single object / array
                guard let others = try relationshipParams.array(from: Consts.data) else {
                    object.setObject(NSNull(), forKey: relationship.key as! NSCopying)
                    return
                }
                
                //Fetch those object from `objects`
                let othersObjects = try others.map { try $0.extractTypeIdPair() }
                    .flatMap { objects[$0] }
                
                //Store reloationships
                let isObject = relationshipParams.object(forKey: Consts.data).map { $0 is NSDictionary } ?? false
                
                if others.count == 1 && isObject {
                    object.setObject(othersObjects.first as Any, forKey: relationship.key as! NSCopying)
                } else {
                    object.setObject(othersObjects, forKey: relationship.key as! NSCopying)
                }
                
            }
            
            object.removeObject(forKey: Consts.relationships)
        }
    }
    
}

//MARK: - Wrap -

extension JsonApiParser {
    
    static func wrap(json: Parameters) throws -> Parameters {
        return try [Consts.data: wrapAttributesAndReloationships(on: json)]
    }
    
    static func wrap(json: [Parameters]) throws -> Parameters {
        return try [
            Consts.data: json.flatMap { try wrapAttributesAndReloationships(on: $0) }
        ]
    }
    
}

private extension JsonApiParser {
    
    static func wrapAttributesAndReloationships(on jsonObject: Parameters) throws -> Parameters {
        var object = jsonObject
        
        var attributes = Parameters()
        var relationships = Parameters()
        
        let objectKeys = object.keys
        for key in objectKeys where key != Consts.type && key != Consts.id {
            
            if let array = object.asArray(from: key) {
                let isArrayOfRelationships = array.first?.containsTypeAndId() ?? false
                if !isArrayOfRelationships {
                    //Handle attribures array
                    attributes[key] = array
                    continue
                }
                let dataArray = try array.map { try $0.asDataWithTypeAndId() }
                //handle reloationship array
                relationships[key] = [Consts.data: dataArray]
                continue
            }
            
            if let obj = object.asDictionaty(from: key) {
                if !obj.containsTypeAndId() {
                    //Handle attributes object
                    attributes[key] = obj
                    continue
                }
                let dataObj = try obj.asDataWithTypeAndId()
                //Handle reloationship object
                relationships[key] = [Consts.data: dataObj]
                continue
            }
            
            attributes[key] = object[key]
        }
        
        object[Consts.attributes] = attributes
        object[Consts.relationships] = relationships
        
        return object
    }
    
}

//MARK: - Helper extensions -

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
        return keys.contains(Consts.type) && keys.contains(Consts.id)
    }
    
    func asDataWithTypeAndId() throws -> Parameters {
        guard let type = self[Consts.type], let id = self[Consts.id] else {
            throw JsonApiUnboxError.notFoundTypeOrId(data: self)
        }
        return [Consts.type: type, Consts.id: id]
    }
    
    func extractTypeIdPair() throws -> TypeIdPair {
        if let id = self[Consts.id] as? String, let type = self[Consts.type] as? String {
            return TypeIdPair(type: type, id: id)
        }
        throw JsonApiUnboxError.notFoundTypeOrId(data: self)
    }
    
    func asDictionaty(from key: String) -> Parameters? {
        return self[key] as? Parameters
    }
    
    func dictionary(for key: String) throws -> Parameters {
        if let value = self[key] as? Parameters {
            return value
        }
        throw JsonApiUnboxError.notDictionary(data: self, value: self[key])
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
        throw JsonApiUnboxError.cantProcess(data: self)
    }
    
}

private extension NSDictionary {
    
    var mutable: NSMutableDictionary {
        return self as? NSMutableDictionary ?? self.mutableCopy() as! NSMutableDictionary
    }
    
    func extractTypeIdPair() throws -> TypeIdPair {
        if let id = self.object(forKey: Consts.id) as? String, let type = self.object(forKey: Consts.type) as? String {
            return TypeIdPair(type: type, id: id)
        }
        throw JsonApiUnboxError.notFoundTypeOrId(data: self)
    }
    
    func dictionary(for key: String, defaultDict: NSDictionary) -> NSDictionary {
        return (self.object(forKey: key) as? NSDictionary) ?? defaultDict
    }
    
    func dictionary(for key: String) throws -> NSDictionary {
        if let value = self.object(forKey: key) as? NSDictionary {
            return value
        }
        throw JsonApiUnboxError.notDictionary(data: self, value: self[key])
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
        throw JsonApiUnboxError.cantProcess(data: self)
    }
    
}
