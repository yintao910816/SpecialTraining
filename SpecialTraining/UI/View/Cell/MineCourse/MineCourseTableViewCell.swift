//
//  MineCourseTableViewCell.swift
//  SpecialTraining
//
//  Created by 徐军 on 2018/12/3.
//  Copyright © 2018年 youpeixun. All rights reserved.
//

import UIKit

class MineCourseTableViewCell: BaseTBCell {

    @IBOutlet weak var ivCourse: UIImageView!
    @IBOutlet weak var ivCourseType: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseTypeTitle: UILabel!
    @IBOutlet weak var courseTeacher: UILabel!
    @IBOutlet weak var ivPayStatus: UIImageView!
    @IBOutlet weak var messageCount: UILabel!
    weak var delegate: MineCourseActions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    @IBAction func clickBtn(_ sender: UIButton) {
        
        switch sender.tag {
        case 1002:
            delegate?.gotoLessonPrepare()
        case 1003:
            delegate?.gotoWaitingLesson()
        default:
            break
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

protocol MineCourseActions: class {
    
    func gotoLessonPrepare()
    
    func gotoWaitingLesson()
    
}
