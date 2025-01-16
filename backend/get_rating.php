<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['ship_name'])) {
    $shipName = $data['ship_name'];
    $isRental = isset($data['is_rental']) ? $data['is_rental'] : false;
    $host = "localhost";
    $username = "root";
    $password = "Flash478";
    $dbname = "ship_database";

    try {
        $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // Choose the table based on the ship type
        $table = $isRental ? 'rental_ships' : 'selling_ships';
        
        $stmt = $pdo->prepare("SELECT user_rating FROM $table WHERE ship_name = :ship_name");
        $stmt->bindParam(':ship_name', $shipName, PDO::PARAM_STR);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        echo json_encode([
            'rating' => $result ? floatval($result['user_rating']) : 0.0
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Ship name not provided']);
}
?>






