//
//  JapxRelationshipResource.swift
//  Japx
//
//  Created by Vlaho Poluta on 16/11/2019.
//

import Foundation

@dynamicMemberLookup
public enum JapxRelationshipResource<Resource: JapxDecodable, ResourceIdentifier: JapxDecodable>: JapxDecodable {
    case resource(Resource)
    case identifer(ResourceIdentifier)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let instance = try? container.decode(Resource.self) {
            self = .resource(instance)
            return
        }
        let identifer = try container.decode(ResourceIdentifier.self)
        self = .identifer(identifer)
    }
    
    public subscript<Element>(dynamicMember keyPath: KeyPath<Resource, Element>) -> Element? {
        return resource?[keyPath: keyPath]
    }
    
    public subscript<Element>(dynamicMember keyPath: KeyPath<ResourceIdentifier, Element>) -> Element? {
        return resourceIdentifer?[keyPath: keyPath]
    }
    
    public var identifer: JapxDecodable {
        switch self {
        case .resource(let instance): return instance
        case .identifer(let identifer): return identifer
        }
    }
    
    public var resource: Resource? {
        switch self {
        case .resource(let instance): return instance
        case .identifer: return nil
        }
    }
    
    public var resourceIdentifer: ResourceIdentifier? {
        switch self {
        case .resource: return nil
        case .identifer(let identifier): return identifier
        }
    }
    
    public var id: String {
        return identifer.id
    }
    
    public var type: String {
        return identifer.type
    }
}

extension JapxRelationshipResource: JapxEncodable & Encodable where Resource: JapxEncodable, ResourceIdentifier: JapxEncodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .resource(let instance): try container.encode(instance)
        case .identifer(let identifier): try container.encode(identifier)
        }
    }
}

public struct JapxResourceIdentifer: JapxDecodable {
    public let id: String
    public let type: String
}

public typealias JapxReleationship<Resource: JapxDecodable> = JapxRelationshipResource<Resource, JapxResourceIdentifer>

