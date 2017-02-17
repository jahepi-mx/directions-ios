//
//  ViewController.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 16/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//
import UIKit

class InstructionViewController: UIViewControllerPortrait {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var ubicationImage: UIImageView!
    @IBOutlet weak var ubicationBtn: UIButton!
    @IBOutlet weak var ubicationLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    var webservice: WebService = WebService.getInstance
    var productManager: ProductManager = ProductManager.getInstance
    var ubicationCode: String = ""
    var alertErrorView: UIAlertController!
    var speech = Speech.getInstance
    
    func setCode(code: String) {
        self.ubicationCode = code
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.layer.cornerRadius = 10
        ubicationBtn.layer.cornerRadius = 10
        labelTitle.text = productManager.getCode()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let instruction: Instruction? = productManager.getCurrentInstruction()!
        if (instruction != nil) {
            instructionLabel.text = "Instruccion " + String(instruction!.getOrder())
            ubicationLabel.text = "Dirígite a la ubicación " + String(instruction!.getUbication()) + " y escanea dando un toque al botón escanear ubicación"
            progressLabel.text = "Avance " + String(format: "%.01f", productManager.getInstructionsProgress() * 100) + " %"
            progressBar.progress = productManager.getInstructionsProgress()
            if (ubicationCode != "") {
                if (instruction?.getUbication() == ubicationCode) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewControllerWithIdentifier("ProductInstructionViewController") as! ProductInstructionViewController
                    presentViewController(viewController, animated: true, completion: nil)
                } else {
                    alertErrorView = UIAlertController(title: "Error!", message: "La ubicación no es correcta", preferredStyle: UIAlertControllerStyle.Alert)
                    alertErrorView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    presentViewController(alertErrorView, animated: true, completion: nil)
                    speech.speak("La ubicación no es correcta")
                }
            } else {
                let message: String = "Iniciando instrucción " + String(instruction!.getOrder()) + "; Dirígete a la ubicación " + (instruction?.getSpelledUbication())!
                speech.speak(message)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickUbicationBtn(sender: AnyObject) {
        ubicationCode = ""
        let strategy: InstructionViewStrategy = InstructionViewStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        presentViewController(viewController, animated: true, completion: nil)
    }
}
