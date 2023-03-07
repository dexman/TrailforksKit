//
//  TrailforksService.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Combine
import CommonCrypto
import Foundation

public final class TrailforksService {

    public init(
        networkClient: NetworkClient,
        serverConfiguration: TrailforksServerConfiguration = .production,
        appCredential: TrailforksAppCredential?
    ) {
        self.networkClient = networkClient
        self.serverConfiguration = serverConfiguration
        self.appCredential = appCredential
    }

    public func send<R>(
        request: TrailforksServiceRequest<R>,
        token: Token? = nil
    ) async throws -> R {
        let urlRequest = try createURLRequest(
            from: request,
            token: token
        )

        let (data, _) = try await networkClient.data(for: urlRequest)
        let result = try await Task { () -> TrailforksServiceResponse<R> in
            let decoder = JSONDecoder()
            return try decoder.decode(TrailforksServiceResponse<R>.self, from: data)
        }.value
        return try result.get()
    }

    public func loginUrl(redirectUrl: URL) throws -> URL {
        var urlComponents = serverConfiguration.baseURLComponents
        urlComponents.path = "/api/1/oauth2/login"
        urlComponents.queryItems = [
            URLQueryItem(
                name: "client_id",
                value: appCredential?.id
            ),
            URLQueryItem(
                name: "redirect_uri",
                value: redirectUrl.absoluteString
            ),
        ]
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        return url
    }

    private let networkClient: NetworkClient
    private let serverConfiguration: TrailforksServerConfiguration
    private let appCredential: TrailforksAppCredential?

    private func createURLRequest<R>(
        from request: TrailforksServiceRequest<R>,
        token: Token?
    ) throws -> URLRequest {
        var parameters = request.parameters
        if let appCredential = appCredential {
            parameters.append(contentsOf: [
                ("app_id", appCredential.id),
                ("app_secret", appCredential.secret),
            ])
        }
        if let token = token {
            let timestamp = String(Int(Date().timeIntervalSince1970))
            let stringToDigest = timestamp + token.tokenSecret
            guard let hash = stringToDigest.data(using: .utf8)?.sha1?.hexString else {
                throw URLError(.unknown)
            }
            parameters.append(contentsOf: [
                ("timestamp", timestamp),
                ("token_public", token.tokenPublic),
                ("hash", hash),
            ])
        }

        var urlComponents = serverConfiguration.baseURLComponents
        urlComponents.path = request.path

        let bodyData: Data?
        if !parameters.isEmpty {
            let queryItems = parameters.map {
                URLQueryItem(name: $0.0, value: $0.1)
            }
            if request.method != "POST" {
                urlComponents.queryItems = queryItems
                bodyData = nil
            } else {
                var bodyUrlComponents = URLComponents()
                bodyUrlComponents.queryItems = queryItems
                bodyData = bodyUrlComponents.query?.data(using: .utf8)
            }
        } else {
            bodyData = nil
        }

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.httpBody = bodyData
        return urlRequest
    }
}
