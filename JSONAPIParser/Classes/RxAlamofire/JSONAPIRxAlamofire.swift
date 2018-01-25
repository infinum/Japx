//
//  JSONAPIRxAlamofire.swift
//  JSONAPIParser
//
//  Created by Vlaho Poluta on 25/01/2018.
//

import RxSwift
import Alamofire
import Foundation

extension DataRequest: ReactiveCompatible {}
extension DownloadRequest: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
    
    public func responseJSONAPI(queue: DispatchQueue? = nil, includeList: String? = nil, keyPath: String? = nil) -> Single<Parameters> {
        
        return Single<Parameters>.create { [weak base] (single) -> Disposable in
            let request = base?.responseJSONAPI(completionHandler: { (response) in
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
    
    public func responseJSONAPI(queue: DispatchQueue? = nil, includeList: String? = nil, keyPath: String? = nil) -> Single<Parameters> {
        
        return Single<Parameters>.create { [weak base] (single) -> Disposable in
            let request = base?.responseJSONAPI(completionHandler: { (response) in
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
