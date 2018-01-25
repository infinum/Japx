//
//  JSONAPICodableAlamofire.swift
//  JSONAPIParser
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import Alamofire
import Foundation

extension Request {
    
    /// Returns a JSON:API object contained in a result type.
    ///
    /// - parameter response: The response from the server.
    /// - parameter data:     The data returned from the server.
    /// - parameter error:    The error already encountered if it exists.
    ///
    /// - returns: The result data type.
    public static func serializeResponseJSONAPI<T: JSONAPIDecodable>(response: HTTPURLResponse?, data: Data?, error: Error?, includeList: String?, keyPath: String?, decoder: JSONAPIDecoder) -> Result<T> {
        guard error == nil else { return .failure(error!) }
        
        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        
        do {
            guard let keyPath = keyPath, !keyPath.isEmpty else  {
                let data = try JSONAPIParser.Decoder.data(with: validData, includeList: includeList)
                let decondable = try decoder.decode(T.self, from: data)
                return .success(decondable)
            }
            
            let json = try JSONAPIParser.Decoder.jsonObject(with: validData, includeList: includeList)
            guard let jsonForKeyPath = (json as AnyObject).value(forKeyPath: keyPath) as? Parameters else  {
                return .failure(JSONAPIAlamofireError.invalidKeyPath(keyPath: keyPath))
            }
            
            let docodable = try decoder.decode(T.self, from: jsonForKeyPath, includeList: includeList)
            return .success(docodable)
            
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    /// Creates a response serializer that returns a JSON:API object result type.
    ///
    /// - returns: A JSON:API object response serializer.
    public static func jsonApiResponseSerializer<T: JSONAPIDecodable>(includeList: String?, keyPath: String?, decoder: JSONAPIDecoder) -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseJSONAPI(response: response, data: data, error: error, includeList: includeList, keyPath: keyPath, decoder: decoder)
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseJSONAPI<T: JSONAPIDecodable>(queue: DispatchQueue? = nil, includeList: String? = nil, keyPath: String? = nil, decoder: JSONAPIDecoder = JSONAPIDecoder(), completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DataRequest.jsonApiResponseSerializer(includeList: includeList, keyPath: keyPath, decoder: decoder),
            completionHandler: completionHandler
        )
    }
}

extension DownloadRequest {
    /// Creates a response serializer that returns a JSON:API object result type.
    ///
    /// - returns: A JSON object response serializer.
    public static func jsonApiResponseSerializer<T: JSONAPIDecodable>(includeList: String?, keyPath: String?, decoder: JSONAPIDecoder) -> DownloadResponseSerializer<T>
    {
        return DownloadResponseSerializer { _, response, fileURL, error in
            guard error == nil else { return .failure(error!) }

            guard let fileURL = fileURL else {
                return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
            }

            do {
                let data = try Data(contentsOf: fileURL)
                return Request.serializeResponseJSONAPI(response: response, data: data, error: error, includeList: includeList, keyPath: keyPath, decoder: decoder)
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
    public func responseJSONAPI<T: JSONAPIDecodable>(queue: DispatchQueue? = nil, includeList: String? = nil, keyPath: String? = nil, decoder: JSONAPIDecoder = JSONAPIDecoder(), completionHandler: @escaping (DownloadResponse<T>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DownloadRequest.jsonApiResponseSerializer(includeList: includeList, keyPath: keyPath, decoder: decoder),
            completionHandler: completionHandler
        )
    }
}
