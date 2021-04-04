//
//  CheckmarkView.swift
//  AnimateCheckMark
//
//  Created by Duncan Champney on 4/3/21.
//

import UIKit

enum AnimationType: Int {
    case opacity = 0
    case stroke = 1
}

class CheckmarkView: UIView {

    public private (set) var checked: Bool = true



    @objc override dynamic class var layerClass: AnyClass {
    get {
            return CAShapeLayer.self
        }
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)
        (layer as! CAShapeLayer).path = checkmarkPath()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        doInitSetup()
    }

    func animateShowCheckmark(_ show: Bool, animationType: AnimationType) {
        guard let layer = layer as? CAShapeLayer else { return }
        let newStrokeEnd: CGFloat = show ? 1.0 : 0.0
        let oldStrokeEnd: CGFloat = show ? 0.0 : 1.0

        //---------------------------------------------------------------------
        //This code is only needed if you allow the user to switch animation types
        switch animationType {
        case .opacity:
            layer.strokeEnd = 1.0 // For opacity animations, make sure the strokeEnd is set to make the check visible
            layer.opacity = Float(oldStrokeEnd) //Set the opacity to the opposite of the new state so it animates correctly.
        case .stroke:
            layer.opacity = 1.0   // For stroke animations, make sure the opacity is set to make the check visible
            layer.strokeEnd = oldStrokeEnd     //Set the strokeEnd to the opposite of the new state so it animates correctly.
        }
        //---------------------------------------------------------------------
        let keyPath = animationType == .opacity ? "opacity" : "strokeEnd"
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = oldStrokeEnd
        animation.toValue = newStrokeEnd
        animation.duration = 0.3
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        layer.add(animation, forKey: nil)
        DispatchQueue.main.async {
            switch animationType {
            case .opacity:
                layer.opacity = Float(newStrokeEnd)
            case .stroke:
                layer.strokeEnd = newStrokeEnd
            }
        }
        self.checked = show
    }

    public func showCheckmark(_ checked: Bool, animated: Bool, animationType: AnimationType) {
        guard let layer = layer as? CAShapeLayer else { return }
        let newStrokeEnd: CGFloat = checked ?  1.0 : 0.0
        if !animated {
            layer.opacity = Float(newStrokeEnd)
            layer.strokeEnd = newStrokeEnd
        } else {
            animateShowCheckmark(checked, animationType: animationType)
        }
    }


    private func checkmarkPath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5, y: bounds.midY))
        path.addLine(to: CGPoint(x: 25, y: bounds.midY + 20))
        path.addLine(to: CGPoint(x: 45, y: bounds.midY - 20))
        return path.cgPath
    }

    func doInitSetup() {
        guard let layer = layer as? CAShapeLayer,
              bounds.size.height >= 50,
              bounds.size.width >= 50
        else { return }
        layer.lineWidth = 2
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.path = checkmarkPath()
    }

}
