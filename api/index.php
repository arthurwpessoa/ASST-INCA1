<?php
require 'flight/Flight.php';

/**
 * Defines the HTTP return codes
 */
define("BAD_REQUEST", 400);
define("CONFLICT", 409);
define("OK", 200);
define("INTERNAL_SERVER_ERROR", 500);
define("UNAUTHORIZED", 401);

/**
 * Function used to open a connecton with the target database (MySQL)
 */
function OpenCon()
{
	$dbhost = "localhost:3306";
	$dbuser = "root";
	$dbpass = "root";
	$db = "zerowaste";
	$conn = new mysqli($dbhost, $dbuser, $dbpass, $db) or die("Connect failed: %s\n" . $conn->error);
	return $conn;
}

/**
 * Function used to authenticate the user prior to processing the request
 * params: $conn - the database connection, $admin - if the request requires admin authentication
 */
function auth($conn, $admin)
{
	$returnCode = UNAUTHORIZED;
	$username = "";
	$id = "";
	if (array_key_exists("Authorization", getallheaders())) {
		$auth = getallheaders()["Authorization"];
		if (strpos($auth, 'Basic') !== false) {
			$auth =  base64_decode(substr($auth, 6));
			$auth = explode(':', $auth);
			$username = $auth[0];
			$password = md5($auth[1]);
			$sql = "select id from users where username = '$username' and password = '$password'";
			if ($admin)
				$sql .= " and admin = 1;";
			$sth = mysqli_query($conn, $sql);
			if (mysqli_num_rows($sth)) {
				$row = mysqli_fetch_assoc($sth);
				$id = $row["id"];
				$returnCode = OK;
				$returnMessage = "Authorized";
			} else
				$returnMessage = "User does not exist or is not authorized to perform this action";
		} else {
			$returnMessage = "Only basic authentication (base64) is allowed";
		}
	} else {
		$returnMessage = "You need to authenticate to perform this action";
	}
	return array(
		'status' => $returnCode,
		'message' => $returnMessage,
		'username' => $username,
		'user_id' => $id
	);
}

/**
 * Exposed REST call to authenticate an user.
 * Content-Type: application/json
 */
Flight::route('POST /users/login', function () {
	$conn = openCon();
	$username = Flight::request()->data->username;
	$password = Flight::request()->data->password;
	$sql = "SELECT * from users where username = '$username' and password = '$password'";
	$sth = mysqli_query($conn, $sql);
	if (mysqli_num_rows($sth)) {
		while ($r = mysqli_fetch_assoc($sth)) {
			unset($r["password"]);
			$response = $r;
		}
		$returnCode = OK;
	} else {
		$returnCode = UNAUTHORIZED;
		$response = array(
			'status' => $returnCode,
			'message' => 'Invalid username or password'
		);
	}
	$conn->close();
	Flight::json($response, $returnCode);
});

Flight::route('OPTIONS /*', function () {
});

/**
 * Exposed REST call to register a user.
 * Content-Type: application/json
 */
Flight::route('POST /users/register', function () {
	$conn = openCon();
	$username = Flight::request()->data->username;
	$firstname = Flight::request()->data->firstname;
	$lastname = Flight::request()->data->lastname;
	$admin = Flight::request()->data->admin;
	$password = Flight::request()->data->password;
	$email = Flight::request()->data->email;
	$sth = mysqli_query($conn, "SELECT * from users where username = '$username' or email = '$email';");
	if (mysqli_num_rows($sth)) {
		$returnMessage = "User with username or e-mail address already exists";
		$returnCode = CONFLICT;
	} else {
		$sql = "INSERT INTO users (username, firstname, lastname, admin, password, email, points) VALUES ('$username', '$firstname', '$lastname',$admin,'$password','$email', 0)";
		if ($conn->query($sql) === TRUE) {
			$returnMessage = "User registered successfully";
			$returnCode = OK;
		} else {
			$returnMessage = $conn->error;
			$returnCode = INTERNAL_SERVER_ERROR;
		}
	}
	$conn->close();
	Flight::json(array(
		'status' => $returnCode,
		'message' => $returnMessage
	), $returnCode);
});

