<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
ini_set("soap.wsdl_cache_enabled", "0");
$server = new SoapServer("barcode.wsdl");

define("KEPLER_PATH", "C:\K80Cliente\K80.exe");
define("KEPLER_KS_INI", "C:\K80Cliente\ks_ini.kpl");
define("KEPLER_USER", "SA");
define("KEPLER_PASSWORD", "123");
define("KEPLER_PRIVILIGE", "ADMINISTRADOR");
define("KEPLER_LANG", "ESPAÑOL");
define("KEPLER_IP", "192.168.0.27:1805");
define("OUTPUT_KEPLER_FOLDER", "C:\\ecommerce\output\\");
define("INPUT_KEPLER_FOLDER", "C:\\ecommerce\input\\");
define("INVOICE_KEPLER_FOLDER", "C:\\ecommerce\\facturas\\");

/**
  @var String $code 
  String definition: code
 */
function processCode($code) {
	//$code = "0031349";
	$startTime = time();
	$cmd = KEPLER_PATH . " '" . KEPLER_KS_INI . "' '" . KEPLER_USER . "' '" . KEPLER_PASSWORD . "' '" . KEPLER_PRIVILIGE . "' '" . KEPLER_LANG . "' '" . KEPLER_IP. "' 'PPPreEntradaProdMiniIpod' '$code' '1'";
	exec($cmd, $output);

	$file = OUTPUT_KEPLER_FOLDER . "preentrada.json";
	$handle = fopen($file, 'r');
	$content = fread($handle, filesize($file));
	fclose($handle);

	$content = str_ireplace("\n", "", $content);
	$content = str_ireplace("\r", "", $content);
	
	$endTime = time();
	$file = OUTPUT_KEPLER_FOLDER . "log.txt";
	$handle = fopen($file, 'a');
	fwrite($handle, "processCode: " . ($endTime - $startTime) . " segs \n\n");
	fclose($handle);
	
    return $content;
}

function confirmCode($code) {
	$startTime = time();
	$cmd = KEPLER_PATH . " '" . KEPLER_KS_INI . "' '" . KEPLER_USER . "' '" . KEPLER_PASSWORD . "' '" . KEPLER_PRIVILIGE . "' '" . KEPLER_LANG . "' '" . KEPLER_IP. "' 'PPPreEntradaProdMiniIpod' '$code' '0'";
	exec($cmd, $output);
	//var_dump($output);
	$file = OUTPUT_KEPLER_FOLDER . "preentrada.json";
	$handle = fopen($file, 'r');
	$content = fread($handle, filesize($file));
	fclose($handle);
	//$content = '{"folio":"3454535", "error":""}';
	$content = str_ireplace("\n", "", $content);
	$content = str_ireplace("\r", "", $content);
	
	$endTime = time();
	$file = OUTPUT_KEPLER_FOLDER . "log.txt";
	$handle = fopen($file, 'a');
	fwrite($handle, "confirmCode: " . ($endTime - $startTime) . " segs \n\n");
	fclose($handle);
	
    return $content;
}

function getProducts($code) {
	
	//$code = "01_0008364";
	$startTime = time();
	$code = str_replace('-', '_', $code);
	$return = "ERROR";
	$cmd = KEPLER_PATH . " '" . KEPLER_KS_INI . "' '" . KEPLER_USER . "' '" . KEPLER_PASSWORD . "' '" . KEPLER_PRIVILIGE . "' '" . KEPLER_LANG . "' '192.168.0.187:1821' 'WebSrvSurTarVia' '$code'";
	exec($cmd, $output);

	$file1 = OUTPUT_KEPLER_FOLDER . "sutirEmbarque.json";
	$handle = fopen($file1, 'r');
	$doc1 = fread($handle, filesize($file1));
	fclose($handle);
	
	$file2 = OUTPUT_KEPLER_FOLDER . "instrucciones.json";
	$handle = fopen($file2, 'r');
	$doc2 = fread($handle, filesize($file2));
	fclose($handle);
	
	@unlink($file1);
	@unlink($file2);
	
	$json = json_decode($doc1);
	if (!array_key_exists("error", $json) && $doc1 != "" && $doc2 != "") {
		$return = $doc1 . "[separator]" . $doc2;
		$return = str_ireplace("\n", "", $return);
		$return = str_ireplace("\r", "", $return);
	}
	$endTime = time();
	$file = OUTPUT_KEPLER_FOLDER . "log.txt";
	$handle = fopen($file, 'a');
	fwrite($handle, "getProducts: " . ($endTime - $startTime) . " segs \n\n");
	fclose($handle);
	
    return utf8_decode($return);
}

function commitRecolect($product, $lot, $qty, $origUbication, $code) {
	$startTime = time();
	$code = str_replace('-', '_', $code);
	$return = "ERROR";
	$origLocation = 11;
	$targetLocation = 11;
	$targetUbication = "ZZ99";
	
	$file = OUTPUT_KEPLER_FOLDER . "debug.json";
	$handle = fopen($file, 'w+');
	fwrite($handle, $product . " " . $lot . " " . $qty . " " . $origUbication . " " . $code);
	fclose($handle);
	
	$cmd = KEPLER_PATH . " '" . KEPLER_KS_INI . "' '" . KEPLER_USER . "' '" . KEPLER_PASSWORD . "' '" . KEPLER_PRIVILIGE . "' '" . KEPLER_LANG . "' '192.168.0.187:1821' 'AlmPTTraspasoUbicacionesTransMiniSerWebSer' '$origLocation' '$origUbication' '$targetLocation' '$targetUbication' '$product' '$qty' '$lot' '$code'";
	exec($cmd, $output);

	$file = OUTPUT_KEPLER_FOLDER . "TraspasoTransito.json";
	$handle = fopen($file, 'r');
	$content = fread($handle, filesize($file));
	fclose($handle);

	@unlink($file);
	
	$json = json_decode($content);
	if ($content != "" && array_key_exists("error", $json)) {
		if ($json->error == "") {
			$return = str_ireplace("\n", "", $content);
			$return = str_ireplace("\r", "", $return);
		} 	
	}
	$endTime = time();
	$file = OUTPUT_KEPLER_FOLDER . "log.txt";
	$handle = fopen($file, 'a');
	fwrite($handle, "commitRecolect: " . ($endTime - $startTime) . " segs \n\n");
	fclose($handle);
	
    return utf8_decode($return);
}

