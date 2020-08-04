//
//  TrailforksServiceRequest.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

public struct TrailforksServiceRequest<ResponseType: Decodable> {

    public let method: String
    public let path: String
    public let parameters: [(String, String)]

    public init(
        method: String = "GET",
        path: String,
        parameters: [(String, String)] = []
    ) {
        self.method = method
        self.path = path
        self.parameters = parameters
    }
}
