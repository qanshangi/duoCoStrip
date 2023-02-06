//
//  ViewController.swift
//  Demo
//
//  Created by content on 2023/1/22.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openLEDClicked(_ sender: NSSwitch) {
        if(sender.intValue == 0) {
            //关闭
            let data = Data.init([0x7e, 0x00, 0x04, 0x00, 0x00, 0x00, 0xff, 0x00, 0xef])
            led.sendMsg(data: data)
        } else {
            //打开
            let data = Data.init([0x7e, 0x00, 0x04, 0xf0, 0x00, 0x01, 0xff, 0x00, 0xef])
            led.sendMsg(data: data)
        }
    }
    
    @IBAction func colorsClicked(_ sender: NSButtonCell) {
        NSColorPanel.setPickerMask([.wheelModeMask, .rgbModeMask, .hsbModeMask, .customPaletteModeMask, .crayonModeMask])
        NSColorPanel.setPickerMode(.wheel)
        let colorPanel: NSColorPanel = NSColorPanel.shared;
        //colorPanel.mode = .RGB //颜色面板的初始选择模式。
        //colorPanel.color = .red //初始化颜色
        colorPanel.isContinuous = true
        colorPanel.setAction(#selector(didChangeColor))
        colorPanel.setTarget(self)
        
        colorPanel.orderFront(nil)
    }
    
    //改变颜色
    @objc func didChangeColor(sender: NSColorPanel) {
        let r: UInt8 = UInt8(sender.color.redComponent * 255)
        let g: UInt8 = UInt8(sender.color.greenComponent * 255)
        let b: UInt8 = UInt8(sender.color.blueComponent * 255)
        
        let data = Data.init([0x7e, 0x00, 0x05, 0x03, r, g, b, 0x00, 0xef])
        led.sendMsg(data: data)
    }
    
    @IBAction func changedColor(_ sender: NSButton) {
        var r: UInt8 = 0
        var g: UInt8 = 0
        var b: UInt8 = 0
        
        switch sender.tag {
        case 0:
            r = 255
        case 1:
            g = 255
        case 2:
            b = 255
        case 3:
            r = 100
            g = 190
            b = 240
        case 4:
            r = 242
            g = 203
            b = 4
        case 5:
            r = 175
            g = 81
            b = 222
        case 6:
            r = 255
            g = 255
            b = 255
        default:
            return
        }
        let data = Data.init([0x7e, 0x00, 0x05, 0x03, r, g, b, 0x00, 0xef])
        led.sendMsg(data: data)
    }
    
    //改变亮度
    @IBAction func changedBrightness(_ sender: NSSlider) {
        let brightness = UInt8(sender.intValue)
        let data = Data.init([ 0x7e, 0x00, 0x01, brightness, 0x00, 0x00, 0x00, 0x00, 0xef])
        led.sendMsg(data: data)
       
    }
    
    //改变灯效
    @IBAction func changedEffect(_ sender: NSComboBox) {
        var effect = Effects.blink_red
        print(sender.indexOfSelectedItem)
        switch sender.indexOfSelectedItem {
        case 0:
            effect = Effects.jump_red_green_blue
        case 1:
            effect = Effects.jump_red_green_blue_yellow_cyan_magenta_white
        case 2:
            effect = Effects.crossfade_red_green_blue
        case 3:
            effect = Effects.crossfade_red_green_blue_yellow_cyan_magenta_white
        case 4:
            effect = Effects.crossfade_red_green
        case 5:
            effect = Effects.crossfade_red_blue
        case 6:
            effect = Effects.crossfade_green_blue
        case 7:
            effect = Effects.crossfade_red
        case 8:
            effect = Effects.crossfade_green
        case 9:
            effect = Effects.crossfade_blue
        case 10:
            effect = Effects.crossfade_yellow
        case 11:
            effect = Effects.crossfade_cyan
        case 12:
            effect = Effects.crossfade_magenta
        case 13:
            effect = Effects.crossfade_white
        case 14:
            effect = Effects.blink_red
        case 15:
            effect = Effects.blink_green
        case 16:
            effect = Effects.blink_blue
        case 17:
            effect = Effects.blink_yellow
        case 18:
            effect = Effects.blink_cyan
        case 19:
            effect = Effects.blink_magenta
        case 20:
            effect = Effects.blink_white
        default:
            return
        }
        let data = Data.init([0x7e, 0x00, 0x03, effect.rawValue, 0x03, 0x00, 0x00, 0x00, 0xef])
        led.sendMsg(data: data)
    }
    
    @IBAction func changedSpeed(_ sender: NSSlider) {
        let speed = UInt8(sender.intValue)
        let data = Data.init([ 0x7e, 0x00, 0x02, speed, 0x00, 0x00, 0x00, 0x00, 0xef])
        led.sendMsg(data: data)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
