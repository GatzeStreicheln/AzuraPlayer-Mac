//
//  SettingsWindowController.swift
//  AzuraPlayer Mac
//

import AppKit
import SwiftUI

@MainActor
class SettingsWindowController: NSWindowController {
    private static var instance: SettingsWindowController?
    private static var closeObserver: NSObjectProtocol?

    static func show() {
        if instance == nil {
            let win = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 720, height: 460),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            let lang = UserDefaults.standard.string(forKey: UserDefaults.Keys.appLanguage) ?? "en"
            win.title = tr("Settings", "Einstellungen", lang)
            win.isReleasedWhenClosed = false

            // NSHostingView statt NSHostingController — kein automatisches Resizing
            let hostingView = NSHostingView(
                rootView: SettingsView().environmentObject(StationStore.shared)
            )
            win.contentView = hostingView
            win.center()

            instance = SettingsWindowController(window: win)

            closeObserver = NotificationCenter.default.addObserver(
                forName: NSWindow.willCloseNotification,
                object: win,
                queue: .main
            ) { _ in
                Task { @MainActor in
                    if let token = SettingsWindowController.closeObserver {
                        NotificationCenter.default.removeObserver(token)
                        SettingsWindowController.closeObserver = nil
                    }
                    SettingsWindowController.instance = nil
                }
            }
        }

        NSApp.activate(ignoringOtherApps: true)
        instance?.window?.makeKeyAndOrderFront(nil)
    }
}
