//
//  SVSliderView.swift
//  SVSlider
//
//  Created by Svetoslav Karasev on 30.08.16.
//  Copyright © 2016 svedm. All rights reserved.
//

import UIKit

@IBDesignable class SVSlider: UIControl {
    //MARK: - Private Variables
    private var slider: UIView = UIView()
    private var sliderWidthConstraint: NSLayoutConstraint!
    private var sliderPositionConstraint: NSLayoutConstraint!
    private var sliderHorizontalPaddingConstraints: [NSLayoutConstraint]!
    private var sliderVerticalPaddingConstraints: [NSLayoutConstraint]!
    private var slideInLabel: UILabel = UILabel()
    private var slideOutLabel: UILabel = UILabel()
    private var slideOutView: UIView = UIView()
    private var imageView: UIImageView = UIImageView()
    private var shouldSlide: Bool = false

    //MARK: - Public Variables
    private(set) var progress: Float = 0.0 {
        didSet {
            slideOutView.alpha = CGFloat(progress)
        }
    }

    //MARK: - IBInspectable Variables
    @IBInspectable var sliderColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            slider.backgroundColor = sliderColor
            setNeedsLayout()
        }
    }

    @IBInspectable var sliderPadding: CGFloat = 2 {
        didSet {
            for constraint in sliderHorizontalPaddingConstraints {
                constraint.constant = sliderPadding
            }

            for constraint in sliderVerticalPaddingConstraints {
                constraint.constant = sliderPadding
            }
            sliderPositionConstraint.constant = sliderPadding
            setNeedsLayout()
        }
    }

    @IBInspectable var sliderShadowColor: UIColor = UIColor.blackColor() {
        didSet {
            slider.layer.shadowColor = sliderShadowColor.CGColor
            setNeedsLayout()
        }
    }

    @IBInspectable var sliderShadowOpacity: Float = 0.5 {
        didSet {
            slider.layer.shadowOpacity = sliderShadowOpacity
            setNeedsLayout()
        }
    }

    @IBInspectable var sliderShadowOffset: CGPoint = CGPoint(x: 0, y: 2) {
        didSet {
            slider.layer.shadowOffset = CGSize(width: sliderShadowOffset.x, height: sliderShadowOffset.y)
            setNeedsLayout()
        }
    }

    @IBInspectable var sliderShadowRadius: CGFloat = 2 {
        didSet {
            slider.layer.shadowRadius = sliderShadowRadius
            setNeedsLayout()
        }
    }

    @IBInspectable var slideInTextColor: UIColor = UIColor.blackColor() {
        didSet {
            slideInLabel.textColor = slideInTextColor
            setNeedsLayout()
        }
    }

    @IBInspectable var slideOutTextColor: UIColor = UIColor.blackColor() {
        didSet {
            slideOutLabel.textColor = slideOutTextColor
            setNeedsLayout()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            slider.layer.cornerRadius = cornerRadius
            slideOutView.layer.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }

    @IBInspectable var slideInText: String = "" {
        didSet {
            slideInLabel.text = slideInText
            setNeedsLayout()
        }
    }

    @IBInspectable var slideOutText: String = "" {
        didSet {
            slideOutLabel.text = slideOutText
            setNeedsLayout()
        }
    }

    @IBInspectable var sliderWidth: CGFloat = 50.0 {
        didSet {
            sliderWidthConstraint.constant = sliderWidth
            setNeedsLayout()
        }
    }

    @IBInspectable var sliderImage: UIImage? = nil {
        didSet {
            imageView.image = sliderImage
            setNeedsLayout()
        }
    }

    @IBInspectable var sliderBackImage: UIImage? = nil

    @IBInspectable var sliderImageContentMode: UIViewContentMode = .Center {
        didSet {
            imageView.contentMode = sliderImageContentMode
            setNeedsLayout()
        }
    }

    @IBInspectable var slideInFont: UIFont = UIFont.systemFontOfSize(15) {
        didSet {
            slideInLabel.font = slideInFont
            setNeedsLayout()
        }
    }

    @IBInspectable var slideOutFont: UIFont = UIFont.systemFontOfSize(15) {
        didSet {
            slideOutLabel.font = slideOutFont
            setNeedsLayout()
        }
    }

    @IBInspectable var slideOutColor: UIColor = UIColor.greenColor() {
        didSet {
            slideOutView.backgroundColor = slideOutColor
            setNeedsLayout()
        }
    }

    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    //MARK: - Private Methods
    private func addVisualConstraints(vertical: String, horizontal: String, view: UIView, toView: UIView) {
        let veritcalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(vertical, options: [], metrics: nil, views: ["view":view])
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(horizontal, options: [], metrics: nil, views: ["view":view])
        addConstraints(veritcalConstraints)
        addConstraints(horizontalConstraints)
    }

    private func setup() {
        //Apply the custom slider styling
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        //Add slideIn label
        slideInLabel.translatesAutoresizingMaskIntoConstraints = false
        slideInLabel.textAlignment = .Center
        slideInLabel.textColor = slideInTextColor
        slideInLabel.font = slideInFont
        addSubview(slideInLabel)
        addVisualConstraints("V:|[view]|", horizontal: "H:|[view]|", view: slideInLabel, toView: self)

        //Add slideOut view
        slideOutView.translatesAutoresizingMaskIntoConstraints = false
        slideOutView.backgroundColor = slideOutColor
        slideOutView.alpha = 0
        slideOutView.layer.cornerRadius = cornerRadius
        addSubview(slideOutView)
        addVisualConstraints("V:|[view]|", horizontal: "H:|[view]|", view: slideOutView, toView: self)

        //Add slideOut label to slideOutView
        slideOutLabel.translatesAutoresizingMaskIntoConstraints = false
        slideOutLabel.textAlignment = .Center
        slideOutLabel.textColor = slideOutTextColor
        slideOutLabel.font = slideOutFont
        slideOutView.addSubview(slideOutLabel)
        addVisualConstraints("V:|[view]|", horizontal: "H:|[view]|", view: slideOutLabel, toView: slideOutView)

        //Create Slider
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.backgroundColor = sliderColor
        slider.layer.cornerRadius = cornerRadius
        slider.layer.masksToBounds = false
        slider.layer.shadowOffset = CGSize(width: sliderShadowOffset.x, height: sliderShadowOffset.y)
        slider.layer.shadowRadius = sliderShadowRadius
        slider.layer.shadowOpacity = sliderShadowOpacity
        slider.layer.shadowColor = sliderShadowColor.CGColor
        addSubview(slider)
        sliderHorizontalPaddingConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[view]->=padding-|", options: [], metrics: ["padding": sliderPadding], views: ["view": slider])
        sliderVerticalPaddingConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-padding-[view]-padding-|", options: [], metrics: ["padding": sliderPadding], views: ["view": slider])
        addConstraints(sliderVerticalPaddingConstraints)
        addConstraints(sliderHorizontalPaddingConstraints)
        sliderWidthConstraint = NSLayoutConstraint(item: slider, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: sliderWidth)
        sliderPositionConstraint = NSLayoutConstraint(item: slider, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: sliderPadding)
        addConstraint(sliderPositionConstraint)
        slider.addConstraint(sliderWidthConstraint)

        //ImageView for optional slider image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        slider.addSubview(imageView)
        imageView.contentMode = sliderImageContentMode
        imageView.image = sliderImage
        addVisualConstraints("V:|[view]|", horizontal: "H:|[view]|", view: imageView, toView: slider)

        //Add pan gesture to slide the slider view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        addGestureRecognizer(pan)
    }

    //MARK: - Public Methods
    func reset() {
        progress = 0
        sliderWidthConstraint.constant = sliderWidth
        sliderPositionConstraint.constant = sliderPadding
        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }

    func panGesture(recognizer: UIPanGestureRecognizer) {
        let x = recognizer.locationInView(self).x
        let lastPosition = bounds.size.width - sliderWidth - sliderPadding
        let startPosition = sliderPadding

        switch (recognizer.state) {
        case .Began:
            sendActionsForControlEvents(.EditingDidBegin)
            shouldSlide = x >= sliderPositionConstraint.constant - sliderPadding
                && x <= sliderPositionConstraint.constant + sliderWidth + sliderPadding
            slideInLabel.hidden = progress > 0.5
            slideOutLabel.hidden = progress < 0.5
        case .Changed:
            guard shouldSlide && x >= startPosition && x < lastPosition else { return }
            sliderPositionConstraint.constant = x
            progress = Float(x / bounds.size.width)
            sendActionsForControlEvents(.ValueChanged)
        case .Ended: fallthrough
        case .Cancelled:
            guard shouldSlide else { return }
            progress = Float(x / bounds.size.width)
            let success: Bool
            let finalX: CGFloat

            //If we are more than 50% through the swipe and moving the the right direction
            if progress > 0.5 && recognizer.velocityInView(self).x > -1 {
                success = true
                finalX = lastPosition
                imageView.image = sliderBackImage
                slideOutLabel.hidden = !success
                progress = 1
            } else {
                success = false
                finalX = startPosition
                imageView.image = sliderImage
                slideInLabel.hidden = success
                slideOutLabel.hidden = !success
                progress = 0
            }

            sliderPositionConstraint.constant = finalX
            setNeedsUpdateConstraints()

            UIView.animateWithDuration(0.25, animations: {
                self.layoutIfNeeded()
            }) { _ in
                if success {
                    if #available(iOS 9.0, *) {
                        self.sendActionsForControlEvents(.PrimaryActionTriggered)
                    }
                    self.sendActionsForControlEvents(.EditingDidEnd)
                } else {
                    self.sendActionsForControlEvents(.TouchCancel)
                }
            }
        default: break
        }

    }
}
