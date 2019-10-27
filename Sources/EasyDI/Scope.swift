//
//  Scope.swift
//  
//
//  Created by Nikolay Fiantsev on 23.10.2019.
//

import Foundation

public enum Scope {
  case unique
  case weakSingleton
}

extension Scope: CustomStringConvertible {
  public var description: String {
    switch self {
    case .unique:
      return "unique"
    case .weakSingleton:
      return "weakSingleton"
    }
  }
}
