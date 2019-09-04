import Cocoa

class RoadCellView: NSTableCellView, ViewModelLoadable {
    
    func loadViewModel(_ vm: RoadCellViewModel) {
        textField?.stringValue = vm.name
        if let iconName = vm.iconName {
            imageView?.image = NSImage(named: iconName)
        }
    }
    
}
