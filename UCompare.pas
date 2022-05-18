unit UCompare;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Samples.Gauges, Vcl.ComCtrls, Data.DB,
  Datasnap.DBClient, ACBrBase, ACBrBoleto, AcbrUtil;

type
  TFrmCompare = class(TForm)
    Button1: TButton;
    StatusBar1: TStatusBar;
    Gauge1: TGauge;
    P1: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    Button2: TButton;
    Button3: TButton;
    Memo3: TMemo;
    Button4: TButton;
    Label1: TLabel;
    ClientDataSet1: TClientDataSet;
    ACBrBoleto1: TACBrBoleto;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    BtnCancelar: TButton;
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    function Explode(Texto, Separador: string): TStrings;
    procedure BtnCancelarClick(Sender: TObject);
  private
    function quebra(texto, inicio, final: string): string;

    { Private declarations }
  public
    { Public declarations }
    cancel : boolean;
  end;

var
  FrmCompare: TFrmCompare;

implementation

{$R *.dfm}

function TFrmCompare.Explode(Texto, Separador: string): TStrings;
var
  strItem: string;
  ListaAuxUTILS: TStrings;
  NumCaracteres, TamanhoSeparador, I: Integer;
begin
  ListaAuxUTILS := TStringList.Create;
  strItem := '';
  NumCaracteres := Length(Texto);
  TamanhoSeparador := Length(Separador);
  I := 1;
  while I <= NumCaracteres do
  begin
    if (Copy(Texto, I, TamanhoSeparador) = Separador) or (I = NumCaracteres) then
    begin
      if (I = NumCaracteres) then
        strItem := strItem + Texto[I];
      ListaAuxUTILS.Add(trim(strItem));
      strItem := '';
      I := I + (TamanhoSeparador - 1);
    end
    else
      strItem := strItem + Texto[I];

    I := I + 1;
  end;
  Explode := ListaAuxUTILS;
end;

function padR(const AString: AnsiString; const nLen: Integer; const Caracter: AnsiChar): AnsiString;
var
  Tam: Integer;
begin
  Tam := Length(AString);
  if Tam < nLen then
    Result := StringOfChar(Caracter, (nLen - Tam)) + AString
  else
    Result := copy(AString, 1, nLen);
end;

function TFrmCompare.quebra(texto, inicio, final: string): string;
var
  quebrado: string;
begin
  quebrado := explode(texto, inicio)[1];
  quebrado := explode(quebrado, final)[0];
  Result := quebrado;
end;

procedure TFrmCompare.BtnCancelarClick(Sender: TObject);
begin
  cancel := true;
end;

procedure TFrmCompare.Button1Click(Sender: TObject);
var
  nome, categoria, linha: string;
  Lista: TStrings;
  I: Integer;
begin
  cancel := false;
  memo3.Lines.Clear;
  memo3.Lines.Encoding.ANSI;

  Lista := Explode(memo1.Text, 'group-title');
  gauge1.MaxValue := Lista.Count;
  for I := 0 to Lista.Count do
 try
    if cancel then
      abort;
    if Pos(UpperCase(quebra(Lista[I], ',', 'http')), UpperCase(memo2.lines.Text)) = 0 then
    begin
      nome := quebra(Lista[I], ',', 'http');
      categoria := quebra(Lista[I], '"', ',');
      memo3.Lines.add(I.ToString + ';' + nome + ';' + categoria) ;
      gauge1.Progress := I + 1;
      application.ProcessMessages;
    end;
  except
    on e: exception do
   // memo3.Lines.Add(e.Message);

  end;

  gauge1.Progress := 0;

end;

procedure TFrmCompare.Button2Click(Sender: TObject);
var
  arq: TextFile;
begin
  if OpenDialog1.Execute then
  begin
    memo1.Lines.LoadFromFile(OpenDialog1.FileName);
  end;

end;

procedure TFrmCompare.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    memo2.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TFrmCompare.Button4Click(Sender: TObject);
var
  Latin1Encoding: TEncoding;
begin
  memo3.Text := Utf8ToAnsi(memo3.text);
  if SaveDialog1.Execute then
   // memo3.Lines.SaveToFile(SaveDialog1.FileName);

end;

procedure TFrmCompare.Button5Click(Sender: TObject);
const
  cDIGITOS_COMPARAR = 3;
begin
  ShowMessage(quebra('a|rapadura"b', '|', '"'));
  //showmessage(StrIsNumber('009').ToString);
end;

end.

