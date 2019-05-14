//
//  STCourseDetailViewController.swift
//  SpecialTraining
//
//  Created by yintao on 2018/12/14.
//  Copyright © 2018 youpeixun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class STCourseDetailViewController: BaseViewController {

    private var viewModel: CourseDetailViewModel!
    
    private var videoView: CourseDetailVideoView!
    private var courseAudioTB: CourseAudioTableView!
    private var courseClassTB: CourseDetailClassTableView!
    
    private var selectedClassView: CourseClassSelectView!
    
    var courseId: String = ""
    
    private let audioPlay = TYAudioPlayer()
    
    @IBOutlet weak var scrollOutlet: UIScrollView!
    
    @IBOutlet weak var videoOutlet: UIButton!
    @IBOutlet weak var audioOutlet: UIButton!
    @IBOutlet weak var classOutlet: UIButton!
    
    @IBOutlet weak var classNameOutlet: UILabel!
    @IBOutlet weak var desOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var bottomRemindOutlet: UILabel!
    @IBOutlet weak var buyOutlet: UIButton!
    @IBOutlet weak var addShoppingCarOutlet: UIButton!

    private var isGotopay: Bool = false
    
    @IBAction func actions(_ sender: UIButton) {

        if sender == videoOutlet {
            set(button: videoOutlet, offsetX: 0)
        }else if sender == audioOutlet {
            set(button: audioOutlet, offsetX: scrollOutlet.width)
        }else if sender == classOutlet {
            set(button: classOutlet, offsetX: scrollOutlet.width * 2)
        }
    }
    
    @IBAction func bottomAction(_ sender: UIButton) {
        switch sender.tag {
        case 5000:
            // 店铺
            break
        case 5001:
            // 客服
            NoticesCenter.alert(message: "功能暂未开放，客服系统正在努力完善中...")
        case 5002:
            // 电话
            let mob = viewModel.courseInfoDataSource.value.mob
            if mob.count > 0 {
                STHelper.phoneCall(with: mob)
            }
        case 5003:
            // 加入购物车
            selectedClassView.animotion(animotion: true)
            isGotopay = false
        case 5004:
            // 立即购买
            selectedClassView.animotion(animotion: true)
            isGotopay = true
        default:
            break
        }
    }
    
    private func set(button: UIButton, offsetX: CGFloat) {
        let btns = [videoOutlet, audioOutlet, classOutlet]
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }), selectedBtn != nil {
            if selectedBtn != button {
                selectedBtn!.isSelected = false
                button.isSelected = true
                scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
            }
        }else {
            button.isSelected = true
            scrollOutlet.setContentOffset(.init(x: offsetX, y: 0), animated: true)
        }
    }
    
    private func set(scroll offsetX: CGFloat) {
        let idx = Int(offsetX / scrollOutlet.width)
        let btns = [videoOutlet, audioOutlet, classOutlet]
        let curBtn = btns[idx]!
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }),
            selectedBtn != nil {
            if selectedBtn != curBtn {
                selectedBtn!.isSelected = false
                curBtn.isSelected = true
            }
        }else {
            curBtn.isSelected = true
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        audioPlay.stop()
    }
    
    override func setupUI() {
        navigationItem.title = "课程详情"
        
        addShoppingCarOutlet.set(cornerRadius: 15, borderCorners: [.topLeft, .bottomLeft])
        buyOutlet.set(cornerRadius: 15, borderCorners: [.topRight, .bottomRight])

        selectedClassView = CourseClassSelectView.init(frame: .zero)
        
        scrollOutlet.contentSize = .init(width: 3*PPScreenW, height: scrollOutlet.height)
        
        videoView = CourseDetailVideoView()
        courseAudioTB = CourseAudioTableView()
        courseClassTB = CourseDetailClassTableView()

        scrollOutlet.addSubview(videoView)
        scrollOutlet.addSubview(courseAudioTB)
        scrollOutlet.addSubview(courseClassTB)

        view.addSubview(selectedClassView)

        videoView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(scrollOutlet.snp.width)
        }
        
        courseAudioTB.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(scrollOutlet.snp.width)
        }

        courseClassTB.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(2*PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(scrollOutlet.snp.width)
        }
        
        selectedClassView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
//        if #available(iOS 11, *) {
//            scrollOutlet.contentInsetAdjustmentBehavior = .never
//            organizationColView.contentInsetAdjustmentBehavior = .never
//            recomendColView.contentInsetAdjustmentBehavior = .never
//        }else {
//            automaticallyAdjustsScrollViewInsets = false
//        }

    }
    
    override func rxBind() {
        viewModel = CourseDetailViewModel.init(courseId: courseId)
        
        viewModel.courseInfoDataSource.asDriver()
            .drive(onNext: { [weak self] data in
                self?.classNameOutlet.text = data.title
                self?.desOutlet.text = data.content
                self?.priceOutlet.text = "¥:\(data.about_price)"
                self?.bottomRemindOutlet.text = data.shop_name
            })
            .disposed(by: disposeBag)
        
        viewModel.videoDatasource
            .asDriver()
            .drive(videoView.datasource)
            .disposed(by: disposeBag)
        
        viewModel.audioDatasource.asDriver()
            .drive(courseAudioTB.datasource)
            .disposed(by: disposeBag)

        viewModel.classDatasource.asDriver()
            .drive(courseClassTB.datasource)
            .disposed(by: disposeBag)
        
        videoView.itemDidSelected
            .subscribe(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "videoPlaySegue", sender: model)
            })
            .disposed(by: disposeBag)
        
        courseAudioTB.itemDidSelected
            .do(onNext: { [weak self] _ in self?.audioPlay.stop() })
            .bind(to: viewModel.requestAudioSource)
            .disposed(by: disposeBag)
        
        courseClassTB.rx.modelSelected(CourseDetailClassModel.self)
            .asDriver()
            .drive(onNext: { [weak self] model in
                self?.performSegue(withIdentifier: "classInfoSegue",
                                   sender: ["classId":model.class_id, "shopId": self?.viewModel.getShopID() ?? "1"])
            })
            .disposed(by: disposeBag)
        
        
        viewModel.audioSourceChange
            .subscribe(onNext: { [weak self] path in
                self?.audioPlay.play(with: path)
            })
            .disposed(by: disposeBag)

        viewModel.classDatasource.asDriver()
            .drive(selectedClassView.dataSource)
            .disposed(by: disposeBag)

        selectedClassView.choseSubject
            .flatMap{ [unowned self] classModel in
                return self.viewModel.insertOrder(classModel: classModel, isGotopay: self.isGotopay)
            }
            .subscribe(onNext: { [unowned self] shopId in
                if self.isGotopay == true {
                    self.performSegue(withIdentifier: "verifyOrderOutlet", sender: shopId)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        courseId = parameters!["course_id"] as! String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verifyOrderOutlet" {
            // 确认订单
            segue.destination.prepare(parameters: ["classIds": [sender as! String]])
        }else if segue.identifier == "videoPlaySegue" {
            let ctrl = segue.destination as! STVideoPlayViewController
            ctrl.preparePlay(videoInfo: (sender as! CourseDetailVideoModel))
        }else if segue.identifier == "classInfoSegue" {
            // 班级详情
            segue.destination.prepare(parameters: sender as? [String: Any])
        }
    }
}

extension STCourseDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        set(scroll: scrollOutlet.contentOffset.x)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            set(scroll: scrollOutlet.contentOffset.x)
        }
    }
    
}

