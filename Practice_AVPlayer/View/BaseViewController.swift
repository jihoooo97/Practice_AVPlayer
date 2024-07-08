//
//  BaseViewController.swift
//  Practice_AVPlayer
//
//  Created by 유지호 on 7/8/24.
//

import UIKit

open class BaseViewController: UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setUIAttributes()
        setLayout()
    }
    
    
    open func setUIAttributes() { }
    
    open func setLayout() { }
    
}
