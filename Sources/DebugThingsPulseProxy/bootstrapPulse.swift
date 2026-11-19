import Foundation
import Logging
import OSLogHandler
import DebugThings

extension DebugThings {

    /// Installs SwiftLog with ``PersistentLogHandler`` (Pulse ``LoggerStore``) and stdout.
    public static func bootstrapPulse(
        level: Logging.Logger.Level = .trace,
        metadata: Logging.Logger.Metadata? = nil
    ) {

        guard LoggingBootstrap.claimSwiftLogInstall() else { return }

        LoggingSystem.bootstrap { label in
            var handlers: [LogHandler] = []

            var pulseHandler = PersistentLogHandler(label: label)
            pulseHandler.logLevel = level
            if let metadata {
                pulseHandler.metadata = metadata
            }
            handlers.append(pulseHandler)

            var stdoutHandler = StreamLogHandler.standardOutput(label: label)
            stdoutHandler.logLevel = level
            if let metadata {
                stdoutHandler.metadata = metadata
            }
            handlers.append(stdoutHandler)

            return MultiplexLogHandler(handlers)
        }
    }

    /// Like ``bootstrapPulse(level:metadata:)`` but multiplexes Pulse with ``OSLogHandler`` instead of stdout.
    public static func bootstrapPulseAndOSLog(
        subsystem: String?,
        level: Logging.Logger.Level = .trace,
        metadata: Logging.Logger.Metadata? = nil
    ) {

        guard LoggingBootstrap.claimSwiftLogInstall() else { return }

        LoggingSystem.bootstrap { label in
            var handlers: [LogHandler] = []

            var pulseHandler = PersistentLogHandler(label: label)
            pulseHandler.logLevel = level
            if let metadata {
                pulseHandler.metadata = metadata
            }
            handlers.append(pulseHandler)

            var osLogHandler = OSLogHandler(
                subsystem: subsystem ?? Bundle.main.bundleIdentifier ?? "default",
                category: label
            )
            osLogHandler.logLevel = level
            if let metadata {
                osLogHandler.metadata = metadata
            }
            handlers.append(osLogHandler)

            return MultiplexLogHandler(handlers)
        }
    }
}
