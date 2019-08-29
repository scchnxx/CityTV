import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var previewView: CCTVPreviewView!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var pauseButton: NSButton!
    @IBOutlet weak var resumeButton: NSButton!
    
    let loader = CCTVDataLoader()
    
    var value: CCTVData.Value?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.fetch(type: .value) { result in
            if case .success(let cctvData) = result {
                if let values = cctvData.values, values.count > 55 {
                    self.value = values[55]
                    return
                }
            }
            self.startButton.isEnabled = false
        }
        
        previewView.didStart = { [unowned self] in
            [self.stopButton, self.pauseButton].forEach { $0?.isEnabled = true }
            self.resumeButton.isEnabled = false
        }
        
        previewView.didPause = { [unowned self] in
            self.pauseButton.isEnabled.toggle()
            self.resumeButton.isEnabled.toggle()
        }
        
        previewView.didResume = { [unowned self] in
            self.pauseButton.isEnabled.toggle()
            self.resumeButton.isEnabled.toggle()
        }
        
        previewView.didStop = { [unowned self] in
            [self.stopButton, self.resumeButton, self.pauseButton].forEach { $0?.isEnabled = false }
        }
        
        previewView.didStop?()
    }

    @IBAction func play(_ sender: Any) {
        guard let value = value else { return }
        previewView.play(with: value)
    }
    
    @IBAction func stop(_ sender: Any) {
        previewView.stop()
    }
    
    @IBAction func pause(_ sender: Any) {
        previewView.pause()
    }
    
    @IBAction func resume(_ sender: Any) {
        previewView.resume()
    }
    
}

