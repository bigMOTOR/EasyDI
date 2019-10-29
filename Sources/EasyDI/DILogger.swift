//
//  DILogger.swift
//  
//
//  Created by Nikolay Fiantsev on 23.10.2019.
//

import Foundation

struct DILogger {
  enum Operation {
    case set
    case get
    
    var description: String {
      switch self {
      case .set:
        return "➡️📦 register"
      case .get:
        return "📦➡️ resolve"
      }
    }
  }
  
  static func log(operation: Operation, for type: Any.Type, scope: Scope? = nil, comment: String = "") {
    guard EasyDI.consoleLogDiOperations else { return }
    let scopePart = scope.flatMap { " with scope: \($0)." } ?? "."
    print("\(operation.description): object for type: \(String(describing: type))\(scopePart) \(comment)")
  }
}
