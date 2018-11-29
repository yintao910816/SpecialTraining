//
//  ImageRx.swift
//  StoryReader
//
//  Created by 尹涛 on 2018/4/23.
//  Copyright © 2018年 020-YinTao. All rights reserved.
//

import Foundation
import RxSwift

func Create(imageTask url: String,
            needCache: Bool = true,
            folder: String = AppImageCacheTmpDir,
            _ cache: CacheDir = .tmp,
            _ imageType: ImageType = .jpg) ->Observable<(UIImage?, String?)>{
    
    return Observable<(UIImage?, String?)>.create { obser -> Disposable in

        if let cacheImage = UIImage.init(contentsOfFile:(cache.path + folder + url.md5 + imageType.typeString)) {
            obser.onNext((cacheImage, url))
            obser.onCompleted()
        }else {
            do {
                try DownImage(url: url, complement: { ret in
                    if needCache, let _noEmptyImage = ret.0 { SaveImage(toSandox: _noEmptyImage, key: url.md5, folder: folder, cache) }
                    
                    obser.onNext(ret)
                    obser.onCompleted()
                })
            } catch {
                obser.onError(error)
                obser.onCompleted()
            }
        }
        return Disposables.create { }
    }
}
