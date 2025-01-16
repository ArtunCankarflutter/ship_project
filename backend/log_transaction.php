<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Enable error reporting for debugging
ini_set('display_errors', 1);
error_reporting(E_ALL);

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

try {
    // Get and validate input data
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!$data) {
        throw new Exception('Invalid JSON data received');
    }

    // Validate required fields
    $requiredFields = ['table', 'full_name', 'email', 'phone_number', 'address', 'ship_name', 'total_amount'];
    foreach ($requiredFields as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            throw new Exception("Missing required field: $field");
        }
    }

    // Database connection
    $host = "localhost";
    $username = "root";
    $password = "Flash478";
    $dbname = "ship_database";

    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Prepare SQL based on table
if ($data['table'] === 'buying_log') {
    $sql = "INSERT INTO buying_log (full_name, email, phone_number, address, ship_name, total_amount, purchase_date) 
            VALUES (:full_name, :email, :phone_number, :address, :ship_name, :total_amount, :purchase_date)";
} else if ($data['table'] === 'renting_log') {
    $sql = "INSERT INTO renting_log (full_name, email, phone_number, address, ship_name, total_amount, rental_start_date, rental_end_date, purchase_date) 
            VALUES (:full_name, :email, :phone_number, :address, :ship_name, :total_amount, :rental_start_date, :rental_end_date, :purchase_date)";
} else {
    throw new Exception('Invalid table specified');
}

$stmt = $pdo->prepare($sql);

// Bind common parameters
$params = [
    ':full_name' => $data['full_name'],
    ':email' => $data['email'],
    ':phone_number' => $data['phone_number'],
    ':address' => $data['address'],
    ':ship_name' => $data['ship_name'],
    ':total_amount' => $data['total_amount'],
    ':purchase_date' => $data['purchase_date'] ?? date('Y-m-d H:i:s')
];

// Add rental-specific parameters if needed
if ($data['table'] === 'renting_log') {
    $params[':rental_start_date'] = $data['rental_start_date'] ?? null;
    $params[':rental_end_date'] = $data['rental_end_date'] ?? null;
}

    
    // Execute the query
    $stmt->execute($params);
    
    echo json_encode([
        'success' => true,
        'message' => 'Transaction logged successfully'
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Database error: ' . $e->getMessage()
    ]);
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
?>
