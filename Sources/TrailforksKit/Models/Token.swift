//
//  Token.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 2/24/21.
//

import Foundation

public struct Token: Equatable, Decodable {

    public let tokenPublic: String
    public let tokenSecret: String
    public let userId: String
    public let username: String
    public let expiresOn: Date

    public init(
        tokenPublic: String,
        tokenSecret: String,
        userId: String,
        username: String,
        expiresOn: Date
    ) {
        self.tokenPublic = tokenPublic
        self.tokenSecret = tokenSecret
        self.userId = userId
        self.username = username
        self.expiresOn = expiresOn
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            tokenPublic: container.decode(String.self, forKey: .tokenPublic),
            tokenSecret: container.decode(String.self, forKey: .tokenSecret),
            userId: container.decode(String.self, forKey: .userId),
            username: container.decode(String.self, forKey: .username),
            expiresOn: Date(
                timeIntervalSince1970: container.decode(TimeInterval.self, forKey: .expiresOn)
            )
        )
    }
    
    private enum CodingKeys: String, CodingKey {
        case expiresOn = "expires_on"
        case tokenPublic = "token_public"
        case tokenSecret = "token_secret"
        case userId = "user_id"
        case username = "username"
    }
}
