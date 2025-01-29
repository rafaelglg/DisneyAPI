//
//  Utilities.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 7/1/25.
//

import Foundation
import UIKit

struct Utilities {
    
    static func getURLPath(baseUrl: EndingPath = .basePath,
                           endingPath: EndingPath) -> String {
        "\(baseUrl.path)\(endingPath.path)"
    }
    
    /// Find the top view controller presented in the view hierarchy
    /// - Parameter controller: Receives a view
    /// - Returns: Returns the first viewController presented
    @MainActor
    static func getTopViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        let rootViewController = controller ?? keyWindow.rootViewController
        
        if let nav = rootViewController as? UINavigationController {
            return getTopViewController(controller: nav.visibleViewController)
            
        } else if let tabController = rootViewController as? UITabBarController, let selected = tabController.selectedViewController {
            return getTopViewController(controller: selected)
            
        } else if let presented = rootViewController?.presentedViewController {
            return getTopViewController(controller: presented)
        }
        
        return rootViewController
    }
}

enum EndingPath {
    
    case basePath
    case allCharacters
    case oneCharacter(id: String)
    
    var path: String {
        switch self {
        case .allCharacters:
            return "character?pageSize=7438"
        case .oneCharacter(let id):
            return "character/\(id)"
        case .basePath:
            return "https://api.disneyapi.dev/"
        }
    }
}
