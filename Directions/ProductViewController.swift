//
//  ViewController.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 16/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//
import UIKit

class ProductViewController: UIViewControllerPortrait, UITableViewDataSource, UITableViewDelegate, WebServiceListener {
    
    static let SEPARATOR: String = "[separator]";
    static let ERROR: String = "ERROR";
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var instructionBtn: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var webService: WebService = WebService.getInstance
    var soundManager: SoundManager = SoundManager()
    var productManager: ProductManager = ProductManager.getInstance
    var alertErrorView: UIAlertController!
    var code: String = ""
    
    func setCodeValue(code: String) {
        let index = code.startIndex.advancedBy(10)
        self.code = code.substringToIndex(index)
    }
    
    private func parseResponse(response: String) {
        let chunks: [String] = response.componentsSeparatedByString(ProductViewController.SEPARATOR)
        
        let products: NSData = chunks[0].dataUsingEncoding(NSUTF8StringEncoding)!
        var anyObj: AnyObject?
        do {
            anyObj = try NSJSONSerialization.JSONObjectWithData(products, options: NSJSONReadingOptions())
        } catch {
            print(error)
        }
        self.parseJsonProducts(anyObj!)
        
        let instructions: NSData = chunks[1].dataUsingEncoding(NSUTF8StringEncoding)!
        do {
            anyObj = try NSJSONSerialization.JSONObjectWithData(instructions, options: NSJSONReadingOptions())
        } catch {
            print(error)
        }
        self.parseJsonInstructions(anyObj!)
    }
    
    private func parseJsonProducts(anyObj: AnyObject) {
        if  anyObj is Array<AnyObject> {
            for json in anyObj as! Array<AnyObject> {
                let product: Product = Product()
                product.setName((json["Producto"] as AnyObject? as? String) ?? "");
                product.setDescription((json["desc"] as AnyObject? as? String) ?? "");
                product.setLots((json["lotes"] as AnyObject? as? String) ?? "");
                product.setBarcode((json["codigoBarras"] as AnyObject? as? String) ?? "");
                let qo: String = (json["QO"] as? String) ?? "0"
                product.setQo(Int(qo) != nil ? Int(qo)! : 0);
                let qty: String = (json["inv"] as? String) ?? "0"
                product.setQuantity(Int(qty) != nil ? Int(qty)! : 0);
                let sel: String = (json["surtido"] as? String) ?? "0"
                product.setSelection(Int(sel) != nil ? Int(sel)! : 0);
                let remain: String = (json["saldo"] as? String) ?? "0"
                product.setRemain(Int(remain) != nil ? Int(remain)! : 0);
                productManager.addProduct(product)
            }
        }
    }
    
    private func parseJsonInstructions(anyObj: AnyObject) {
        if  anyObj is Array<AnyObject> {
            var order: Int = 0;
            var lastUbication: String = "";
            var instruction: Instruction = Instruction()
            for json in anyObj as! Array<AnyObject> {
                let ubication: String = (json["ubicacion"] as AnyObject? as? String) ?? ""
                if (ubication != lastUbication) {
                    order = order + 1
                    instruction = Instruction()
                    instruction.setOrder(order)
                    instruction.setUbication(ubication)
                    productManager.addInstruction(instruction)
                }
                let productInstruction: ProductInstruction = ProductInstruction()
                productInstruction.setLot((json["lote"] as AnyObject? as? String) ?? "");
                let name: String = (json["producto"] as AnyObject? as? String) ?? ""
                productInstruction.setProduct(productManager.getProductByName(name)!)
                let qty: String = (json["Q"] as? String) ?? "0"
                productInstruction.setQuantity(Int(qty) != nil ? Int(qty)! : 0);
                let consecutive: String = (json["con"] as? String) ?? "0"
                productInstruction.setConsecutive(Int(consecutive) != nil ? Int(consecutive)! : 0);
                let line: String = (json["lin"] as? String) ?? "0"
                productInstruction.setLine(Int(line) != nil ? Int(line)! : 0);
                instruction.addProductInstruction(productInstruction)
                lastUbication = ubication
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        backBtn.layer.cornerRadius = 10
        instructionBtn.layer.cornerRadius = 10
        alertErrorView = UIAlertController(title: "Error!", message: "No hay instrucciones disponibles", preferredStyle: UIAlertControllerStyle.Alert)
        alertErrorView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (productManager.hasCode() == false) {
            presentViewController(Dialog.waitDialog(), animated: true, completion: nil)
            productManager.setCode(code)
            webService.changeListener(self)
            webService.getProducts(code)
        }
        labelTitle.text = productManager.getCode()
        progressLabel.text = "Avance " + String(format: "%.01f", productManager.getInstructionsProgress() * 100) + " %"
        progressBar.progress = self.productManager.getInstructionsProgress()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        let row = indexPath.row
        let product: Product = productManager.getProduct(row)
        cell.title.text = product.getName()
        cell.desc.text = product.getDescription()
        cell.quantity.text = "Cantidad: " + String(product.getQuantity())
        cell.remain.text = "Saldo: " + String(product.getRemain())
        cell.selection.text = "Surtido: " + String(product.getSelection())
        cell.qo.text = "QO: " + String(product.getQo())
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productManager.productSize()
    }
    
    @IBAction func onClickInstructions(sender: UIButton) {
        if (productManager.hasInstructions() && productManager.isDone() == false) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let instructionViewController = storyboard.instantiateViewControllerWithIdentifier("InstructionViewController") as! InstructionViewController
            presentViewController(instructionViewController, animated: true, completion: nil)
        } else {
            alertErrorView.message = "No hay instrucciones disponibles o ya fueron completadas"
            presentViewController(alertErrorView, animated: true, completion: nil)
        }
    }
    
    func success(response: String) {
        if (response == ProductViewController.ERROR) {
            error()
        } else {
            self.parseResponse(response)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.dismissViewControllerAnimated(false, completion: nil)
                self.soundManager.playSuccess()
                self.progressLabel.text = "Avance " + String(format: "%.01f", self.productManager.getInstructionsProgress() * 100) + " %"
                self.progressBar.progress = self.productManager.getInstructionsProgress()
            })
        }
    }
    
    func error() {
        dispatch_async(dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(false, completion: nil)
            self.alertErrorView.message = "Hubo un error al contactar con el servicio web"
            self.presentViewController(self.alertErrorView, animated: true, completion: nil)
            self.soundManager.playError()
        })
    }
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        let strategy: ProductViewStrategy = ProductViewStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        presentViewController(viewController, animated: true, completion: nil)
    }
}

