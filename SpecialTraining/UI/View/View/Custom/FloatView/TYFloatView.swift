//
//  TYFloatView.swift
//  SpecialTraining
//
//  Created by yintao on 2019/2/15.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import UIKit

class TYFloatView: UIView {
    
    private var menuDatasource = [String]()
    private var menuTbView: UITableView!
    private var convertView: UIView!
    private var superView: UIView!
    private var belowViewFrame: CGRect!
    private var fontSize: Float = 15

    public var didSelectedCallBack: ((String) ->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupView() {
        isHidden = true
        
        if menuDatasource.count == 0 { return }
        
        let maxString = menuDatasource.max(by: { $1.count > $0.count })!
        let maxWidth = maxString.getTexWidth(fontSize: fontSize, height: 20) + 30
        let floatHeight: CGFloat = CGFloat(menuDatasource.count * 44)
//        let rect = convertView.convert(belowViewFrame, to: superView)
        let floatX = belowViewFrame.minX - maxWidth
        let floatY = UIDevice.current.isX == true ? belowViewFrame.maxY + 10 + 44 : belowViewFrame.maxY + 10

        menuTbView = UITableView.init(frame: .init(x: floatX, y: floatY, width: maxWidth, height: floatHeight))
        menuTbView.delegate = self
        menuTbView.dataSource = self
        menuTbView.backgroundColor = .white
        menuTbView.rowHeight = 44
        menuTbView.isScrollEnabled = false
        menuTbView.showsVerticalScrollIndicator = false
        menuTbView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        addSubview(menuTbView)
        
        menuTbView.layer.shadowColor = UIColor.black.cgColor
        menuTbView.layer.shadowOpacity = 0.5
        menuTbView.layer.shadowRadius = 5

        menuTbView.register(UITableViewCell.self, forCellReuseIdentifier: "FLoatViewCellID")
        
        convertView.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func creatView(belowViewFrame: CGRect,
                         convertView: UIView,
                         superView: UIView,
                         menuDatasource: [String],
                         fontSize: Float = 15) ->TYFloatView{

        let floatView = TYFloatView.init(frame: superView.bounds)
        floatView.backgroundColor = .clear
        floatView.superView = superView
        floatView.belowViewFrame = belowViewFrame
        floatView.convertView = convertView
        floatView.menuDatasource = menuDatasource
        floatView.fontSize = fontSize
        
        floatView.setupView()
        return floatView
    }

    public func viewAnimotion() {
        isHidden = !isHidden
    }
}

extension TYFloatView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FLoatViewCellID")!
        cell.selectionStyle = .none
        cell.textLabel?.text = menuDatasource[indexPath.row]
        cell.textLabel?.font = UIFont.init(name: sr_fontName, size: CGFloat(fontSize))
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDatasource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isHidden = true
        didSelectedCallBack?(menuDatasource[indexPath.row])
    }
}

extension TYFloatView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHidden = true
    }
}

class FLoatViewCell: UITableViewCell {
 
    
}
