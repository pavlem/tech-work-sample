//
//  BaseVC.swift
//  testDaresay
//
//  Created by Pavle Mijatovic on 30/10/2019.
//  Copyright © 2019 Pavle Mijatovic. All rights reserved.
//

import Foundation
import UIKit

protocol Blurrable: BaseVC {
    func blurrBackground()
}

extension Blurrable {
    private var blurView: UIView {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    func blurrBackground() {
        guard let topPresentedViewController = UIApplication.topPresentedViewController else { return }
        topPresentedViewController.definesPresentationContext = true
        view.insertSubview(blurView, at: 0)
    }
}

// MARK: - SGAlertProtocol
extension BaseVC: DaresayAlertProtocol {
    func alertDismissed() { }
    func alertPresented() { }
}

class BaseVC: UIViewController {
    
    // MARK: - API
    func addBackButton(color: UIColor? = nil) {
        let btn = UIButton.addBackButton(color: color, btnImage: UIImage.backBtnImg, onView: self.view)
        btn.addTarget(self, action: #selector(self.backBtn), for: .touchUpInside)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        ReachabilityHelper.shared.delegate = self
    }
    
    // MARK: - Actions
    @objc func backBtn() {
        if let nc = self.navigationController {
            nc.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper
    func showDaresayAlert(text: String, isPositiveAlert: Bool = true, isDismissedAfterTimeout: Bool = false, timeoutForDismiss: Double? = nil) {
        DispatchQueue.main.async {
            let sgAlert = DaresayAlert.init(title: text, type: isPositiveAlert ? DaresayAlertType.positive : DaresayAlertType.negative, isDismissedAfterTimeout: true, timeoutForDismiss: timeoutForDismiss)
            sgAlert.delegate = self
            sgAlert.showAlert(animated: true)
        }
    }
    
    func showNoInternetAlert() {
        DispatchQueue.main.async {
            let sgAlert = DaresayAlert.init(title: "Common_NetworkError".localized, type: DaresayAlertType.negative, isDismissedAfterTimeout: true)
            sgAlert.delegate = self
            sgAlert.showAlert(animated: true)
        }
    }
}

// MARK: - ReachabilityHelperProtocol
extension BaseVC: ReachabilityHelperProtocol {
    @objc func noInternet() {
        self.showDaresayAlert(text: "Common_NetworkError".localized, isPositiveAlert: false)
        aprint("BaseVC - noInternet()")
    }
    
    @objc func online() {
        aprint("BaseVC - online()")
    }
}
