//
//  EmailClient.swift
//  Auto2FA
//
//  Created by Billy Lo
//

import AppKit
import Foundation
import SendGrid

final class EmailClient {

  func sendEmail(_ code: SecurityCode) {

      guard let myApiKey = ProcessInfo.processInfo.environment["SG_API_KEY"] else {
          print("Unable to retrieve API key")
          return
      }
      Session.shared.authentication = Authentication.apiKey(myApiKey)
      
      let personalization = Personalization(recipients: "billylo1@gmail.com")
      let plainText = Content(contentType: ContentType.plainText, value: code.code)
      let htmlText = Content(contentType: ContentType.htmlText, value: "<h1>\(code.code)</h1>")
      let email = Email(
          personalizations: [personalization],
          from: "billy@evergreen-labs.com",
          content: [plainText, htmlText],
          subject: "OTP Code"
      )
      
      do {
          try Session.shared.send(request: email)
          print("sent successfully \(code.code)")

      } catch {
          print(error)
      }

  
  }

  func open(_ url: URL?) {
    url ?> { NSWorkspace.shared.open($0) }
  }

  func terminate() {
    NSApplication.shared.terminate(nil)
  }

  func showOnboardingWindow() -> NSWindow {
    let window = OnboardingWindow()
    window.screen?.visibleFrame ?> { frame in
      let offsetX = window.frame.width / 2
      let offsetY = window.frame.height / 2
      let initialPosition = CGPoint(
        x: frame.midX - offsetX,
        y: frame.midY - offsetY
      )
      window.setFrameOrigin(initialPosition)
    }
    window.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
    return window
  }
}
