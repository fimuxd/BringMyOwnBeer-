//
//  RxApplicationDelegateProxy.swift
//  UIApplication+Rx
//
//  Created by Jörn Schoppe on 29.02.16.
//  Copyright © 2015 Jörn Schoppe. All rights reserved.
//

import RxSwift
import RxCocoa

open class RxApplicationDelegateProxy: DelegateProxy<UIApplication, UIApplicationDelegate>, DelegateProxyType, UIApplicationDelegate {
    
    // Typed parent object.
    public weak private(set) var application: UIApplication?
    
    init(application: ParentObject) {
        self.application = application
        super.init(parentObject: application, delegateProxy: RxApplicationDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxApplicationDelegateProxy(application: $0) }
    }
    
    public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?, to object: UIApplication) {
        object.delegate = delegate
    }
    
    /**
     We have to always retain the original delegate here.
     
     Technically this creates a retain cycle. In this special case that is not a problem
     because UIApplication exists as long as the app exists anyway.
     
     It is necessary to retain the original AppDelegate because when RxApplicationDelegateProxy
     replaces the original delegate with the proxy it normally only keeps a weak reference
     to the original delegate to forward events to the original delegate.
     
     For other delegates the original delegate should not be retained because other delegates usually are
     owned by another class (often a UIViewController). In case of the default app delegate
     it is different because there is no class that owns it. When the application is initialized
     the app delegate is explicitly initialized and allocated when UIApplicationMain() is called.
     Because of this the first app delegate is released when another object is set as app delegate
     
     And that makes it necessary to retain the orignal app delegate when the proxy is set
     as new delegate.
     
     Thanks to Michał Ciuba (https://twitter.com/MichalCiuba) who suggested this approach in
     his answer to my question on Stack Overflow:
     http://stackoverflow.com/questions/35575305/transform-uiapplicationdelegate-methods-into-rxswift-observables
     */
    override open func setForwardToDelegate(_ forwardToDelegate: UIApplicationDelegate?, retainDelegate: Bool) {
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: true)
    }
    
}
