<?php
$serverKey = 'AAAAmlmyhlQ:APA91bFADxFaR20YXSehRNvP9TXlOdPTDXvcSe3hqU2OxnLp1vdD0nOaOysSRZddaWR8GtX2nIMi1oXirp0MTrsGDWjOJ8VefH9tsG0QEgeWn79GfXtT3mM7ZPdlG7xkZkyjq64f3DNq';

//код для отправки пост запроса методом JSON
$data = json_decode(file_get_contents('php://input'), true);

//подключаемся к БД
$username="a0088692_lgototvet";
$password="afLai4fy";
$database="a0088692_lgototvet";
$connection=mysqli_connect('localhost', $username, $password);

$db_selected = mysqli_select_db($connection, $database);
if (!$db_selected) {
  die ('Can\'t use db : ' . mysqli_error());
  }

 //показываем список новостей
 if($data["subject"] == "news"){ 	
 	$query ="SELECT * FROM `news` WHERE `region` = '".$data['region']."' OR `region` = '0'";
 	$result = mysqli_query($connection, $query);
 	$count = mysqli_num_rows($result);
 	if($count > 0) {echo '[{';} else {echo '[{"news" : 0}]';}
 	while ($row = @mysqli_fetch_assoc($result)){
 		echo '"title" : "'.$row['title'].'",'
 		echo '"text" : "'.$row['text'].'",'
 		echo '"dateNews" : "'.$row['dateNews'].'",'
 		echo '"linkPic" : "'.$row['linkPic'].'",'
 		echo '"link" : "'.$row['link'].'",'
 		$count--;
				if($count > 0) {echo '},{';} else {echo '}]';}
 	}
 }
?>