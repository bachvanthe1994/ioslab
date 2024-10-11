import UIKit


protocol DualThumbSliderDelegate: AnyObject {
    func sliderValueChanged(minValue: Int, maxValue: Int)
}

class DualThumbSlider: UIView {
    
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 100
    var currentMinValue: CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    var currentMaxValue: CGFloat = 80 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var minThumbView = UIView()
    private var maxThumbView = UIView()
    private var trackLayer = CAShapeLayer()

    private var trackHeight: CGFloat = 10
    private var thumbRadius: CGFloat = 15
    
    weak var delegate: DualThumbSliderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        addGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        addGestureRecognizers()
    }
    
    private func setupLayers() {
        trackLayer.backgroundColor = UIColor.green.cgColor
        layer.addSublayer(trackLayer)
        
        // Thay đổi từ CAShapeLayer thành UIView
        minThumbView.backgroundColor = UIColor.blue
        minThumbView.layer.cornerRadius = thumbRadius
        addSubview(minThumbView)
        
        maxThumbView.backgroundColor = UIColor.red
        maxThumbView.layer.cornerRadius = thumbRadius
        addSubview(maxThumbView)
        
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawTrack()
        layoutThumbs()
    }
    
    private func drawTrack() {
        let path = UIBezierPath()
        trackLayer.path = path.cgPath
        trackLayer.frame = .init(origin: .init(x: 0, y: 0), size: frame.size)
    }
    
    private func layoutThumbs() {
        minThumbView.frame = CGRect(x: minThumbPosition() - thumbRadius, y: (frame.size.height - thumbRadius * 2) / 2, width: thumbRadius * 2, height: thumbRadius * 2)
        maxThumbView.frame = CGRect(x: maxThumbPosition() - thumbRadius, y: (frame.size.height - thumbRadius * 2) / 2, width: thumbRadius * 2, height: thumbRadius * 2)
        
        let minValue = min(currentMinValue, currentMaxValue)
        let maxValue = max(currentMinValue, currentMaxValue)
        var min = 0
        var max = 0
        
        if (minValue <= 0.5) {
            min = 0
        } else if (minValue >= 99.5) {
            min = 100
        } else {
            min = Int(minValue)
        }
        
        if (maxValue <= 0.5) {
            max = 0
        } else if (maxValue >= 99.5) {
            max = 100
        } else {
            max = Int(maxValue)
        }
        
        delegate?.sliderValueChanged(minValue: min, maxValue: max)
    }
    
    private func minThumbPosition() -> CGFloat {
        return frame.size.width * (currentMinValue - minValue) / (maxValue - minValue)
    }
    
    private func maxThumbPosition() -> CGFloat {
        return frame.size.width * (currentMaxValue - minValue) / (maxValue - minValue)
    }
    
    private func addGestureRecognizers() {
        let minPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMinThumbPan(_:)))
        minThumbView.addGestureRecognizer(minPanGesture)
        
        let maxPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMaxThumbPan(_:)))
        maxThumbView.addGestureRecognizer(maxPanGesture)
    }

    @objc private func handleMinThumbPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self) //lấy toạ độ dịch chuyển +-
        let newX = minThumbPosition() + translation.x
        var newValue = newX * (maxValue - minValue) / frame.size.width + minValue
        if (newValue < minValue) {
            newValue = minValue
        }
        if (newValue > maxValue) {
            newValue = maxValue
        }
        currentMinValue = newValue
        gesture.setTranslation(.zero, in: self) //reset gesture
        layoutThumbs()
    }
    
    @objc private func handleMaxThumbPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self) //lấy toạ độ dịch chuyển +-
        let newX = maxThumbPosition() + translation.x
        var newValue = newX * (maxValue - minValue) / frame.size.width + minValue
        if (newValue < minValue) {
            newValue = minValue
        }
        if (newValue > maxValue) {
            newValue = maxValue
        }
        currentMaxValue = newValue
        gesture.setTranslation(.zero, in: self) //reset gesture
        layoutThumbs()
    }
}
