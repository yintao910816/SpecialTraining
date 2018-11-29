//
//  HUDUtil.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/10.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

extension String {

    public func textSize(font: UIFont, width: CGFloat, height: CGFloat) ->CGSize {
        let size = CGSize(width: width, height: height)
        let attributes = [NSAttributedString.Key.font: font]
        return self.boundingRect(with: size,
                                 options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading],
                                 attributes: attributes,
                                 context:nil)
            .size
    }

}
