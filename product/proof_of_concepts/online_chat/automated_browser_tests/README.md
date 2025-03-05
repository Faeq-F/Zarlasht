## Automated Browser Tests
The project consists of tests for the project in the parent directory

### install dependencies on Linux

https://hexdocs.pm/chrobot/chrobot/install.html

### Project structure
<!-- prettier-ignore-start -->

```
root
├── src
│   └── ... (setup code)
├── test
│   ├── automated_browser_tests_test.gleam
│   │   (general page use & layout tests)
│   │
│   └── websocket_messages_test.gleam
│       (WebSocket use tests)
│
├── gleam.toml (configuration for the project)
|
└── README.md (this file)
```

<!-- prettier-ignore-end -->