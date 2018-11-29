//
//  BaseTBCell.swift
//  ComicsReader
//
//  Created by 尹涛 on 2018/5/29.
//  Copyright © 2018年 yintao. All rights reserved.
//

import UIKit

class BaseTBCell: UITableViewCell {

    lazy var sepLine: UIView = {
        let view = UIView()
        view.backgroundColor = SEP_LINE_COLOR
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        defaultSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func dealSeperateLine(row: Int, totle: Int) {
        if totle > 0 {
            sepLine.isHidden = row == totle - 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        defaultSetup()
    }

    private func defaultSetup() {        
        addSubview(sepLine)        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sepLine.snp.makeConstraints{
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(self).offset(-10)
            $0.bottom.equalTo(self)
            $0.height.equalTo(1)
        }
    }
}
