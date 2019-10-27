# EasyDI

EasyDI - simple DI for my own needs, but welcome to join if you need something like that. 🙃

## Getting Started

### Registration
```swift
let container = Container()
container.register(factory: { TestClass() }, scope: .unique)
container.object(TestClass.self, implements: ProtocolA.self)
```

### Resolving
```swift
let object: ProtocolA = try! container.resolve()
```

## Author

Nikolay Fiantsev   

-- https://www.linkedin.com/in/nikolayfnv/   
-- https://www.facebook.com/NikolayFiantsev

## Contributing

- Something wrong or you need anything else? Please open an issue or make a Pull Request.
- Pull requests are welcome.

## License

EasyDI is available under the MIT license. See the LICENSE file for more info.