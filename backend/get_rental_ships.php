<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$host = "localhost";
$username = "root";
$password = "Flash478"; 
$dbname = "ship_database";

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Veritabanına bağlanılamadı: " . $conn->connect_error);
}

$sql = "SELECT * FROM rental_ships";
$result = $conn->query($sql);

$ships = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $ships[] = $row;
    }
}

header('Content-Type: application/json');
echo json_encode($ships);

$conn->close();
?>
