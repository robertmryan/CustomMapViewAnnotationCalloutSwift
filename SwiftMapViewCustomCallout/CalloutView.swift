//
//  CalloutView.swift
//  SwiftMapViewCustomCallout
//
//  Created by Robert Ryan on 8/7/16.
//  Copyright © 2015-2016 Robert Ryan. All rights reserved.
//

import UIKit
import MapKit

/// This callout view is used to render a custom callout bubble for an annotation view.
/// The size of this is dictated by the constraints that are established between the
/// this callout view's `contentView` and its subviews (e.g. if those subviews have their
/// own intrinsic size). Or, alternatively, you always could define explicit width and height
/// constraints for the callout.
///
/// This is an abstract class that you won't use by itself, but rather subclass to and fill
/// with the appropriate content inside the `contentView`. But this takes care of all of the
/// rendering of the bubble around the callout.

class CalloutView: UIView {

    /// The annotation for which this callout has been created.

    weak var annotation: MKAnnotation?

    /// Shape of pointer at the bottom of the callout bubble
    ///
    /// - rounded: Circular, rounded pointer.
    /// - straight: Straight lines for pointer. The angle is measured in radians, must be greater than 0 and less than `.pi` / 2. Using `.pi / 4` yields nice 45 degree angles.

    enum BubblePointerType {
        case rounded
        case straight(angle: CGFloat)
    }

    /// Shape of pointer at bottom of the callout bubble, pointing at annotation view.

    private let bubblePointerType = BubblePointerType.rounded

    /// Insets for rounding of callout bubble's corners
    ///
    /// The "bottom" is amount of rounding for pointer at the bottom of the callout

    private let inset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)

    /// Shape layer for callout bubble

    private let bubbleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.blue.cgColor
        layer.lineWidth = 0.5
        return layer
    }()

    /// Content view for annotation callout view
    ///
    /// This establishes the constraints between the `contentView` and the `CalloutView`,
    /// leaving enough padding for the chrome of the callout bubble.

    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    init(annotation: MKAnnotation) {
        self.annotation = annotation

        super.init(frame: .zero)

        configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configure the view.

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: inset.top / 2.0),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom - inset.right / 2.0),
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset.left / 2.0),
            contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset.right / 2.0),
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: inset.left + inset.right),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: inset.top + inset.bottom)
        ])

        addBackgroundButton(to: contentView)

        layer.insertSublayer(bubbleLayer, at: 0)
    }

    // if the view is resized, update the path for the callout bubble

    override func layoutSubviews() {
        super.layoutSubviews()

        updatePath()
    }

    // Override hitTest to detect taps within our callout bubble

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let contentViewPoint = convert(point, to: contentView)
        return contentView.hitTest(contentViewPoint, with: event)
    }
}

// MARK: - Public interface

extension CalloutView {
    /// Callout tapped.
    ///
    /// If you want to detect a tap on the callout, override this method. By default, this method does nothing.
    ///
    /// - Parameter sender: The actual hidden button that was tapped, not the callout, itself.

    @objc func didTouchUpInCallout(_ sender: Any) {
        // this is intentionally blank
    }

    /// Add this `CalloutView` to an annotation view (i.e. show the callout on the map above the pin)
    ///
    /// - Parameter annotationView: The annotation to which this callout is being added.

    func add(to annotationView: MKAnnotationView) {
        annotationView.addSubview(self)

        // constraints for this callout with respect to its superview

        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: annotationView.topAnchor, constant: annotationView.calloutOffset.y),
            centerXAnchor.constraint(equalTo: annotationView.centerXAnchor, constant: annotationView.calloutOffset.x)
        ])
    }
}

// MARK: - Private methods

private extension CalloutView {

    /// Update `UIBezierPath` for callout bubble
    ///
    /// The setting of the bubblePointerType dictates whether the pointer at the bottom of the
    /// bubble has straight lines or whether it has rounded corners.

