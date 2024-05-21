//
//  EmployeeType.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import Foundation

public enum EmployeeType: String, Decodable {
  case fullTime = "FULL_TIME"
  case partTime = "PART_TIME"
  case contractor = "CONTRACTOR"

  var position: String {
    switch self {
      case .fullTime:
        return "Full Time"
      case .partTime:
        return "Part Time"
      case .contractor:
        return "Contractor"
    }
  }
}
