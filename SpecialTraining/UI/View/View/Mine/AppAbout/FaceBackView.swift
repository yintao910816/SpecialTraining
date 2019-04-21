//
//  FaceBackView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/4/14.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class FaceBackView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var inputFaceBackOutlet: PlaceholderTextView!
    @IBOutlet private weak var inputPhoneOutlet: UITextField!
    @IBOutlet private weak var submitOutlet: UIButton!
    
    private var tapGes: UITapGestureRecognizer!
    private let disposeBag = DisposeBag()
    
    private let keyBoardManager = KeyboardManager()
    
    public var faceBackContent: Driver<String>!
    public var phone: Driver<String>!
    public var submitAction: Driver<Void>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("FaceBackView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        faceBackContent = inputFaceBackOutlet.rx.text.orEmpty.asDriver()
        phone = inputPhoneOutlet.rx.text.orEmpty.asDriver()
        submitAction = submitOutlet.rx.tap.asDriver()
            .do(onNext: { [unowned self] in
                self.endEditing(true)
            })
        
        inputFaceBackOutlet.placeholder = "请详细描述您遇到的问题或建议"
        
        contentView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        setNeedsLayout()
        layoutIfNeeded()
        
        var rect = frame
        rect.size.height = submitOutlet.frame.maxY
        self.frame = frame
        
        tapGes = UITapGestureRecognizer.init()
        contentView.addGestureRecognizer(tapGes)
        
        tapGes.rx.event
            .subscribe(onNext: { [unowned self] _ in self.endEditing(true) })
            .disposed(by: disposeBag)
        
        keyBoardManager.removeNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        keyBoardManager.removeNotification()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        keyBoardManager.move(coverView: inputPhoneOutlet, moveView: contentView)
    }
}

extension FaceBackView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        keyBoardManager.move(coverView: inputPhoneOutlet, moveView: contentView)
        return true
    }
}
