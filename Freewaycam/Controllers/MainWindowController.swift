import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.minSize = CGSize(width: 360 + 1 + 640, height: 480)
    }

}
