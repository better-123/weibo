//
//  PhotoBrowserAnimator.swift
//  weibo
//
//  Created by better on 2019/8/7.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit


//MARK: -面向接口开发(协议)动画弹出的接口
protocol AnimatorPresentedDelegate : NSObjectProtocol {
    func startRect(indexPath:IndexPath) -> CGRect
    func endRect(indexPath:IndexPath) -> CGRect
    func imageView(indexPath:IndexPath) -> UIImageView
}
//MARK: -面向接口开发(协议)动画消失的接口
protocol AnimatorDismissDelegate : NSObjectProtocol {
    func indexPathForDismiss() -> IndexPath
    func imageViewForDismiss() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    //MARK: -属性
    var isPresented : Bool = false
    var delegate: AnimatorPresentedDelegate?
    var dismissDelegate: AnimatorDismissDelegate?
    
    var indexPath: IndexPath?
    
}

//MARK: -转场代理方法
extension PhotoBrowserAnimator: UIViewControllerTransitioningDelegate {
    //弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
}

//MARK: - 转场动画
extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissedView(transitionContext: transitionContext)
        
    }
    ///自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        guard let delegate = delegate,let indexPath = indexPath else {
            return
        }
        //1.取出弹出view
        let presentedView = transitionContext.view(forKey: .to)
        //2.将presentedview添加到containerView中
        transitionContext.containerView.addSubview(presentedView!)
        //3执行动画
        let imageView = delegate.imageView(indexPath: indexPath)
        let startRect = delegate.startRect(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        presentedView?.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = delegate.endRect(indexPath: indexPath)
            
        }) { (_) in
            imageView.removeFromSuperview()
            presentedView?.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    ///自定义消失动画
    private func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        guard let dismissDelegate = dismissDelegate,let delegate = delegate else {
            return
        }
        //1.取出弹出view
        let dismissView = transitionContext.view(forKey: .from)
        dismissView?.removeFromSuperview()
        //2.获取执行动画的imageview
        let imageView = dismissDelegate.imageViewForDismiss()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.indexPathForDismiss()

        //3执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = delegate.startRect(indexPath: indexPath)

        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
}
