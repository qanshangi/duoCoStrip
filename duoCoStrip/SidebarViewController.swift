//
//  SidebarViewController.swift
//  Demo
//
//  Created by content on 2023/1/25.
//

import Cocoa

class SidebarViewController: NSViewController {
  
    @IBOutlet weak var stackView: NSStackView!
    
    var buttons: Array<NSButton> = Array()
    
    @objc func clicked(_ sender: NSButton) {
        //未连接
        if(led.characteristics[sender.tag] == nil) {
            led.connect(sender.tag)
        //断开连接
        } else {
            led.disconnect(sender.tag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text: NSTextField = NSTextField(labelWithString: "搜索设备中")
        text.alignment = .center
        stackView.addView(text, in: .top)
        //居中
        let layout:NSLayoutConstraint = NSLayoutConstraint(item: text,
                                                           attribute: NSLayoutConstraint.Attribute.centerX,
                                                           relatedBy: NSLayoutConstraint.Relation.equal,
                                                           toItem: stackView,
                                                           attribute: NSLayoutConstraint.Attribute.centerX,
                                                           multiplier: 1,
                                                           constant: 0)
        text.addConstraint(layout)
        stackView.addConstraint(layout)
        
        //多线程
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        //扫描中
        group.enter()
        queue.async {
            led.startScan(
                connected: {(_ index: Int)->Void in
                    let queue = DispatchQueue.main
                    queue.async {
                        self.buttons[index].bezelColor = NSColor.systemBlue   //NSColor(red: 0.4, green: 0.5, blue: 0.8, alpha: 0.8)
                    }
                },
                disconnected: {(_ index: Int)->Void in
                    let queue = DispatchQueue.main
                    queue.async {
                        self.buttons[index].bezelColor = NSColor.white
                    }
                })
            sleep(3)
            led.stopScan()
            group.leave()
        }
        
        //扫描完成
        group.notify(queue: queue) {
            //主线程
            let queue = DispatchQueue.main
            queue.async {
                
                if(led.peripherals.count != 0) {
                    self.stackView.removeConstraint(layout)
                    self.stackView.removeView(text)
                    
                    for (index, peripheral) in led.peripherals.enumerated() {
                        let button: NSButton = NSButton(title: peripheral.identifier.uuidString, target: self, action: #selector(self.clicked))
                        button.bezelStyle = .regularSquare
                        button.bezelColor = NSColor.white
                        button.tag = index;
                        
                        self.buttons.append(button)
                        //按钮高度
                        let layout:NSLayoutConstraint = NSLayoutConstraint(item: button,
                                                                            attribute: .height,
                                                                            relatedBy: .equal,
                                                                            toItem: nil,
                                                                            attribute: .notAnAttribute,
                                                                            multiplier: 1,
                                                                            constant: 30)
                        button.addConstraint(layout)
                        
                        self.stackView.addView(button, in: .top)
                    }
                }
            }
        }
    }
    
}

/*class Scroller: NSScroller {
    override func draw(_ dirtyRect: NSRect) {
        //清除背景
        self.drawKnob()
    }
}*/
