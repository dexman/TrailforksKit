//
//  NetworkClient.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Combine
import Foundation

/// Abstract protocol for network requests
///
/// This makes it easier to write tests and mock server responses.
public protocol NetworkClient {

    typealias NetworkClientResponse = (data: Data, response: HTTPURLResponse)

    func data(for request: URLRequest) async throws -> NetworkClientResponse
}

/// Concrete implementation of `NetworkClient` based on a real `URLSession`.
extension URLSession: NetworkClient {

    public func data(
        for request: URLRequest
    ) async throws -> NetworkClientResponse {
        if #available(iOS 15.0, macOS 12.0, *) {
            let (data, response) = try await self.data(for: request, delegate: nil)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            return (data, httpResponse)
        } else {
            return try await backwardsCompatibleData(for: request)
        }
    }

    private func backwardsCompatibleData(
        for request: URLRequest
    ) async throws -> NetworkClientResponse {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<NetworkClientResponse, Error>) in
            var cancellable: AnyCancellable?
            cancellable = dataTaskPublisher(for: request).sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable = nil
                },
                receiveValue: { (data, response) in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        continuation.resume(throwing: URLError(.badServerResponse))
                        return
                    }
                    continuation.resume(returning: (data, httpResponse))
                }
            )
            withExtendedLifetime(cancellable) {}
        }
    }
}
