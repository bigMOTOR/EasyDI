//
//  DIError.swift
//  
//
//  Created by Nikolay Fiantsev on 23.10.2019.
//

import Foundation

public enum DIError: Error {
  case cannotCast(object: Any, type: Any.Type)
  case noRegisteredObjectFor(type: Any.Type)
  case noRegisteredObject(desc: String)
}

extension DIError: ErrorLocalizedDescription {
  public var description : String {
    switch self {
    case .cannotCast(let object, let type):
      return "Cannot cast: \(object) to type: \(String(describing: type))"
    case .noRegisteredObjectFor(let type):
      return "Cannot find registered object for type: \(String(describing: type))"
    case .noRegisteredObject(let desc):
      return "Cannot find registered object for type: \(desc)"
    }
  }
}

protocol ErrorLocalizedDescription: LocalizedError, CustomStringConvertible { }

extension ErrorLocalizedDescription {
  public var errorDescription: String? {
    return description
  }
}
