//
//  NetworkClient.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

public typealias NetworkClientResult = Result<(response: HTTPURLResponse, data: Data?), Error>

/// Abstract protocol for network requests
///
/// This makes it easier to write tests and mock server responses.
public protocol NetworkClient {

    func send(
        request: URLRequest,
        completion: @escaping (NetworkClientResult) -> Void
    ) -> NetworkClientCancellable
}

public protocol NetworkClientCancellable {

    func cancel()
}

struct EmptyCancellable: NetworkClientCancellable {

    func cancel() {}
}

/// Concrete implementation of `NetworkClient` based on a real `URLSession`.
public final class URLSessionNetworkClient: NetworkClient {

    public struct BadServerResponse: Error {}

    public init(session: URLSession) {
        self.session = session
    }

    public func send(
        request: URLRequest,
        completion: @escaping (NetworkClientResult) -> Void
    ) -> NetworkClientCancellable {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(BadServerResponse()))
            }

            completion(.success((response, data)))
        }
        task.resume()
        return task
    }

    private let session: URLSession
}

extension URLSessionTask: NetworkClientCancellable {}
