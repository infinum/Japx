//
//  JSONAPICodableAlamofire.swift
//  JSONAPIParser
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Alamofire
import Foundation

extension Request {
    
    /// Returns a parsed and decoded JSON:API object into requested type contained in result type.
    ///
    /// - parameter response:       The response from the server.
    /// - parameter data:           The data returned from the server.
    /// - parameter error:          The error already encountered if it exists.
    /// - parameter includeList:    The include list for desirializing JSON:API relationships.
    /// - parameter keyPath:        The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:        The decoder that performs the decoding on parsed JSON into requested type.
    ///
    /// - returns: The result data type.
    public static func serializeResponseCodableJSONAPI<T: JSONAPIDecodable>(response: HTTPURLResponse?, data: Data?, error: Error?, includeList: String?, keyPath: String?, decoder: JSONAPIDecoder) -> Result<T> {
        guard error == nil else { return .failure(error!) }
        
        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        
        do {
            guard let keyPath = keyPath, !keyPath.isEmpty else  {
                let decodable = try decoder.decode(T.self, from: validData, includeList: includeList)
                return .success(decodable)
            }
            
            let json = try JSONAPIParser.Decoder.jsonObject(with: validData, includeList: includeList)
            guard let jsonForKeyPath = (json as AnyObject).value(forKeyPath: keyPath) else {
                return .failure(JSONAPIAlamofireError.invalidKeyPath(keyPath: keyPath))
            }
            let data = try JSONSerialization.data(withJSONObject: jsonForKeyPath, options: .init(rawValue: 0))
            
            let decodable = try decoder.jsonDecoder.decode(T.self, from: data)
            return .success(decodable)
            
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    
    /// Creates a response serializer that returns a parsed and decoded JSON:API object into requested type contained in result type.
    ///
    /// - parameter includeList:    The include list for desirializing JSON:API relationships.
    /// - parameter keyPath:        The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:        The decoder that performs the decoding on parsed JSON into requeted type.
    ///
    /// - returns: A JSON:API object response serializer.
    public static func codableJsonApiResponseSerializer<T: JSONAPIDecodable>(includeList: String?, keyPath: String?, decoder: JSONAPIDecoder) -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseCodableJSONAPI(response: response, data: data, error: error, includeList: includeList, keyPath: keyPath, decoder: decoder)
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter includeList:       The include list for desirializing JSON:API relationships.
    /// - parameter keyPath:           The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:           The decoder that performs the decoding on parsed JSON into requeted type.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseCodableJSONAPI<T: JSONAPIDecodable>(queue: DispatchQueue? = nil, includeList: String? = nil, keyPath: String? = nil, decoder: JSONAPIDecoder = JSONAPIDecoder(), completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DataRequest.codableJsonApiResponseSerializer(includeList: includeList, keyPath: keyPath, decoder: decoder),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    
    /// Creates a response serializer that returns a parsed and decoded JSON:API object into requested type contained in result type.
    ///
    /// - parameter includeList:    The include list for desirializing JSON:API relationships.
    /// - parameter keyPath:        The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:        The decoder that performs the decoding on parsed JSON into requeted type.
    ///
    /// - returns: A JSON:API object response serializer.
    public static func codableJsonApiResponseSerializer<T: JSONAPIDecodable>(includeList: String?, keyPath: String?, decoder: JSONAPIDecoder) -> DownloadResponseSerializer<T>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }

            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseCodableJSONAPI(response: response, data: data, error: error, includeList: includeList, keyPath: keyPath, decoder: decoder)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
            }
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter includeList:       The include list for desirializing JSON:API relationships.
    /// - parameter keyPath:           The keyPath where object decoding on parsed JSON should be performed.
    /// - parameter decoder:           The decoder that performs the decoding on parsed JSON into requeted type.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseCodableJSONAPI<T: JSONAPIDecodable>(queue: DispatchQueue? = nil, includeList: String? = nil, keyPath: String? = nil, decoder: JSONAPIDecoder = JSONAPIDecoder(), completionHandler: @escaping (DownloadResponse<T>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.codableJsonApiResponseSerializer(includeList: includeList, keyPath: keyPath, decoder: decoder),
            completionHandler: completionHandler
        )
    }
}
