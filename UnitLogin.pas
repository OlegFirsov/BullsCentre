unit UnitLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Defaults;

type
  TFormLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtLogin: TEdit;
    edtPassword: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    function TestPassword(pass:String;hash:Integer): Boolean;
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;
  isTest: Boolean;

implementation

{$R *.dfm}

uses UnitDB;


procedure TFormLogin.btnCancelClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormLogin.btnOKClick(Sender: TObject);
var
  pass: String;
  hash: Integer;
begin
  with DataMdl do
  begin
    ADOQuerySprav.Close;
    ADOQuerySprav.SQL.Clear;
    ADOQuerySprav.SQL.Add('SELECT login,password FROM users WHERE login="' + Trim(edtLogin.Text) + '"');
    ADOQuerySprav.Open;
    if ADOQuerySprav.RecordCount > 0 then
      begin
        pass := Trim(edtPassword.Text);
        hash := ADOQuerySprav.FieldByName('password').AsInteger;
        if TestPassword(pass,hash) then
          begin
            isTest := True;
            FormLogin.Close();
            //Application.MessageBox('Верный пароль.','Информация',MB_OK);
          end
          else
            begin
              Application.MessageBox('Неверный пароль, попробуйте еще раз.','Информация',MB_OK);
              edtPassword.SetFocus();
              isTest := False;
            end;
      end
      else
        begin
          Application.MessageBox('Нет такого пользователя, введите еще раз.','Информация',MB_OK);
          edtLogin.SetFocus();
        end;

    //
  end;
end;

function TFormLogin.TestPassword(pass:String;hash:Integer): Boolean;
var
  i:Integer;
begin
i := BobJenkinsHash(pass[1],Length(pass)*SizeOf(pass[1]),0);
    if (Trim(pass) <> '') and (i = hash)  then
      result := True
    else
      result := False;
end;

end.
