# encoding: utf-8

require "apns"

APNS.host = 'gateway.sandbox.push.apple.com'

APNS.pem =  "lib/pem/timenotePushDev.pem"

APNS.port = 2195

device_token = "652ecbc39b5f86e12865aed6ad3d687511eb16e64b480f9dbeef04156fd29e74"

APNS.send_notification(device_token, :alert => 'shy分享了一张照片给你。', :badge => 1, :sound => 'default', :other => {:sent => 'with apns gem'})

=begin
require "grocer"

pusher = Grocer.pusher(
  certificate: "/Users/xjp/timenotePushDev.pem",      # required
  passphrase:  "",                       # optional
  gateway:     "gateway.sandbox.push.apple.com", # optional; See note below.
  port:        2195,                     # optional
  retries:     3                         # optional
)

notification = Grocer::Notification.new(
  device_token: "652ecbc39b5f86e12865aed6ad3d687511eb16e64b480f9dbeef04156fd29e74",
  alert:        "test push",
  badge:        44,
  sound:        "siren.aiff",         # optional
  expiry:       Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
  identifier:   1234                  # optional
)

pusher.push(notification)
=end