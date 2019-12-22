//
//  OptionalProtocol.swift
//  
//
//  Created by Nikolay Fiantsev on 22.12.2019.
//

import Foundation

protocol OptionalProtocol {
  static var wrappedType: Any.Type { get }
}

extension Optional: OptionalProtocol {
  static var wrappedType: Any.Type { return Wrapped.self }
}

func wrappedTypeFromOptionalType(_ type: Any.Type) -> Any.Type? {
  return (type as? OptionalProtocol.Type)?.wrappedType
}
