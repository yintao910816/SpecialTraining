
//
//  StudentInfoCell.swift
//  SpecialTraining
//
//  Created by 尹涛 on 2018/11/19.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit

class StudentInfoCell: UITableViewCell {

    @IBOutlet weak var ivHead: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    
    public var changeStuentInfoCallBack: ((StudentInfoModel) ->())?
    public var deleteStudentCallBack: ((StudentInfoModel) ->())?

    var model: StudentInfoModel! {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickBtn(_ sender: UIButton) {
        switch sender.tag {
        case 1000:
            changeStuentInfoCallBack?(model)
        case 1001:
            deleteStudentCallBack?(model)
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
