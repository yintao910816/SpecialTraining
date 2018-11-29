//
//  EmptyDataView.swift
//  ComicsReader
//
//  Created by 尹涛 on 2018/8/21.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit
import SnapKit

class EmptyDataView: UIView {

    private lazy var contentImageV: UIImageView = {
        let imageV = UIImageView.init(image: UIImage.init(named: "empty_bg"))
        return imageV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(contentImageV)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentImageV.snp.makeConstraints{
            $0.centerX.equalTo(self.snp.centerX)
            $0.centerY.equalTo(self.snp.centerY)
            $0.width.equalTo(self.snp.width).multipliedBy(1.0/2.0)
            $0.height.equalTo(contentImageV.snp.width).multipliedBy(1)
        }
    }

    deinit {
        PrintLog("释放了 \(self)")
    }
}
