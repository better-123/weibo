//
//  PopoverAnimator.swift
//  weibo
//
//  Created by better on 2019/7/24.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    
    //MARK: - 属性
    var isPresented : Bool = false
    
    //Mark: - 对外提供属性
    var presentedFrame : CGRect = CGRect.zero
    
    var callBack:((_ isPresented:Bool)->())?
    //注意:如果自定义了一个构造函数,但是没有对默认的构造函数init(),进行重写,那么自定义的构造函数会覆盖默认的init()构造函数
    override init() {
        
    }
    init(callBack : @escaping (_ isPresented :Bool) -> ()) {
        self.callBack = callBack
    }
    
    
}
//MARK: - 自定义转场代理方法(自定义转场,系统不会帮我们做一些事情了)
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    //MARK: - 自定义转场协议
    ///改变弹出控制器尺寸大小的方法
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = WZPresntationController(presentedViewController: presented, presenting: presenting)
        //设置弹出view的frame
        presentation.presentedFrame = presentedFrame
        //要改变尺寸,就自定义一个UIPresentationController类
        return presentation
    }
    ///自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        //调用闭包(如果要调用一个闭包,这个闭包不能是一个可选类型,要保证它有值,所以这里我们要强制解包)
        callBack!(isPresented)
        return self
    }
    ///自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        //调用闭包(如果要调用一个闭包,这个闭包不能是一个可选类型,要保证它有值,所以这里我们要强制解包)
        callBack!(isPresented)
        return self
    }
}

//MARK: - 弹出和消失View动画方法
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    
    ///动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    ///动画执行方式,以及属性设置
    //transitionContext:转场上下文,可以通过转场上下文获取弹出的view和消失的view
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissedView(transitionContext: transitionContext)
    }
    
    ///自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        print("弹出动画")
        //1获取弹出的view
        //UITransitionContextFromViewKey:获取消失view,UITransitionContextToViewKey:获取弹出view
        let presentedView = transitionContext.view(forKey: .to)
        
        //2将弹出的view添加到containerView中
        transitionContext.containerView.addSubview(presentedView!)
        //3执行动画(x方向不变,y方向变大)
        presentedView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
        //设置锚点(动画开始执行的地方)
        presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            //恢复view原本的样子
            presentedView?.transform = CGAffineTransform.identity
        }) { (isFinished : Bool) in
            //isFinished随便取的名字,如果后面不用这个参数,可以用_代替
            //告诉转场上下文动画执行已经完成
            transitionContext.completeTransition(true)
        }
    }
    ///自定义消失动画
    private func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        print("消失动画")
        //1获取消失的view
        //UITransitionContextFromViewKey:获取消失view,UITransitionContextToViewKey:获取弹出view
        let dismissView = transitionContext.view(forKey: .from)
        
        //2执行动画(x方向不变,y方向变大)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0001)
        }) { (isFinished : Bool) in
            //从父控件移除view
            dismissView?.removeFromSuperview()
            //修改按钮状态为为选择状态
//            self.navTitleBtn.isSelected = false
            //isFinished随便取的名字,如果后面不用这个参数,可以用_代替
            //告诉转场上下文动画执行已经完成
            transitionContext.completeTransition(true)
        }
    }
    
}

