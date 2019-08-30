import Cocoa

extension CCTVPreviewView {
    
    enum State {
        case loading
        case playing
        case stopped
    }
    
}

class CCTVPreviewView: NSView {
    
    private let timeoutInterval = TimeInterval(3)
    private var session: URLSession!
    private var currentDataTask: URLSessionDataTask?
    private var imageData = Data()
    private var currentCCTV: CCTV?
    private var recoveryCount = 0
    
    var didStartLoading: (() -> Void)?
    var didStart:        (() -> Void)?
    var didFailToStart:  (() -> Void)?
    var didStop:         (() -> Void)?
    
    var state = State.stopped {
        didSet {
            switch state {
            case .loading:
                didStartLoading?()
            case .playing:
                didStart?()
            case .stopped:
                (oldValue == .stopped) ? didFailToStart?() : didStop?()
            }
        }
    }
    
    var backgroundColor: NSColor? {
        get {
            guard let cgColor = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set {
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        
        wantsLayer = true
        layer?.contentsGravity = .resizeAspect
        backgroundColor = .black
    }
    
    private func isValidImageData(_ data: Data) -> Bool {
        guard data.count >= 125 else { return false }
        let endIndex = data.endIndex
        let hasSOI = data.subdata(in: 0..<2) == SOI
        let hasEOI = (data.range(of: EOI, options: .backwards, in: (endIndex - 4)..<endIndex) != nil)
        return hasSOI && hasEOI
    }
    
    private func setImage(_ image: NSImage) {
        layer?.contents = image
    }
    
    private func recover() {
        guard let cctv = currentCCTV else { return }
        let request = URLRequest(url: cctv.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        state = .loading
        currentDataTask = session.dataTask(with: request)
        currentDataTask?.resume()
    }
    
    func resume() {
        guard state != .playing else { return }
        recover()
    }
    
    func play(cctv: CCTV) {
        guard cctv != currentCCTV else {
            resume()
            return
        }
        currentCCTV = cctv
        stop()
        recover()
    }
    
    func stop() {
        guard state != .stopped, let task = currentDataTask else { return }
        currentDataTask = nil
        task.cancel()
        state = .stopped
    }
    
}

fileprivate let SOI = Data([0xFF, 0xD8])
fileprivate let EOI = Data([0xFF, 0xD9])

extension CCTVPreviewView: URLSessionDelegate, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if state != .playing {
            imageData.removeAll()
            state = .playing
        }
        imageData += data
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        if isValidImageData(imageData), let image = NSImage(data: imageData) {
            setImage(image)
        }
        imageData.removeAll()
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard task == currentDataTask else { return }
        
        if recoveryCount != 3 {
            recoveryCount += 1
            recover()
        } else {
            currentDataTask = nil
            state = .stopped
        }
    }
    
}
