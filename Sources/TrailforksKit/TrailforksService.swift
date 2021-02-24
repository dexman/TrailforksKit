//
//  TrailforksService.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import CommonCrypto
import Foundation

public final class TrailforksService {

    public init(networkClient: NetworkClient, appCredential: TrailforksAppCredential?) {
        self.networkClient = networkClient
        self.appCredential = appCredential
    }

    @discardableResult
    public func send<R>(
        request: TrailforksServiceRequest<R>,
        token: Token? = nil,
        completion: @escaping (Result<R, Error>) -> Void
    ) -> NetworkClientCancellable {
        let urlRequest: URLRequest
        do {
            urlRequest = try createURLRequest(
                from: request,
                token: token
            )
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return EmptyCancellable()
        }

        return networkClient.send(request: urlRequest) { (result: NetworkClientResult) in
            let decoder = JSONDecoder()
            do {
                let data = try result.get().data ?? Data()
                let result = try decoder.decode(TrailforksServiceResponse<R>.self, from: data)
                let value = try result.get()
                completion(.success(value))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private let networkClient: NetworkClient
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

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.trailforks.com"
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
