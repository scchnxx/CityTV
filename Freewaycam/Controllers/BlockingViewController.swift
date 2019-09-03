import Cocoa

class BlockingViewController: NSViewController {
    
    @IBOutlet
    private weak var blockingIndicator: NSProgressIndicator!
    
    private let effectView = NSVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEffectView()
    }
    
    private func setupEffectView() {
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.blendingMode = .withinWindow
        view.addSubview(effectView, positioned: NSWindow.OrderingMode.below, relativeTo: blockingIndicator)
        effectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        effectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        effectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        effectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func startAnimation() {
        blockingIndicator.startAnimation(nil)
    }
    
    func stopAnimation() {
        blockingIndicator.stopAnimation(nil)
    }
    
}
