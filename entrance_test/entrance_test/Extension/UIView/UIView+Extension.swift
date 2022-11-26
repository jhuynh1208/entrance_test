import UIKit

// MARK: - instance from nib
extension UIView {
    class func instance(nibName: String) -> UIView {
        let views = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)
        return views?.first as! UIView
    }
    
    class func instanceFromNib() -> UIView {
        let className = String(describing: self)
        return instance(nibName: className)
    }
}

// MARK: - Animations
extension UIView {
    //Rotate CABasicAnimation
    func rotateInfinity(duration: Double) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2 // Minus can be Direction
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = .infinity
        self.layer.add(rotationAnimation, forKey: nil)
    }
}

// MARK: - Add/Remove
extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    func removeSubviews(_ subviews: UIView...) {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - Helper
extension UIView {
    func addToContainer(withMargin inset: UIEdgeInsets) -> UIView {
        let containerForMargin = UIView()
        containerForMargin.addSubview(self)

        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerForMargin.topAnchor, constant: inset.top ),
            self.bottomAnchor.constraint(equalTo: containerForMargin.bottomAnchor, constant: -inset.bottom ),
            self.leftAnchor.constraint(equalTo: containerForMargin.leftAnchor, constant: inset.left),
            self.rightAnchor.constraint(equalTo: containerForMargin.rightAnchor, constant: -inset.right)
        ])

        return containerForMargin
    }
}
