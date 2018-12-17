//
//  CourseTimeTableView.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/17.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class CourseTimeTableView: BaseTB {
    
    private let titles = ["    初级（适合人群，有无基础）", "    高级（适合人群，有无基础）"]
    
    private let disposeBag = DisposeBag()
    
    let datasource = Variable([SectionModel<Int, String>]())
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
        setupUI()
        rxBind()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        showsVerticalScrollIndicator = false
        
        rowHeight = 80
        
        register(UINib.init(nibName: "CourseTimeCell", bundle: Bundle.main), forCellReuseIdentifier: "CourseTimeCellID")
    }
    
    private func rxBind() {
        
        let dataSignal = RxTableViewSectionedReloadDataSource<SectionModel<Int, String>>.init(configureCell: { (_, tb, indexPath, model) -> UITableViewCell in
            let cell = tb.dequeueReusableCell(withIdentifier: "CourseTimeCellID") as! CourseTimeCell
            return cell
        })

        datasource.asDriver()
            .drive(rx.items(dataSource: dataSignal))
            .disposed(by: disposeBag)
        
        rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension CourseTimeTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel.init()
        title.backgroundColor = RGB(242, 242, 242, 242)
        let text = titles[section]
        title.attributedText = text.attributed(NSRange.init(location: 6, length: text.count - 6),
                                               RGB(47, 171, 213), UIFont.systemFont(ofSize: 13))
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = RGB(47, 171, 213)
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}
