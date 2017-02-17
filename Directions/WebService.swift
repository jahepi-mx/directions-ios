//
//  WebService.swift
//  PTScanner
//
//  Created by Javier Hernández Pineda on 04/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation

class WebService: NSObject, NSXMLParserDelegate {
    
    static let URL: String = "http://192.168.0.27:3306/barcode_webservice/barcode.php";
    
    var mutableData: NSMutableData = NSMutableData()
    var currentElementName: NSString = ""
    var response: String?
    var listener: WebServiceListener?
    var method: String = ""
    
    // Singleton pattern, to share this instance between view controllers
    static let getInstance = WebService()
    
    override init() {
    }
    
    func getMethod() -> String {
        return method;
    }
    
    func changeListener(listener: WebServiceListener) {
        self.listener = listener
    }
    
    func login(email: String, password: String) -> Bool  {
        method = "login";
        if (email == "") {
            listener?.error()
            return false
        }
        let soapMessage: String = String(format: "<?xml version='1.0' encoding='UTF-8' standalone='no'?><SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:tns='urn:Pennsylvania' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soapenc='http://schemas.xmlsoap.org/soap/encoding/' xmlns:soap='http://schemas.xmlsoap.org/wsdl/soap/' xmlns:wsdl='http://schemas.xmlsoap.org/wsdl/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' ><SOAP-ENV:Body><mns:login xmlns:mns='urn:Pennsylvania' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><email xsi:type='xsd:string'><![CDATA[%@]]></email><password xsi:type='xsd:string'><![CDATA[%@]]></password></mns:login></SOAP-ENV:Body></SOAP-ENV:Envelope>", email, password)
        
        let url = NSURL(string: WebService.URL)
        let theRequest = NSMutableURLRequest(URL: url!)
        let msgLength = soapMessage.characters.count
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(theRequest, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.mutableData.length = 0;
                    self.mutableData.appendData(data!)
                    let xmlParser = NSXMLParser(data: self.mutableData)
                    xmlParser.delegate = self
                    xmlParser.parse()
                    xmlParser.shouldResolveExternalEntities = true
                } else {
                    self.listener?.error()
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                }
            } else {
                self.listener?.error()
                NSLog("Unwrapping NSHTTPResponse failed")
            }
        })
        task.resume()
        return true
    }
    
    func getProducts(code: String) -> Bool  {
        method = "getProducts";
        if (code == "") {
            listener?.error()
            return false
        }
        let soapMessage: String = String(format: "<?xml version='1.0' encoding='UTF-8' standalone='no'?><SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:tns='urn:Pennsylvania' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soapenc='http://schemas.xmlsoap.org/soap/encoding/' xmlns:soap='http://schemas.xmlsoap.org/wsdl/soap/' xmlns:wsdl='http://schemas.xmlsoap.org/wsdl/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' ><SOAP-ENV:Body><mns:getProducts xmlns:mns='urn:Pennsylvania' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><code xsi:type='xsd:string'><![CDATA[%@]]></code></mns:getProducts></SOAP-ENV:Body></SOAP-ENV:Envelope>", code)
        
        let url = NSURL(string: WebService.URL)
        let theRequest = NSMutableURLRequest(URL: url!)
        let msgLength = soapMessage.characters.count
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(theRequest, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.mutableData.length = 0;
                    self.mutableData.appendData(data!)
                    let xmlParser = NSXMLParser(data: self.mutableData)
                    xmlParser.delegate = self
                    xmlParser.parse()
                    xmlParser.shouldResolveExternalEntities = true
                } else {
                    self.listener?.error()
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                }
            } else {
                self.listener?.error()
                NSLog("Unwrapping NSHTTPResponse failed")
            }
        })
        task.resume()
        return true
    }
    
    func commitRecolect(product: String, lot: String, qty: String, ubication: String, code: String) -> Bool  {
        method = "commitRecolect";
        if (product == "" || lot == "" || qty == "" || ubication == "" || code == "") {
            listener?.error()
            return false
        }
        let soapMessage: String = String(format: "<?xml version='1.0' encoding='UTF-8' standalone='no'?><SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:tns='urn:Pennsylvania' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soapenc='http://schemas.xmlsoap.org/soap/encoding/' xmlns:soap='http://schemas.xmlsoap.org/wsdl/soap/' xmlns:wsdl='http://schemas.xmlsoap.org/wsdl/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' ><SOAP-ENV:Body><mns:commitRecolect xmlns:mns='urn:Pennsylvania' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><product xsi:type='xsd:string'><![CDATA[%@]]></product><lot xsi:type='xsd:string'><![CDATA[%@]]></lot><qty xsi:type='xsd:string'><![CDATA[%@]]></qty><ubication xsi:type='xsd:string'><![CDATA[%@]]></ubication><code xsi:type='xsd:string'><![CDATA[%@]]></code></mns:commitRecolect></SOAP-ENV:Body></SOAP-ENV:Envelope>", product, lot, qty, ubication, code)
        
        let url = NSURL(string: WebService.URL)
        let theRequest = NSMutableURLRequest(URL: url!)
        let msgLength = soapMessage.characters.count
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(theRequest, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.mutableData.length = 0;
                    self.mutableData.appendData(data!)
                    let xmlParser = NSXMLParser(data: self.mutableData)
                    xmlParser.delegate = self
                    xmlParser.parse()
                    xmlParser.shouldResolveExternalEntities = true
                } else {
                    self.listener?.error()
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                }
            } else {
                self.listener?.error()
                NSLog("Unwrapping NSHTTPResponse failed")
            }
        })
        task.resume()
        return true
    }
    
    func processCode(code: String) -> Bool  {
        method = "processCode";
        if (code == "") {
            listener?.error()
            return false
        }
        let soapMessage: String = String(format: "<?xml version='1.0' encoding='UTF-8' standalone='no'?><SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:tns='urn:Pennsylvania' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soapenc='http://schemas.xmlsoap.org/soap/encoding/' xmlns:soap='http://schemas.xmlsoap.org/wsdl/soap/' xmlns:wsdl='http://schemas.xmlsoap.org/wsdl/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' ><SOAP-ENV:Body><mns:processCode xmlns:mns='urn:Pennsylvania' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><code xsi:type='xsd:string'><![CDATA[%@]]></code></mns:processCode></SOAP-ENV:Body></SOAP-ENV:Envelope>", code)
        
        let url = NSURL(string: WebService.URL)
        let theRequest = NSMutableURLRequest(URL: url!)
        let msgLength = soapMessage.characters.count
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(theRequest, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.mutableData.length = 0;
                    self.mutableData.appendData(data!)
                    let xmlParser = NSXMLParser(data: self.mutableData)
                    xmlParser.delegate = self
                    xmlParser.parse()
                    xmlParser.shouldResolveExternalEntities = true
                } else {
                    self.listener?.error()
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                }
            } else {
                self.listener?.error()
                NSLog("Unwrapping NSHTTPResponse failed")
            }
        })
        task.resume()
        return true
    }
    
    func confirmCode(code: String) -> Bool  {
        method = "confirmCode";
        if (code == "") {
            listener?.error()
            return false
        }
        let soapMessage: String = String(format: "<?xml version='1.0' encoding='UTF-8' standalone='no'?><SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:tns='urn:Pennsylvania' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soapenc='http://schemas.xmlsoap.org/soap/encoding/' xmlns:soap='http://schemas.xmlsoap.org/wsdl/soap/' xmlns:wsdl='http://schemas.xmlsoap.org/wsdl/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' ><SOAP-ENV:Body><mns:confirmCode xmlns:mns='urn:Pennsylvania' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><code xsi:type='xsd:string'><![CDATA[%@]]></code></mns:confirmCode></SOAP-ENV:Body></SOAP-ENV:Envelope>", code)
        
        let url = NSURL(string: WebService.URL)
        let theRequest = NSMutableURLRequest(URL: url!)
        let msgLength = soapMessage.characters.count
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(theRequest, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.mutableData.length = 0;
                    self.mutableData.appendData(data!)
                    let xmlParser = NSXMLParser(data: self.mutableData)
                    xmlParser.delegate = self
                    xmlParser.parse()
                    xmlParser.shouldResolveExternalEntities = true
                } else {
                    self.listener?.error()
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                }
            } else {
                self.listener?.error()
                NSLog("Unwrapping NSHTTPResponse failed")
            }
        })
        task.resume()
        return true
    }
    
    func commitTransfer1(product: String, lot: String, qty: String, ubication: String, code: String) -> Bool  {
        method = "commitTransfer1";
        if (product == "" || lot == "" || qty == "" || ubication == "" || code == "") {
            listener?.error()
            return false
        }
        let soapMessage: String = String(format: "<?xml version='1.0' encoding='UTF-8' standalone='no'?><SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:tns='urn:Pennsylvania' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soapenc='http://schemas.xmlsoap.org/soap/encoding/' xmlns:soap='http://schemas.xmlsoap.org/wsdl/soap/' xmlns:wsdl='http://schemas.xmlsoap.org/wsdl/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' ><SOAP-ENV:Body><mns:commitTransfer1 xmlns:mns='urn:Pennsylvania' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><product xsi:type='xsd:string'><![CDATA[%@]]></product><lot xsi:type='xsd:string'><![CDATA[%@]]></lot><qty xsi:type='xsd:string'><![CDATA[%@]]></qty><ubication xsi:type='xsd:string'><![CDATA[%@]]></ubication><code xsi:type='xsd:string'><![CDATA[%@]]></code></mns:commitTransfer1></SOAP-ENV:Body></SOAP-ENV:Envelope>", product, lot, qty, ubication, code)
        
        let url = NSURL(string: WebService.URL)
        let theRequest = NSMutableURLRequest(URL: url!)
        let msgLength = soapMessage.characters.count
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(theRequest, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.mutableData.length = 0;
                    self.mutableData.appendData(data!)
                    let xmlParser = NSXMLParser(data: self.mutableData)
                    xmlParser.delegate = self
                    xmlParser.parse()
                    xmlParser.shouldResolveExternalEntities = true
                } else {
                    self.listener?.error()
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                }
            } else {
                self.listener?.error()
                NSLog("Unwrapping NSHTTPResponse failed")
            }
        })
        task.resume()
        return true
    }
    
    func commitTransfer2(product: String, lot: String, qty: String, ubication: String, code: String) -> Bool  {
        method = "commitTransfer2";
        if (product == "" || lot == "" || qty == "" || ubication == "" || code == "") {
            listener?.error()
            return false
        }
        let soapMessage: String = String(format: "<?xml version='1.0' encoding='UTF-8' standalone='no'?><SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:tns='urn:Pennsylvania' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soapenc='http://schemas.xmlsoap.org/soap/encoding/' xmlns:soap='http://schemas.xmlsoap.org/wsdl/soap/' xmlns:wsdl='http://schemas.xmlsoap.org/wsdl/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' ><SOAP-ENV:Body><mns:commitTransfer2 xmlns:mns='urn:Pennsylvania' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><product xsi:type='xsd:string'><![CDATA[%@]]></product><lot xsi:type='xsd:string'><![CDATA[%@]]></lot><qty xsi:type='xsd:string'><![CDATA[%@]]></qty><ubication xsi:type='xsd:string'><![CDATA[%@]]></ubication><code xsi:type='xsd:string'><![CDATA[%@]]></code></mns:commitTransfer2></SOAP-ENV:Body></SOAP-ENV:Envelope>", product, lot, qty, ubication, code)
        
        let url = NSURL(string: WebService.URL)
        let theRequest = NSMutableURLRequest(URL: url!)
        let msgLength = soapMessage.characters.count
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        let session: NSURLSession = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(theRequest, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.mutableData.length = 0;
                    self.mutableData.appendData(data!)
                    let xmlParser = NSXMLParser(data: self.mutableData)
                    xmlParser.delegate = self
                    xmlParser.parse()
                    xmlParser.shouldResolveExternalEntities = true
                } else {
                    self.listener?.error()
                    print("Status: \(httpResponse.statusCode) and Response: \(httpResponse)")
                }
            } else {
                self.listener?.error()
                NSLog("Unwrapping NSHTTPResponse failed")
            }
        })
        task.resume()
        return true
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElementName == "return" {
            response = string
            listener?.success(response!)
        }
    }
}
