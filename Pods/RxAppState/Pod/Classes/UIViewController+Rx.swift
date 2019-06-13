//
//  UIViewController+Rx.swift
//  Pods-RxAppState_Example
//
//  Created by Jörn Schoppe on 28.10.17.
//

import RxSwift
import RxCocoa

/**
 ViewController view states
*/
public enum ViewControllerViewState: Equatable {
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
    case viewDidLoad
    case viewDidLayoutSubviews
}

/**
 UIViewController view state changes.
 Emits a Bool value indicating whether the change was animated or not
 */

extension RxSwift.Reactive where Base: UIViewController {
    public var viewDidLoad: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in return }
    }
    
    public var viewDidLayoutSubviews: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .map { _ in return }
    }
    
    public var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewWillDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewDidDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
    }
    
    /**
     Observable sequence of the view controller's view state
     
     This gives you an observable sequence of all possible states.
     
     - returns: Observable sequence of AppStates
     */
    public var viewState: Observable<ViewControllerViewState> {
        return Observable.of(
            viewDidLoad.map {_ in return ViewControllerViewState.viewDidLoad },
            viewDidLayoutSubviews.map {_ in return ViewControllerViewState.viewDidLayoutSubviews },
            viewWillAppear.map {_ in return ViewControllerViewState.viewWillAppear },
            viewDidAppear.map {_ in return ViewControllerViewState.viewDidAppear },
            viewWillDisappear.map {_ in return ViewControllerViewState.viewWillDisappear },
            viewDidDisappear.map {_ in return ViewControllerViewState.viewDidDisappear }
            )
            .merge()
    }
}
