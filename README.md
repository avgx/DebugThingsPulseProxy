# DebugThingsPulseProxy

Optional [Pulse](https://github.com/kean/Pulse) integration for [DebugThings](https://github.com/avgx/DebugThings): persistent SwiftLog handler, network capture settings, and URL session logging adapters.

Depends on `DebugThings` and `Pulse`. Use [DebugThings](https://github.com/avgx/DebugThings) alone when you do not need Pulse.

## Product

| Product | Purpose |
|--------|---------|
| `DebugThingsPulseProxy` | `PersistentLogHandler`, `bootstrapPulse` / `bootstrapPulseAndOSLog`, `PulseNetworkCaptureSettings`, `PulseSessionEventLogger`, `StreamingSkippingURLSessionTaskLogger`. |

## SwiftPM

```swift
.package(url: "https://github.com/avgx/DebugThings.git", from: "1.0.0"),
.package(url: "https://github.com/avgx/DebugThingsPulseProxy.git", from: "1.0.0"),
```

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "DebugThings", package: "DebugThings"),
        .product(name: "DebugThingsPulseProxy", package: "DebugThingsPulseProxy"),
    ]
),
```

For local development with sibling checkouts, replace the remote URLs with `.package(path: "../DebugThings")` and `.package(path: "../DebugThingsPulseProxy")`.

## Logging bootstrap

Call **exactly one** bootstrap per process (subsequent calls are ignored).

```swift
import DebugThings
import DebugThingsPulseProxy
import Logging

DebugThings.bootstrapPulse(level: .trace)
```

```swift
DebugThings.bootstrapPulseAndOSLog(subsystem: "com.example.app", level: .trace)
```

Update capture rules when your settings UI changes:

```swift
var settings = PulseNetworkCaptureSettings.default
settings.excludedHosts = ["telemetry.example.com", "stream.example.com"]
settings.includedHosts = ["api.example.com"]
settings.applyToSharedNetworkLogger()
```

Wire URL session delegates:

```swift
let pulse = PulseSessionEventLogger()
let taskLogger = StreamingSkippingURLSessionTaskLogger(inner: pulse)
let delegate = URLSessionTaskLoggerDelegate(taskLogger: taskLogger)
let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
```

`StreamingSkippingURLSessionTaskLogger` stops forwarding response bodies to Pulse once the response looks like SSE (`text/event-stream`) or MJPEG-style multipart (`multipart/x-mixed-replace`). Combine with `excludedHosts` / `excludedURLs` for endpoints that never get a useful `Content-Type`.

## Tests

```bash
swift test
```

Some tests use a serialized suite so SwiftLog bootstrapping runs only once per test process.
