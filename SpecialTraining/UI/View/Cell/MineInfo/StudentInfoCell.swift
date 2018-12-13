
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
    
    weak var delegate: StudentInfoAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickBtn(_ sender: UIButton) {
        switch sender.tag {
        case 1000:
            delegate?.changeInfo()
        case 1001:
            delegate?.addInfo()
        default:
            break
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

protocol StudentInfoAction:class {
    func changeInfo()
    
    func addInfo()
}
