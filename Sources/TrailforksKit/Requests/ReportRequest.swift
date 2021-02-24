//
//  ReportRequest.swift
//  TrailforksKitTests
//
//  Created by Arthur Dexter on 2/24/21.
//

import CoreLocation
import Foundation

public enum ReportRequest {

    public static func make(
        userId: String,
        trailId: String,
        status: Status,
        condition: Condition? = nil,
        description: String? = nil,
        marker: CLLocationCoordinate2D? = nil
    ) -> TrailforksServiceRequest<Report> {
        var parameters: [(String, String)] = [
            ("action", "add"),
            ("userid", userId),
            ("trailid", trailId),
            ("status", status.rawValue),
        ]
        if let condition = condition {
            parameters.append(("condition", condition.rawValue))
        }
        if let description = description {
            parameters.append(("description", description))
        }
        if let marker = marker {
            parameters.append(("marker", "\(marker.latitude),\(marker.longitude)"))
        }
        return TrailforksServiceRequest(
            method: "POST",
            path: "/api/1/report",
            parameters: parameters
        )
    }
}
