//
//  Scope.swift
//  
//
//  Created by Nikolay Fiantsev on 23.10.2019.
//

import Foundation

public enum Scope {
  /// resolve your type as a new instance every time you call resolve
  case unique
  /// container stores week reference to the resolved instance. While a strong reference to the resolved instance exists resolve will return the same instance. After the resolved instance is deallocated next resolve will produce a new instance.
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
