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

h1 {
	font-size: xx-large;
}

label {
	display: block;
	padding-top: 10px;
}

#content {
	padding: 40px;
	padding-left: 60px;
	font: normal 12px/20px "Trebuchet MS", Verdana, Arial, Helvetica, sans-serif;
}

p {
	margin-top: 100px;
	text-align: right;
	font-size: 90%;
}

a {
	color: #F60;
	font-style: italic;
	font-weight: bold;
};
</style>

</head>
<body>

<div id="content">
	<h1>Opções</h1>

	<form method="get" action="calgen.php" target="calendar">
		<label for="year">Ano</label>
		<input type="text" value="<?=date('Y') ?>" name="year"/>

		<label for="month">Mês</label>
		<select name="month">
			<option selected="selected" value="0">--</option>
			<option value="1">Janeiro</option>
			<option value="2">Fevereiro</option>
			<option value="3">Março</option>
			<option value="4">Abril</option>
			<option value="5">Maio</option>
			<option value="6">Junho</option>
			<option value="7">Julho</option>
			<option value="8">Agosto</option>
			<option value="9">Setembro</option>
			<option value="10">Outubro</option>
			<option value="11">Novembro</option>
			<option value="12">Dezembro</option>
		</select>

		<label for="cols">Colunas</label>
		<select name="cols">
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
			<option selected="selected" value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>
			<option value="7">7</option>
			<option value="8">8</option>
			<option value="9">9</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
		</select>

		<label for="style">Tema</label>
		<select name="style">
			<option selected="selected" value="default.css">Default</option>
			<option value="food.css">Food</option>
			<option value="classic.css">Classic</option>
			<option value="dark.css">Dark</option>
			<option value="vintage.css">Vintage</option>
			<option value="clean.css">Clean</option>
		</select>

		<label for="dummy">&nbsp;</label>
		<input type="hidden" name="dummy" value=""/>

		<input type="submit" value="OK!"/>
	</form>

	<p>Criado por <a href="http://twitter.com/_Felipe" title="_Felipe"
		target="_blank">_Felipe</a><br/>
	Powered by Pascal + PHP<br/>
	<a href="download.php" title="Source Code">Download Source Code</a>
	</p>
</div>

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-5475466-4");
pageTracker._trackPageview();
} catch(err) {}</script>

</body>
</html>

