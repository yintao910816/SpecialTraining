//
//  ChatAudoLeftView.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/21.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class ChatAudoLeftView: UIView {

    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var audoOutlet: UIImageView!
    @IBOutlet weak var audoDurationOutlet: UILabel!
    
    @IBOutlet weak var bgAudioOutlet: UIImageView!
    
    @IBOutlet weak var iconOutlet: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func awakeFromNib() {
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        contentView = (Bundle.main.loadNibNamed("ChatAudoLeftView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    var model: ChatVoiceModel! {
        didSet {
            iconOutlet.setImage(model.iconStr, .userIcon)
            timeOutlet.text = model.messageTime
            audoDurationOutlet.text = "\(model.duration)″"
            if model.isPlaying == true {
                audoOutlet.loadGif(name: "other_voice")
            }else {
                audoOutlet.image = UIImage.init(named: "voice_first_frame_left")
            }
        }
    }

}

extension ChatAudoLeftView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }
        if bgAudioOutlet.frame.contains(point) {
            if model.isPlaying == false {
                audoOutlet.loadGif(name: "other_voice")
                NotificationCenter.default.post(name: NotificationName.AudioPlayState.AudioPlayStart, object: self.model)
                model.isPlaying = true
            }else {
                audoOutlet.image = UIImage.init(named: "voice_first_frame_left")
                NotificationCenter.default.post(name: NotificationName.AudioPlayState.AudioPlayStop, object: self.model)
                model.isPlaying = false
            }
        }
    }
}
