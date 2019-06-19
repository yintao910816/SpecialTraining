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

    private let headerHeight: CGFloat = PPScreenW + 145
    private let headerScrollHeight: CGFloat = PPScreenW + 145 + 7 + 7 + 29 + 10

    private var viewModel: CourseDetailViewModel!
    
    @IBOutlet weak var headerView: CourseDetailHeaderView!
    
    @IBOutlet weak var headerHeightCns: NSLayoutConstraint!
    @IBOutlet weak var headerTopCns: NSLayoutConstraint!
    private var courseInfoView: CourseDetailInfoView!
    private var videoView: CourseDetailVideoView!
    private var courseAudioTB: CourseAudioTableView!
    private var courseClassTB: CourseDetailClassTableView!
    
    private var selectedClassView: CourseClassSelectView!
    
    var courseId: String = ""
    
    private let audioPlay = TYAudioPlayer()
    
    @IBOutlet weak var scrollOutlet: UIScrollView!
    
    @IBOutlet weak var detailOutlet: UIButton!
    @IBOutlet weak var videoOutlet: UIButton!
    @IBOutlet weak var audioOutlet: UIButton!
    @IBOutlet weak var classOutlet: UIButton!
    
    @IBOutlet weak var bottomRemindOutlet: UILabel!
    @IBOutlet weak var buyOutlet: UIButton!
    @IBOutlet weak var addShoppingCarOutlet: UIButton!

    private var isGotopay: Bool = false
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actions(_ sender: UIButton) {

        if sender == detailOutlet {
            set(button: detailOutlet, offsetX: 0)
        }else if sender == videoOutlet {
            set(button: videoOutlet, offsetX: scrollOutlet.width)
        }else if sender == audioOutlet {
            set(button: audioOutlet, offsetX: scrollOutlet.width * 2)
        }else if sender == classOutlet {
            set(button: classOutlet, offsetX: scrollOutlet.width * 3)
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
            if STHelper.userIsLogin() {
                selectedClassView.animotion(animotion: true)
                isGotopay = false
            }
        case 5004:
            // 立即购买
            if STHelper.userIsLogin() {
                selectedClassView.animotion(animotion: true)
                isGotopay = true
            }
        default:
            break
        }
    }
    
    private func set(button: UIButton, offsetX: CGFloat) {
        
        let btns = [detailOutlet, videoOutlet, audioOutlet, classOutlet]
        let views = [courseInfoView, videoView, courseAudioTB, courseClassTB]

        if let selectedBtn = btns.first(where: { $0?.isSelected == true }),
            selectedBtn != nil {
            if selectedBtn != button {
                if let idx = btns.firstIndex(where: { $0 == button }),
                    let selectedIdx = btns.firstIndex(where: { $0 == selectedBtn })
                {
                    if let y = (views[selectedIdx] as? AdaptScrollAnimotion)?.scrollContentOffsetY,
                        let scrollView = (views[idx] as? AdaptScrollAnimotion),
                        scrollView.canAnimotion(offset: y) == false
                    {
                        scrollView.scrollMax(contentOffset: y)
                    }
                }
                
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
        let btns = [detailOutlet, videoOutlet, audioOutlet, classOutlet]
        let views = [courseInfoView, videoView, courseAudioTB, courseClassTB]

        let curBtn = btns[idx]!
        
        if let selectedBtn = btns.first(where: { $0?.isSelected == true }),
            selectedBtn != nil {
            if selectedBtn != curBtn {
                if let idx = btns.firstIndex(where: { $0 == curBtn }),
                    let selectedIdx = btns.firstIndex(where: { $0 == selectedBtn })
                {
                    if let y = (views[selectedIdx] as? AdaptScrollAnimotion)?.scrollContentOffsetY,
                        let scrollView = (views[idx] as? AdaptScrollAnimotion),
                        scrollView.canAnimotion(offset: y) == false
                    {
                        scrollView.scrollMax(contentOffset: y)
                    }
                }

                selectedBtn!.isSelected = false
                curBtn.isSelected = true
            }
        }else {
            curBtn.isSelected = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        audioPlay.stop()
    }
    
    override func setupUI() {
        headerHeightCns.constant = headerHeight

        selectedClassView = CourseClassSelectView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: PPScreenH - 60))
        
        scrollOutlet.contentSize = .init(width: 4*PPScreenW, height: scrollOutlet.height)
        
        courseInfoView = CourseDetailInfoView.init(frame: .init(x: 0, y: 0, width: PPScreenW, height: PPScreenH - 60))
        videoView = CourseDetailVideoView()
        courseAudioTB = CourseAudioTableView()
        courseClassTB = CourseDetailClassTableView()

        scrollOutlet.addSubview(courseInfoView)
        scrollOutlet.addSubview(videoView)
        scrollOutlet.addSubview(courseAudioTB)
        scrollOutlet.addSubview(courseClassTB)

        view.addSubview(selectedClassView)

        courseInfoView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(scrollOutlet.snp.width)
        }

        videoView.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(scrollOutlet.snp.width)
        }
        
        courseAudioTB.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(2*PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(scrollOutlet.snp.width)
        }

        courseClassTB.snp.makeConstraints{
            $0.left.equalTo(scrollOutlet.snp.left).offset(3*PPScreenW)
            $0.top.equalTo(scrollOutlet.snp.top)
            $0.height.equalTo(scrollOutlet.snp.height)
            $0.width.equalTo(scrollOutlet.snp.width)
        }
        
        selectedClassView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        if #available(iOS 11, *) {
            scrollOutlet.contentInsetAdjustmentBehavior = .never
