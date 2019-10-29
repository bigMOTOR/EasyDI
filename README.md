# EasyDI

EasyDI - Dependency Injection,  simple as a railroad.
 
Digging deeper into SwiftUI I realized that I don't need all these difficulties which current Dependency Injection frameworks bring to you (all this resolving by tag from Storyboard, etc.) I decided to make it simple for my own needs and bring it to my pet-projects as experiment.

But welcome to join if you need something like that. 🙃

## Getting Started
* Start by creating `let container = Container()` and registering your dependencies, by associating a protocol or type to a factory`.
* Then you can call `container.resolve() as ProtocolA` to get your dependency using that container.
* You can easily provide scopes to tell the container how to produce instances.

<details>
<summary>Supported Scopes</summary>
  
* unique - resolve your type as a new instance every time you call resolve;
  
* weakSingleton - container stores week reference to the resolved instance. While a strong reference to the resolved instance exists resolve will return the same instance. After the resolved instance is deallocated next resolve will produce a new instance.
</details>

### Registration
```swift
let container = Container()
container.register(scope: .unique) { TestClass() }
container.object(TestClass.self, implements: ProtocolA.self)
```

### Resolving
```swift
let object: ProtocolA = try! container.resolve()
```

### Log DI Operations
Log for all DI operations can be on/off by `EasyDI.consoleLogDiOperations = false` true by default.

## Installation
EasyDI available via Swift Package Manager by url [https://github.com/bigMOTOR/EasyDI.git](https://github.com/bigMOTOR/EasyDI.git)

## Author

Nikolay Fiantsev   

- https://www.linkedin.com/in/nikolayfnv/   
- https://www.facebook.com/NikolayFiantsev

## Contributing

- Something wrong or you need anything else? Please open an issue or make a Pull Request.
- Pull requests are welcome.

## License

EasyDI is available under the MIT license. See the LICENSE file for more info.
