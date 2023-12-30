<?php
header('Access-Control-Allow-Origin: *');
include "./conn.php";

// รับค่าจากแบบฟอร์มที่ส่งมา
$id_card = isset($_REQUEST['id_card']) ? $_REQUEST['id_card'] : '';
$titlename = isset($_REQUEST['titlename']) ? $_REQUEST['titlename'] : '';
$firstname = isset($_REQUEST['firstname']) ? $_REQUEST['firstname'] : '';
$lastname = isset($_REQUEST['lastname']) ? $_REQUEST['lastname'] : '';
$date_of_birth = isset($_REQUEST['date_of_birth']) ? $_REQUEST['date_of_birth'] : '';
$heart_value = isset($_REQUEST['heart_value']) ? $_REQUEST['heart_value'] : '';
$pulse_value = isset($_REQUEST['pulse_value']) ? $_REQUEST['pulse_value'] : '';

// เขียนคำสั่ง SQL เพื่อเพิ่มข้อมูลลงในตาราง
$sql = "INSERT INTO `user` (`id_card`, `titlename`, `firstname`, `lastname`, `date_of_birth`, `heart_value`, `pulse_value`) 
        VALUES ('$id_card', '$titlename', '$firstname', '$lastname', '$date_of_birth', $heart_value, $pulse_value)";

if (mysqli_query($conn, $sql)) {
    // ส่งรหัสสถานะ 200 (OK)
    http_response_code(200);
    echo json_encode(['status' => 'success', 'message' => 'User added successfully.']);
} else {
    // ส่งรหัสสถานะ 500 (Internal Server Error) หากมีข้อผิดพลาดในการเพิ่มข้อมูล
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error: ' . $sql . '<br>' . mysqli_error($conn)]);
}

// ปิดการเชื่อมต่อกับฐานข้อมูล
mysqli_close($conn);
?>
