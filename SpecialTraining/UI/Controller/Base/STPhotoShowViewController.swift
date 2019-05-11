//
//  STPhotoShowViewController.swift
//  SpecialTraining
//
//  Created by sw on 11/05/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class STPhotoShowViewController: BaseViewController {

    private var carouselView: CarouselView!
    private var closeButton: TYClickedButton!
    
    private var photoData: [PhotoModel] = []
    
    deinit {
        carouselView.dellocTimer()
    }

    override func setupUI() {
        view.backgroundColor = .black
        
        carouselView = CarouselView()
        carouselView.backgroundColor = .clear
        carouselView.setData(source: photoData, autoScroll: false)
        
        closeButton = TYClickedButton.init(type: .system)
        closeButton.setImage(UIImage.init(named: "navigationButtonReturn"), for: .normal)
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        
        view.addSubview(carouselView)
        view.addSubview(closeButton)
        
        carouselView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        closeButton.snp.makeConstraints{
            $0.left.equalTo(15)
            $0.top.equalTo(LayoutSize.fitTopArea + 20 + 12)
        }
    }
    
    func configData(photoList: [String] = []) { photoData = PhotoModel.creatPhotoModels(photoList: photoList) }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}
