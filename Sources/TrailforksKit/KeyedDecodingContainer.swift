//
//  KeyedDecodingContainer.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

extension KeyedDecodingContainer {

    /// Decode a value for the given key as a string, then convert it to T using LosslessStringConvertible.
    func decodeFromString<T: LosslessStringConvertible>(_ type: T.Type, forKey key: Key) throws -> T {
        let stringValue = try decode(String.self, forKey: key)
        return try convertFromString(type, stringValue: stringValue, forKey: key)
    }

    /// Decode an optional value for the given key as a string, then convert it to T using LosslessStringConvertible.
    func decodeFromStringIfPresent<T: LosslessStringConvertible>(_ type: T.Type, forKey key: Key) throws -> T? {
        return try decodeIfPresent(String.self, forKey: key).map { (stringValue: String) -> T in
            return try convertFromString(type, stringValue: stringValue, forKey: key)
        }
    }

    private func convertFromString<T: LosslessStringConvertible>(_: T.Type, stringValue: String, forKey key: Key) throws -> T {
        guard let value = T(stringValue) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "Could not convert \(stringValue) to \(T.self)")
        }
        return value
    }
}
