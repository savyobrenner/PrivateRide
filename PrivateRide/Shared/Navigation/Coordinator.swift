//
//  Coordinator.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 09/12/24.
//

import UIKit
import SwiftUI

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    var navigationController: AppNavigationController { get set }

    func start()
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func present<Content: View>(_ view: Content, animated: Bool)
    func setRootViewController<Content: View>(_ view: Content, animated: Bool)
}

extension Coordinator {
    func present<Content: View>(_ view: Content, animated: Bool) {
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: animated)
    }
    
    func present(
        _ coordinator: Coordinator,
        modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
        modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
        animated: Bool = true,
        isModalInPresentation: Bool = false,
        completion: (() -> Void)? = nil) {
            coordinator.parentCoordinator = self
            childCoordinators.append(coordinator)
            
            coordinator.navigationController.modalPresentationStyle = modalPresentationStyle
            coordinator.navigationController.modalTransitionStyle = modalTransitionStyle
            coordinator.navigationController.isModalInPresentation = isModalInPresentation
            coordinator.start()
            
            navigationController.present(coordinator.navigationController, animated: animated, completion: completion)
        }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated) { [weak self] in
            guard let self = self else { return }
            self.removeFromParent()
            completion?()
        }
    }
    
    func setRootViewController<Content: View>(_ view: Content, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: view)
        navigationController.setViewControllers([hostingController], animated: animated)
    }
    
    private func removeFromParent() {
        if let parentCoordinator = parentCoordinator {
            parentCoordinator.childCoordinators.removeAll { $0 === self }
        }
    }
}
