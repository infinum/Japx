//
//  NSError+Japx.swift
//  Japx
//
//  Created by Nikola Majcen on 29/01/2019.
//

import Foundation

extension NSError {

    convenience init(error: Error) {
        guard let error = error as? JapxError else {
            self.init(domain: "co.infinum.japx-objc",
                      code: JapxErrorType.undefined.rawValue,
                      userInfo: nil)
            return
        }

        let errorType: JapxErrorType
        let errorData: Any

        switch error {
        case .cantProcess(data: let data):
            errorType = .cantProcess
            errorData = data
        case .notDictionary(data: let data, value: _):
            errorType = .notDictionary
            errorData = data
        case .notFoundTypeOrId(data: let data):
            errorType = .notFoundTypeOrId
            errorData = data
        case .relationshipNotFound(data: let data):
            errorType = .relationshipNotFound
            errorData = data
        case .unableToConvertNSDictionaryToParams(data: let data):
            errorType = .unableToConvertNSDictionaryToParams
            errorData = data
        case .unableToConvertDataToJson(data: let data):
            errorType = .unableToConvertDataToJson
            errorData = data
        }

        self.init(domain: "co.infinum.japx-objc",
                  code: errorType.rawValue,
                  userInfo: ["data": errorData])
    }
}

