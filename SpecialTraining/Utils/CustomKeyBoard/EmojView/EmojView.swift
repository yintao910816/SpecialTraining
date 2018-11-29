//
//  EmojView.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/5/12.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit

public protocol EmojiOperation {
    func deleteEmoj(emojName : String)
    func inputEmoj(emojName : String)
}

class EmojView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let pageCtrlHeight: CGFloat = 15.0
    
    private let emjoSize = min(adaptationHeight(28), 28)
    private var emjos: [String]!
    private var emjoType: EmjoType!
    private var rowsCount: Int!
    private var countInRow: Int!
    private var lineSpacing: CGFloat!
    private var interitemSpacing: CGFloat!
    
    private var collectionView: UICollectionView!
    private var pageCtrl      : UIPageControl!
    
    public var delegate: EmojiOperation?
    
    init(emjos: [String],
         emjoType: EmjoType,
         rowsCount: Int = 3,
         countInRow: Int = 8,
         lineSpacing: CGFloat = adaptationHeight(18),
         interitemSpacing: CGFloat = adaptationWidth(12)) {
        
        let h = emjoSize * 3 + lineSpacing * 4 + pageCtrlHeight + LayoutSize.bottomVirtualArea
        let rect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: h)
        super.init(frame: rect)
        
        self.emjos            = emjos
        self.emjoType         = emjoType
        self.rowsCount        = rowsCount
        self.countInRow       = countInRow
        self.lineSpacing      = lineSpacing
        self.interitemSpacing = interitemSpacing

        _setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:
    //MARK: setup
    private func _setupView() {
        backgroundColor = UIColor.white
        let layout = EmojViewFlowLayout()
        //水平布局
        layout.scrollDirection  = .horizontal
        layout.rowsCount        = self.rowsCount
        layout.countInRow       = self.countInRow
        layout.sectionNum       = emojiSections()
        layout.lineSpacing      = self.lineSpacing
        layout.interitemSpacing = self.interitemSpacing
        layout.emojItemSize     = .init(width: emjoSize, height: emjoSize)
        //计算每个分区的左右边距
        let xOffset = (self.width - CGFloat(countInRow) * emjoSize - CGFloat(self.countInRow - 1) * self.interitemSpacing)/2.0
        //设置分区的内容偏移
        layout.edgeInsets = .init(top: 0, left: xOffset, bottom: 0, right: xOffset)
        
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0,
                                                                  width: frame.width,
                                                                  height: frame.height - pageCtrlHeight - LayoutSize.bottomVirtualArea), 
                                               collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate   = self
        collectionView.dataSource = self

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(collectionView)
        
        pageCtrl = UIPageControl.init(frame: CGRect.init(x: 0, y: collectionView.frame.maxY, width: width, height: pageCtrlHeight))
        pageCtrl.pageIndicatorTintColor = RGB(220.0, 220.0, 220.0)
        pageCtrl.currentPageIndicatorTintColor = UIColor.gray
        pageCtrl.numberOfPages = layout.sectionNum
        addSubview(pageCtrl)
    }
    
    private func emojiSections() ->Int {
        let itemsInSection = self.countInRow * self.rowsCount - 1;
        return (self.emjos.count/itemsInSection)+(self.emjos.count%itemsInSection==0 ? 0 : 1);
    }
    
    //MARK:
    //MARK: <##>
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsInSection = countInRow * rowsCount - 1
        if((section + 1) * itemsInSection <= emjos.count) {
            return (itemsInSection + 1)
        }else{
            let countItems = emjos.count - section * itemsInSection;
            return (countItems + 1);
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        //获取section cell总数
        let itemCount = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        if indexPath.row == itemCount - 1 {
            // 最后一个cell是删除按钮
            let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: emjoSize, height: emjoSize))
            img.contentMode   = .scaleAspectFit
            img.clipsToBounds = true
            img.image = UIImage.init(named: "emjo_del")
            cell.contentView.addSubview(img)
        }else {
        
            if emjoType == EmjoType.system {
                let lbl = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: emjoSize, height: emjoSize))
                lbl.font = UIFont.systemFont(ofSize: 30)
                lbl.text = emjos[indexPath.row + indexPath.section * (countInRow * rowsCount - 1)]
                cell.contentView.addSubview(lbl)
            }else {
                let imgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: emjoSize, height: emjoSize))
                imgView.image = EmojImage.emojImage(emjos[indexPath.row+indexPath.section*(countInRow * rowsCount - 1)])
                cell.contentView.addSubview(imgView)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //获取section cell总数
        let itemCount = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        //
        let itemsInSection = countInRow * rowsCount - 1;
        let idx = indexPath.section * itemsInSection + indexPath.row
//        let emojName = emjos[indexPath.section*itemsInSection+indexPath.row];
//        let emojName = emjos[idx];

        if (indexPath.row == itemCount - 1) //最后一个cell是删除按钮
        {
            PrintLog(emjos[idx - 1])
            delegate?.deleteEmoj(emojName: emjos[idx - 1])
        }else
        { //这里手动将表情符号添加到textField上
            PrintLog(emjos[idx])
            delegate?.inputEmoj(emojName: emjos[idx])
        }
    }
    
    //MARK:
    //MARK: 翻页后对分页控制器进行更新
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contenOffset = scrollView.contentOffset.x
        var page = contenOffset/scrollView.frame.size.width
        page += (Int(contenOffset) % Int(scrollView.frame.size.width)) == 0 ? 0:1
        pageCtrl.currentPage = Int(page)
    }
}
