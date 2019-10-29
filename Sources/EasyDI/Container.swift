//
//  Container.swift
//  
//
//  Created by Nikolay Fiantsev on 23.10.2019.
//

import Foundation
import SLogger

private typealias FactoryWithScope = (factory: ()throws->Any, scope: Scope)

public final class Container {  
  private var _objectFactories = [String : FactoryWithScope]()
  private var _factoryAliases = [String : String]()
  private var _weakSingletonObjects = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)
  
  public init() {}
  
  // TODO: Add method implements which could call declarative style - container.register(factory: { TestClass() }).implements(ProtocolA.self)
  
  // MARK: - Registration
  public func register<T>(scope: Scope = .unique, factory: @escaping ()throws->T) {
    DILogger.log(operation: .set, for: T.self, scope: scope)
    let key = String(describing: T.self)
    
    switch !(T.self is AnyClass) && scope == .weakSingleton {
    case true:
      SLogger.warning("weakSingleton scope works only for classes! Scope will be \(Scope.unique)!")
      _objectFactories[key] = (factory, .unique)
    case false:
      _objectFactories[key] = (factory, scope)
    }
  }
  
  public func registerConstructor<S, T>(scope: Scope = .unique, factory: @escaping (S)->T) throws {
    DILogger.log(operation: .set, for: T.self, scope: scope, comment: "from type: \(String(describing: S.self))")
    let voidFactory: ()throws->T = { [weak self] in
      guard let wSelf = self else { throw DIError.cannotPerformFactory(type: S.self) }
      let constructorParam: S = try wSelf.resolve()
      return factory(constructorParam)
    }
    return register(scope: scope, factory: voidFactory)
  }
    
  public func object(_ object: Any.Type, implements: Any.Type) {
    DILogger.log(operation: .set, for: implements.self)
    _factoryAliases[String(describing: implements.self)] = String(describing: object.self)
  }
    
  // MARK: - Resolving
  public func resolve<T>() throws -> T {
    DILogger.log(operation: .get, for: T.self)
    guard let resolveProspect = try _findFactory(for: T.self) else { throw DIError.noRegisteredObjectFor(type: T.self) }
    
    let object = try { factoryWithScope -> Any in
      switch factoryWithScope.scope {
        case .unique:
        return try factoryWithScope.factory()
      case .weakSingleton:
        return try _resolveWeakSingleton(factory: factoryWithScope.factory)
      }
    }(resolveProspect)
    
    guard let resolvedObject = object as? T else { throw DIError.cannotCast(object: object, type: T.self) }
    return resolvedObject
  }
  
   // MARK: - Private Methods
  private func _resolveWeakSingleton<T>(factory: ()throws->T) throws -> T {
    let typeKey = String(describing: T.self) as NSString

    if let resolvedObject = _weakSingletonObjects.object(forKey: typeKey) {
      guard let object = resolvedObject as? T else { throw DIError.cannotCast(object: resolvedObject, type: T.self) }
      return object
    } else {
      let object = try factory()
      _weakSingletonObjects.setObject(object as AnyObject, forKey: typeKey)
      return object
    }
  }
  
  private func _findFactory(for type: Any.Type) throws -> FactoryWithScope? {
    let typeKey = String(describing: type)
    if let object = _objectFactories[typeKey] {
      return object
    }
    
    switch typeKey.contains("&") {
    case true:
      let key = try _factoryForConcatenate(typeKey: typeKey)
      return _objectFactories[key]
    case false:
      return _factoryAliases[typeKey].flatMap { _objectFactories[$0] }
    }
  }
  
  private func _factoryForConcatenate(typeKey: String) throws -> String {
    let typesSet = Set(
      typeKey.split(separator: "&")
        .map(String.init)
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .compactMap { _factoryAliases[$0] })
    guard let first = typesSet.first else { throw DIError.noRegisteredObject(desc: typeKey) }
    return first
  }
  
}
