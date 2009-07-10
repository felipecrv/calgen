unit Generator;

interface

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

procedure GenerateOneMonthCalendar(Y: integer; M: byte);
begin
	WriteLn('mes');
end;

procedure GenerateCalendar(Y: integer);
begin
	WriteLn('ano');
end;

end.
