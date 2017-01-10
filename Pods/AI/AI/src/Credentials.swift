//
//  Credentials.swift
//  APII
//
//  Created by Kuragin Dmitriy on 11/11/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

import Foundation

public struct Credentials {
    var clientAccessToken: String
    
    public init(_ clientAccessToken: String) {
        self.clientAccessToken = clientAccessToken
    }
    
    public init(clientAccessToken: String) {
        self.clientAccessToken = clientAccessToken
    }
}

private let kAuthorizationHTTPHeaderFieldName = "Authorization"

internal extension NSMutableURLRequest {
    func authenticate(credentials: Credentials) {
        self.addValue("Bearer \(credentials.clientAccessToken)", forHTTPHeaderField: kAuthorizationHTTPHeaderFieldName);
    }
}