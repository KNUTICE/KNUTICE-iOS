//
//  RequestMethod.swift
//  Network
//
//  Created by 이정훈 on 1/2/26.
//

import Alamofire

public enum RequestMethod {
    case get
    case post
    case put
    case patch
    case delete
}

extension RequestMethod {
    var alamofire: Alamofire.HTTPMethod {
        switch self {
        case .get:    return .get
        case .post:   return .post
        case .put:    return .put
        case .patch:  return .patch
        case .delete: return .delete
        }
    }
}
