//
//  HistoryWindowController.swift
//  AzuraPlayer Mac
//

import AppKit
import SwiftUI

@MainActor
class HistoryWindowController: NSWindowController {
    private static var instance: HistoryWindowController?
    private static var closeObserver: NSObjectProtocol?

    static func show() {
        if instance == nil {
            let win = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 860, height: 580),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            let lang = UserDefaults.standard.string(forKey: UserDefaults.Keys.appLanguage) ?? "en"
            win.title = tr("History", "Verlauf", lang)
            win.isReleasedWhenClosed = false

            let hostingView = NSHostingView(rootView: HistoryView())
            win.contentView = hostingView
            win.center()

            instance = HistoryWindowController(window: win)

            closeObserver = NotificationCenter.default.addObserver(
                forName: NSWindow.willCloseNotification,
                object: win,
                queue: .main
            ) { _ in
                Task { @MainActor in
                    if let token = HistoryWindowController.closeObserver {
                        NotificationCenter.default.removeObserver(token)
                        HistoryWindowController.closeObserver = nil
                    }
                    HistoryWindowController.instance = nil
                }
            }
        }

        NSApp.activate(ignoringOtherApps: true)
        instance?.window?.makeKeyAndOrderFront(nil)
    }
}