/**
 * Exposed REST call to register or update a menu
 * Content-Type: application/json
 * Requires admin authentication
 */
Flight::route('POST /menu/register', function () {
	$conn = openCon();
	$auth = auth($conn, true);
	$returnMessage = $auth["message"];
	$returnCode = $auth["status"];
	if ($returnCode == OK) {
		$name = Flight::request()->data->name;
		$ingredients = Flight::request()->data->ingredients;
		$price = Flight::request()->data->price;
		$date = Flight::request()->data->date;
		$allergies = Flight::request()->data->allergies;
		$sql = "SELECT * from menu where name = '$name' and date = '$date';";
		$sth = mysqli_query($conn, $sql);
		$baseUrl = "http://localhost/zerowaste/assets/img/menu/";
		$photo = null;
		$exists = mysqli_num_rows($sth);
		if (Flight::request()->files["photo"] != null) {
			$uploaddir = "../assets/img/menu/";
			$uploadfile = $uploaddir . Flight::request()->files["photo"]["name"];
			if (move_uploaded_file(Flight::request()->files["photo"]['tmp_name'], $uploadfile)) {
				$photo = $baseUrl . Flight::request()->files["photo"]["name"];
			}
		}
		if ($exists) {
			$id = mysqli_fetch_assoc($sth)["id"];
			if ($photo == null)
				$photo = mysqli_fetch_assoc($sth)["photo"];
			$sql = "UPDATE menu set name = '$name', ingredients = '$ingredients', price = $price, date = '$date', allergies = '$allergies', photo = '$photo' where id = $id";
		} else {
			if ($photo == null)
				$photo = $baseUrl . "food-placeholder.png";
			$sql = "INSERT INTO menu (name, ingredients, price, date, allergies, photo) VALUES ('$name', '$ingredients', $price, '$date','$allergies', '$photo')";
		}
		if ($conn->query($sql) === TRUE) {
			$returnMessage = "Menu " . ($exists ? "updated" : "registered") . " successfully";
			$returnCode = OK;
		} else {
			$returnMessage = $conn->error;
			$returnCode = INTERNAL_SERVER_ERROR;
		}
	}
	$conn->close();
	Flight::json(array(
		'status' => $returnCode,
		'message' => $returnMessage
	), $returnCode);
});


/**
 * Exposed REST call to register a menu
 * Content-Type: application/json
 * Requires admin authentication
 */
Flight::route('POST /payment/', function () {
	$conn = openCon();
	$auth = auth($conn, false);
	$returnMessage = $auth["message"];
	$returnCode = $auth["status"];
	$sqlExec = [];
	if ($returnCode == OK) {
		$user_id = $auth["user_id"];
		$points = Flight::request()->data->points;
		$sql = "INSERT INTO payment (user_id, credit, date) values ($user_id, $points, now())";
		$sqlExec[] = $sql;
		$sql = "SELECT * from users where id = $user_id";
		$sth = mysqli_query($conn, $sql);
		if (mysqli_num_rows($sth)) {
			$row = mysqli_fetch_assoc($sth);
			$credit = $row["points"] + $points;
			$sql = "UPDATE users set points = '$credit' where id = $user_id";
		}
		$sqlExec[] = $sql;
		foreach ($sqlExec as &$sql) {
			if ($conn->query($sql) === TRUE) {
				$returnMessage = "Payment registered successfully";
				$returnCode = OK;
			} else {
				$returnMessage = $conn->error;
				$returnCode = INTERNAL_SERVER_ERROR;
			}
		}
	}
	$conn->close();
	Flight::json(array(
		'status' => $returnCode,
		'message' => $returnMessage
	), $returnCode);
});

/**
 * Exposed REST call to retrieve a list or a single row from a database table.
 * Content-Type: application/json
 * Requires admin authentication
 */
