//
//  ViewAwareHostingController.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI

protocol HostingControllerRootViewNameProviding {
    var rootViewName: String { get }
    
    func isSameType(with viewType: any View.Type) -> Bool
}

final class ViewAwareHostingController<V: View>: UIHostingController<V>, HostingControllerRootViewNameProviding {
    
    let rootViewName: String
    
    init(rootViewName: String, rootView: V) {
        self.rootViewName = rootViewName
        
        super.init(rootView: rootView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isSameType(with viewType: any View.Type) -> Bool {
        rootViewName == String(describing: viewType)
    }
}