function commitTransfer1($product, $lot, $qty, $origUbication, $code) {
	$startTime = time();
	$code = str_replace('-', '_', $code);
	$return = "ERROR";
	$origLocation = 11;
	$targetLocation = 11;
	$targetUbication = "ZZ98";
	
	$file = OUTPUT_KEPLER_FOLDER . "debug.json";
	$handle = fopen($file, 'w+');
	fwrite($handle, $product . " " . $lot . " " . $qty . " " . $origUbication . " " . $code);
	fclose($handle);
	
	$cmd = KEPLER_PATH . " '" . KEPLER_KS_INI . "' '" . KEPLER_USER . "' '" . KEPLER_PASSWORD . "' '" . KEPLER_PRIVILIGE . "' '" . KEPLER_LANG . "' '192.168.0.187:1821' 'AlmPTTraspasoUbicacionesTransTemMiniSerWebSer' '$origLocation' '$origUbication' '$targetLocation' '$targetUbication' '$product' '$qty' '$lot' '$code'";
	exec($cmd, $output);

	$file = OUTPUT_KEPLER_FOLDER . "TraspasoTemporal.json";
	$handle = fopen($file, 'r');
	$content = fread($handle, filesize($file));
	fclose($handle);

	@unlink($file);
	
	$json = json_decode($content);
	if ($content != "" && array_key_exists("error", $json)) {
		if ($json->error == "") {
			$return = str_ireplace("\n", "", $content);
			$return = str_ireplace("\r", "", $return);
		} 	
	}
	$endTime = time();
	$file = OUTPUT_KEPLER_FOLDER . "log.txt";
	$handle = fopen($file, 'a');
	fwrite($handle, "commitTransfer1: " . ($endTime - $startTime) . " segs \n\n");
	fclose($handle);
	
    return utf8_decode($return);
}

function commitTransfer2($product, $lot, $qty, $origUbication, $code) {
	$startTime = time();
	$code = str_replace('-', '_', $code);
	$return = "ERROR";
	$origLocation = 11;
	$targetLocation = 11;
	$targetUbication = $origUbication;
	$origUbication = "ZZ98";
	
	$file = OUTPUT_KEPLER_FOLDER . "debugsalida.json";
	$handle = fopen($file, 'w+');
	fwrite($handle, $product . " " . $lot . " " . $qty . " " . $origUbication . " " . $code);
	fclose($handle);
	
	$cmd = KEPLER_PATH . " '" . KEPLER_KS_INI . "' '" . KEPLER_USER . "' '" . KEPLER_PASSWORD . "' '" . KEPLER_PRIVILIGE . "' '" . KEPLER_LANG . "' '192.168.0.187:1821' 'AlmPTTraspasoUbicacionesTransTemUbiMiniSerWebSer' '$origLocation' '$origUbication' '$targetLocation' '$targetUbication' '$product' '$qty' '$lot' '$code'";
	exec($cmd, $output);

	$file = OUTPUT_KEPLER_FOLDER . "TraspasoSalidaTemporal.json";
	$handle = fopen($file, 'r');
	$content = fread($handle, filesize($file));
	fclose($handle);

	@unlink($file);
	
	$json = json_decode($content);
	if ($content != "" && array_key_exists("error", $json)) {
		if ($json->error == "") {
			$return = str_ireplace("\n", "", $content);
			$return = str_ireplace("\r", "", $return);
		} 	
	}
	$endTime = time();
	$file = OUTPUT_KEPLER_FOLDER . "log.txt";
	$handle = fopen($file, 'a');
	fwrite($handle, "commitTransfer2: " . ($endTime - $startTime) . " segs \n\n");
	fclose($handle);
	
    return utf8_decode($return);
}

function login($email, $password) {
	$link = mysqli_connect("192.168.0.17", "root", "dani3l.13", "pmpp_db");
	$email = trim($email) . "@pennsylvania.com.mx";
	$salt = "";
	$sql = "SELECT password FROM users WHERE email = '$email' LIMIT 1";
	$rs = mysqli_query($link, $sql);
	if ($row = mysqli_fetch_row($rs)) {
		$salt = substr($row[0], 0, 10);
	}
	$password = $salt . substr(sha1($salt . trim($password)), 0, -10);
	$sql = "SELECT 1 FROM users WHERE email = '$email' AND password = '$password'";
	$rs = mysqli_query($link, $sql);
	if ($row = mysqli_fetch_row($rs)) return "true";
	return "false";
}

$server->addFunction("login");
$server->addFunction("processCode");
$server->addFunction("confirmCode");
$server->addFunction("getProducts");
$server->addFunction("commitRecolect");
$server->addFunction("commitTransfer1");
$server->addFunction("commitTransfer2");
$server->handle();
?>