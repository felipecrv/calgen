unit CalendarUtils;

interface

function IsLeapYear(Y: integer): boolean;
function MonthLen(Y, M: integer): integer;
function FirstWeekDayOfMonth(Y, M: integer): integer;

implementation

const
	MONTH_LEN_T: array [1..12] of Integer = (31, 28, 31, 30, 31, 30,
                                     31, 31, 30, 31, 30, 31);

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

{ Diz em que dia da semana o mês começa }
function FirstWeekDayOfMonth(Y, M: integer): integer;
begin
	FirstWeekDayOfMonth := 5;
end;

end.
