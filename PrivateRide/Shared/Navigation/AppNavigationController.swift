//
//  AppNavigationController.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

final class AppNavigationController: UINavigationController {

    var dismissCallback: (() -> Void)?
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        commonSetup()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        commonSetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonSetup() {
        setNavigationBarHidden(true, animated: false)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        
        dismissCallback?()
    }
}
