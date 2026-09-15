//
//  JapxAlamofire.swift
//  Japx
//
//  Created by Vlaho Poluta on 25/01/2018.
//

#if canImport(Alamofire)

import Foundation
import Alamofire

#if !COCOAPODS
import Japx
#endif

/// `JapxAlamofireError` is the error type returned by JapxAlamofire subspec.
public enum JapxAlamofireError: Error {
    
    /// - invalidKeyPath: Returned when a nested JSON object doesn't exist in parsed JSON:API response by provided `keyPath`.
    case invalidKeyPath(keyPath: String)
}

extension JapxAlamofireError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .invalidKeyPath(keyPath: keyPath): return "Nested JSON doesn't exist by keyPath: \(keyPath)."
        }
    }
}

extension DataRequest {

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched. Defaults to `.main` .
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           The options specifying how `JapxKit.Decoder` should decode JSON:API into JSON.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    // `@preconcurrency` mirrors Alamofire's own `response(queue:responseSerializer:completionHandler:)`,
    // keeping non-`Sendable` captures at call sites a warning instead of an error.
    @preconcurrency
    @discardableResult
    public func responseJSONAPI(
        queue: DispatchQueue = .main,
        includeList: String? = nil,
        options: JapxKit.Decoder.Options = .default,
        completionHandler: @escaping @Sendable (AFDataResponse<JSONAPIDocument>) -> Void
    ) -> Self {
        return response(
            queue: queue,
            responseSerializer: JSONAPIResponseSerializer(includeList: includeList, options: options),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched. Defaults to `.main` .
    /// - parameter includeList:       The include list for deserializing JSON:API relationships.
    /// - parameter options:           The options specifying how `JapxKit.Decoder` should decode JSON:API into JSON.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    // `@preconcurrency` mirrors Alamofire's own `response(queue:responseSerializer:completionHandler:)`,
    // keeping non-`Sendable` captures at call sites a warning instead of an error.
    @preconcurrency
    @discardableResult
    public func responseJSONAPI(
        queue: DispatchQueue = .main,
        includeList: String? = nil,
        options: JapxKit.Decoder.Options = .default,
        completionHandler: @escaping @Sendable (AFDownloadResponse<JSONAPIDocument>) -> Void
    ) -> Self {
        return response(
            queue: queue,
            responseSerializer: JSONAPIResponseSerializer(includeList: includeList, options: options),
            completionHandler: completionHandler
        )
    }
}

/// A `Sendable` box around a parsed JSON:API dictionary, used as the serialized object of
/// `JSONAPIResponseSerializer` since Alamofire requires `SerializedObject: Sendable`.
///
/// `@unchecked Sendable`: the decoder releases every reference to the wrapped dictionary
/// (including nested `NSMutableDictionary` values it builds) before the box is created,
/// and the contents are never mutated afterwards. The initializer is internal so that
/// `JSONAPIResponseSerializer` stays the only producer, which is what keeps that
/// guarantee true. Required as long as the public API carries `[String: Any]`.
public struct JSONAPIDocument: @unchecked Sendable {

    /// The parsed JSON:API object.
    public let dictionary: Japx.Parameters

    /// Creates an instance wrapping the parsed JSON:API object.
    init(dictionary: Japx.Parameters) {
        self.dictionary = dictionary
    }

    /// Accesses the value associated with `key` in the parsed JSON:API object.
    ///
    /// Mirrors subscripting the dictionary directly, so call sites written against
    /// `Japx.Parameters` keep working.
    public subscript(key: String) -> Any? {
        dictionary[key]
    }
}

public final class JSONAPIResponseSerializer: ResponseSerializer {

    public let includeList: String?
    public let options: JapxKit.Decoder.Options

    /// Creates an instance using the values provided.
    ///
    /// - Parameters:
    ///   - includeList:         The include list for deserializing JSON:API relationships.
    ///   - options:             The options specifying how `JapxKit.Decoder` should decode JSON:API into JSON.
    public init(
        includeList: String?,
        options: JapxKit.Decoder.Options
    ) {
        self.includeList = includeList
        self.options = options
    }

    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> JSONAPIDocument {
        guard error == nil else { throw error! }

        guard var data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }

            return JSONAPIDocument(dictionary: [:])
        }

        data = try dataPreprocessor.preprocess(data)

        do {
            return JSONAPIDocument(dictionary: try JapxKit.Decoder.jsonObject(with: data, includeList: includeList, options: options))
        } catch {
            throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
        }
    }
}

#endif
