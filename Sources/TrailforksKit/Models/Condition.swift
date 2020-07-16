//
//  Condition.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

public enum Condition: String, Decodable {

    /// 0 - Unknown
    case unknown = "0"

    /// 1 - Snow Packed
    case snowPacked = "1"

    /// 2 - Prevalent Mud
    case prevalentMud = "2"

    /// 3 - Wet
    case wet = "3"

    /// 4 - Variable
    case variable = "4"

    /// 5 - Dry
    case dry = "5"

    /// 6 - Very Dry
    case veryDry = "6"

    /// 7 - Snow Covered
    case snowCovered = "7"

    /// 8 - Freeze/thaw Cycle
    case freezeThawCycle = "8"

    /// 9 - Icy
    case icy = "9"

    /// 10 - Snow Groomed
    case snowGroomed = "10"

    /// 11 - Ideal
    case ideal = "11"
}
