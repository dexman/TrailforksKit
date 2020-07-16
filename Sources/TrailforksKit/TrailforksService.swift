//
//  TrailforksService.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

public final class TrailforksService {

    public init(networkClient: NetworkClient, appCredential: TrailforksAppCredential?) {
        self.networkClient = networkClient
        self.appCredential = appCredential
    }

    @discardableResult
    public func send<R: TrailforksServiceRequest>(
        request: R,
        completion: @escaping (Result<R.ResponseType, Error>) -> Void
    ) -> NetworkClientCancellable {
        let urlRequest: URLRequest
        do {
            urlRequest = try createURLRequest(from: request)
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
                let result = try decoder.decode(TrailforksServiceResponse<R.ResponseType>.self, from: data)
                let value = try result.get()
                completion(.success(value))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private let networkClient: NetworkClient
    private let appCredential: TrailforksAppCredential?

    private func createURLRequest<R: TrailforksServiceRequest>(from request: R) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.trailforks.com"
        urlComponents.path = request.trailforksServicePath

        var queryItems: [URLQueryItem] = request.trailforksServiceParameters.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }
        if let appCredential = appCredential {
            queryItems.append(contentsOf: [
                URLQueryItem(name: "app_id", value: appCredential.id),
                URLQueryItem(name: "app_secret", value: appCredential.secret),
            ])
        }
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.trailforksServiceMethod
        return urlRequest
    }
}
