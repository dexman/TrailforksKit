//
//  TrailforksServerConfiguration.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 3/7/23.
//

import Foundation

public struct TrailforksServerConfiguration {
    public static let production = TrailforksServerConfiguration(
        baseURLComponents: {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "www.trailforks.com"
            return components
        }()
    )

    public let baseURLComponents: URLComponents
}
