//
//  ViewController.swift
//  Sneaker Sight
//
//  Created by Michael Bernasol on 11/9/19.
//  Copyright © 2019 Michael Bernasol. All rights reserved.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else{
                fatalError("Could not convert UIImage into CIImage")
            }
            
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)

    }
        
    
        //implements custom ML model
        func detect(image:CIImage){
            
            guard let model = try? VNCoreMLModel(for:SneakerRecognition().model) else{
                fatalError("CoreML model failed")
            }
            
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else {
                    fatalError("Model failed")
                }
                if let firstResult = results.first{
                    if firstResult.identifier.contains("Air Jordan 1"){
                        self.navigationItem.title = "These are Air Jordan 1s."
                    }else if firstResult.identifier.contains("Yeezy Boost 350") {
                        self.navigationItem.title = "These are Yeezy Boost 350s"
                    }
                }
        
                
                print(results)
        }
        
            let handler = VNImageRequestHandler(ciImage:image)
            
            try! handler.perform([request])
            
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker,animated: true, completion: nil)
        
    }
    


}

