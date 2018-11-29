//
//  Debug.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/3/28.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation

func PrintLogDetail<N>(_ message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
        print("文件路径：\(fileName as NSString)\n方法：\(methodName)\n行号：\(lineNumber)\n打印信息：\(message)");
    #endif
}

func PrintLog<N>(_ message:N){
    #if DEBUG
        print("打印信息：\(message)");
    #endif
}
