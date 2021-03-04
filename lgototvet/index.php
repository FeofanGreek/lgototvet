<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<style>
span, b, a, a:active, a:visited
        {
          text-decoration: none;
          color:#23a4ff;
        }
td{border:1px solid grey;margin:0px;padding:5px;} 
.group {
  position: relative;
  margin-bottom: 30px;
}
.part{
      display:block;
      padding:8px;
      margin:8px;
      border-radius:5px;
      box-shadow: 0 0 10px rgba(0,0,0,0.5);
      text-align: justify;
      }
input, textarea {
  font-size: 16px;
  padding: 10px;
  display: block;
  width: 300px;
  border: none;
  border-bottom: 1px solid #ccc;
}
input:focus, textarea:focus {
  outline: none;
}
label {
  color: #999;
  font-size: 18px;
  position: absolute;
  pointer-events: none;
  left: 10px;
  top: 15px;
  transition: 0.2s ease all;
  -moz-transition: 0.2s ease all;
  -webkit-transition: 0.2s ease all;
}

/* active state */
input:focus ~ label, input:valid ~ label {
  top: -15px;
  font-size: 14px;
  color: #5264AE;
}


/* BOTTOM BARS ================================= */
.bar {
  position: relative;
  display: block;
  width: 320px;
}
.bar:before, .bar:after {
  content: "";
  height: 2px;
  width: 0;
  bottom: 0;
  position: absolute;
  background: #5264AE;
  transition: 0.2s ease all;
  -moz-transition: 0.2s ease all;
  -webkit-transition: 0.2s ease all;
}
.bar:before {
  left: 50%;
}
.bar:after {
  right: 50%;
}

/* active state */
input:focus ~ .bar:before,
input:focus ~ .bar:after {
  width: 50%;
}
textarea:focus ~ .bar:before,
textarea:focus ~ .bar:after {
  width: 50%;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=yes" />
</head>
<body>

<?
$serverKey = 'AAAAmlmyhlQ:APA91bFADxFaR20YXSehRNvP9TXlOdPTDXvcSe3hqU2OxnLp1vdD0nOaOysSRZddaWR8GtX2nIMi1oXirp0MTrsGDWjOJ8VefH9tsG0QEgeWn79GfXtT3mM7ZPdlG7xkZkyjq64f3DNq';

//подключаемся к БД
$username="	a0088692_lgototvet";
$password="afLai4fy";
$database="a0088692_lgototvet";
$connection=mysqli_connect('localhost', $username, $password);

$db_selected = mysqli_select_db($connection, $database);
if (!$db_selected) {
  die ('Can\'t use db : ' . mysqli_error());
  }

if(!$_GET){
echo '<div class="part" style="display:inline-block;width:90%;margin:3%;padding:10px;border:1px solid grey;border-radius:5px;text-align:center;"><a href="/?addnews=1">Добавить новость</a></div>
	<div class="part" style="display:inline-block;width:90%;margin:3%;padding:10px;border:1px solid grey;border-radius:5px;text-align:center;"><a href="/?editnews=1">Список нововстей</a> </div>
	<div class="part" style="display:inline-block;width:90%;margin:3%;padding:10px;border:1px solid grey;border-radius:5px;text-align:center;"> <a href="/?addgrant=1">Добавить льготу</a> </div>
	<div class="part" style="display:inline-block;width:90%;margin:3%;padding:10px;border:1px solid grey;border-radius:5px;text-align:center;"> <a href="/?fsendpush=1">Сделать рассылку уведомлений</a></div>
	';
}

if($_GET['addnews']){

echo '
	<center>Добавление новости от: '$today = date("d.m.y");'</center>
		<form method="POST" action="/?addnews=1">
			<label>Регион новости
				<select name="region" required>
		';
			$query ="SELECT * FROM `region` WHERE 1";
				$result = mysqli_query($connection, $query);
				while ($row = @mysqli_fetch_assoc($result)){
					echo '<option value="'.$row['id'].'">'.$row['name'].'</option>';
				}
	echo '</select></label><br>
	<label>Заголовок
		<input type="text" name="title" placeholder="до 100 символов" maxlength="100">
		</label><br>
		<label>Краткий текст
		<textarea name="text" placeholder="до 1000 символов" maxlength="1000" rows="4"></textarea>		
		</label><br>
		<label>Ссылка на картинку
		<input type="text" name="linkpic" placeholder="до 300 символов" maxlength="100">
		</label><br>
		<label>Ссылка на новость
		<input type="text" name="link" placeholder="до 300 символов" maxlength="100">
		</label><br>
		<input type="submit" value="Создать" name="createnews">';			
}

if($_POST['createnews']){
	$title = $_POST['title'];
	$text = $_POST['text'];
	$region = $_POST['region'];
	$linkpic = $_POST['linkpic'];
	$link = $_POST['link'];
		$query ="SERT INTO `news`(`title`, `text`, `linkPic`, `link`, `region`) VALUES ('".$title."',".$text."',".$linkpic."',".$link."',".$region."')";
				$result = mysqli_query($connection, $query);
	header('Location: '.$_SERVER['PHP_SELF'];				
}



?>
</body>
</html>
