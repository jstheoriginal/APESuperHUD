// HudView.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 apegroup
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class HudView: UIView {
    
    internal let hudMessageView: UIView
    internal let iconImageView: UIImageView
    internal let loadingActivityIndicator: UIActivityIndicatorView
    internal let informationLabel: UILabel
    internal var iconImageWidthConstraint: NSLayoutConstraint!
    internal var iconImageHeightConstraint: NSLayoutConstraint!
    internal var hudHeightConstraint: NSLayoutConstraint!
    internal var hudWidthConstraint: NSLayoutConstraint!
    
    var isActivityIndicatorSpinnning: Bool {

        get {
            return self.loadingActivityIndicator.isAnimating
        }

    }
    
    var isActiveTimer: Bool = false {
        willSet {
            if !newValue {
                timer.invalidate()
            }
        }
    }

    private var isAnimating: Bool = false
    private var timer = Timer()
    private var loadingMessagesHandler: LoadingMessagesHandler!
    private var blurEffectView: UIView?
    
    internal override init(frame: CGRect) {
        hudMessageView = UIView(frame: CGRect(x: 0, y: 0, width: 144, height: 144))
        hudMessageView.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loadingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        informationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 144, height: 16))
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.textAlignment = .center
        informationLabel.numberOfLines = 0
        
        hudMessageView.addSubview(iconImageView)
        hudMessageView.addSubview(loadingActivityIndicator)
        hudMessageView.addSubview(informationLabel)
        
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.addSubview(hudMessageView)
        self.generateConstraints()
        self.setupGestureRecognizers()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateConstraints() {
        self.generateMessageViewConstraints()
        self.generateIconConstraints()
        self.generateLoadingIndicatorConstraints()
        self.generateLabelConstraints()
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HudView.tapGestureRecognized(sender:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func generateMessageViewConstraints() {
        let centerXConstraint = NSLayoutConstraint(item: hudMessageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: hudMessageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: hudMessageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 144)
        let heightConstraint = NSLayoutConstraint(item: hudMessageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 144)
        
        widthConstraint.priority = UILayoutPriorityRequired - 1
        heightConstraint.priority = UILayoutPriorityRequired - 1
        
        [centerXConstraint, centerYConstraint, widthConstraint, heightConstraint].forEach {
            $0.isActive = true
        }
        
        hudWidthConstraint = widthConstraint
        hudHeightConstraint = heightConstraint
    }
    
    private func generateIconConstraints() {
        let centerXConstraint = NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: hudMessageView, attribute: .centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: iconImageView, attribute: .top, relatedBy: .equal, toItem: hudMessageView, attribute: .top, multiplier: 1, constant: 30)
        let widthConstraint = NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48)
        let heightConstraint = NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48)
        
        [centerXConstraint, topConstraint, widthConstraint, heightConstraint].forEach {
            $0.isActive = true
        }
        
        iconImageWidthConstraint = widthConstraint
        iconImageHeightConstraint = heightConstraint
    }
    
    private func generateLoadingIndicatorConstraints() {
        let centerXConstraint = NSLayoutConstraint(item: loadingActivityIndicator, attribute: .centerX, relatedBy: .equal, toItem: iconImageView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: loadingActivityIndicator, attribute: .centerY, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: loadingActivityIndicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48)
        let heightConstraint = NSLayoutConstraint(item: loadingActivityIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48)
        
        [centerXConstraint, centerYConstraint, widthConstraint, heightConstraint].forEach {
            $0.isActive = true
        }
    }
    
    private func generateLabelConstraints() {
        let topConstraint = NSLayoutConstraint(item: informationLabel, attribute: .top, relatedBy: .equal, toItem: iconImageView, attribute: .bottom, multiplier: 1, constant: 8)
        let bottomConstraint = NSLayoutConstraint(item: informationLabel, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: hudMessageView, attribute: .bottom, multiplier: 1, constant: -18)
        let leadingConstraint = NSLayoutConstraint(item: informationLabel, attribute: .leading, relatedBy: .equal, toItem: hudMessageView, attribute: .leading, multiplier: 1, constant: 5)
        let trailingConstraint = NSLayoutConstraint(item: informationLabel, attribute: .trailing, relatedBy: .equal, toItem: hudMessageView, attribute: .trailing, multiplier: 1, constant: -5)
        
        [topConstraint, bottomConstraint, leadingConstraint, trailingConstraint].forEach {
            $0.isActive = true
        }
        
        informationLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
    }
}


