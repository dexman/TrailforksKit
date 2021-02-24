//
//  Report.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 2/24/21.
//

import Foundation

public struct Report: Equatable, Decodable {

    public let action: String
    public let userId: String
    public let trailId: String
    public let status: Status
    public let condition: Condition
    public let description: String
    public let marker: String
    public let reportId: Int

    public init(
        action: String,
        userId: String,
        trailId: String,
        status: Status,
        condition: Condition,
        description: String,
        marker: String,
        reportId: Int
    ) {
        self.action = action
        self.userId = userId
        self.trailId = trailId
        self.status = status
        self.condition = condition
        self.description = description
        self.marker = marker
        self.reportId = reportId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            action: container.decode(String.self, forKey: .action),
            userId: container.decode(String.self, forKey: .userId),
            trailId: container.decode(String.self, forKey: .trailId),
            status: container.decode(Status.self, forKey: .status),
            condition: container.decode(Condition.self, forKey: .condition),
            description: container.decode(String.self, forKey: .description),
            marker: container.decode(String.self, forKey: .marker),
            reportId: container.decode(Int.self, forKey: .reportId)
        )
    }

    private enum CodingKeys: String, CodingKey {
        case action
        case userId = "userid"
        case trailId = "trailid"
        case status
        case condition
        case description
        case marker
        case reportId = "reportid"
    }
}
