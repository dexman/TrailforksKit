//
//  RegionsRequest.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

public struct RegionsRequest: Hashable {

    public enum Parameters: Hashable {
        case filter([Filter])
        case page(Int)
        case rows(Int)
        case scope(Scope)
    }

    public enum Filter: Hashable {
        case parent(String)
    }

    public enum Scope: String, Hashable {
        case basic
        case detailed
        case full
        case index
        case links
        case files
    }

    public init(parameters: [Parameters]) {
        self.parameters = parameters
    }

    private let parameters: [Parameters]
}

extension RegionsRequest: TrailforksServiceRequest {

    public typealias ResponseType = [Region]

    public var trailforksServicePath: String {
        return "/api/1/regions"
    }

    public var trailforksServiceParameters: [(String, String)] {
        return parameters.map { parameter -> (String, String) in
            switch parameter {
            case let .filter(filters):
                let filterStrings = filters.map { (filter: Filter) -> (String, String) in
                    switch filter {
                    case let .parent(parentId):
                        return ("parent", parentId)
                    }
                }
                let filterValue = filterStrings.map { "\($0.0)::\($0.1)" }.joined(separator: ";")
                return ("filter", filterValue)
            case let .page(page):
                return ("page", "\(page)")
            case let .rows(rows):
                return ("rows", "\(rows)")
            case let .scope(scope):
                return ("scope", scope.rawValue)
            }
        }
    }
}