Flight::route('GET /@table/@id', function ($table, $id) {
	$conn = openCon();
	$admin = $table == "menu" ? false : true;
	$auth = auth($conn, $admin);
	$returnCode = $auth["status"];
	$returnMessage = $auth["message"];
	if ($returnCode == OK) {
		$all = $id == "*";
		$sql = "SELECT * from $table";
		if (!$all)
			$sql .= " where id = $id";
		$sth = mysqli_query($conn, $sql);
		$rows = $all ? array() : "";
		while ($r = mysqli_fetch_assoc($sth)) {
			if ($all) {
				if ($table == "orders") {
					$sql = "SELECT * from menu where id = " . $r["menu_id"];
					$orderSth = mysqli_query($conn, $sql);
					if (mysqli_num_rows($orderSth)) {
						$menu = mysqli_fetch_assoc($orderSth);
						unset($r["menu_id"]);
						$r["menu"] = $menu;
						$sql = "SELECT * from users where id = " . $r["person_id"];
						$orderSth = mysqli_query($conn, $sql);
						if (mysqli_num_rows($orderSth)) {
							$user = mysqli_fetch_assoc($orderSth);
							unset($r["person_id"]);
							$r["user"] = $user;
						} else {
							$returnMessage = "Couldn't retrieve user information from registered order number " . $r["id"];
							$returnCode = INTERNAL_SERVER_ERROR;
							break;
						}
					} else {
						$returnMessage = "Couldn't retrieve menu information from registered order number " . $r["id"];
						$returnCode = INTERNAL_SERVER_ERROR;
						break;
					}
				}
				$rows[] = $r;
			} else
				$rows = $r;
		}
		$conn->close();
		Flight::json($rows);
		return;
	}
	Flight::json(array(
		'status' => $returnCode,
		'message' => $returnMessage
	), $returnCode);
});


/**
 * Exposed REST call to create a new order
 * Content-Type: application/json
 */
Flight::route('POST /order/create', function () {
	$conn = openCon();
	$auth = auth($conn, false);
	$returnMessage = $auth["message"];
	$returnCode = $auth["status"];
	if ($returnCode == OK) {
		$menu_id = Flight::request()->data->menu_id;
		$person_id = $auth["user_id"];
		$quantity = Flight::request()->data->quantity;
		$date = date('Y-m-d', time());
		$sql = "SELECT points from users where id = " . $person_id;
		$sth = mysqli_query($conn, $sql);
		if (mysqli_num_rows($sth)) {
			$row = mysqli_fetch_assoc($sth);
			$points = $row["points"];
			$sql = "SELECT price from menu where id = " . $menu_id;
			$sth = mysqli_query($conn, $sql);
			if (mysqli_num_rows($sth)) {
				$row = mysqli_fetch_assoc($sth);
				$price = $row["price"];
				$points = $points - $price;
				if ($points > 0) {
					$sql = "INSERT INTO orders (menu_id, person_id, quantity, date) values ($menu_id, $person_id, $quantity, '$date')";
					if ($conn->query($sql) === TRUE) {
						$sql = $sql = "UPDATE users set points = '$points' where id = $person_id";
						if ($conn->query($sql) === TRUE) {
							$returnMessage = "order created successfully";
							$returnCode = OK;
						} else {
							$returnMessage = $conn->error;
							$returnCode = INTERNAL_SERVER_ERROR;
						}
					} else {
						$returnMessage = $conn->error;
						$returnCode = INTERNAL_SERVER_ERROR;
					}
				} else {
					$returnMessage = "Insufficient points to order the menu";
					$returnCode = BAD_REQUEST;
				}
			} else {
				$returnMessage = "Could not retrieve menu information";
				$returnCode = INTERNAL_SERVER_ERROR;
			}	
		} else {
			$returnMessage = "Could not retrieve user points";
			$returnCode = INTERNAL_SERVER_ERROR;
		}
	}
	$conn->close();
	Flight::json(array(
		'status' => $returnCode,
		'message' => $returnMessage
	), $returnCode);
});

Flight::start();
