//
//  ImagePickerManager.swift
//  Uveaa Solar
//
//  Created by apple on 12/02/24.
//

import Foundation
import UIKit

protocol ImagePickerDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
}

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: ImagePickerDelegate?
    private var presentingViewController: UIViewController?
       
       init(presentingViewController: UIViewController) {
           super.init()
           self.presentingViewController = presentingViewController
       }

       func showImagePickerActionSheet() {
           let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

           let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { [weak self] (_) in
               self?.openCamera()
           }

           let chooseFromGalleryAction = UIAlertAction(title: "Choose from Gallery", style: .default) { [weak self] (_) in
               self?.openGallery()
           }

          
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

           actionSheet.addAction(takePhotoAction)
           actionSheet.addAction(chooseFromGalleryAction)
           actionSheet.addAction(cancelAction)

           presentingViewController?.present(actionSheet, animated: true, completion: nil)
       }
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            // Handle the case where the camera is not available
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        
        /*
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
               imagePicker.cameraDevice = .rear
           } else if UIImagePickerController.isCameraDeviceAvailable(.front) {
               imagePicker.cameraDevice = .front
//               imagePicker.cameraViewTransform = CGAffineTransform(scaleX: -1.0, y: 1.0)
           }
           
        
        /*
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            imagePicker.cameraDevice = .rear
            //imagePicker.cameraViewTransform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        else if UIImagePickerController.isCameraDeviceAvailable(.front) {
            imagePicker.cameraDevice = .front
            imagePicker.cameraViewTransform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        */
        */
        
        presentingViewController?.present(imagePicker, animated: true, completion: nil)
    }

       private func openGallery() {
           let imagePicker = UIImagePickerController()
           imagePicker.sourceType = .photoLibrary
           imagePicker.delegate = self
           presentingViewController?.present(imagePicker, animated: true, completion: nil)
       }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            delegate?.didSelectImage(selectedImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