extension HudView {
    
    static func create() -> HudView {
        
        let view: HudView = HudView(frame: UIScreen.main.bounds)
        
        // Colors
        view.informationLabel.textColor = APESuperHUD.appearance.textColor
        view.hudMessageView.backgroundColor = APESuperHUD.appearance.foregroundColor
        view.backgroundColor = APESuperHUD.appearance.backgroundColor
        view.iconImageView.tintColor = APESuperHUD.appearance.iconColor
        view.loadingActivityIndicator.color = APESuperHUD.appearance.loadingActivityIndicatorColor

        // Corner radius
        view.hudMessageView.layer.cornerRadius = CGFloat(APESuperHUD.appearance.cornerRadius)
        
        // Shadow
        if APESuperHUD.appearance.shadow {
            view.hudMessageView.layer.shadowColor = UIColor.black.cgColor
            view.hudMessageView.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.hudMessageView.layer.shadowRadius = 6.0
            view.hudMessageView.layer.shadowOpacity = 0.15
        }
        
        // Font
        let font = UIFont(name: APESuperHUD.appearance.fontName, size: APESuperHUD.appearance.fontSize)
        view.informationLabel.font = font
        
        return view
    }
    
    func deviceOrientationDidChange() {
        frame = (superview?.bounds)!
        blurEffectView?.frame = (superview?.bounds)!

        layoutIfNeeded()
    }

    func removeHud(animated: Bool, onDone: ((Void) -> Void)?) {

        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        timer.invalidate()
        
        if animated {
            animateOutHud(completion: { [weak self] _ in
                
                self?.blurEffectView?.removeFromSuperview()
                self?.removeFromSuperview()
                
                onDone?()

            })

        } else {
            
            self.blurEffectView?.removeFromSuperview()
            self.removeFromSuperview()
            
            onDone?()

        }

    }
    
    func showMessages(messages: [String]) {
        loadingMessagesHandler = LoadingMessagesHandler(messages: messages)
        let showMessagesSelector = #selector(showMessages as (Void) -> Void)
        showMessages()
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: showMessagesSelector, userInfo: nil, repeats: true)
    }
    
    func showMessages() {
        let message = loadingMessagesHandler.firstMessage()
        if isActiveTimer {
            hideViewsAnimated(views: [informationLabel], completion: { [weak self] in
                self?.showLoadingActivityIndicator(text: message, completion: nil)
            })
        }
    }
    
    func showFunnyMessages(languageType: LanguageType) {
        loadingMessagesHandler = LoadingMessagesHandler(languageType: languageType)
        let showFunnyMessagesSelector = #selector(showFunnyMessages as (Void) -> Void)
        showFunnyMessages()
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: showFunnyMessagesSelector, userInfo: nil, repeats: true)
    }
    
    func showFunnyMessages() {
        let funnyMessage = loadingMessagesHandler.randomMessage()
        if isActiveTimer {
            hideViewsAnimated(views: [informationLabel], completion: { [weak self] in
                self?.showLoadingActivityIndicator(text: funnyMessage, completion: nil)
            })
        }
    }

    func showLoadingActivityIndicator(text: String?, completion: (() -> Void)?) {

        iconImageView.alpha = 0.0
        informationLabel.text = text ?? ""

        loadingActivityIndicator.startAnimating()

        showViewsAnimated(views: [loadingActivityIndicator, informationLabel], completion: { _ in

            completion?()

        })

    }

    func hideLoadingActivityIndicator(completion: (() -> Void)?) {

        hideViewsAnimated(views: [loadingActivityIndicator, informationLabel], completion: { [weak self] _ in

            self?.loadingActivityIndicator.stopAnimating()

            completion?()

        })

    }

    func showMessage(message: String?, icon: UIImage?, completion: (() -> Void)?) {

        informationLabel.text = message

        if icon != nil {
            alpha = 1.0
            iconImageView.image = icon
            loadingActivityIndicator.alpha = 0
            loadingActivityIndicator.stopAnimating()
        }

        showViewsAnimated(views: [informationLabel, iconImageView], completion: { _ in

            completion?()

        })

    }
}


// MARK: - Lifecycle

extension HudView {

