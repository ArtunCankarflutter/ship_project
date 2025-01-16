<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET");
header("Access-Control-Allow-Headers: Content-Type");

echo json_encode(['status' => 'success', 'message' => 'Connection successful']);
?>