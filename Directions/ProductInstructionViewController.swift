//
//  ProductInstructionViewController.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 22/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//
import UIKit

class ProductInstructionViewController: UIViewControllerPortrait, WebServiceListener {
    
    static let ERROR: String = "ERROR";
    
    enum CODE_TYPE { case BOX, PIECE, CUSTOM }
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var ubicationLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var pieceButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    
    var webservice: WebService = WebService.getInstance
    var productManager: ProductManager = ProductManager.getInstance
    var code: Code?
    var speech: Speech = Speech.getInstance
    var soundManager: SoundManager = SoundManager()
    var alertErrorView: UIAlertController!
    var alertGoBackView: UIAlertController!
    var alertSuccessView: UIAlertController!
    var alertNextProductView: UIAlertController!
    var customInputAlert: UIAlertController!
    var instruction: Instruction?
    var productInstruction: ProductInstruction?
    var errorReading: Bool = false
    var alertInputTextField: UITextField?
    
    struct Code {
        var product: String
        var lot: String
        var quantity: Int
        var type: CODE_TYPE
    }
    
    func setCode(codeString: String, type: CODE_TYPE) {
        errorReading = true
        if (type == CODE_TYPE.BOX) {
            let components = codeString.componentsSeparatedByString("_")
            switch (components.count) {
                case 3: code = Code(product: components[0], lot: components[2], quantity: Int(components[1])!, type: type); errorReading = false;
                default: flushCode()
            }
        } else if (type == CODE_TYPE.PIECE) {
            instruction = productManager.getCurrentInstruction()
            if (instruction != nil) {
                productInstruction = instruction!.getCurrentProductInstruction()
                if (codeString == productInstruction?.getProductBarcode()) {
                    code = Code(product: productInstruction!.getProductName()!, lot: productInstruction!.getLot(), quantity: 1, type: type)
                    errorReading = false;
                    return
                }
            }
            flushCode()
        } else if (type == CODE_TYPE.CUSTOM) {
            /*instruction = productManager.getCurrentInstruction()
            if (instruction != nil) {
                productInstruction = instruction!.getCurrentProductInstruction()
                if (codeString == productInstruction?.getProductBarcode()) {
                    code = Code(product: productInstruction!.getProductName()!, lot: productInstruction!.getLot(), quantity: 0, type: type)
                    errorReading = false;
                    return
                }
            }
            flushCode()*/
            let components = codeString.componentsSeparatedByString("_")
            switch (components.count) {
                case 3: code = Code(product: components[0], lot: components[2], quantity: 0, type: type); errorReading = false;
                default: flushCode()
            }
        }
    }
    
    func flushCode() {
        code = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
        pieceButton.layer.cornerRadius = 10
        customButton.layer.cornerRadius = 10
        instruction = productManager.getCurrentInstruction()
        if (instruction != nil) {
            productInstruction = instruction!.getCurrentProductInstruction()
            if (productInstruction != nil) {
                ubicationLabel.text = "Ubicación " + instruction!.getUbication()
                productLabel.text = productInstruction!.getProductName()! + " (" + productInstruction!.getLot() + ")"
                descriptionLabel.text = productInstruction!.getProductDescription()
                quantityLabel.text = "Cantidad " + String(productInstruction!.getQuantity())
                
                alertGoBackView = UIAlertController(title: "Confirmación", message: "Está seguro que desea regresar?", preferredStyle: UIAlertControllerStyle.Alert)
                alertGoBackView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewControllerWithIdentifier("InstructionViewController") as! InstructionViewController
                    self.presentViewController(viewController, animated: true, completion: nil)
                }))
                alertGoBackView.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
                
