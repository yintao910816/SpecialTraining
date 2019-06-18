//
//  ImageCacheCenter.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/9/4.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import Kingfisher

class ImageCacheCenter { /** 图片缓存信息 */
    
    public static let shared = ImageCacheCenter()
    
    private let imageHost = ""
    
    /// 获取图片地址
    ///
    /// - Parameter path: 接口返回图片地址 - 部分不包含域名
    /// - Returns: 完整URL
    public final func imageURL(_ path: String, type :ImageStrategy) ->String {
        let fullPath = path.contains("http://") == true ? path : "\(imageHost + path)"
        switch type {
        case .scale:
            if fullPath.contains(".jpg") == true {
                return fullPath.replacingOccurrences(of: ".jpg", with: "_s.jpg")
            }else if fullPath.contains(".png") == true {
                return fullPath.replacingOccurrences(of: ".png", with: "_s.png")
            }else {
                return fullPath
            }
        default:
            return fullPath
        }
    }
    
    public final func kingfisherCache(_ folder: KingfisherCacheFolder) ->ImageCache {
        return folder.folderCache
    }
    
    // 清除图片缓存
    public final func clear(cache folder: KingfisherCacheFolder = .canClear, completion handler: (()->())? = nil) {
        // disk
        folder.folderCache.clearDiskCache(completion: handler)
        // memory
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
    // 计算缓存大小
    public final func size(forCache folder: KingfisherCacheFolder = .canClear, completion handler: ((String)->())? = nil) {
        folder.folderCache.calculateDiskCacheSize(completion: { size in
            guard let cmp = handler else {
                return
            }
            cmp(self.sizeString(forSize: size))
        })
        
    }
    
    
    //MARK:
    //MARK: private
    private func sizeString(forSize size: UInt) ->String {
        let sizeFloat = CGFloat(size) / (1024.00 * 1024.00)
        return String(format: "%.2fM", sizeFloat)
    }

    public final func image(forKey key: String) ->UIImage? {
        return KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: key)
    }
}

enum KingfisherCacheFolder {
    // 非tmp文件夹下，可手动清除
    case canClear
    // tmp文件夹下
    case tmp
}

extension KingfisherCacheFolder {

    fileprivate var folderCache: ImageCache {
        get {
            switch self {
            case .canClear:
                return ImageCache.init(name: "canClearKingImageCache")
            case .tmp:
                return ImageCache.init(name: "kingfisherTemCache", diskCachePathClosure: { (path, folder) -> String in
                    return (NSTemporaryDirectory() as NSString).appendingPathComponent(folder)
                })
            }
        }
    }
}

//MARK:
//MARK: 图片类型
enum ImageStrategy {
    case original
    case scale
    
    case userIcon
}

extension ImageStrategy {
    /**
     获取 placeholder
     */
    var placeholder: UIImage? {
        switch self {
        case .original,
             .scale:
            return UIImage.init(named: "default_bg")
        case .userIcon:
            return UIImage.init(named: "default_user_icon")
        }
    }
}
