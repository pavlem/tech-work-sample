//
//  UIImage+Icons.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import UIKit

protocol DaresayAlertProtocol: class  {
    func alertDismissed()
    func alertPresented()
}

enum DaresayAlertType {
    case positive
    case negative
}

class DaresayAlert: UIView {
    
    // MARK: - API
    weak var delegate: DaresayAlertProtocol?
    
    func showAlert(animated: Bool) {
        show(animated: animated)
    }
    
    func dismissAlert(animated: Bool) {
        dismiss(animated: animated)
    }
    
    var timeoutForDismiss: Double?
    
    // MARK: - Properties
    private var backgroundView = UIView()
    private var infoView = UIView()
    
    // MARK: Vars
    private var dismissTimer: Timer?
    // MARK: Constants
    private let animationDuration = 0.3
    private let defaultTimeoutForDismiss = 3.0
    private let lblPadding = CGFloat(30)
    private let imageHeightAndWidth = CGFloat(45)
    private let paddingBetweenImgAndLbl = CGFloat(21)

    // MARK: Calculated
    private var imgViewTopPadding: CGFloat {
        return UIApplication.keyWindow?.safeAreaInsets.top ?? 0
    }
    
    // MARK: - Inits
    convenience init(title: String, type: DaresayAlertType? = .positive, isDismissedAfterTimeout: Bool = false, timeoutForDismiss: Double? = nil) {
        self.init(frame: UIScreen.main.bounds)
        
        initialize(title: title, type: type)
        
        if isDismissedAfterTimeout {
            if timeoutForDismiss != nil {
                self.timeoutForDismiss = timeoutForDismiss!
            }
            addDissmissTimer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        self.dismissTimer?.invalidate()
    }
    
    // MARK: - Helper
    func initialize(title: String, type: DaresayAlertType? = .positive) {
        setBackgroundView()
        setInfoView(type: type!)
        let imageView = addImageView(type: type!, toView: infoView)
        let titleLabel = addTitleLbl(type: type!, title: title, imageView: imageView, toView: self.infoView)
        imageView.center = CGPoint(x: self.infoView.bounds.midX, y: self.infoView.bounds.midY);
        imageView.frame.origin.y = imgViewTopPadding
        let dialogViewHeight = imageView.frame.origin.y + imageView.frame.height + 21 + titleLabel.frame.height + 10
        infoView.frame.size.height = dialogViewHeight
        self.infoView.frame.origin.y =  -self.infoView.frame.size.height
    }
    
    func setInfoView(type: DaresayAlertType, toView view: UIView? = nil) {
        infoView.clipsToBounds = true
        infoView.frame.size = CGSize(width: frame.width, height: 0)
        infoView.backgroundColor = color(forType: type)
        infoView.alpha = 0.0
        
        if view != nil {
            view!.addSubview(infoView)
        } else {
            addSubview(infoView)
        }
    }
    
    func addImageView(type: DaresayAlertType, toView view: UIView) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image(forType: type)
        imageView.frame.size.height = imageHeightAndWidth
        imageView.frame.size.width = imageView.frame.size.height
        imageView.frame.origin.y = imgViewTopPadding
        imageView.clipsToBounds = true
        
        view.addSubview(imageView)
        return imageView
    }
    
    func addTitleLbl(type: DaresayAlertType, title: String, imageView: UIImageView, toView view: UIView) -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width - (lblPadding * 2), height: 0))
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.center = infoView.center
        titleLabel.frame.origin.y = imageView.frame.origin.y + imageView.frame.height + paddingBetweenImgAndLbl
        
        view.addSubview(titleLabel)
        return titleLabel
    }
    
    func image(forType type: DaresayAlertType) -> UIImage {
        switch type {
        case .positive:
            return UIImage.SGAlert.positiveImg
        case .negative:
            return UIImage.SGAlert.negativeImg
        }
    }
    
    func color(forType type: DaresayAlertType) -> UIColor {
        switch type {
        case .positive:
            return UIColor(red: 64/255, green: 152/255, blue: 75/255, alpha: 1)
        case .negative:
            return UIColor(red: 185/255, green: 68/255, blue: 75/255, alpha: 1)
        }
    }
    
    func addDissmissTimer() {
        self.dismissTimer = Timer.scheduledTimer(timeInterval: timeoutForDismiss ?? defaultTimeoutForDismiss, target: self, selector: #selector(self.closeToast), userInfo: nil, repeats: false)
    }
    
    func setBackgroundView() {
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.alpha = 0.0
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        backgroundView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.backgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.addSubview(blurEffectView)
    }
    
    // MARK: - Actions
    @objc func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func didTappedOnBackgroundView() {
        dismiss(animated: true)
    }
    
    @objc func closeToast(timer: Timer) {
        dismiss(animated: true)
    }
    
    // MARK: - Helper - Actions
    private func show(animated: Bool) {
        
        if var topController = UIApplication.shared.delegate?.window??.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.view.addSubview(self)
        }
        
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.infoView.frame.origin.y = 0
                self.backgroundView.alpha = 1.0
                self.infoView.alpha = 1.0
                self.delegate?.alertPresented()
            })
        } else {
            self.backgroundView.alpha = 1.0
            self.backgroundView.frame.origin.y =  0
            self.delegate?.alertPresented()
        }
    }
    
    private func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.infoView.frame.origin.y =  -self.infoView.frame.size.height
                self.backgroundView.alpha = 0.0
                self.infoView.alpha = 0.0
            }, completion: { (completed) in
                self.removeFromSuperview()
                self.delegate?.alertDismissed()
            })
        } else {
            self.removeFromSuperview()
            self.delegate?.alertDismissed()
        }
    }
}
