<?php

function get($key) {
	if (isset($_GET[$key]))
		return $_GET[$key];
	else
		error('Parâmetro inválido: '.$key);
}

$y = intval(get('year'));
if ($y < 1900 || $y > 5875706)
	error('Ano inválido');

$m = intval(get('month'));
if ($m < 0 || $m > 12)
	error('Mês inválido');
if ($m == 0)
	$m = '';

$cols = intval(get('cols'));
if ($cols < 0 || $cols > 12)
	error('Quantidade de colunas inválida');

$style = get('style');
if (!in_array($style, array('default.css', 'food.css')))
	error('Tema inválido');

print `calgen -s $style -c $cols $m $y`;
?>

<?php
function error($e) {
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8"/>

<style type="text/css">
body {
	font: normal 12px/20px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
	color: #616B76;
	background-color: #F9F8F7;
	margin: 0;
	padding: 0;
}

p { color: red; }

h1 { font-size: xx-large; }

#content {
	padding: 40px;
	padding-left: 60px;
	font: normal 12px/20px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
}
</style>

</head>
<body>

<div id="content">
	<h1>Erro</h1>
	<p><?=$e ?></p>
</div>

</body>
</html>
<?php
	exit();
}

