//
//  TokenRequest.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 2/24/21.
//

import Foundation

public enum TokenRequest: Hashable {

    public static func make(code: String) -> TrailforksServiceRequest<Token> {
        return TrailforksServiceRequest(
            path: "/api/1/token",
            parameters: [("code", code)]
        )
    }
}
