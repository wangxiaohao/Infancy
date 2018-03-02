//
//  InMultipleImagePickerPreviewViewController.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/2.
//  Copyright © 2018年 haowang. All rights reserved.
//

import Foundation
import QMUIKit


protocol MultipleImagePickerPreviewViewControllerDelegate: QMUIImagePickerPreviewViewControllerDelegate{
    func imagePickerPreviewViewController( imagePickerPreviewViewController: InMultipleImagePickerPreviewViewController, sendImageWithImagesAssetArray  imagesAssetArray:[QMUIAsset]);
}
class InMultipleImagePickerPreviewViewController: QMUIImagePickerPreviewViewController {
    let BottomToolBarViewHeight : CGFloat = 45
    var _imageCountLabel:QMUILabel!
    var assetsGroup:QMUIAssetsGroup!
    var mutablDelegate:MultipleImagePickerPreviewViewControllerDelegate!
    var shouldUseOriginImage:Bool!
    var _sendButton:QMUIButton!
    var _originImageCheckboxButton :QMUIButton!
    var _bottomToolBarView:UIView!
    let  ImageCountLabelSize = CGSize(width: 18, height: 18)

    
    override func initSubviews() {
        super.initSubviews()
        
        _bottomToolBarView = UIView()
        _bottomToolBarView.backgroundColor = self.toolBarBackgroundColor;
        self.view.addSubview(_bottomToolBarView)
        
        _sendButton = QMUIButton()
        _sendButton.qmui_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
        _sendButton.setTitleColor(self.topToolBarView.tintColor, for: .normal)
        _sendButton.setTitle("确定", for: .normal)
        _sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        _sendButton.sizeToFit()
        _sendButton.reactive.controlEvents(.touchUpInside)
            .observeValues {
               [weak self] (button) in
                self?.navigationController?.dismiss(animated: true, completion: {
                    if self?.selectedImageAssetArray.count == 0 {
                        let set = self?.imagesAssetArray.object(at: Int(self?.imagePreviewView.currentImageIndex ?? 0 ))
                        self?.selectedImageAssetArray.add(set)
                    }
                    self?.mutablDelegate.imagePickerPreviewViewController(imagePickerPreviewViewController: self!, sendImageWithImagesAssetArray: self?.selectedImageAssetArray as! [QMUIAsset])
                    
                })
                
                
        }
    
        _bottomToolBarView.addSubview(_sendButton)
        
        _imageCountLabel = QMUILabel()
        _imageCountLabel.backgroundColor = QMUICMI?.buttonTintColor;
        _imageCountLabel.textColor = UIColorWhite;
        _imageCountLabel.font = UIFont.systemFont(ofSize: 12)
        _imageCountLabel.textAlignment = .center
        _imageCountLabel.lineBreakMode = .byWordWrapping
        _imageCountLabel.layer.masksToBounds = true;
        _imageCountLabel.layer.cornerRadius = 18 / 2;
        _imageCountLabel.isHidden = true;
        _bottomToolBarView.addSubview(_imageCountLabel)
        
        _originImageCheckboxButton = QMUIButton()
        _originImageCheckboxButton.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        _originImageCheckboxButton.setTitleColor(self.toolBarTintColor, for: .normal)
      
        _originImageCheckboxButton.setImage(UIImage.init(named: "origin_image_checkbox"), for: .normal)
        _originImageCheckboxButton.setImage(UIImage.init(named: "origin_image_checkbox_checked"), for: .selected)
        _originImageCheckboxButton.setImage(UIImage.init(named: "origin_image_checkbox_checked"), for: .selected)
        _originImageCheckboxButton.setTitle("原图", for: .normal)
        
        _originImageCheckboxButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        _originImageCheckboxButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    
        _originImageCheckboxButton.sizeToFit()
        
        _originImageCheckboxButton.qmui_outsideEdge = UIEdgeInsetsMake(-6.0, -6.0, -6.0, -6.0);
        _originImageCheckboxButton.reactive.controlEvents(.touchUpInside)
            .observeValues {
               [weak self] (button) in
                
                if (button.isSelected) {
                    button.isSelected = false;
                    button.setTitle("原图", for:.normal)
                    button.sizeToFit()
                    self?._bottomToolBarView.setNeedsLayout()
                } else {
                    button.isSelected = true
                self?.updateOriginImageCheckboxButtonWithIndex(self?.imagePreviewView.currentImageIndex ?? 0)
                  
                }
                self?.shouldUseOriginImage = button.isSelected
        }
        _bottomToolBarView.addSubview(_originImageCheckboxButton)
    }
    
    func updateOriginImageCheckboxButtonWithIndex(_ index:UInt){
        let asset : QMUIAsset = self.imagesAssetArray.object(at: Int(index)) as! QMUIAsset
        if asset.assetType == .audio || asset.assetType == .video{
            _originImageCheckboxButton.isHidden = true
        }
        else {
            _originImageCheckboxButton.isHidden = false
            if _originImageCheckboxButton.isSelected{
                asset.assetSize({
                   [weak self] (size) in
                    //size 可以计算大小
                    self?._originImageCheckboxButton.setTitle("原图", for: .normal)
                    self?._originImageCheckboxButton.sizeToFit()
                    self?._bottomToolBarView.setNeedsLayout()
                    
                })
            }
        }
    }
    override func singleTouch(inZooming zoomImageView: QMUIZoomImageView!, location: CGPoint) {
        super.singleTouch(inZooming: zoomImageView, location: location)
        _bottomToolBarView.isHidden = !_bottomToolBarView.isHidden
    }
    override func zoomImageView(_ imageView: QMUIZoomImageView!, didHideVideoToolbar didHide: Bool) {
        super.zoomImageView(imageView, didHideVideoToolbar: didHide)
        _bottomToolBarView.isHidden = didHide
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomToolBarPaddingHorizontal : CGFloat = 12.0;
        _bottomToolBarView.frame = CGRect(x:0, y:(self.view.bounds.height) - BottomToolBarViewHeight, width:(self.view.bounds.width),height: BottomToolBarViewHeight);
        _sendButton.frame = CGRectSetXY(_sendButton.frame, (_bottomToolBarView.frame.width) - bottomToolBarPaddingHorizontal - (_sendButton.frame.width), CGFloatGetCenter((_bottomToolBarView.frame.height), (_sendButton.frame.height)));
        _imageCountLabel.frame = CGRect(x:(_sendButton.frame.minX) - 5 - ImageCountLabelSize.width, y:(_sendButton.frame.minY) + CGFloatGetCenter((_sendButton.frame.height), (_imageCountLabel.frame.height)), width:ImageCountLabelSize.width, height:ImageCountLabelSize.height);
        _originImageCheckboxButton.frame = CGRectSetXY(_originImageCheckboxButton.frame, bottomToolBarPaddingHorizontal, CGFloatGetCenter((_bottomToolBarView.frame.height), (_originImageCheckboxButton.frame.height)));
    }
    override func imagePreviewView(_ imagePreviewView: QMUIImagePreviewView!, willScrollHalfTo index: UInt) {
        super.imagePreviewView(imagePreviewView, willScrollHalfTo: index)
        self.updateOriginImageCheckboxButtonWithIndex(index)
    }
    
}
