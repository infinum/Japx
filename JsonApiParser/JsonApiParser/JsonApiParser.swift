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

extension TypeIdPair: Hashable, Equatable {
    var hashValue: Int {
        return (type + id).hashValue
    }
    
    static func == (lhs: TypeIdPair, rhs: TypeIdPair) -> Bool {
        return lhs.type == rhs.type && lhs.id == rhs.id
    }
}

struct JsonApiParser {
    
    static func unbox(jsonApiInput: [String: Any]) throws -> NSDictionary {
        let jsonApi = (jsonApiInput as NSDictionary).mutable
        
        let dataObjectsArray = try jsonApi.array(from: Consts.data)
        let includedObjectsArray = (try? jsonApi.array(from: Consts.included)) ?? []
        
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
        
        jsonApi[Consts.data] = dataObjects.map { objects[$0]! }
        return jsonApi
    }
    
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

private extension JsonApiParser {
    
    static func resolveAttributes(from objects: [TypeIdPair: NSMutableDictionary]) throws {
        
        objects.values.forEach { (object) in
            let attributes = try? object.dictionary(for: Consts.attributes)
            attributes?.forEach { object[$0] = $1 }
        }
        
    }
    
    static func resolveRelationships(from objects: [TypeIdPair: NSMutableDictionary]) throws {
        
        try objects.values.forEach { (object) in
            
            try object.dictionary(for: Consts.relationships, defaultDict: NSDictionary()).forEach { (relationship) in
              
                guard let relationshipParams = relationship.value as? NSDictionary else {
                    throw JsonApiUnboxError.relationshipNotFound(data: relationship)
                }
                
                //Extract typy id from single object / array
                let others = try relationshipParams.array(from: Consts.data)
                
                //Fetch those object from `objects`
                let othersObjects = try others.map { try $0.extractTypeIdPair() }
                    .flatMap { objects[$0] }
                
                //Store reloationships
                if others.count == 1 {
                    object[relationship.key] = othersObjects.first
                } else {
                    object[relationship.key] = othersObjects
                }
                
            }
        }
    }
    
}

private extension Dictionary where Key == String {

    func asDataWithTypeAndId() throws -> Parameters {
        guard let type = self[Consts.type], let id = self[Consts.id] else {
            throw JsonApiUnboxError.notFoundTypeOrId(data: self)
        }
        return [Consts.type: type, Consts.id: id]
    }

    func asArray(from key: String) -> [Parameters]? {
        return self[key] as? [Parameters]
    }

    func asDictionaty(from key: String) -> Parameters? {
        return self[key] as? Parameters
    }

    func containsTypeAndId() -> Bool {
        return keys.contains(Consts.type) && keys.contains(Consts.id)
    }

}

private extension NSDictionary {
    
    var mutable: NSMutableDictionary {
        return self as? NSMutableDictionary ?? self.mutableCopy() as! NSMutableDictionary
    }
    
    func extractTypeIdPair() throws -> TypeIdPair {
        if let id = self[Consts.id] as? String, let type = self[Consts.type] as? String {
            return TypeIdPair(type: type, id: id)
        }
        throw JsonApiUnboxError.notFoundTypeOrId(data: self)
    }
    
    func string(for key: String) throws -> String {
        if let value = self[key] as? String {
            return value
        }
        throw JsonApiUnboxError.notString(data: self, value: self[key])
    }
    
    func dictionary(for key: String, defaultDict: NSDictionary) -> NSDictionary {
        return (self[key] as? NSDictionary) ?? defaultDict
    }
    
    func dictionary(for key: String) throws -> NSDictionary {
        if let value = self[key] as? NSDictionary {
            return value
        }
        throw JsonApiUnboxError.notDictionary(data: self, value: self[key])
    }
    
    func array(from key: String) throws -> [NSDictionary] {
        let value = self[key]
        if let array = value as? [NSDictionary] {
            return array
        }
        if let dick = value as? NSDictionary {
            return [dick]
        }
        throw JsonApiUnboxError.cantProcess(data: self)
    }
    
}
