//
//  BaseCoordinator.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import SwiftUI
import UIKit

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    var navigationController: AppNavigationController

    private var tasks: [Task<Void, Never>] = []
    
    init(navigationController: AppNavigationController) {
        self.navigationController = navigationController
        
        navigationController.dismissCallback = { [weak self] in
            self?.tasks.forEach { $0.cancel() }
        }
    }
    
    func start() {
        fatalError("Start method must be implemented")
    }
}

// MARK: - Helpers
extension BaseCoordinator {
    /// all the tasks spun up using this func will be automatically cancelled.
    func autoCancellingTask(body: @escaping () async -> Void) {
        let task = Task {
            await body()
        }
        
        tasks.append(task)
    }
    
    func handleError(_ error: Error) {

    }
}
