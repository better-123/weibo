//
//  ProgressView.swift
//  weibo
//
//  Created by better on 2019/8/7.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    //定义进度属性
    var progress: CGFloat = 0 {
        didSet{
            //绘制方法
            setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //获取贝塞尔曲线
        //中心点
        let center = CGPoint(x: rect.width*0.5, y: rect.height * 0.5)
        //半径
        let radius = rect.width * 0.5 - 3
        //开始角度
        let startAngle = CGFloat(-(Double.pi / 2))
        //开始角度
        let endAngle = CGFloat(2 * Double.pi) * progress + startAngle
        
        //创建贝塞尔曲线
        //clockwise:true:他是一个关闭路径
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //绘制一条到中心点的线
        bezierPath.addLine(to: center)
        bezierPath.close()
        //设置绘制颜色
        UIColor(white: 1.0, alpha: 0.4).setFill()
        //开始绘制
        bezierPath.fill()
    }

}
