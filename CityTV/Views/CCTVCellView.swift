import Cocoa

class CCTVCellView: NSTableCellView {

    var cellViewModel: CCTVCellViewModel?
    
    @IBOutlet weak var fromTextField: NSTextField!
    @IBOutlet weak var toTextField: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func loadCellViewModel(_ vm: CCTVCellViewModel) {
        fromTextField.stringValue = vm.from
        toTextField.stringValue = vm.to
        imageView?.image = #imageLiteral(resourceName: "CCTV")
        cellViewModel = vm
    }
    
//    override func mouseDown(with event: NSEvent) {
////        super.mouseDown(with: event)
//        print(123)
//        cellViewModel?.didClick?()
//    }
    
}
