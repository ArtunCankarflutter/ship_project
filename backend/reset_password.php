<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

$host = "localhost";
$username = "root";
$password = "Flash478"; 
$dbname = "ship_database"; 

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$data = json_decode(file_get_contents("php://input"), true);

$email = $data['email'];
$question = $data['secret_question'];
$answer = $data['secret_answer'];
$new_password = $data['new_password'];

$sql = "SELECT * FROM users WHERE email = ? AND secret_question = ? AND secret_answer = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sis", $email, $question, $answer);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $update_sql = "UPDATE users SET password = ? WHERE email = ?";
    $update_stmt = $conn->prepare($update_sql);
    $update_stmt->bind_param("ss", $new_password, $email);
    if ($update_stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Password reset successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to reset password"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid credentials"]);
}

$conn->close();
?>