    override internal func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let bounds = newSuperview?.bounds {
            frame = bounds
            
            if addBlurEffectView() != nil {
                backgroundColor = UIColor.clear
                blurEffectView = addBlurEffectView()
                insertSubview(blurEffectView!, at: 0)
            }

            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
            
            // HUD Size
            if APESuperHUD.appearance.hudSquareSize < frame.width && APESuperHUD.appearance.hudSquareSize < frame.height {
                hudWidthConstraint.constant = APESuperHUD.appearance.hudSquareSize
                hudHeightConstraint.constant = APESuperHUD.appearance.hudSquareSize
            
            } else {
                let size = frame.width <= frame.height ? frame.width : frame.height
                hudWidthConstraint.constant = size
                hudHeightConstraint.constant = size
            }
            
            // Icon size
            iconImageWidthConstraint.constant = APESuperHUD.appearance.iconWidth
            iconImageHeightConstraint.constant = APESuperHUD.appearance.iconHeight
        }

    }

    override internal func didMoveToSuperview() {
        super.didMoveToSuperview()

        setupDefaultState()

        animateInHud(completion: { _ in

        })

    }
}


// MARK: - Setup

extension HudView {

    private func setupDefaultState() {

        alpha = 0.0
        hudMessageView.alpha = 0.0
        informationLabel.alpha = 0.0
        iconImageView.alpha = 0.0
        loadingActivityIndicator.alpha = 0.0
        loadingActivityIndicator.stopAnimating()

        layoutIfNeeded()

    }
    
    private func addBlurEffectView() -> UIView? {
        
        var blurEffect: UIBlurEffect?
   
        switch APESuperHUD.appearance.backgroundBlurEffect {
            
        case .Dark:
            blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.dark)
            
        case .Light:
            blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.light)
            
        case .ExtraLight:
            blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            
        case .None:
            
          return nil
            
        }
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        
        return blurEffectView
        
    }

}


// MARK: - User Interactions
extension HudView {
    
    @IBAction func tapGestureRecognized(sender: AnyObject) {
        
        if APESuperHUD.appearance.cancelableOnTouch {
            removeHud(animated: true, onDone: nil)
        }
        
    }
    
}


// MARK: - Animations

extension HudView {

    private func animateInHud(completion: () -> Void ) {

        hudMessageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        layoutIfNeeded()

        UIView.animate(withDuration: APESuperHUD.appearance.animateInTime, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: { [weak self] _ in

            self?.hudMessageView.alpha = 1.0
            self?.alpha = 1.0
            self?.hudMessageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            self?.layoutIfNeeded()

            }, completion: { _ in

                completion()
        })

    }

    private func animateOutHud(completion: () -> Void) {

        let delay: TimeInterval = isAnimating ? (APESuperHUD.appearance.animateInTime + 0.1) : 0

        isAnimating = true

        UIView.animate(withDuration: APESuperHUD.appearance.animateOutTime, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: { [weak self] _ in

            self?.alpha = 0.0

            }, completion: { [weak self] _ in

                self?.isAnimating = false
                completion()

            })

    }

    /**
     Animates in a array of views.
     
     - parameter views: the array of views to animate in
     - parameter completion: The completion block that will be trigger when the animation of views are finished
     
    */
    private func showViewsAnimated(views: [UIView], completion: () -> Void ) {

        let delay: TimeInterval = isAnimating ? APESuperHUD.appearance.animateInTime : 0

        isAnimating = true

        UIView.animate(withDuration: APESuperHUD.appearance.animateOutTime, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {

            for view in views {
                view.alpha = 1.0
            }

            }, completion: { [weak self] _ in

                self?.isAnimating = false
                completion()

            })

    }

    /**
     Animates out a array of views.
     
     - parameter views: the array of views to animate ot
     - parameter completion: The completion block that will be trigger when the animation of views are finished
     
    */
    private func hideViewsAnimated(views: [UIView], completion: () -> Void ) {

        let delay: TimeInterval = isAnimating ? APESuperHUD.appearance.animateInTime : 0

        runWithDelay(delay: delay + 0.1, closure: { [weak self] in

            self?.isAnimating = true

            UIView.animate(withDuration: APESuperHUD.appearance.animateOutTime, animations: {

                for view in views {
                    view.alpha = 0.0
                }

                }, completion: { [weak self] _ in

                    self?.isAnimating = false
                    completion()

            })

        })

    }

}
