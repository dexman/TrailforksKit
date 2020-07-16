//
//  Status.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

public enum Status: String, Decodable {

    /// 0 - None, used for regions with no status
    case none = "0"

    /// 1 - Clear / Green
    case clear = "1"

    /// 2 - Minor Issue / Yellow
    case minorIssue  = "2"

    /// 3 - Significant Issue / Amber
    case significantIssue = "3"

    /// 4 - Closed
    case closed = "4"
}
