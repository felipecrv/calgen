<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
<meta name="keywords" content="calendário, gerador de calendário, calendário html, calendar generator">
<title>Gerador de Calendário</title>
</head>

<frameset cols="25%,75%">
	<frame src="options.php"/>
	<frame name="calendar" src="calgen.php?year=<?=date('Y') ?>&month=0&cols=4&style=default.css"/>

	<noframes>
		<body>Seu Browser não suporta frames</body>
	</noframes>
</frameset>

</html>

