//
//  PhotoManger.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/2.
//  Copyright © 2018年 haowang. All rights reserved.
//

import Foundation
import Photos
import UIKit
import QMUIKit

extension PhotoDelegate where Self:BaseViewController{
    
    func actionSheetToPickImage(_ mutable:Bool?=false){
        
        weak var weakself = self
        let alertController = UIAlertController(title: nil,
                                                message: nil, preferredStyle: .actionSheet)
        let cancelAction    = UIAlertAction(title: "取消", style: .cancel, handler: {
            action in
            
        })
        let okAction        = UIAlertAction(title: "拍照", style: .default,                                    handler: {
            action in
            PhotoManger.shareViewController(.camera, vcl: weakself!,mutable:mutable!)
        })
        let okAction2        = UIAlertAction(title: "从手机相册中选择", style: .default,
                                             handler: {
                                                action in
                                                PhotoManger.shareViewController(.photoLibrary, vcl: weakself!,mutable:mutable!)
        })
        alertController.addAction(okAction)
        alertController.addAction(okAction2)
        alertController.addAction(cancelAction)
        if (presentedViewController != nil) {
            weakself?.dismiss(animated: true, completion: {
                [weak self] in
                self?.present(alertController, animated: true , completion: nil)
            })
        }
        else {
            weakself?.present(alertController, animated: true, completion: nil)
            
        }
    }
}

var PhotoManger = Photo()

class Photo : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
 
    
    var delegate : PhotoDelegate?
    
    fileprivate let maxSelectCount = 9  //最多可选张数
    fileprivate var mutable_choice:Bool = false //是否多选
    
    /*** 系统相机使用 ***/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true , completion: {
            [weak self] in
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self?.delegate?.didChooseImage(images: [image])
        })
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true , completion: nil)
    }
    
    
   
    func shareViewController<inVc:BaseViewController>(_ type: UIImagePickerControllerSourceType,vcl:inVc,mutable:Bool) where inVc: PhotoDelegate  {
        
        if type == .photoLibrary {
            let albumVC =  QMUIAlbumViewController()
            
            albumVC.albumViewControllerDelegate = self
            albumVC.contentType = QMUIAlbumContentType.all
            albumVC.title = "所有照片"
            albumVC.view.tag = mutable ? 1047 : 1048   //具体阅读QMUI源码
            self.mutable_choice = mutable
            self.delegate = vcl
            
            let nav = BaseNavigationViewController(rootViewController: albumVC)
            vcl.present(nav, animated: true, completion: nil)
        }
        else {
            
            guard UIImagePickerController.isSourceTypeAvailable(type) else {
                return
            }
            let pick = UIImagePickerController()
            pick.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            pick.delegate = self
            pick.sourceType = type
            self.delegate = vcl
            vcl.present(pick, animated: true , completion: nil)
        }
        
       
    }
    deinit {
    }
}

// MARK: - 相册选择
extension Photo:QMUIAlbumViewControllerDelegate,QMUIImagePickerViewControllerDelegate,QMUIImagePickerPreviewViewControllerDelegate{
    
    
    func imagePickerViewController(for albumViewController: QMUIAlbumViewController!) -> QMUIImagePickerViewController! {
        let picker = QMUIImagePickerViewController()
        picker.imagePickerViewControllerDelegate = self
        picker.maximumSelectImageCount = UInt(maxSelectCount)
        picker.view.tag = albumViewController.view.tag
        picker.allowsMultipleSelection = self.mutable_choice
        return picker
    }
    
    func imagePickerViewControllerDidCancel(_ imagePickerViewController: QMUIImagePickerViewController!) {
        imagePickerViewController.dismiss(animated: true, completion: nil)
    }
    func imagePickerPreviewViewController(_ imagePickerPreviewViewController: QMUIImagePickerPreviewViewController!, didCheckImageAt index: Int) {
        deprint(index)
    }
    
    
    func imagePickerViewController(_ imagePickerViewController: QMUIImagePickerViewController!, didFinishPickingImageWithImagesAssetArray imagesAssetArray: NSMutableArray!) {
        
        deprint("选择完成")
    }
    func imagePickerViewController(_ imagePickerViewController: QMUIImagePickerViewController!, didCheckImageAt index: Int) {
        deprint("选择了单张")
    }
    func imagePickerPreviewViewController(for imagePickerViewController: QMUIImagePickerViewController!) -> QMUIImagePickerPreviewViewController! {
        
        if mutable_choice {
            let vc = InMultipleImagePickerPreviewViewController()
            vc.delegate = self
            vc.maximumSelectImageCount = UInt(self.maxSelectCount)
            vc.view.tag = imagePickerViewController.view.tag
            return vc
        }
        else {
            let vc = InSingleImagePickerPreviewViewController()
            vc.singleDelegate = self
            vc.view.tag = imagePickerViewController.view.tag
            return vc
        }
        
    }
    
}

// MARK: - 进入大图预览模式选择图片
extension Photo:SingleImagePickerPreviewViewControllerDelegate,MultipleImagePickerPreviewViewControllerDelegate {
    func imagePickerPreviewViewController(imagePickerPreviewViewController: InSingleImagePickerPreviewViewController, didSelectImageWithImagesAsset imageAsset: QMUIAsset) {
        
        imageAsset.requestImageData {
          [weak self] (data, info, isGif, isHEIC) in
            
            let image = UIImage.init(data: data!)
            self?.delegate?.didChooseImage(images: [image!])
            
        }
        
    }
    

    func imagePickerPreviewViewController(imagePickerPreviewViewController: InMultipleImagePickerPreviewViewController, sendImageWithImagesAssetArray imagesAssetArray: [QMUIAsset]) {
        
        var img_array : [UIImage] = []
        for sub in imagesAssetArray{
            
            let image =  sub.originImage()
            img_array.append(image!)
        }
        self.delegate?.didChooseImage(images: img_array)
        
    }
}

