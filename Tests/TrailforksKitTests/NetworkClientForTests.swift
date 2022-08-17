//
//  NetworkClientForTests.swift
//  TrailforksKitTests
//
//  Created by Arthur Dexter on 7/16/20.
//

import Combine
import Foundation
@testable import TrailforksKit
import XCTest

final class NetworkClientForTests: NetworkClient {

    typealias NetworkClientResult = Result<NetworkClientResponse, Error>

    struct UnexpectedRequest: Error {
        let request: URLRequest
    }

    func expect(request: URLRequest, result: NetworkClientResult) {
        expectationsQueue.sync {
            expectations[ExpectationKey(request)] = result
        }
    }

    func expect(method: String = "GET", url: URL, statusCode: Int = 200, data: Data = .init()) {
        let key = ExpectationKey(method: method, url: url)
        expectationsQueue.sync {
            expectations[key] = .success((
                data,
                HTTPURLResponse(
                    url: url,
                    statusCode: statusCode,
                    httpVersion: nil,
                    headerFields: nil
                )!
            ))
        }
    }

    func expect(method: String = "GET", url: URL, statusCode: Int = 200, fixtureNamed fixtureName: String) throws {
        let fixtureURL = try XCTUnwrap(Bundle.module.url(forResource: fixtureName, withExtension: nil))
        let data = try Data(contentsOf: fixtureURL)
        expect(method: method, url: url, statusCode: statusCode, data: data)
    }

    public func data(
        for request: URLRequest
    ) async throws -> NetworkClientResponse {
        let key = ExpectationKey(request)
        let result = self.expectations[key, default: .failure(UnexpectedRequest(request: request))]
        return try await Task {
            try result.get()
        }.value
    }

    private struct ExpectationKey: Hashable {
        let method: String?
        let url: URL?

        init(method: String?, url: URL?) {
            self.method = method
            self.url = url
        }

        init(_ request: URLRequest) {
            self.method = request.httpMethod
            self.url = request.url
        }
    }
    private var expectations: [ExpectationKey: NetworkClientResult] = [:]
    private let expectationsQueue = DispatchQueue(label: "DummyNetworkClient.expectationsQueue")
}
