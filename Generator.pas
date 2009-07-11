unit Generator;

interface
type
	TinyStr = string[10];

uses
	CalendarUtils, Config;

type
	TGeneratorOptions = record
		{ Título da página }
		PageTitle: string[511];
		{ Saída na tela }
		OutputOnStdOut: boolean;
		{ Arquivo de Saída }
		OutputFilePath: string[511];
		{ Arquivo de estilo CSS }
		Style: string[511];
		{ O CSS vai junto ao HTML }
		EmbedStyle: boolean;
		{ É o calendário de um mês apenas}
		OneMonth: boolean;
		{ Quantidade de colunas }
		Cols: integer;
	end;

const
	Months: array[1..12] of string[12] = ('Janeiro', 'Fevereiro', 'Março',
		'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro',
		'Dezembro');
var
	GenOptions: TGeneratorOptions;

procedure GenerateOneMonthCalendar(Y: integer; M: byte);
procedure GenerateCalendar(Y: integer);

implementation

var
	Out: Text; { Saída }
	Style: Text; { Folha de Estilo }

{ Exibe a mensagem de erro e fecha o programa }
procedure IOError(IOR: integer; F: string);
begin
	if IOR = 442 then
	 begin
		WriteLn(StdErr, ParamStr(0), ': ', F, ': Arquivo não encontrado');
		Halt(2);
	 end
	else
	 begin
		WriteLn(StdErr, ParamStr(0), ': IOError: IOResult = #', IOR,
		' ao ler arquivo ', F);
		Halt(1);
	 end;	
end;

{ Abre um arquivo e dá mensagem de erro se ele não existir }
function AssignFile(var F: Text; Path: string; RaiseError: boolean): integer;
var
	IOR: Integer;
begin
	Assign(F, Path);
	{$I-} Reset(F); {$I+}
	IOR := IOResult;
	{ Se o erro tiver que ser disparado ele será ;-) }
	if RaiseError then
		if IOR <> 0 then IOError(IOR, Path);

	{ ...senão AssignFile retorna o IOResult para que seja possível tratar o
	erro de outra forma. }
	AssignFile := IOR;
end;

