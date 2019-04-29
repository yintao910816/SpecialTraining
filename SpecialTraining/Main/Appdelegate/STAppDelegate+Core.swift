//
//  STAppDelegate+Core.swift
//  SpecialTraining
//
//  Created by sw on 17/04/2019.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation

extension STAppDelegate {

    func configAppData() {
        DbManager.dbSetup()

        _ = UserInfoModel.slectedLoginUser()
            .subscribe(onNext: { UserAccountServer.share.save(loginUser: $0) })
    }
}