    func updatePath() {
        let path = UIBezierPath()
        var point = CGPoint(x: bounds.width - inset.right, y: bounds.height - inset.bottom)
        var controlPoint: CGPoint

        path.move(to: point)

        switch bubblePointerType {
        case .rounded:
            addRoundedCalloutPointer(to: path)

        case .straight(let angle):
            addStraightCalloutPointer(to: path, angle: angle)
        }

        // bottom left

        point.x = inset.left
        path.addLine(to: point)

        // lower left corner

        controlPoint = CGPoint(x: 0, y: bounds.height - inset.bottom)
        point = CGPoint(x: 0, y: controlPoint.y - inset.left)
        path.addQuadCurve(to: point, controlPoint: controlPoint)

        // left

        point.y = inset.top
        path.addLine(to: point)

        // top left corner

        controlPoint = CGPoint.zero
        point = CGPoint(x: inset.left, y: 0)
        path.addQuadCurve(to: point, controlPoint: controlPoint)

        // top

        point = CGPoint(x: bounds.width - inset.left, y: 0)
        path.addLine(to: point)

        // top right corner

        controlPoint = CGPoint(x: bounds.width, y: 0)
        point = CGPoint(x: bounds.width, y: inset.top)
        path.addQuadCurve(to: point, controlPoint: controlPoint)

        // right

        point = CGPoint(x: bounds.width, y: bounds.height - inset.bottom - inset.right)
        path.addLine(to: point)

        // lower right corner

        controlPoint = CGPoint(x: bounds.width, y: bounds.height - inset.bottom)
        point = CGPoint(x: bounds.width - inset.right, y: bounds.height - inset.bottom)
        path.addQuadCurve(to: point, controlPoint: controlPoint)

        path.close()

        bubbleLayer.path = path.cgPath
    }

    func addRoundedCalloutPointer(to path: UIBezierPath) {
        // lower right
        var point = CGPoint(x: bounds.width / 2.0 + inset.bottom, y: bounds.height - inset.bottom)
        path.addLine(to: point)

        // right side of arrow

        var controlPoint = CGPoint(x: bounds.width / 2.0, y: bounds.height - inset.bottom)
        point = CGPoint(x: bounds.width / 2.0, y: bounds.height)
        path.addQuadCurve(to: point, controlPoint: controlPoint)

        // left of pointer

        controlPoint = CGPoint(x: point.x, y: bounds.height - inset.bottom)
        point = CGPoint(x: point.x - inset.bottom, y: controlPoint.y)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
    }

    func addStraightCalloutPointer(to path: UIBezierPath, angle: CGFloat) {
        // lower right
        var point = CGPoint(x: bounds.width / 2.0 + tan(angle) * inset.bottom, y: bounds.height - inset.bottom)
        path.addLine(to: point)

        // right side of arrow

        point = CGPoint(x: bounds.width / 2.0, y: bounds.height)
        path.addLine(to: point)

        // left of pointer

        point = CGPoint(x: bounds.width / 2.0 - tan(angle) * inset.bottom, y: bounds.height - inset.bottom)
        path.addLine(to: point)
    }

    /// Add background button to callout
    ///
    /// This adds a button, the same size as the callout's `contentView`, to the `contentView`.
    /// The purpose of this is two-fold: First, it provides an easy method, `didTouchUpInCallout`,
    /// that you can `override` in order to detect taps on the callout. Second, by adding this
    /// button (rather than just adding a tap gesture or the like), it ensures that when you tap
    /// on the button, that it won't simultaneously register as a deselecting of the annotation,
    /// thereby dismissing the callout.
    ///
    /// This serves a similar functional purpose as `_MKSmallCalloutPassthroughButton` in the
    /// default system callout.
    ///
    /// - Parameter view: The view to which we're adding this button.

    func addBackgroundButton(to view: UIView) {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        button.addTarget(self, action: #selector(didTouchUpInCallout(_:)), for: .touchUpInside)
    }
}
