import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    updateApplicationIconForAppearance()
  }

  override func applicationDidBecomeActive(_ notification: Notification) {
    super.applicationDidBecomeActive(notification)
    updateApplicationIconForAppearance()
  }

  private func updateApplicationIconForAppearance() {
    let isDark = NSApp.effectiveAppearance.bestMatch(
      from: [.darkAqua, .aqua]
    ) == .darkAqua
    let iconName = isDark ? "DarkAppIcon" : "AppIcon"

    if let icon = NSImage(named: NSImage.Name(iconName)) {
      NSApp.applicationIconImage = icon
    }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
