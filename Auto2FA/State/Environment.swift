//
//  Environment.swift
//  Auto2FA
//
//  Created by JT Bergman on 1/21/23.
//

import Foundation

struct Environment {
  let application: ApplicationClient
  let messages: MessageClient
  let notifications: NotificationClient
    let email: EmailClient
  let permissions: PermissionClient

  init(
    application: ApplicationClient,
    messages: MessageClient,
    notifications: NotificationClient,
    email: EmailClient,
    permissions: PermissionClient
  ) {
    self.application = application
    self.messages = messages
    self.notifications = notifications
    self.permissions = permissions
      self.email = email
  }

  static var live: Environment = {
    let application = ApplicationClient()
    let notifications = NotificationClient()
      let email = EmailClient()
    let messages = MessageClient(
      applicationClient: application,
      notificationClient: notifications,
      emailClient: email
    )
    let permissions = PermissionClient(
      messageClient: messages,
      notificationClient: notifications
    )
    return Environment(
      application: application,
      messages: messages,
      notifications: notifications,
      email: email,
      permissions: permissions
    )
  }()
}
