//
//  InSingleImagePicker.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/2.
//  Copyright © 2018年 haowang. All rights reserved.
//

import Foundation
import QMUIKit

protocol SingleImagePickerPreviewViewControllerDelegate:QMUIImagePickerPreviewViewControllerDelegate {
    
    func imagePickerPreviewViewController( imagePickerPreviewViewController:InSingleImagePickerPreviewViewController, didSelectImageWithImagesAsset  imageAsset:QMUIAsset)
}

class  InSingleImagePickerPreviewViewController:QMUIImagePickerPreviewViewController{
    
    var singleDelegate :SingleImagePickerPreviewViewControllerDelegate!
    var _confirmButton :QMUIButton!
    var assetsGroup:QMUIAssetsGroup!
    override func initSubviews() {
        super.initSubviews()

        _confirmButton = QMUIButton()
        _confirmButton.qmui_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
        _confirmButton.setTitleColor(UIColor.white, for: .normal)
        _confirmButton.setTitle("使用", for: .normal)
        _confirmButton.sizeToFit()
        self.topToolBarView.addSubview(_confirmButton)
        _confirmButton.reactive.controlEvents(.touchUpInside)
            .observeValues {
               [weak self] (button) in
                self?.navigationController?.dismiss(animated: true, completion: {
                    let _strongSelf = self
                    self?.singleDelegate.imagePickerPreviewViewController(imagePickerPreviewViewController: _strongSelf!, didSelectImageWithImagesAsset: _strongSelf!.imagesAssetArray.object(at: Int( self?.imagePreviewView.currentImageIndex ?? 0)) as! QMUIAsset)
                })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _confirmButton.frame = CGRectSetXY(_confirmButton.frame, (self.topToolBarView.frame.width) - (_confirmButton.frame.width) - 10, (self.backButton.frame.minY) + CGFloatGetCenter((self.backButton.frame.height), (_confirmButton.frame.height)));
        self.backButton.frame.size.width = 30
        self.backButton.frame.size.height = 30
        
    }
    
    
}
