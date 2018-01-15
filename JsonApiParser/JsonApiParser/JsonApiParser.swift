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
    
    static func unbox(jsonApi: Parameters) throws -> Parameters {
        
        var dataObjects = [TypeIdPair]()
        var includedObjects = [TypeIdPair]()
        var objects = [TypeIdPair: Parameters]()
        
        for dic in try jsonApi.array(from: Consts.data) {
            let typeId = try dic.extractTypeIdPair()
            dataObjects.append(typeId)
            objects[typeId] = dic
        }
        for dic in (try? jsonApi.array(from: Consts.included)) ?? [] {
            let typeId = try dic.extractTypeIdPair()
            includedObjects.append(typeId)
            objects[typeId] = dic
        }
        
        try resolveAttributes(from: &objects)
        try resolveRelationships(from: &objects, keyOrder: dataObjects + includedObjects)
        
        var dick = jsonApi
        dick[Consts.data] = dataObjects.map { objects[$0]! }
        return dick
    }
    
    static func wrap(json: Parameters) throws -> Parameters {
        var object = json
        
        var attributes = Parameters()
        var relationships = Parameters()
        
        let objectKeys = object.keys
        for key in objectKeys where key != Consts.type && key != Consts.id {
            
            if let array = object.asArray(from: key) {
                let isArrayOfRelationships = array.first?.containsTypeAndId() ?? false
                if !isArrayOfRelationships {
                    attributes[key] = array
                    continue
                }
                let dataArray = try array.map { try $0.asDataWithTypeAndId() }
                relationships[key] = [Consts.data: dataArray]
                continue
            }
            
            if let obj = object.asDick(from: key) {
                if !obj.containsTypeAndId() {
                    attributes[key] = obj
                    continue
                }
                let dataObj = try obj.asDataWithTypeAndId()
                relationships[key] = [Consts.data: dataObj]
                continue
            }
            
            attributes[key] = object[key]
        }
        
        object[Consts.attributes] = attributes
        object[Consts.relationships] = relationships
        
        return [Consts.data: object]
    }
    
}

private extension JsonApiParser {
    
    static func resolveAttributes(from objects: inout [TypeIdPair: Parameters]) throws {
        
        for typeId in objects.keys {
            
            var object = objects[typeId]!
            let attributes = try? object.dick(for: Consts.attributes)
            attributes?.forEach { object[$0] = $1 }
            objects[typeId] = object
        }
    }
    
    static func resolveRelationships(from objects: inout [TypeIdPair: Parameters], keyOrder: [TypeIdPair]) throws {
        
        for typeId in keyOrder {
            
            var object = objects[typeId]!
            for relationship in (try? object.dick(for: Consts.relationships)) ?? [:] {
                guard let relationshipParams = relationship.value as? Parameters else {
                    throw JsonApiUnboxError.relationshipNotFound(data: relationship)
                }
                let others = try relationshipParams.array(from: Consts.data)
                let othersObjects = try others.map { try $0.extractTypeIdPair() }
                    .map { objects[$0] }
                    .flatMap { $0 }
                if others.count == 1 {
                    object[relationship.key] = othersObjects.first
                } else {
                    object[relationship.key] = othersObjects
                }
            }
            objects[typeId] = object
            
        }
    }
    
}

private extension Dictionary where Key == String {
    
    func asDataWithTypeAndId() throws ->Parameters {
        guard let type = self[Consts.type], let id = self[Consts.id] else {
            throw JsonApiUnboxError.notFoundTypeOrId(data: self)
        }
        return [Consts.type: type, Consts.id: id]
    }
    
    func asArray(from key: String) -> [Parameters]? {
        return self[key] as? [Parameters]
    }
    
    func asDick(from key: String) -> Parameters? {
        return self[key] as? Parameters
    }
    
    func containsTypeAndId() -> Bool {
        return keys.contains(Consts.type) && keys.contains(Consts.id)
    }
    
}

private extension Dictionary where Key == String {
    
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
    
    func dick(for key: String) throws -> Parameters {
        if let value = self[key] as? Parameters {
            return value
        }
        throw JsonApiUnboxError.notDictionary(data: self, value: self[key])
    }
    
    func array(from key: String) throws -> [Parameters] {
        let value = self[key]
        if let array = value as? [Parameters] {
            return array
        }
        if let dick = value as? Parameters {
            return [dick]
        }
        throw JsonApiUnboxError.cantProcess(data: self)
    }
    
}
