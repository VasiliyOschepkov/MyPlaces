//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Vasiliy Oschepkov on 14/04/2019.
//  Copyright © 2019 Vasiliy Oschepkov. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    @IBOutlet weak var imageOfPlace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                // Необходимо установить разрешение
                // добавляем в info.plist Privacy - Camera Usage Description $(PRODUCT_NAME) photo use
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cansel = UIAlertAction(title: "Cansel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cansel)
            
            present(actionSheet, animated: true)
        }else {
            view.endEditing(true)
        }
    }

}

// MARK: text field delegate
extension NewPlaceViewController: UITextFieldDelegate {
    // скрываем клавиатуру по нажатию Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Work with image
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true    // Возможность редактировать фото
            imagePicker.sourceType = source
            
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            imageOfPlace.image = image
            imageOfPlace.contentMode = .scaleAspectFill
            imageOfPlace.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