////            courseInfoView.webView.scrollView.contentInsetAdjustmentBehavior = .never
            courseInfoView.contentInsetAdjustmentBehavior = .never
//            courseClassTB.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }

    }
    
    override func rxBind() {
        viewModel = CourseDetailViewModel.init(courseId: courseId)
        
        viewModel.courseInfoDataSource.asDriver()
            .drive(onNext: { [weak self] data in
//                self?.classNameOutlet.text = data.title
//                self?.desOutlet.text = data.content
//                self?.priceOutlet.text = "¥:\(data.about_price)"
                self?.headerView.model = data
                self?.courseInfoView.model = data
                self?.bottomRemindOutlet.text = data.shop_name
            })
            .disposed(by: disposeBag)
        
//        courseInfoView.contentSizeObser
//            .bind(to: viewModel.contentSizeObser)
//            .disposed(by: disposeBag)
        
        courseInfoView.animotionHeaderSubject
            .subscribe(onNext: { [unowned self] in self.setHeaderScroll(distance: $0, scrollView: self.courseInfoView) })
            .disposed(by: disposeBag)

        viewModel.headerPicDataSource.asDriver()
            .drive(onNext: { [weak self] data in
                self?.headerView.picList = data
            })
            .disposed(by: disposeBag)

        viewModel.videoDatasource
            .asDriver()
            .drive(videoView.datasource)
            .disposed(by: disposeBag)
        
        viewModel.audioDatasource.asDriver()
            .drive(courseAudioTB.datasource)
            .disposed(by: disposeBag)

        viewModel.classListDatasource.asDriver()
            .drive(courseClassTB.datasource)
            .disposed(by: disposeBag)
        
        courseClassTB.animotionHeaderSubject
            .subscribe(onNext: { [unowned self] in self.setHeaderScroll(distance: $0, scrollView: self.courseClassTB) })
            .disposed(by: disposeBag)
        
        courseClassTB.rx.modelSelected(CourseDetailClassModel.self)
            .asDriver()
            .drive(onNext: { [weak self] model in
                self?.performSegue(withIdentifier: "classInfoSegue",
                                   sender: ["classId":model.class_id, "shopId": self?.viewModel.getShopID() ?? "1"])
            })
            .disposed(by: disposeBag)

        videoView.itemDidSelected
            .subscribe(onNext: { [unowned self] model in
                self.performSegue(withIdentifier: "videoPlaySegue", sender: model)
            })
            .disposed(by: disposeBag)
        
        videoView.animotionHeaderSubject
            .subscribe(onNext: { [unowned self] in self.setHeaderScroll(distance: $0, scrollView: self.videoView) })
            .disposed(by: disposeBag)

        courseAudioTB.itemDidSelected
            .do(onNext: { [weak self] _ in self?.audioPlay.stop() })
            .bind(to: viewModel.requestAudioSource)
            .disposed(by: disposeBag)
        
        courseAudioTB.animotionHeaderSubject
            .subscribe(onNext: { [unowned self] in self.setHeaderScroll(distance: $0, scrollView: self.courseAudioTB) })
            .disposed(by: disposeBag)
        
        viewModel.audioSourceChange
            .subscribe(onNext: { [weak self] path in
                self?.audioPlay.play(with: path)
            })
            .disposed(by: disposeBag)

        viewModel.classSelectDatasource.asDriver()
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
        
        selectedClassView.addShoppingCarSubject
            .filter{ _ in STHelper.userIsLogin() }
            .subscribe(onNext: { [unowned self] classModel in
                _ = self.viewModel.insertOrder(classModel: classModel, isGotopay: false)
            })
            .disposed(by: disposeBag)
        
        selectedClassView.buySubject
            .filter{ _ in STHelper.userIsLogin() }
            .flatMap{ [unowned self] classModel in
                return self.viewModel.insertOrder(classModel: classModel, isGotopay: true)
            }
            .subscribe(onNext: { [unowned self] shopId in
                self.performSegue(withIdentifier: "verifyOrderOutlet", sender: shopId)
            })
            .disposed(by: disposeBag)

        // header
        headerView.moreChoseSubject
            .subscribe(onNext: { [unowned self] in
                self.selectedClassView.animotion(animotion: true, isOkType: false)
            })
            .disposed(by: disposeBag)
        
        headerView.backOutlet.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
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
    
    private func headerAnimotion(isUp: Bool) {
        if isUp
        {
            if headerTopCns.constant == 0
            {
                headerTopCns.constant = -headerView.height
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }else
        {
            if headerTopCns.constant != 0
            {
                headerTopCns.constant = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addShoppingCarOutlet.set(cornerRadius: 15, borderCorners: [.topLeft, .bottomLeft])
        buyOutlet.set(cornerRadius: 15, borderCorners: [.topRight, .bottomRight])

//        if courseInfoView != nil { courseInfoView.scrollMinContentHeight = view.height - 115 }
//        if videoView != nil      { videoView.scrollMinContentHeight = view.height - 115 }
//        if courseAudioTB != nil  { courseAudioTB.scrollMinContentHeight = view.height - 115 }
//        if courseClassTB != nil  { courseClassTB.scrollMinContentHeight = view.height - 115 }
    }
}

extension STCourseDetailViewController {
    
    private func setHeaderScroll(distance: CGFloat, scrollView: UIView) {
        if (0 <= distance && distance <= headerScrollHeight) {
            // 向上滑
            headerTopCns.constant = -distance
        }else if (distance < 0){
            // 向下滑
            if headerTopCns.constant != 0 {
                headerTopCns.constant = 0
            }
        }else if (distance > headerScrollHeight){
            headerTopCns.constant = -headerScrollHeight
        }
        
        if scrollView == courseInfoView {
            if videoView.canAnimotion(offset: distance) { videoView.scrollMax(contentOffset: distance) }
            if courseAudioTB.canAnimotion(offset: distance) { courseAudioTB.scrollMax(contentOffset: distance) }
            if courseClassTB.canAnimotion(offset: distance) { courseClassTB.scrollMax(contentOffset: distance) }
        }else if scrollView == videoView {
            if courseInfoView.canAnimotion(offset: distance) { courseInfoView.scrollMax(contentOffset: distance) }
            if courseAudioTB.canAnimotion(offset: distance) { courseAudioTB.scrollMax(contentOffset: distance) }
            if courseClassTB.canAnimotion(offset: distance) { courseClassTB.scrollMax(contentOffset: distance) }
        }else if scrollView == courseAudioTB {
            if courseInfoView.canAnimotion(offset: distance) { courseInfoView.scrollMax(contentOffset: distance) }
            if videoView.canAnimotion(offset: distance) { videoView.scrollMax(contentOffset: distance) }
            if courseClassTB.canAnimotion(offset: distance) { courseClassTB.scrollMax(contentOffset: distance) }
        }else if scrollView == courseClassTB {
            if courseInfoView.canAnimotion(offset: distance) { courseInfoView.scrollMax(contentOffset: distance) }
            if courseAudioTB.canAnimotion(offset: distance) { courseAudioTB.scrollMax(contentOffset: distance) }
            if videoView.canAnimotion(offset: distance) { videoView.scrollMax(contentOffset: distance) }
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

protocol AdaptScrollAnimotion {
    func canAnimotion(offset y: CGFloat) ->Bool
    
    func scrollMax(contentOffset y: CGFloat)
    
    var scrollContentOffsetY: CGFloat { get }
}
