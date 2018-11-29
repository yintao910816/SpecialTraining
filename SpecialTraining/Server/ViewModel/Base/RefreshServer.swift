//
//  Protocol.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/4/6.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
import RxSwift

extension UIScrollView {

    final func prepare<T>(_ ower: RefreshVM<T>,
                          _ type: T.Type,
                          showFooter: Bool = false,
                          showHeader: Bool = true,
                          isAddNoMoreContent: Bool = true) {
        addFreshView(ower: ower, showFooter: showFooter, showHeader: showHeader)
        bind(ower, type, showFooter, showHeader, isAddNoMoreContent: isAddNoMoreContent)
    }
    
    final func headerRefreshing() {
        if mj_footer != nil {
            mj_footer.isHidden = true
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) { [weak self] in
            self?.mj_header.beginRefreshing()
        }
    }
}

extension UIScrollView {

    fileprivate func addFreshView<T>(ower: RefreshVM<T>, showFooter: Bool, showHeader: Bool) {

        if showHeader == true {
            mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
                ower.requestData(true)
            })
        }
        
        if showFooter == true {
            mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
                ower.requestData(false)
            })
            mj_footer.isHidden = true
//            self.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
//                ower.requestData(false)
//            })
        }
    }
    
    fileprivate func bind<T>(_ ower: RefreshVM<T>,
                             _ type: T.Type,
                             _ hasFooter: Bool,
                             _ hasHeader: Bool,
                             isAddNoMoreContent: Bool) {
        _ = ower.refreshStatus
            .asObservable()
            .bind(onNext: { [weak self] statue in
            
                switch statue {
                case .DropDownSuccess:
                    if hasHeader {
                        self?.mj_header.endRefreshing()
                    }
                    if hasFooter == true {
                        self?.mj_footer.isHidden = false
//                        self?.mj_footer.resetNoMoreData()
                    }
//                    if isAddNoMoreContent == true { self?.addNoMoreDataFooter(isAdd: false) }
                    break
                case .DropDownSuccessAndNoMoreData:
                    if hasHeader {
                        self?.mj_header.endRefreshing()
                    }
                    if hasFooter == true {
                        self?.mj_footer.isHidden = true
//                        self?.mj_footer.endRefreshingWithNoMoreData()
                    }
//                    if isAddNoMoreContent == true { self?.addNoMoreDataFooter(isAdd: true) }
                    break
                case .PullSuccessHasMoreData:
                    if hasFooter == true { self?.mj_footer.endRefreshing() }
                    
//                    if isAddNoMoreContent == true { self?.addNoMoreDataFooter(isAdd: false) }
                    break
                case .PullSuccessNoMoreData:
                    if hasFooter == true {
                        self?.mj_footer.isHidden = true
//                        self?.mj_footer.endRefreshingWithNoMoreData()
                    }
//                    if isAddNoMoreContent == true { self?.addNoMoreDataFooter(isAdd: true) }
                    break
                case .InvalidData:
                    if hasHeader {
                        self?.mj_header.endRefreshing()
                    }
                    if hasFooter == true { self?.mj_footer.endRefreshing() }
//                    if isAddNoMoreContent == true { self?.addNoMoreDataFooter(isAdd: false) }
                    break
                }
            })
    }
    
//    private func addNoMoreDataFooter(isAdd: Bool) {
//        guard let tableView = self as? UITableView else {
//            return
//        }
//
//        if isAdd == true {
//            let footer = NoMoreDataFooter()
//            tableView.tableFooterView = footer.contentView
//        }else {
//            tableView.tableFooterView = nil
//        }
//    }

}

enum RefreshStatus: Int {
   
    case DropDownSuccess              // 下拉成功，有更多的数据
    case DropDownSuccessAndNoMoreData // 下拉成功，并且没有更多数据了
    case PullSuccessHasMoreData       // 上拉，还有更多数据
    case PullSuccessNoMoreData        // 上拉，没有更多数据
    case InvalidData                  // 无效的数据
}

class RefreshVM<T>: BaseViewModel {
    
    public var datasource    = Variable([T]())
    public var pageModel     = PageModel()
    public var refreshStatus = Variable(RefreshStatus.InvalidData)
    
    public let itemSelected = PublishSubject<IndexPath>()
    public let modelSelected = PublishSubject<T>()

    /**
     * 子类重写，响应上拉下拉加载数据
     */
    func requestData(_ refresh: Bool) {

    }

}

extension RefreshVM {

    /**
     刷新方法，发射刷新信号 - 用于列表数据(只有一个table)
     */
    public final func updateRefresh(_ refresh: Bool,
                                    _ models: [T]?,
                                    _ totle: Int?,
                                    pageSize psize: Int? = 10,
                                    _ addData: Bool = true) {
        self.pageModel.pageSize = psize!
        self.pageModel.totle = totle ?? 0
        if refresh {  // 下拉刷新处理
            let retData = models ?? [T]()
            isEmptyContentObser.value = retData.count == 0
            refreshStatus.value = (self.pageModel.hasNext) == true ? .DropDownSuccess : .DropDownSuccessAndNoMoreData
            if addData == true { datasource.value = retData }
        } else { // 上拉刷新处理
            refreshStatus.value = (self.pageModel.hasNext) == true ? .PullSuccessHasMoreData : .PullSuccessNoMoreData
            if addData == true { datasource.value.append(contentsOf: (models ?? [T]())) }
        }
    }
    
    /**
     刷新方法，发射刷新信号 - 用于列表数据(有多个table)
     */
    public final func updateRefresh(_ refresh: Bool,
                                    _ models: [T]?,
                                    _ totle: Int?,
                                    dataContainer: [T]? = nil,
                                    pageSize psize: Int? = 10,
                                    pageModel: PageModel) ->[T] {

        pageModel.pageSize = psize!
        pageModel.totle = totle ?? 0
        if refresh {  // 下拉刷新处理
            let retData = models ?? [T]()
            isEmptyContentObser.value = retData.count == 0
            refreshStatus.value = (pageModel.hasNext) == true ? .DropDownSuccess : .DropDownSuccessAndNoMoreData
            return retData
        } else { // 上拉刷新处理
            refreshStatus.value = (pageModel.hasNext) == true ? .PullSuccessHasMoreData : .PullSuccessNoMoreData

            var retDatas = dataContainer == nil ? [T]() : dataContainer!
            retDatas.append(contentsOf: models ?? [T]())
            return retDatas
        }
    }

    /**
     刷新方法，发射刷新信号 - 用于单个模型的刷新
     */
    public final func stopRefresh() {
        refreshStatus.value = .DropDownSuccess
    }
    
    /**
     网络请求失败和出错都会统一调用这个方法
     */
    public final func revertCurrentPageAndRefreshStatus(pageModel: PageModel? = nil) {
        // 修改刷新view的状态
        refreshStatus.value = .InvalidData
        // 还原请求页
        if let currentPageModel = pageModel {
            currentPageModel.currentPage = currentPageModel.currentPage > 1 ? currentPageModel.currentPage - 1 : 1
        }else {
            self.pageModel.currentPage = self.pageModel.currentPage > 1 ? self.pageModel.currentPage - 1 : 1
        }
    }
    
    /**
     * 重写 requestData 时，必须调用
     * 多个列表时，pageModel 传当前列表的 PageModel
     */
    public final func setupPage(refresh: Bool, pageModel: PageModel? = nil) {
        if let currentModel = pageModel {
            currentModel.setupCurrentPage(refresh: refresh)
        }else {
            self.pageModel.setupCurrentPage(refresh: refresh)
        }
    }

}
