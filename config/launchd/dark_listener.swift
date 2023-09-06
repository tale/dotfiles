import Cocoa

// Arguments are passed through launchd/invocation
let arguments = Array(CommandLine.arguments.dropFirst())
let snippetFile = URL(fileURLWithPath: arguments[0])
let stateFile = URL(fileURLWithPath: arguments[1])

@discardableResult
func toggleAlacritty(_ isDark: Bool) -> Int32 {
    do {
        let snippet = try String(contentsOf: snippetFile)
        let newSnippet = snippet.replacingOccurrences(
            of: "<replace>",
            with: isDark ? "dark" : "light"
        )

        try newSnippet.write(to: stateFile, atomically: true, encoding: .utf8)
    } catch {
        print("Alacritty snippet error: \(error)")
        return 1
    }

    return 0
};

func toggle() {
    let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
    toggleAlacritty(isDark)
}

DistributedNotificationCenter.default.addObserver(
    forName: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil,
    queue: nil
) { _ in
    toggle()
}

NSWorkspace.shared.notificationCenter.addObserver(
    forName: NSWorkspace.didWakeNotification,
    object: nil,
    queue: nil
) { _ in
    toggle()
}

toggle()
NSApplication.shared.run()
