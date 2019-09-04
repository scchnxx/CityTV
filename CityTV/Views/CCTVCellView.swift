import Cocoa

class CCTVCellView: NSTableCellView, ViewModelLoadable {

    var cellViewModel: CCTVCellViewModel?
    
    @IBOutlet weak var fromTextField: NSTextField!
    @IBOutlet weak var toTextField: NSTextField!
    
    func loadViewModel(_ vm: CCTVCellViewModel) {
        fromTextField.stringValue = vm.from
        toTextField.stringValue = vm.to
        if let iconName = vm.iconName {
            imageView?.image = NSImage(named: iconName)
        }
        cellViewModel = vm
    }
    
//    override func mouseDown(with event: NSEvent) {
////        super.mouseDown(with: event)
//        print(123)
//        cellViewModel?.didClick?()
//    }
    
}
