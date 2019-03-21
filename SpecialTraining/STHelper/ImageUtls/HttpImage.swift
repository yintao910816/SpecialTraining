//
//  HttpImage.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/3/14.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {

    final func setImage(_ url: String?,
                        _ type: ImageStrategy = .original,
                        cacheFolder folder: KingfisherCacheFolder? = .canClear,
                        forTransitionOptions transition: KingfisherOptionsInfoItem? = .transition(.fade(0.2)),
                        forOption options: KingfisherOptionsInfo = [.cacheMemoryOnly])
    {
        guard let turl: String = url else {
            PrintLog("图片地址为空！！！")
            image = type.placeholder
            return
        }
        let dealURL = ImageCacheCenter.shared.imageURL(turl, type: type)

        if let memoryCache = ImageCacheCenter.shared.image(forKey: dealURL) {
            image = memoryCache
            return
        }

        if ValidateNum.URL(dealURL).isRight == false { return }
        
        if type != .userIcon {
            var _options = [KingfisherOptionsInfoItem]()
            if let _folder = folder {
                _options.append(.targetCache(ImageCacheCenter.shared.kingfisherCache(_folder)))
            }else {
                _options.append(contentsOf: options)
            }
            
            if let t = transition  {
                _options.append(t)
            }
            
            _options.append(contentsOf: [.backgroundDecode])
            
            kf_setImage(dealURL, type, _options)
        }else {
            kf_setImage(dealURL, type, nil)
        }
    }
    
    private func kf_setImage(_ url: String, _ type: ImageStrategy, _ options: KingfisherOptionsInfo?) {
        
        kf.setImage(with: URL(string: url),
                    placeholder: type.placeholder,
                    options: options,
                    progressBlock: { (current, totle) in
//                        PrintLog("当前进度 \(current), 总进度 \(totle)")
                    }) { (image, error, cacheType, url) in
                        if type != .userIcon {
                            if let _image = image, let _url = url {
                                KingfisherManager.shared.cache.store(_image, forKey: _url.absoluteString, toDisk: false)
                            }
                        }
                    }
    }
    
}

extension UIButton {

    final func setImage(_ url: String?,
                        _ type: ImageStrategy = .original,
                        isBgImage: Bool = false,
                        cacheFolder folder: KingfisherCacheFolder? = .canClear,
                        forTransitionOptions transition: KingfisherOptionsInfoItem? = .transition(.fade(0.2)),
                        forOption options: KingfisherOptionsInfo = [.cacheMemoryOnly])
    {
        guard let turl: String = url else {
            PrintLog("图片地址为空！！！")
            if isBgImage {
                setBackgroundImage(type.placeholder, for: .normal)
            }else {
                setImage(type.placeholder, for: .normal)
            }
            return
        }
        
        let dealURL = ImageCacheCenter.shared.imageURL(turl, type: type)

        if let memoryCache = ImageCacheCenter.shared.image(forKey: dealURL) {
            if isBgImage {
                setBackgroundImage(memoryCache, for: .normal)
            }else {
                setImage(memoryCache, for: .normal)
            }
            return
        }
        
        if ValidateNum.URL(dealURL).isRight == false { return }
        
        if type != .userIcon {
            var _options = [KingfisherOptionsInfoItem]()
            if let _folder = folder {
                _options.append(.targetCache(ImageCacheCenter.shared.kingfisherCache(_folder)))
            }else {
                _options.append(contentsOf: options)
            }
            
            if let t = transition  {
                _options.append(t)
            }
            
            _options.append(contentsOf: [.backgroundDecode])
            
            kf_setImage(dealURL, isBgImage: isBgImage, type, _options)
        }else {
            kf_setImage(dealURL, isBgImage: isBgImage, type, nil)
        }
        
    }
    
    private func kf_setImage(_ url: String, isBgImage: Bool, _ type: ImageStrategy, _ options: KingfisherOptionsInfo?) {
        if isBgImage {
            kf.setBackgroundImage(with: URL(string: ImageCacheCenter.shared.imageURL(url, type: type)),
                                  for: .normal,
                                  placeholder: type.placeholder,
                                  options: options,
                                  progressBlock: { (current, totle) in
                                    //                                PrintLog("当前进度 \(current), 总进度 \(totle)")
            }) { (image, error, cacheType, url) in
                if type != .userIcon {
                    if let _image = image, let _url = url {
                        KingfisherManager.shared.cache.store(_image, forKey: _url.absoluteString, toDisk: false)
                    }
                }
            }
        }else {
            kf.setImage(with: URL(string: ImageCacheCenter.shared.imageURL(url, type: type)),
                                  for: .normal,
                                  placeholder: type.placeholder,
                                  options: options,
                                  progressBlock: { (current, totle) in
                                    //                                PrintLog("当前进度 \(current), 总进度 \(totle)")
            }) { (image, error, cacheType, url) in
                if type != .userIcon {
                    if let _image = image, let _url = url {
                        KingfisherManager.shared.cache.store(_image, forKey: _url.absoluteString, toDisk: false)
                    }
                }
            }
        }
    }
    
}
