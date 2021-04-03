//
//  CheckmarkView.swift
//  AnimateCheckMark
//
//  Created by Duncan Champney on 4/3/21.
//

import UIKit

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

    func animateShowCheckmark(_ show: Bool) {
        guard let layer = layer as? CAShapeLayer else { return }
        let newStrokeEnd: CGFloat = show ? 1.0 : 0.0
        let oldStrokeEnd: CGFloat = show ? 0.0 : 1.0
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = oldStrokeEnd
        animation.toValue = newStrokeEnd
        animation.duration = 0.5
        layer.add(animation, forKey: nil)
        DispatchQueue.main.async {
            layer.strokeEnd = newStrokeEnd
        }
    }

    public func showCheckmark(_ checked: Bool, animated: Bool) {
        guard let layer = layer as? CAShapeLayer else { return }
        let newStrokeEnd: CGFloat = checked ?  1.0 : 0.0
        if !animated {
            layer.strokeEnd = newStrokeEnd
        } else {
            animateShowCheckmark(checked)
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
