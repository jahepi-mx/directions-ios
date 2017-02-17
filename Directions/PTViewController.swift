//
//  PTViewController.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 02/12/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation

class PTViewController: UIViewControllerPortrait, UITableViewDataSource, UITableViewDelegate, WebServiceListener {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var qrLabel: UILabel!
    @IBOutlet weak var processBtn: UIButton!
    
    var code: String = ""
    var response: String = "";
    var alertView: UIAlertController!
    var alertErrorView: UIAlertController!
    var alertSuccessView: UIAlertController!
    var webService: WebService = WebService.getInstance
    var isProcessing: Bool = false
    var speech = Speech.getInstance
    
    var list: Array<Item> = []
    
    struct Item {
        var qty: String = ""
        var name: String = ""
        var desc: String = ""
    }
    
    func setCodeValue(code: String) {
        self.code = code
    }
    
    func parseJson(anyObj: AnyObject) -> Array<Item>{
        var list: Array<Item> = []
        if  anyObj is Array<AnyObject> {
            var item: Item = Item()
            for json in anyObj as! Array<AnyObject>{
                item.name = (json["Producto"] as AnyObject? as? String) ?? ""
                item.qty =  (json["Q"] as AnyObject? as? String) ?? ""
                item.desc =  (json["desc"] as AnyObject? as? String) ?? ""
                list.append(item)
            }
        }
        return list
    }
    
    @IBAction func onProcessBtnClick(sender: AnyObject) {
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func onBackBtn(sender: AnyObject) {
        let strategy: PTViewStrategy = PTViewStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presentViewController(Dialog.waitDialog(), animated: true, completion: nil)
        webService.changeListener(self)
        webService.processCode(code)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn.layer.masksToBounds = true
        backBtn.layer.cornerRadius = 20
        processBtn.layer.masksToBounds = true
        processBtn.layer.cornerRadius = 20
        qrLabel.layer.masksToBounds = true
        qrLabel.layer.cornerRadius = 5
        qrLabel.text = code
        
        alertView = UIAlertController(title: "Confirmación", message: "Estás seguro de confirmar la acción?", preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "Procesar", style: .Default, handler: {(action: UIAlertAction) in
            if (self.list.count == 0) {
                self.registerError("Documento no encontrado, verificar si no está cancelado o ya se hizo la entrada")
            } else {
                if (!self.isProcessing) {
                    self.isProcessing = true
                    self.presentViewController(Dialog.waitDialog(), animated: true, completion: nil)
                    let tempCode: String = self.code
                    self.webService.confirmCode(tempCode)
                }
            }
        }))
        alertView.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
        
        alertErrorView = UIAlertController(title: "Error!", message: "Hubo un error al llamar al servicio web, intenta nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
        alertErrorView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        alertSuccessView = UIAlertController(title: "Exito Registro", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertSuccessView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction) in
            let strategy: PTViewStrategy = PTViewStrategy()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
            viewController.setStrategy(strategy)
            self.presentViewController(viewController, animated: true, completion: nil)
        }))
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellpt", forIndexPath: indexPath) as! CustomCellPT
        let row = indexPath.row
        cell.productLabel.text = list[row].name
        cell.quantityLabel.text = "Cantidad " + list[row].qty
        cell.descLabel.text = list[row].desc
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onProcessCode(response: String) {
        self.response = response
        let data: NSData = self.response.dataUsingEncoding(NSUTF8StringEncoding)!
        var anyObj: AnyObject?
        do {
            anyObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
        } catch {
            print(error)
        }
        list = self.parseJson(anyObj!)
        print(list)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        if (list.count == 0) {
            let message: String = "Documento no encontrado, verificar si no está cancelado o ya se hizo la entrada"
            registerError(message)
            speech.speak(message)
        } else {
            var message: String = ""
            for item in list {
                message += "Debes contar " + item.qty + " de " + item.desc + "     "
            }
            speech.speak(message)
        }
    }
    
    func success(response : String) {
        if (webService.getMethod() == "processCode") {
            self.dismissViewControllerAnimated(false, completion:  {() -> Void in
                self.onProcessCode(response);
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(false, completion: nil)
                let data: NSData = response.dataUsingEncoding(NSUTF8StringEncoding)!
                var anyObj: AnyObject?
                do {
                    anyObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                    let folio: String = (anyObj!["folio"] as? String) ?? ""
                    let error: String = (anyObj!["error"] as? String) ?? ""
                    if (folio == "") {
                        self.isProcessing = false
                        self.registerError(error)
                    } else {
                        self.alertSuccessView.message = "Folio " + folio
                        let chars = folio.characters.map { String($0) }
                        let spelledFolio = chars.joinWithSeparator(" ")
                        self.speech.speak("Folio " + spelledFolio + " generado")
                        self.presentViewController(self.alertSuccessView, animated: true, completion: nil)
                    }
                } catch {
                    print(error)
                }
            })
        }
    }
    
    func error() {
        dispatch_async(dispatch_get_main_queue(), {
            self.isProcessing = false
            self.dismissViewControllerAnimated(false, completion: nil)
            self.alertErrorView.message = "Hubo un error al llamar al servicio web, intenta nuevamente";
            self.presentViewController(self.alertErrorView, animated: true, completion: nil)
        })
    }
    
    func registerError(error: String) {
        alertErrorView.message = error
        presentViewController(alertErrorView, animated: true, completion: nil)
    }
}
