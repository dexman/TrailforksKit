//
//  TrailforksServiceRequest.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

public protocol TrailforksServiceRequest {

    associatedtype ResponseType: Decodable

    var trailforksServiceMethod: String { get }
    var trailforksServicePath: String { get }
    var trailforksServiceParameters: [(String, String)] { get }
}

extension TrailforksServiceRequest {

    public var trailforksServiceMethod: String {
        return "GET"
    }
}
