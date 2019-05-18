//
//  MedieView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/24.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class MedieView: UIView {

    weak var delegate: MediaProtocol?
    
    struct Frame {
        static let itemWidth: CGFloat = 70
        static let itemHeight: CGFloat = 70
        
        static let h_margin = (UIScreen.main.bounds.size.width - 4*itemWidth) / 5.0
        static let edgeInset: UIEdgeInsets = UIEdgeInsets.init(top: 15,
                                                               left: h_margin,
                                                               bottom: 15,
                                                               right: h_margin)
    }
    
    private var datasource: [String]!
    
    private var collectionView: UICollectionView!
    
    init(datasource: [String]) {
        let h = datasource.count > 4 ? (Frame.itemHeight + Frame.edgeInset.top * 2) : (Frame.itemHeight * 2 + Frame.edgeInset.top * 3)
        super.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: h))
        
        self.datasource = datasource
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = .init(width: Frame.itemWidth, height: Frame.itemHeight)
        layout.sectionInset = Frame.edgeInset
        layout.minimumLineSpacing = Frame.edgeInset.top
        layout.minimumInteritemSpacing = Frame.h_margin

        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        collectionView.register(MediaCell.self, forCellWithReuseIdentifier: "MediaCellID")
    }
}

extension MedieView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCellID", for: indexPath) as! MediaCell)
        cell.imgStr = datasource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.mediaItem(selected: indexPath.row)
    }
}

class MediaCell: UICollectionViewCell {
    
    private var imgV: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgV = UIImageView()
        addSubview(imgV)
        
        imgV.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    var imgStr: String! {
        didSet {
            imgV.image = UIImage.init(named: imgStr)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

protocol MediaProtocol: class {
    
    /// 多功能键盘选中item
    ///
    /// - Parameter reload: 隐藏时是否需要刷新键盘
    func mediaItem(selected idx: Int)

}
