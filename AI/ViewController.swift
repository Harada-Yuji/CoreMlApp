//
//  ViewController.swift
//  AI
//
//  Created by Harada Yuji on 2018/08/06.
//  Copyright © 2018年 Harada Yuji. All rights reserved.
//

import UIKit

import CoreML
import Vision

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myTextView: UITextView!
    
    var imagePicker: UIImagePickerController!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        myTextView.text = ""
        
    }

    @IBAction func tapButton(_ sender: Any) {
        imagePicker.sourceType =  .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        myImageView.image = image
        
        predict(inputImage: image)
    }

    func predict(inputImage: UIImage) {
        self.myTextView.text = ""
        guard let model = try? VNCoreMLModel(for: Resnet50().model)else {
            return
        }
        let request = VNCoreMLRequest(model: model) {
            request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }
            for result in results {
                let per = Int(result .confidence * 100)
                if per >= 1 {
                    let name = result.identifier
                    self.myTextView.text.append("これは\(name)です。確率は\(per)%\n")
                }
            }
        
        }
        guard let ciImage = CIImage(image: inputImage) else {
            return
        }
        let imageHandler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try imageHandler.perform([request])
        } catch {
            print("エラー\(error)")
        }
        
        
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

