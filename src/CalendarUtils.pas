unit CalendarUtils;

interface

function IsLeapYear(Y: integer): boolean;
function MonthLen(Y, M: integer): integer;
function FirstWeekDayOfMonth(Y, M: integer): integer;

implementation

const
	MONTH_LEN_T: array [1..12] of integer = (31, 28, 31, 30, 31, 30,
                                     31, 31, 30, 31, 30, 31);
	MONTH_LEN_T_CUMULATIVE: array [0..12] of integer = (
		0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365);

{ Verifica se o ano é bissexto }
function IsLeapYear(Y: integer): boolean;
begin
	IsLeapYear := (Y mod 4 = 0) and ((Y mod 100 <> 0) or (Y mod 400 = 0));
end;

{ Retorna o tamanho do mês considerando anos bissextos }
function MonthLen(Y, M: integer): integer;
begin
	if M = 2 then
	 begin
		if IsLeapYear(Y) then MonthLen := MONTH_LEN_T[2] + 1
		else MonthLen := MONTH_LEN_T[2];
	 end
	else
		MonthLen := MONTH_LEN_T[M];
end;

{ Diz quantos anos bissextos existem no intervalo [1900..Y] }
function CountLeapYearsFrom1900(Y: integer): integer;
begin
	CountLeapYearsFrom1900 := Y div 4 - Y div 100 + Y div 400 - 460;
end;

{ Diz em que dia da semana o mês começa }
function FirstWeekDayOfMonth(Y, M: integer): integer;
var
	Days: integer; { Quantidade de dias desde 1 de Janeiro de 1900 até o
	primeiro dia do mês M do ano Y }
begin
	Days := (Y - 1901) * 365 + CountLeapYearsFrom1900(Y - 1) +
		MONTH_LEN_T_CUMULATIVE[M - 1] + 1;
	if IsLeapYear(Y) and (M > 2) then Inc(Days);

	{ 1 de Janeiro de 1900 é uma segunda 1 = 2 - 1}
	FirstWeekDayOfMonth := ((1 + Days) mod 7) + 1;
end;

end.
