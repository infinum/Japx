//
//  JSONAPIAlamofire.swift
//  Alamofire
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Alamofire
import Foundation

public enum JSONAPIAlamofireError: Error {
    case invalidKeyPath(keyPath: String)
}

extension JSONAPIAlamofireError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .invalidKeyPath(keyPath: keyPath):   return "Nested object doesn't exist by keyPath: \(keyPath)."
        }
    }
}

extension Request {
    
    /// Returns a JSON:API object contained in a result type.
    ///
    /// - parameter response: The response from the server.
    /// - parameter data:     The data returned from the server.
    /// - parameter error:    The error already encountered if it exists.
    ///
    /// - returns: The result data type.
    public static func serializeResponseJSONAPI(response: HTTPURLResponse?, data: Data?, error: Error?, includeList: String?, keyPath: String?) -> Result<Parameters> {
        guard error == nil else { return .failure(error!) }
        
        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success([:]) }
        
        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        
        do {
            let json = try JSONAPIParser.Decoder.jsonObject(with: validData, includeList: includeList)
            
            guard let keyPath = keyPath, !keyPath.isEmpty else  { return .success(json) }
            
            if let json = (json as AnyObject).value(forKeyPath: keyPath) as? Parameters {
                return .success(json)
            } else {
                return .failure(JSONAPIAlamofireError.invalidKeyPath(keyPath: keyPath))
            }
        
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    /// Creates a response serializer that returns a JSON:API object result type.
    ///
    /// - returns: A JSON:API object response serializer.
    public static func jsonApiResponseSerializer(includeList: String?, keyPath: String?) -> DataResponseSerializer<Parameters> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseJSONAPI(response: response, data: data, error: error, includeList: includeList, keyPath: keyPath)
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONAPI(queue: DispatchQueue? = nil, includeList: String? = nil, keyPath: String? = nil, completionHandler: @escaping (DataResponse<Parameters>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DataRequest.jsonApiResponseSerializer(includeList: includeList, keyPath: keyPath),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    /// Creates a response serializer that returns a JSON:API object result type.
    ///
    /// - returns: A JSON object response serializer.
    public static func jsonApiResponseSerializer(includeList: String?, keyPath: String?) -> DownloadResponseSerializer<Parameters>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }
            
            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseJSONAPI(response: response, data: data, error: error, includeList: includeList, keyPath: keyPath)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONAPI(queue: DispatchQueue? = nil, includeList: String? = nil, keyPath: String? = nil, completionHandler: @escaping (DownloadResponse<Parameters>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.jsonApiResponseSerializer(includeList: includeList, keyPath: keyPath),
            completionHandler: completionHandler
        )
    }
}

private let emptyDataStatusCodes: Set<Int> = [204, 205]
