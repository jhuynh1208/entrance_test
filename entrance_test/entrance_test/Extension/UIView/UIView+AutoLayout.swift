import UIKit

/// AutoLayout DSL extended from https://www.swiftbysundell.com/posts/building-dsls-in-swift
protocol LayoutAnchor {
    func constraint(equalTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
}

protocol LayoutDimension: LayoutAnchor {
    func constraint(equalToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint
}

protocol AnyLayoutAnchorBox {
    func unbox<T: LayoutAnchor>() -> T?

    func constraint(equalTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint
}

struct ConcreteLayoutAnchorBox<Base: LayoutAnchor>: AnyLayoutAnchorBox {
    var base: Base

    init(_ base: Base) {
        self.base = base
    }

    func unbox<T: LayoutAnchor>() -> T? {
        return (self as AnyLayoutAnchorBox as? ConcreteLayoutAnchorBox<T>)?.base
    }

    func constraint(equalTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint {
        return base.constraint(equalTo: anchor.unbox()!, constant: constant)
    }

    func constraint(greaterThanOrEqualTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint {
        return base.constraint(greaterThanOrEqualTo: anchor.unbox()!, constant: constant)
    }

    func constraint(lessThanOrEqualTo anchor: AnyLayoutAnchorBox,
                    constant: CGFloat) -> NSLayoutConstraint {
        return base.constraint(lessThanOrEqualTo: anchor.unbox()!, constant: constant)
    }
}

struct AnyLayoutAnchor {
    private var box: AnyLayoutAnchorBox

    init<T: LayoutAnchor>(_ box: T) {
        self.box = ConcreteLayoutAnchorBox(box)
    }
}

extension AnyLayoutAnchor: LayoutAnchor {
    func constraint(equalTo anchor: AnyLayoutAnchor, constant: CGFloat) -> NSLayoutConstraint {
        return box.constraint(equalTo: anchor.box, constant: constant)
    }

    func constraint(greaterThanOrEqualTo anchor: AnyLayoutAnchor, constant: CGFloat) -> NSLayoutConstraint {
        return box.constraint(greaterThanOrEqualTo: anchor.box, constant: constant)
    }

    func constraint(lessThanOrEqualTo anchor: AnyLayoutAnchor, constant: CGFloat) -> NSLayoutConstraint {
        return box.constraint(lessThanOrEqualTo: anchor.box, constant: constant)
    }
}

extension NSLayoutAnchor: LayoutAnchor {}

extension NSLayoutDimension: LayoutDimension {}

struct LayoutProperty<Anchor: LayoutAnchor> {
    fileprivate let anchor: Anchor
}

struct DimensionProperty<Anchor: LayoutDimension> {
    let width: LayoutProperty<Anchor>
    let height: LayoutProperty<Anchor>
}

class LayoutBuilder {
    lazy var leading = property(with: view.leadingAnchor)
    lazy var trailing = property(with: view.trailingAnchor)
    lazy var top = property(with: view.topAnchor)
    lazy var bottom = property(with: view.bottomAnchor)
    lazy var width = property(with: view.widthAnchor)
    lazy var height = property(with: view.heightAnchor)
    lazy var centerX = property(with: view.centerXAnchor)
    lazy var centerY = property(with: view.centerYAnchor)
    lazy var firstBaseline = property(with: view.firstBaselineAnchor)
    lazy var lastBaseline = property(with: view.lastBaselineAnchor)
    
    lazy var edges = properties(with: view.edgesAnchor)
    lazy var center = properties(with: view.centerAnchor)
    lazy var size = DimensionProperty(width: width, height: height)

    private let view: UIView

    init(view: UIView) {
        self.view = view
    }

    private func property<Anchor: LayoutAnchor>(with anchor: Anchor) -> LayoutProperty<Anchor> {
        return LayoutProperty(anchor: anchor)
    }

    private func properties<Anchor: LayoutAnchor>(with anchors: [Anchor]) -> [LayoutProperty<Anchor>] {
        return anchors.map { LayoutProperty(anchor: $0) }
    }
}

extension LayoutProperty {
    func equal(to otherAnchor: Anchor, offset constant: CGFloat = 0) {
        anchor.constraint(equalTo: otherAnchor,
                          constant: constant).isActive = true
    }

    func greaterThanOrEqual(to otherAnchor: Anchor,
                                   offset constant: CGFloat = 0) {
        anchor.constraint(greaterThanOrEqualTo: otherAnchor,
                          constant: constant).isActive = true
    }

    func lessThanOrEqual(to otherAnchor: Anchor,
                                offset constant: CGFloat = 0) {
        anchor.constraint(lessThanOrEqualTo: otherAnchor,
                          constant: constant).isActive = true
    }
}

extension LayoutProperty where Anchor: LayoutDimension {
    func equal(toConstant constant: CGFloat) {
        anchor.constraint(equalToConstant: constant).isActive = true
    }

    func greaterThanOrEqual(toConstant constant: CGFloat) {
        anchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }

    func lessThanOrEqual(toConstant constant: CGFloat) {
        anchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
    }
}

extension UIView {
    func layout(using builder: (LayoutBuilder) -> Void) {
        self.translatesAutoresizingMaskIntoConstraints = false
        builder(LayoutBuilder(view: self))
    }

    var edgesAnchor: [AnyLayoutAnchor] {
        return [
            AnyLayoutAnchor(topAnchor),
            AnyLayoutAnchor(leadingAnchor),
            AnyLayoutAnchor(bottomAnchor),
            AnyLayoutAnchor(trailingAnchor),
        ]
    }

    var centerAnchor: [AnyLayoutAnchor] {
        return [AnyLayoutAnchor(centerXAnchor), AnyLayoutAnchor(centerYAnchor)]
    }

    var sizeAnchor: [NSLayoutDimension] {
        return [widthAnchor, heightAnchor]
    }
}

func + <Anchor: LayoutAnchor>(lhs: Anchor, rhs: CGFloat) -> (Anchor, CGFloat) {
    return (lhs, rhs)
}

func - <Anchor: LayoutAnchor>(lhs: Anchor, rhs: CGFloat) -> (Anchor, CGFloat) {
    return (lhs, -rhs)
}

func == <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: (Anchor, CGFloat)) {
    lhs.equal(to: rhs.0, offset: rhs.1)
}

func == <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: Anchor) {
    lhs.equal(to: rhs)
}

func == <Anchor: LayoutDimension>(lhs: LayoutProperty<Anchor>, rhs: CGFloat) {
    lhs.equal(toConstant: rhs)
}

func == <Anchor: LayoutDimension>(lhs: DimensionProperty<Anchor>, rhs: CGSize) {
    lhs.width.equal(toConstant: rhs.width)
    lhs.height.equal(toConstant: rhs.height)
}

func == <Anchor: LayoutDimension>(lhs: DimensionProperty<Anchor>, rhs: [Anchor]) {
    assert(rhs.count == 2, "Layout anchors count must be 2")
    lhs.width.equal(to: rhs[0])
    lhs.height.equal(to: rhs[1])
}

func == <Anchor: LayoutAnchor>(lhs: [LayoutProperty<Anchor>], rhs: [Anchor]) {
    assert(lhs.count == rhs.count, "Layout properties count must equal to anchors count")
    zip(lhs, rhs).forEach { $0.equal(to: $1) }
}

func >= <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: (Anchor, CGFloat)) {
    lhs.greaterThanOrEqual(to: rhs.0, offset: rhs.1)
}

func >= <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: Anchor) {
    lhs.greaterThanOrEqual(to: rhs)
}

func >= <Anchor: LayoutDimension>(lhs: LayoutProperty<Anchor>, rhs: CGFloat) {
    lhs.greaterThanOrEqual(toConstant: rhs)
}

func <= <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: (Anchor, CGFloat)) {
    lhs.lessThanOrEqual(to: rhs.0, offset: rhs.1)
}

func <= <Anchor: LayoutAnchor>(lhs: LayoutProperty<Anchor>, rhs: Anchor) {
    lhs.lessThanOrEqual(to: rhs)
}

func <= <Anchor: LayoutDimension>(lhs: LayoutProperty<Anchor>, rhs: CGFloat) {
    lhs.lessThanOrEqual(toConstant: rhs)
}