function AbsPath(P: string): boolean;
begin
	{ Exemplos:
		/home/felipe/style.css
		../style.css
		./style.css
		C:\style.css
	}
	AbsPath := (P[1] = '/') or (P[1] = '\') or (P[1] = '.') or (P[2] = ':');
end;
		
{ Inicialização do generator }
procedure GeneratorInit;
var
	IOR: integer;
begin
	{ Inicialização da Saída }
	if not GenOptions.OutputOnStdOut then
	 begin
		IOR := AssignFile(Out, GenOptions.OutputFilePath, true);
		Rewrite(Out);
	 end;

	{ Inicialização do arquivo de estilo CSS }
	if GenOptions.EmbedStyle then
	 begin
		IOR := AssignFile(Style, GenOptions.Style, false);

		{ Se ocorreu algum erro }
		if IOR <> 0 then
		 begin
			{ Se o arquivo não foi encontrado e é possível achá-lo no
			 STYLESHEET_PATH }
			if (IOR = 442) and (not AbsPath(GenOptions.Style)) then
			 begin
				{ Procura pela folha de estilo no STYLESHEETS_PATH }
				WriteLn(StdErr, ParamStr(0), ': ',
				GenOptions.Style, ': Arquivo  não encontrado');
				WriteLn(StdErr, ParamStr(0), ': Procurando por ',
					GenOptions.Style, ' em ', STYLESHEETS_PATH);
				GenOptions.Style := STYLESHEETS_PATH + GenOptions.Style;
				IOR := AssignFile(Style, GenOptions.Style, true);
			 end
			else				
				IOError(IOR, GenOptions.Style);
		 end;
	 end;
end;

{ Final da execução do generator }
procedure GeneratorExit;
begin
	{ Fecha arquivo de saída }
	if not GenOptions.OutputOnStdOut then
		Close(Out);

	{ Fecha o arquivo de estilo }
	if GenOptions.EmbedStyle then
		Close(Style);
end;

{ Imprime um texto na saída padoa ou no arquivo de saíuda }
procedure OutputText(O: string);
begin
	if GenOptions.OutputOnStdOut then Write(O)
	else Write(Out, O);
end;

procedure OutputLn(O: string);
begin
	if GenOptions.OutputOnStdOut then WriteLn(O)
	else WriteLn(Out, O);
end;

{ Imprime os links p/ os arquivos CSS ou o próprio CSS embedded }
procedure OutputCssStyle;
var
	L: string[255];
begin
	{ Insere o CSS, "linkado" ou "embedded" }
	if not GenOptions.EmbedStyle then
	 begin
		OutputText('<link href="');
		OutputText(GenOptions.Style);
		OutputLn('" rel="stylesheet" type="text/css" />');
	 end
	else
	 begin
		OutputLn('
<style type="text/css">');
		while not eof(Style) do
		 begin
			ReadLn(Style, L);
			OutputLn(L);
		 end;
		OutputLn('</style>
');
	 end;
end;

{ Gera o cabeçalho do arquivo html }
procedure GenerateHeader;
begin
	OutputText('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
<title>');
	OutputText(GenOptions.PageTitle);
	OutputLn('</title>');
	OutputCssStyle;
	OutputLn('</head>
<body>

<div id="content">');
end;

{ Gera o espaçamento no início e no fim do calendário }
procedure GeneratePadding(Padding: byte);
var i: byte;
begin
	Padding := Padding mod 7;
	for i := 1 to Padding do
		OutputLn('	<td>&nbsp;</td>');
end;

{ Gera a céĺula que representa o dia na tabela }
procedure GenerateDay(Day: integer);
var
	DayStr: TinyStr;
begin
	Str(Day, DayStr);
	OutputText('	<td>');
	OutputText(DayStr);
	OutputLn('</td>');
end;

{ Gera o rodapé do arquivo html }
procedure GenerateFooter;
begin
	OutputLn('</div>

</body>
</html>
');
end;

{ Imprime o calendário(mês) e altera o WeekDayStart p/ o do próximo mês }
procedure GenerateMonth(Y, M: integer; var WeekDayStart: integer);
var
	MLen, EndPad, D, i: integer;
begin
	OutputText('<table class="month-calendar" cellspacing="0" cellpadding="0"
		summary="Calendário de ');
	OutputText(Months[M]);
	OutputLn('">');
	OutputText('<caption>');
	OutputText(Months[M]);
	OutputLn('</caption>');

	OutputLn(' <tr>
	<th scope="col" abbr="Domingo" title="Domingo">D</th>
	<th scope="col" abbr="Segunda" title="Segunda">S</th>
	<th scope="col" abbr="Terça" title="Terça">T</th>
	<th scope="col" abbr="Quarta" title="Quarta">Q</th>
	<th scope="col" abbr="Quinta" title="Quinta">Q</th>
	<th scope="col" abbr="Sexta" title="Sexta">S</th>
	<th scope="col" abbr="Sábado" title="Sábado">S</th>
 </tr>');


	{ Imprimindo os dias }
	OutputLn(' <tr>'); { Abre a semana }
	GeneratePadding(WeekDayStart - 1); { Espaçamento }
	MLen := MonthLen(Y, M); { Tamanho do mês }
	D := 1; { Dia do mês }
	i := WeekDayStart; { Contador de células da semana }
	repeat
		GenerateDay(D); { Imprime a célula do dia D }
		Inc(D); Inc(i);
		if i = 8 then
		 begin
			{ Fecha semana e abre outra}
			OutputLn(' </tr>
 <tr>');
			i := 1;
		 end;
	until D > MLen;
	{ Calcula o espaçamento final e gera-o }
	EndPad := 8 - i; { i < 8 }
	GeneratePadding(EndPad);
	{ Fecha semana e mês }
	OutputLn(' </tr>
</table>
');

	{ Retorna o dia da semana em que o próximo mês vai começar. Isso faz com que
	não seja necessário chamar FirstWeekDayOfMonth() na hora de gerar cada mês. }
	{ (7 >= EndPad >= 1) ==> (1 <= WeekDayStart <= 7) }
	WeekDayStart := 8 - EndPad;
end;

{ Gera o calendário de apenas um mês }
procedure GenerateOneMonthCalendar(Y: integer; M: byte);
var
	DayStart: integer; { Primeiro dia do mês }
begin
	GeneratorInit;
	{ Gera o cabeçalho do arquivo html }
	GenerateHeader;

	{ Gera o calendário do mês }
	DayStart := FirstWeekDayOfMonth(Y, M);
	GenerateMonth(Y, M, DayStart);

	{ Gera o rodapé do arquivo html }
	GenerateFooter;

	GeneratorExit;
end;

{ Gera o calendário completo de um ano }
procedure GenerateCalendar(Y: integer);
var
	DayStart, M, i: integer;
	YearStr: TinyStr;
begin
	GeneratorInit;
	{ Gera o cabeçalho do arquivo html }
	GenerateHeader;

	OutputText('<h1>');
	Str(Y, YearStr);
	OutputText(YearStr);
	OutputLn('</h1>
');

	DayStart := FirstWeekDayOfMonth(Y, 1); { Primeiro dia do ano }
	M := 1; { Contador de mês }
	i := 1; { Contador de mês na linha }
	OutputLn('<div class="month-set">'); { Abre o month-set }
	repeat
		GenerateMonth(Y, M, DayStart); { Gera o mês }
		Inc(M); Inc(i);
		if i = GenOptions.Cols + 1 then
		 begin
			{ Abre e fecha o month-set }
			OutputLn('</div>
<div class="month-set">');
			i := 1;
		 end;
	until M > 12;
	OutputLn('</div>'); { Fecha o month-set }


	{ Gera o rodapé do arquivo html }
	GenerateFooter;

	GeneratorExit;
end;

end.
