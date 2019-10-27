//
//  Container.swift
//  
//
//  Created by Nikolay Fiantsev on 23.10.2019.
//

import Foundation
import SLogger

private typealias FactoryWithScope = (factory: ()->Any, scope: Scope)

public final class Container {  
  private var _objectFactories = [String : FactoryWithScope]()
  private var _factoryAliases = [String : String]()
  private var _weakSingletonObjects = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)
  
  // MARK: - Registration
  public func register<T>(factory: @escaping ()->T, scope: Scope = .unique) {
    DILogger.log(operation: .set, for: T.self, scope: scope)
    let key = String(describing: T.self)
    
    switch !(T.self is AnyClass) && scope == .weakSingleton {
    case true:
      SLogger.warning("weakSingleton scope works only for AnyClass! Scope set to \(Scope.unique)!")
      _objectFactories[key] = (factory, .unique)
    case false:
      _objectFactories[key] = (factory, scope)
    }
  }
  
  public func register<T>(_ implements: Any.Type, factory: @escaping ()->T, scope: Scope = .unique) throws {
    if try _findFactory(for: T.self) == nil {
      register(factory: factory, scope: scope)
    }
    _factoryAliases[String(describing: implements.self)] = String(describing: T.self)
  }
  
  public func object(_ object: Any.Type, implements: Any.Type) {
    DILogger.log(operation: .set, for: implements.self)
    _factoryAliases[String(describing: implements.self)] = String(describing: object.self)
  }
    
  // MARK: - Resolving
  public func resolve<T>() throws -> T {
    DILogger.log(operation: .get, for: T.self)
    guard let resolveProspect = try _findFactory(for: T.self) else { throw DIError.noRegisteredObjectFor(type: T.self) }
    
    switch resolveProspect.scope {
    case .unique:
      let object = resolveProspect.factory()
      guard let resolvedObject = object as? T else { throw DIError.cannotCast(object: object, type: T.self) }
      return resolvedObject
    case .weakSingleton:
      return try _resolveWeakSingleton(factory: resolveProspect.factory) as! T // !!!
    }
  }
  
   // MARK: - Private Methods
  private func _resolveWeakSingleton<T>(factory: ()->T) throws -> T {
    let typeKey = String(describing: T.self) as NSString

    if let resolvedObject = _weakSingletonObjects.object(forKey: typeKey) {
      guard let object = resolvedObject as? T else { throw DIError.cannotCast(object: resolvedObject, type: T.self) }
      return object
    } else {
      let object = factory()
      guard let resolvedObject = object as? T else { throw DIError.cannotCast(object: object, type: T.self) }
      // !!!
      _weakSingletonObjects.setObject(object as AnyObject, forKey: typeKey)
      return resolvedObject
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
