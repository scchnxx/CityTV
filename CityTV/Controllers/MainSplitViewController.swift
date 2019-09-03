import Cocoa

class MainSplitViewController: NSSplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewItems.first?.minimumThickness = 360
        splitViewItems.first?.maximumThickness = 360
    }
    
}
