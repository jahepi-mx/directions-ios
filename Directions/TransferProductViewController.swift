//
//  TransferProductViewController.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 06/01/17.
//  Copyright © 2017 Javier Hernández Pineda. All rights reserved.
//

import UIKit

class TransferProductViewController: UIViewControllerPortrait, WebServiceListener {
    
    enum CODE_TYPE_TRANSFER { case BOX, CUSTOM, NONE }
    
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var ubicationLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var webservice: WebService = WebService.getInstance
    var soundManager: SoundManager = SoundManager()
    var alertErrorView: UIAlertController!
    var errorReading: Bool = false
    var customInputAlert: UIAlertController!
    var alertInputTextField: UITextField?
    var alertGoBackView: UIAlertController!
    var alertSuccessView: UIAlertController!
    var speech: Speech = Speech.getInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
        customButton.layer.cornerRadius = 10
        ubicationLabel.text = "Ubicación " + Transfer.getInstance.ubication
        alertErrorView = UIAlertController(title: "Error!", message: "No hay datos disponibles", preferredStyle: UIAlertControllerStyle.Alert)
        alertErrorView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        customInputAlert = UIAlertController(title: "Cantidad", message: "Ingresa las piezas a recolectar:", preferredStyle: UIAlertControllerStyle.Alert)
        customInputAlert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil))
        customInputAlert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: {(action: UIAlertAction) in
                if (self.alertInputTextField?.text != "") {
                    Transfer.getInstance.qty = Int((self.alertInputTextField?.text)!)!
                }
                self.proccessCode()
        }))
        customInputAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Ingresa Cantidad:"
            textField.keyboardType = UIKeyboardType.NumberPad
            self.alertInputTextField = textField
        })
        alertGoBackView = UIAlertController(title: "Confirmación", message: "Está seguro que desea regresar?", preferredStyle: UIAlertControllerStyle.Alert)
        alertGoBackView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("TransferViewController") as! TransferViewController
            Transfer.getInstance.ubication = "";
            self.presentViewController(viewController, animated: true, completion: nil)
        }))
        alertGoBackView.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        alertSuccessView = UIAlertController(title: "Éxito", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertSuccessView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (errorReading) {
            self.displayErrorMessage("Hubo un error al escanear el código")
        }
        if (Transfer.getInstance.type == CODE_TYPE_TRANSFER.CUSTOM) {
            self.presentViewController(customInputAlert, animated: true, completion: nil)
        } else if (Transfer.getInstance.type == CODE_TYPE_TRANSFER.BOX) {
            proccessCode();
        }
    }
    
    func proccessCode() {
        webservice.changeListener(self)
        presentViewController(Dialog.waitDialog(), animated: true, completion: nil)
        if (Transfer.getInstance.section == "section1") {
            webservice.commitTransfer1(Transfer.getInstance.product, lot: Transfer.getInstance.lots, qty: String(Transfer.getInstance.qty), ubication: Transfer.getInstance.ubication, code: Transfer.getInstance.code)
        } else {
             webservice.commitTransfer2(Transfer.getInstance.product, lot: Transfer.getInstance.lots, qty: String(Transfer.getInstance.qty), ubication: Transfer.getInstance.ubication, code: Transfer.getInstance.code)
        }
        
    }
    
    func setCode(codeString: String, type: CODE_TYPE_TRANSFER) {
        errorReading = true
        Transfer.getInstance.type = type
        if (type == CODE_TYPE_TRANSFER.BOX) {
            let components = codeString.componentsSeparatedByString("_")
            switch (components.count) {
                case 3:
                    Transfer.getInstance.product = components[0];
                    Transfer.getInstance.lots = components[2];
                    Transfer.getInstance.qty = Int(components[1])!
                    Transfer.getInstance.code = codeString;
                    errorReading = false;
                default: break
            }
        } else if (type == CODE_TYPE_TRANSFER.CUSTOM) {
            let components = codeString.componentsSeparatedByString("_")
            switch (components.count) {
            case 3:
                Transfer.getInstance.product = components[0];
                Transfer.getInstance.lots = components[2];
                Transfer.getInstance.code = codeString;
                Transfer.getInstance.qty = 0
                errorReading = false;
                default: break
            }
        }
        if (errorReading) {
            Transfer.getInstance.type = CODE_TYPE_TRANSFER.NONE;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickCustomBtn(sender: AnyObject) {
        let strategy: TransferViewCustomStrategy = TransferViewCustomStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickRegisterBtn(sender: AnyObject) {
        let strategy: TransferViewBoxStrategy = TransferViewBoxStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        Transfer.getInstance.type = CODE_TYPE_TRANSFER.NONE;
        presentViewController(alertGoBackView, animated: true, completion: nil)
    }
    
    func success(response: String) {
        dispatch_async(dispatch_get_main_queue(), {
            Transfer.getInstance.type = CODE_TYPE_TRANSFER.NONE;
            self.dismissViewControllerAnimated(false, completion: nil)
            if (response != ProductInstructionViewController.ERROR) {
                    self.soundManager.playSuccess()
                let message: String = "Se realizo el traspaso"
                self.speech.speak(message)
                self.alertSuccessView.message = message
                self.presentViewController(self.alertSuccessView, animated: true, completion: nil)
            } else {
                self.displayErrorMessage("No se pudo recolectar la cantidad")
            }
        })
    }

    func error() {
        dispatch_async(dispatch_get_main_queue(), {
            Transfer.getInstance.type = CODE_TYPE_TRANSFER.NONE;
            self.dismissViewControllerAnimated(false, completion: nil)
            self.alertErrorView.message = "Hubo un error al contactar con el servicio web"
            self.presentViewController(self.alertErrorView, animated: true, completion: nil)
            self.soundManager.playError()
        })
    }
    
    private func displayErrorMessage(message: String) {
        self.speech.speak(message)
        self.alertErrorView.message = message
        self.presentViewController(self.alertErrorView, animated: true, completion: nil)
        self.soundManager.playError()
    }
}