//
//  MineSectionCollectionReusableView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/18.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class MineSectionCollectionReusableView: UICollectionReusableView {

    @IBOutlet var contentView: UICollectionReusableView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    weak var delegate: MineSectionHeaderAction?
    
    @IBAction func clickAddBtn() {
      
        delegate?.addBtnClick()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        contentView = (Bundle.main.loadNibNamed("MineSectionCollectionReusableView", owner: self, options: nil)?.first as! UICollectionReusableView)
        correctWidth()
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title: String! {
        didSet {
            titleOutlet.text = title
        }
    }
    
}

protocol MineSectionHeaderAction: class {
    func addBtnClick()
}
