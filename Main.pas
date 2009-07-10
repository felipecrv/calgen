program CalGen;
{CALendar GENerator}

uses
	Generator;

type
	TinyStr = string[10];

const
	USAGE =
'Uso: calgen [OPCAO]... [[MES] ANO]

 Exemplos:
   calgen
   calgen 2009
   calgen 7 2009
   calgen -c 3 -o calendario.html
   calgen -s custom.css

 Opções:
   -o       Nome do arquivo de saída
   -s       Nome do arquivo de estilo CSS
   -c       Quantidade de colunas
   -t       Título da página
';

{ Mensagens de erros fatais }

procedure InvalidYear(Y: string);
begin
	WriteLn(StdErr, ParamStr(0), ': ano ', Y, ' não está no intervalo 1..5875706');
	Halt(64);
end;

procedure InvalidMonth(M: string);
begin
	WriteLn(StdErr, ParamStr(0), M, ' não é um número de mês (1..12)');
	Halt(64);
end;

procedure InvalidParam(P: string);
begin
	WriteLn(StdErr, ParamStr(0), ': Opção Inválida -- ', P);
	WriteLn(StdErr, USAGE);
	Halt(64);
end;

{ Converte de string para inteiro }
function ValidateInt(P: string; var Out: integer): boolean;
var
	i: byte;
	Ret: boolean;
	E: integer;
begin
	ret := true;
	for i := 1 to Length(P) do
	 begin
		if (not ((P[i] >= '0') and (P[i] <= '9'))) then
			Ret := false;
	 end;

	if Ret then Val(P, Out, E);
	ValidateInt := Ret;
end;

{ Lê o próximo parâmetro. Útil quando ParamStr(Index) requer um argumento. }
procedure NextParam(var Index: integer; var P, NextP: string);
begin
	if (ParamCount > Index) then
	 begin
		Inc(Index);
		NextP := ParamStr(Index);
	 end
	else
	 begin
		WriteLn(StdErr, ParamStr(0), ': ', P, ' requer um argumento');
		Halt(64);
	 end;
end;

{ Trata uma opção da linha de comando }
procedure HandleParam(P: string; var Index: integer);
var
	Cols: string[3];
	E: integer;
begin
	if P = '-t' then
		NextParam(Index, P, GenOptions.PageTitle)
	else if P = '-s' then
		NextParam(Index, P, GenOptions.Style)
	else if P = '-o' then
	 begin
		NextParam(Index, P, GenOptions.OutputFilePath);
		GenOptions.OutputOnStdOut := false;
	 end
	else if P = '-c' then
	 begin
		NextParam(Index, P, Cols);
		if not ValidateInt(Cols, GenOptions.Cols) then
			InvalidParam(ParamStr(Index + 1));
	 end
	else
		InvalidParam(P);
end;

var
	T: TimeStamp;
	MonthStr, YearStr: TinyStr;
	{ Usados na manipulação dos argumentos }
	i, j, Tmp, Year, Month: integer;
	Param: string;

begin
	{ Algumas opções /default/ }
	GenOptions.Style := 'default.css';
	GenOptions.EmbedStyle := true;
	GenOptions.OutputOnStdOut := true;
	GenOptions.OneMonth := true;
	GetTimeStamp(T);
	Year := T.Year;
	Month := T.Month;
	Str(Year, YearStr);
	GenOptions.PageTitle := 'Calendário de ' + Months[Month] + '/' + YearStr;

	{ Se não houver nenhum argumento gerar calendário do mês atual }
	if (ParamCount = 0) then
	 begin
		GenerateOneMonthCalendar(Year, Month);
		Halt;
	 end;

	{ Verificando se o usuário usou: "calgen -h" ou "calgen --help" }
	if (ParamCount = 1) then
	 begin
		Param := ParamStr(1);
		if (Param[1] = '-') and ((Param = '-h') or (Param = '--help')) then
		 begin
			WriteLn(USAGE);
			Halt;
		 end;
	 end;

	{ Acessando os argumentos (ParamCount > 0) }
	i := 1;
	while i <= ParamCount do
	 begin
		Param := ParamStr(i);
		if (Param[1] = '-') then
		 begin
			{ Trata a opção }
			HandleParam(Param, i);
		 end
		else
		 begin
			{ Se não começa com '-', o parâmetro deve ser o mês ou o ano. }
			{ Mês e Ano são supostamente os últimos argumentos. }
			if ValidateInt(Param, Tmp) then
			 begin	 
				{ Se existe outro argumento... }
				if (i < ParamCount) then
				 begin
					Month := Tmp;
					if ValidateInt(ParamStr(i + 1), Tmp) then
						Year := Tmp
					else
						InvalidYear(ParamStr(i + 1));
				 end
				else
				 begin
					Year := Tmp;
					GenOptions.OneMonth := false;
				 end;
			 end
			else
			 { Se o primeiro inteiro não é válido... }
			 begin
				if (i < ParamCount) then InvalidMonth(Param)
				else InvalidYear(Param);
			 end;
			
			{ Testando se existem outros parâmetros para poder dizer que eles
			 não são permitidos }
			if (ParamCount > i + 1) then InvalidParam(ParamStr(i + 1))
			else break;
		 end;
		 
		Inc(i);
	 end;

	{ Valida mês e ano }
	if (Month < 1) or (Month > 12) then
	 begin
		Str(Month, MonthStr);
		InvalidMonth(MonthStr);
	 end;
	if (Year < 1) or (Year > 5875706) then
	 begin
		Str(Year, YearStr);
		InvalidYear(YearStr);
	 end;

	{ Gera calendário }
	if GenOptions.OneMonth then
		GenerateOneMonthCalendar(Year, Month)
	else
	 begin
		Str(Year, YearStr);
		GenOptions.PageTitle := 'Calendário de ' + YearStr;
		GenerateCalendar(Year);
	 end;
end.

