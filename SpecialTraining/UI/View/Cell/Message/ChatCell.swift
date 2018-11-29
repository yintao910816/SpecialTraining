//
//  ChatCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/20.
//  Copyright © 2018 youpeixun. All rights reserved.
//
import UIKit

class ChatCell: UITableViewCell {

    struct Frame {
        // 头像高度
        static let iconHeight:CGFloat = 40
        // 除开文字高度的剩余高度
        static let otherHeight: CGFloat = 16 + 12 + 10
        // 内容与气泡上下间距
        static let content_v_margin: CGFloat = 10
        // 内容能显示的宽度区域
        static let contentLayoutWidth: CGFloat = PPScreenW - iconHeight - 12 - 20 - 25

        //MARK   --- 文字内容
        
        // 文字的最小高度
        static let textMinHeight: CGFloat = iconHeight - 20
        
        //MARK   --- 图片内容
        
        // 图片内容固定高度
        static let imageHeight: CGFloat = 100
        
        //MARK   --- 音频内容
        
        static let audoCellHeight: CGFloat = 78

    }
    
    lazy var leftChatView: ChatLeftView = {
        return ChatLeftView()
    }()
    
    lazy var rightChatView: ChatRightView = {
        return ChatRightView()
    }()
    
    lazy var leftImageChatView: ChatImageLeftView = {
        return ChatImageLeftView()
    }()

    lazy var rightImageChatView: ChatImageRightView = {
        return ChatImageRightView()
    }()
    
    lazy var leftVoiceChatView: ChatAudoLeftView = {
        return ChatAudoLeftView()
    }()
    
    lazy var rightVoiceChatView: ChatAudoRightView = {
        return ChatAudoRightView()
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var model: ChatModel! {
        didSet {
            contentView.removeAllSubviews()
            switch model.messageType {
            case .text:
                if model.isMyselfSend == true {
                    contentView.addSubview(rightChatView)
                    rightChatView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
                    rightChatView.model = (model as! ChatTextModel)
                }else {
                    contentView.addSubview(leftChatView)
                    leftChatView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
                    leftChatView.model = (model as! ChatTextModel)
                }
            case .image:
                if model.isMyselfSend == true {
                    contentView.addSubview(rightImageChatView)
                    rightImageChatView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
                    rightImageChatView.model = (model as! ChatImageModel)
                }else {
                    contentView.addSubview(leftImageChatView)
                    leftImageChatView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
                    leftImageChatView.model = (model as! ChatImageModel)
                }
            case .voice:
                if model.isMyselfSend == true {
                    contentView.addSubview(rightVoiceChatView)
                    rightVoiceChatView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
                    rightVoiceChatView.model = (model as! ChatVoiceModel)
                }else {
                    contentView.addSubview(leftVoiceChatView)
                    leftVoiceChatView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
                    leftVoiceChatView.model = (model as! ChatVoiceModel)
                }

            default:
                break
            }
        }
    }
    
    deinit {
        PrintLog("释放了 \(self)")
    }
}
