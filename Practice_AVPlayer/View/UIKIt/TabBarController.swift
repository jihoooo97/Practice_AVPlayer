//
//  TabBarController.swift
//  Practice_AVPlayer
//
//  Created by 유지호 on 7/8/24.
//

import SwiftUI

public class TabBarController: UITabBarController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
        tabBar.barTintColor = .systemBackground
        
        setTab()
    }
    
    
    private func setTab() {
        let uikitView = UINavigationController(rootViewController: ViewController())
        uikitView.tabBarItem = .init(title: "UIKit", image: .init(systemName: "1.square"), tag: 0)
        
        let swiftuiView = UINavigationController(rootViewController: UIHostingController(rootView: ContentView()))
        swiftuiView.tabBarItem = .init(title: "SwiftUI", image: .init(systemName: "2.square"), tag: 1)
        
        self.setViewControllers([uikitView, swiftuiView], animated: true)
    }
    
}
