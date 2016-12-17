//
//  HomeViewController+touchimage.swift
//  区帮
//
//  Created by apple on 2016/8/25.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit

extension HomeViewController{
    func touchimage(){
        let vc = addViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
