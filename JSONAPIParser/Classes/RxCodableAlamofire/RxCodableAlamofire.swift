//
//  RxCodableAlamofire.swift
//  JSONAPIParser
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import RxSwift
import Alamofire
import Foundation

extension Reactive where Base: DataRequest {
    
    public func responseCodableJSONAPI<T: JSONAPIDecodable>(queue: DispatchQueue? = nil, includeList: String? = nil, keyPath: String? = nil, decoder: JSONAPIDecoder = JSONAPIDecoder()) -> Single<T> {
        
        return Single<T>.create { [weak base] (single) -> Disposable in
            let request = base?.responseCodableJSONAPI(queue: queue, includeList: includeList, keyPath: keyPath, decoder: decoder, completionHandler: { (response: DataResponse<T>) in
                switch response.result {
                    case .success(let value): single(.success(value))
                    case .failure(let error): single(.error(error))
                }
            })
            
            return Disposables.create {
                request?.cancel()
            }
        }
        
    }
}


extension Reactive where Base: DownloadRequest {

    public func responseCodableJSONAPI<T: JSONAPIDecodable>(queue: DispatchQueue? = nil, includeList: String? = nil, keyPath: String? = nil, decoder: JSONAPIDecoder = JSONAPIDecoder()) -> Single<T> {

        return Single<T>.create { [weak base] (single) -> Disposable in
            let request = base?.responseCodableJSONAPI(queue: queue, includeList: includeList, keyPath: keyPath, decoder: decoder, completionHandler: { (response: DownloadResponse<T>) in
                switch response.result {
                case .success(let value): single(.success(value))
                case .failure(let error): single(.error(error))
                }
            })
            
            return Disposables.create {
                request?.cancel()
            }
        }
    }
}

