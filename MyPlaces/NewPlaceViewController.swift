//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Vasiliy Oschepkov on 14/04/2019.
//  Copyright © 2019 Vasiliy Oschepkov. All rights reserved.
//

import UIKit


class NewPlaceViewController: UITableViewController {
    var imageIsChanged = false
    var currentPlace: Place?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        
        setupData()
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
    
    func savePlace() {
        var image: UIImage?
        
        if imageIsChanged {
            image = imageOfPlace.image
        }else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             image: image?.pngData())
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.image = newPlace.image
            }
        }else {
            StorageManager.saveObject(newPlace)
        }
        
    }
    
    private func setupData() {
        if currentPlace == nil {return}
        
        guard let data = currentPlace?.image, let image = UIImage(data: data) else {return}
        
        placeName.text = currentPlace?.name
        placeLocation.text = currentPlace?.location
        placeType.text = currentPlace?.type
        
        imageOfPlace.image = image
        imageOfPlace.contentMode = .scaleAspectFill
        
        setupNavigationBar()
        
        imageIsChanged = true
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }

    @IBAction func cancelClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: text field delegate
extension NewPlaceViewController: UITextFieldDelegate {
    // скрываем клавиатуру по нажатию Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChange() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        }else {
            saveButton.isEnabled = false
        }
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
            imageIsChanged = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
