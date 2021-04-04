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

///This class creates a view with a shape layer containing a checkmark, and has a function `showCheckmark(_:Bool, animated: Bool, animationType: AnimationType)` that will show or hide the checkmark with optional stroke or alpha animation.
class CheckmarkView: UIView {

    /// This enum is used to specify the timing curve to use when animiating the showing/hiding of the checkmark.
    enum AnimationCurve: Int {
        case linear = 0
        case easeInEaseOut = 1
    }

    /// Interrogate this property to determine of the checkmark is currently shown. (If the view is "checked")
    public private (set) var checked: Bool = true

    /// This variable determines the animation timing curve used for both the alpha and strokeEnd animations. It defaults to linear animation timing
    public var animationCurve: AnimationCurve = .linear

    /// This variable determines the animation duration used for both the alpha and strokeEnd animations.
    public var animationDuration = 0.3

    /// This declaration changes the type of the view's "backing layer" to be a `CAShapeLayer` instead of a regular `CALayer`
    @objc override dynamic class var layerClass: AnyClass {
    get {
            return CAShapeLayer.self
        }
    }

    /**
    This function animates showing or hiding the checkmark view's layer by animating the layer's strokeEnd property. It uses the instance variable animationCurve to determine the animation timing (.linear or .easeInEaseOut). Normally you would not call this function directly, but would call `showCheckmark(_:animated:animationType:)` instead
     - Parameter show: If true, show the layer. If false, hide it
    */
    public func animateCheckmarkStrokeEnd(_ show: Bool) {
        guard let layer = layer as? CAShapeLayer else { return }
        let newStrokeEnd: CGFloat = show ? 1.0 : 0.0
        let oldStrokeEnd: CGFloat = show ? 0.0 : 1.0

        let keyPath = "strokeEnd"
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = oldStrokeEnd
        animation.toValue = newStrokeEnd
        animation.duration = animationDuration
        let timingFunction: CAMediaTimingFunction
        if animationCurve == .linear {
            timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        } else {
            timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        animation.timingFunction = timingFunction
        layer.add(animation, forKey: nil)
        DispatchQueue.main.async {
            layer.strokeEnd = newStrokeEnd
        }
        self.checked = show
    }

    /**
    This function animates showing or hiding the checkmark view by animating the view's alpha property. It uses the instance variable animationCurve to determine the animation timing curve (.curveLinear or .curveEaseInOut)
     - Parameter show: If true, show the layer. If false, hide it
    */
    public func animateCheckmarkAlpha(_ checked: Bool) {
        var animationOptions: UIView.AnimationOptions
        if animationCurve == .linear {
            animationOptions = .curveLinear
        } else {
            animationOptions = .curveEaseInOut
        }
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: animationOptions,
                       animations: {
                        let newAlpha: CGFloat = checked ? 1.0 : 0.0
                        self.alpha = newAlpha
                       }
        )
    }

    /**
    This function will show/hide the checkmark, with or without animation. If animated == true, it uses the animationType parameter to determine if it should animate the opacity or the stroking of the checkmark. It uses the current value of the animationCurve and animationDuration properties.
     - Parameter checked: If true, show the checkmark. If false, hide it.
     - Parameter animated: if true, show/hide the checkmark with animation. If false, show/hide the checkmark without animation.
     - Parameter animationType: If animated == true, specifies the type of animation to use (alpha or stroke animation). This parameter is ignored if animated = false
    */
    public func showCheckmark(_ checked: Bool, animated: Bool, animationType: AnimationType) {
        guard let layer = layer as? CAShapeLayer else { return }
        let newStrokeEnd: CGFloat = checked ?  1.0 : 0.0
        //---------------------------------------------------------------------
        //This code is only needed if you allow the user to switch animation types
        let oldStrokeEnd: CGFloat = checked ? 0.0 : 1.0

        switch animationType {
        case .opacity:
            layer.strokeEnd = 1.0 // For opacity animations, make sure the strokeEnd is set to make the check visible
            alpha = oldStrokeEnd
        case .stroke:
            alpha = 1.0
            layer.strokeEnd = oldStrokeEnd
        }
        //---------------------------------------------------------------------

        if !animated {
            alpha = newStrokeEnd
            layer.strokeEnd = newStrokeEnd
        } else {
            if animationType == .stroke {
                animateCheckmarkStrokeEnd(checked)
            } else {

                animateCheckmarkAlpha(checked)
            }
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

    override required init(frame: CGRect) {
        super.init(frame: frame)
        doInitSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        doInitSetup()
    }


}
