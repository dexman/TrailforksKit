//
//  RegionsRequest.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

public enum RegionsRequest: Hashable {

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

    public static func make(parameters: [RegionsRequest.Parameters]) -> TrailforksServiceRequest<[Region]> {
        return TrailforksServiceRequest(
            path: "/api/1/regions",
            parameters: parameters.map { parameter -> (String, String) in
                switch parameter {
                case let .filter(filters):
                    let filterStrings = filters.map { (filter: RegionsRequest.Filter) -> (String, String) in
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
            })
    }
}