                alertErrorView = UIAlertController(title: "Error!", message: "No hay datos disponibles", preferredStyle: UIAlertControllerStyle.Alert)
                alertErrorView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                
                alertSuccessView = UIAlertController(title: "Éxito", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                alertSuccessView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction) in
                    if (self.instruction!.isDone()) {
                        if (self.productManager.isDone()) {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewControllerWithIdentifier("ProductViewController") as! ProductViewController
                            self.presentViewController(viewController, animated: true, completion: nil)
                        } else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewControllerWithIdentifier("InstructionViewController") as! InstructionViewController
                            self.presentViewController(viewController, animated: true, completion: nil)
                        }
                    }
                }))
                
                alertNextProductView = UIAlertController(title: "Producto", message: "Se ha terminado la recolección, oprime OK para pasar al siguiente producto", preferredStyle: UIAlertControllerStyle.Alert)
                alertNextProductView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewControllerWithIdentifier("ProductInstructionViewController") as! ProductInstructionViewController
                    self.presentViewController(viewController, animated: true, completion: nil)
                }))
                
                customInputAlert = UIAlertController(title: "Cantidad", message: "Ingresa las piezas a recolectar:", preferredStyle: UIAlertControllerStyle.Alert)
                customInputAlert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil))
                customInputAlert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: {(action: UIAlertAction) in
                    if (self.code != nil) {
                        if (self.alertInputTextField?.text != "") {
                            self.code?.quantity = Int((self.alertInputTextField?.text)!)!
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.proccessCode()
                        })
                    }
                    
                }))
                customInputAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Ingresa Cantidad:"
                    textField.keyboardType = UIKeyboardType.NumberPad
                    self.alertInputTextField = textField
                })
            }
        }
    }
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        presentViewController(alertGoBackView, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (code != nil) {
            if (code?.type == CODE_TYPE.CUSTOM) {
                self.presentViewController(customInputAlert, animated: true, completion: nil)
            } else {
                proccessCode();
            }
        } else {
            if (productInstruction != nil) {
                if (errorReading == false) {
                    speech.speak("Piezas pendientes por recolectar del producto " + productInstruction!.getProductSpelledName()! + ", " + String(productInstruction!.getQuantity()))
                } else {
                    self.displayErrorMessage("Hubo un error al escanear el código")
                }
            }
        }
    }
    
    func proccessCode() {
        if (productInstruction != nil) {
            progressLabel.text = "Avance " + String(format: "%.01f", productManager.getInstructionsProgress() * 100) + " %"
            progressBar.progress = productManager.getInstructionsProgress()
            if (code != nil) {
                if (self.code?.lot == self.productInstruction?.getLot() && self.code?.product == self.productInstruction?.getProductName()) {
                    if (self.productInstruction!.checkForSubtractQuantity((self.code?.quantity)!)) {
                        presentViewController(Dialog.waitDialog(), animated: true, completion: nil)
                        webservice.changeListener(self)
                        webservice.commitRecolect(productInstruction!.getProductName()!, lot: productInstruction!.getLot(), qty: String(self.code!.quantity), ubication: instruction!.getUbication(), code: productManager.getCode())
                    } else {
                        self.displayErrorMessage("Se sobrepasa la cantidad a recolectar o la cantidad no es válida")
                    }
                } else {
                    self.displayErrorMessage("El código no concuerda con el lote y clave de producto")
                }
            } else {
                if (errorReading == false) {
                    speech.speak("Piezas pendientes por recolectar del producto " + productInstruction!.getProductSpelledName()! + ", " + String(productInstruction!.getQuantity()))
                } else {
                    self.displayErrorMessage("Hubo un error al escanear el código")
                }
            }
        }
    }
    
    @IBAction func onClickRegisterBtn(sender: AnyObject) {
        let strategy: ProductInstructionViewStrategy = ProductInstructionViewStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    
    @IBAction func onClickPieceBtn(sender: AnyObject) {
        let strategy: ProductInstructionPieceViewStrategy = ProductInstructionPieceViewStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickCustomBtn(sender: AnyObject) {
        let strategy: ProductInstructionCustomViewStrategy = ProductInstructionCustomViewStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        presentViewController(viewController, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func success(response: String) {
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(false, completion: nil)
            if (response != ProductInstructionViewController.ERROR) {
                if (self.productInstruction!.subtractQuantity((self.code?.quantity)!)) {
                    self.progressLabel.text = "Avance " + String(format: "%.01f", self.productManager.getInstructionsProgress() * 100) + " %"
                    self.progressBar.progress = self.productManager.getInstructionsProgress()
                    self.quantityLabel.text = "Cantidad " + String(self.productInstruction!.getQuantity())
                    if (self.productInstruction!.getQuantity() > 0) {
                        self.speech.speak("Piezas pendientes por recolectar del producto " + self.productInstruction!.getProductSpelledName()! + ", " + String(self.productInstruction!.getQuantity()))
                    }
                    self.soundManager.playSuccess()
                    if (self.instruction!.isDone()) {
                        let message: String = self.productManager.isDone() ? "Se han completado las instrucciones, el proceso ha finalizado" : "Se ha terminado la instrucción número " + String(self.instruction!.getOrder())
                        self.speech.speak(message)
                        self.alertSuccessView.message = message
                        self.presentViewController(self.alertSuccessView, animated: true, completion: nil)
                    } else {
                        if (self.productInstruction!.isDone()) {
                            self.speech.speak("Se ha terminado la recolección, oprime OK para pasar al siguiente producto")
                            self.presentViewController(self.alertNextProductView, animated: true, completion: nil)
                        }
                    }
                } else {
                    self.displayErrorMessage("El código sobrepasa la cantidad a recolectar")
                }
            } else {
                self.displayErrorMessage("No se pudo recolectar la cantidad")
            }
        })
    }
    
    private func displayErrorMessage(message: String) {
        self.speech.speak(message)
        self.alertErrorView.message = message
        self.presentViewController(self.alertErrorView, animated: true, completion: nil)
        self.soundManager.playError()
    }
    
    func error() {
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(false, completion: nil)
            self.alertErrorView.message = "Hubo un error al contactar con el servicio web"
            self.presentViewController(self.alertErrorView, animated: true, completion: nil)
            self.soundManager.playError()
        })
    }
}