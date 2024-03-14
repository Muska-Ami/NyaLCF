import Cocoa
import FlutterMacOS

import bitsdojo_window_macos

class MainFlutterWindow: BitsdojoWindow {
  override func bitsdojo_window_configure() -> UInt {
    return BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP
  }

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.standardWindowButton(NSWindow.ButtonType.closeButton)?.isHidden = true
    self.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isHidden = true
    self.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
