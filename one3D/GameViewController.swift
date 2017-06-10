//
//  GameViewController.swift
//  one3D
//
//  Created by 覃子轩 on 2017/6/9.
//  Copyright © 2017年 覃子轩. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    fileprivate var scnView:SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testShow()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    /// 展现一张3D模型
    private func testShow() {
        // 创建一个屏幕
        let scene = SCNScene(named: "art.scnassets/ship.scn")!//SCNScene(named: "art.scnassets/file.dae")!
        
        // 在屏幕中创建一个摄像机
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(cameraNode)
        
        // 添加一个灯光到屏幕中
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // 添加一个环境灯光到屏幕中
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient //环境
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // 取得飞船节点
        //        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        //
        //        // 给3D飞船一个运动动画
        //        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // 取得一个SCNView
        //let scnView = self.view as! SCNView
        self.scnView = SCNView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        
        // 设置场景到这个view中
        self.scnView.scene = scene
        
        // 允许用户去操作摄像机
        self.scnView.allowsCameraControl = true
        
        // 展现fps和timing数据信息
        self.scnView.showsStatistics = true
        
        // 设置view的背景色
        self.scnView.backgroundColor = UIColor.orange
        
        // 设置点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.scnView.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(self.scnView)
    }

}

// MARK: - 描述响应函数
extension GameViewController {
    
    /// 点击飞船的响应函数
    ///
    /// - parameter gestureRecognize:
    @objc fileprivate func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        print("Hello tap!!!!!")
        // 取得SCNView
        //let scnView = scnView
        
        // 检查被点击
        let p = gestureRecognize.location(in: self.scnView)
        let hitResults = self.scnView.hitTest(p, options: [:])
        // 检查点击次数
        if hitResults.count > 0 {
            // 检索第一个被点击的对像
            let result: AnyObject = hitResults[0]
            
            // 取得对像的材料
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                //设置材质的emission颜色
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
}

// MARK: - 拓展描述系统override函数
extension GameViewController {
    
    /// 系统函数：是否自动旋转
    override var shouldAutorotate: Bool {
        return true
    }
    
    /// 系统函数：是否隐藏状态条
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// 系统函数：设置窗口
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // 判断是否是phone(因为有可能是ipad)
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
}
