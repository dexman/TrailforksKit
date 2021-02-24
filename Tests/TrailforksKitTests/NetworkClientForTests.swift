//
//  NetworkClientForTests.swift
//  TrailforksKitTests
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation
@testable import TrailforksKit
import XCTest

final class NetworkClientForTests: NetworkClient {

    struct UnexpectedRequest: Swift.Error {
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
                HTTPURLResponse(
                    url: url,
                    statusCode: statusCode,
                    httpVersion: nil,
                    headerFields: nil)!,
                data
            ))
        }
    }

    func expect(method: String = "GET", url: URL, statusCode: Int = 200, fixtureNamed fixtureName: String) throws {
        let bundle = Bundle.module
//        let bundle =  Bundle(path: "/Users/adexter/Code/Personal/TrailforksKit/.build/x86_64-apple-macosx/debug/TrailforksKit_TrailforksKitTests.bundle")!
        let fixtureURL = try XCTUnwrap(bundle.url(forResource: fixtureName, withExtension: nil))
        let data = try Data(contentsOf: fixtureURL)
        expect(method: method, url: url, statusCode: statusCode, data: data)
    }

    func send(request: URLRequest, completion: @escaping (NetworkClientResult) -> Void) -> NetworkClientCancellable {
        let cancellable = NetworkClientCancellableForTests()
        expectationsQueue.async {
            guard !cancellable.isCancelled else {
                DispatchQueue.global().async {
                    completion(.failure(URLError(.cancelled)))
                }
                return
            }

            let key = ExpectationKey(request)
            let result = self.expectations[key, default: .failure(UnexpectedRequest(request: request))]
            DispatchQueue.global().async {
                guard !cancellable.isCancelled else {
                    completion(.failure(URLError(.cancelled)))
                    return
                }
                completion(result)
            }
        }
        return cancellable
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

class NetworkClientCancellableForTests: NetworkClientCancellable {

    var isCancelled: Bool {
        return queue.sync {
            return unsafeIsCancelled
        }
    }

    func cancel() {
        queue.sync {
            unsafeIsCancelled = true
        }
    }

    private var unsafeIsCancelled: Bool = false
    private let queue = DispatchQueue(label: "DummyNetworkClientCancellable")
}
