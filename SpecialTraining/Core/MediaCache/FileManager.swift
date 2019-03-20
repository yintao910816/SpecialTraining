//
//  FileManager.swift
//  SpecialTraining
//
//  Created by yintao on 2019/3/21.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
import UIKit

enum FileCacheType {
    case audio
    case video
}

class FileHelper {
    static let share = FileHelper()
    
    private let videoCacheFolder = "/VideoCache/"
    private let audioCacheFolder = "/AudioCache/"
    private let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                               FileManager.SearchPathDomainMask.userDomainMask,
                                                               true).first!

    init() {
        creatFolder()
    }
    
    public func getLocalMediaPath(type: FileCacheType, url: String) ->String? {
        let path = getCachePath(type: type) + url
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        return nil
    }
    
    public func getCachePath(type: FileCacheType) ->String {
        switch type {
        case .audio:
            return docuPath + audioCacheFolder
        case .video:
            return docuPath + videoCacheFolder
        }
    }
    
    private func creatFolder() {
        let _videoFolderPath = docuPath + videoCacheFolder
        let _audioFolderPath = docuPath + audioCacheFolder
        // create folder
        do {
            if !FileManager.default.fileExists(atPath: _videoFolderPath) {
                try FileManager.default.createDirectory(atPath: _videoFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            if !FileManager.default.fileExists(atPath: _audioFolderPath) {
                try FileManager.default.createDirectory(atPath: _audioFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print("create folder fail")
        }
    }
}
