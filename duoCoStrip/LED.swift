//
//  LED.swift
//  Demo
//
//  Created by content on 2023/1/26.
//

import Foundation
//数据来源
//https://github.com/TheSylex/ELK-BLEDOM-bluetooth-led-strip-controller

//[0x7e, 0x00, 0x04, 0xf0, 0x00, 0x01, 0xff, 0x00, 0xef]        开灯
//[0x7e, 0x00, 0x04, 0x00, 0x00, 0x00, 0xff, 0x00, 0xef]        关灯
//[0x7e, 0x00, 0x05, 0x03, R, G, B, 0x00, 0xef]                 更改颜色
//[ 0x7e, 0x00, 0x01, brightness, 0x00, 0x00, 0x00, 0x00, 0xef] 更改亮度
//[0x7e, 0x00, 0x03, effect, 0x03, 0x00, 0x00, 0x00, 0xef]      更改灯效
//[0x7e, 0x00, 0x02, speed, 0x00, 0x00, 0x00, 0x00, 0xef]       更改速度

enum Effects: UInt8{
    case jump_red_green_blue = 0x87 //三色跳变
    case jump_red_green_blue_yellow_cyan_magenta_white = 0x88   //七色跳变
    case crossfade_red = 0x8b   //红色渐变
    case crossfade_green = 0x8c //绿色渐变
    case crossfade_blue = 0x8d  //蓝色渐变
    case crossfade_yellow = 0x8e    //黄色渐变
    case crossfade_cyan = 0x8f  //青色渐变
    case crossfade_magenta = 0x90   //紫色渐变
    case crossfade_white = 0x91 //白色渐变
    case crossfade_red_green = 0x92 //红绿渐变
    case crossfade_red_blue = 0x93  //红蓝渐变
    case crossfade_green_blue = 0x94    //绿蓝渐变
    case crossfade_red_green_blue = 0x89    //三色渐变
    case crossfade_red_green_blue_yellow_cyan_magenta_white = 0x8a  //七色渐变
    case blink_red = 0x96   //红色频闪
    case blink_green = 0x97 //绿色频闪
    case blink_blue = 0x98  //蓝色频闪
    case blink_yellow = 0x99    //黄色频闪
    case blink_cyan = 0x9a  //青色频闪
    case blink_magenta = 0x9b   //紫色频闪
    case blink_white = 0x9c //白色频闪
    case blink_red_green_blue_yellow_cyan_magenta_white = 0x95  //七色频闪
}
