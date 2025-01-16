<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

try {
    // Database connection
    $host = "localhost";
    $username = "root";
    $password = "Flash478";
    $dbname = "ship_database";

    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Get transactions from both tables
    $buying_sql = "SELECT *, 'purchase' as type FROM buying_log ORDER BY purchase_date DESC";
    $renting_sql = "SELECT *, 'rental' as type FROM renting_log ORDER BY purchase_date DESC";

    $buying_stmt = $pdo->query($buying_sql);
    $renting_stmt = $pdo->query($renting_sql);

    $buying_transactions = $buying_stmt->fetchAll(PDO::FETCH_ASSOC);
    $renting_transactions = $renting_stmt->fetchAll(PDO::FETCH_ASSOC);

    $all_transactions = array_merge($buying_transactions, $renting_transactions);

    // Sort by purchase date
    usort($all_transactions, function($a, $b) {
        return strtotime($b['purchase_date']) - strtotime($a['purchase_date']);
    });

    echo json_encode([
        'success' => true,
        'data' => $all_transactions
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