//
//  TrailforksServiceResponse.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

enum TrailforksServiceResponse<T: Decodable>: Decodable {

    case success(T)
    case failure(Error)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let error: Int = try container.decodeIfPresent(Int.self, forKey: .error), error != 0 {
            let message: String = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
            self = .failure(TrailforksServiceError(message: message))
        } else if let data = try container.decodeIfPresent(T.self, forKey: .data) {
            self = .success(data)
        } else {
            self = .failure(DecodingError.dataCorruptedError(
                forKey: .data,
                in: container,
                debugDescription: "data not found in container"))
        }
    }

    func get() throws -> T {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }

    private enum CodingKeys: String, CodingKey {
        case error
        case message
        case data
    }
}

public struct TrailforksServiceError: Error {

    public let message: String

    public init(message: String) {
        self.message = message
    }
}
