unit UntPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.StdCtrls, FMX.TabControl, FMX.Controls.Presentation,
  FMX.Layouts,

  FMX.Objects,
  System.IOUtils, FMX.Gestures;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    ToolBar1: TToolBar;
    tbcPrincipal: TTabControl;
    tbiFoto1: TTabItem;
    Button1: TButton;
    fdConn: TFDConnection;
    qryProdutos: TFDQuery;
    qryProdutosTITULO: TStringField;
    qryProdutosDESCRICAO: TStringField;
    qryProdutosPRECO: TFMTBCDField;
    qryProdutosFOTO: TBlobField;
    qryProdutosPRECO_PROMO: TFMTBCDField;
    qryProdutosFOTO2: TBlobField;
    qryProdutosFOTO3: TBlobField;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    Layout3: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    Layout7: TLayout;
    HorzScrollBox1: THorzScrollBox;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Rectangle1: TRectangle;
    Label4: TLabel;
    qryProdutosID: TIntegerField;
    GestureManager1: TGestureManager;
    TabItem1: TTabItem;
    Image5: TImage;
    Label2: TLabel;
    Layout2: TLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    Layout10: TLayout;
    HorzScrollBox2: THorzScrollBox;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Layout11: TLayout;
    Label3: TLabel;
    Button2: TButton;
    procedure fdConnBeforeConnect(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure NextTab(Sender: TObject);
    procedure PreviousTab(Sender: TObject);
    procedure ChangeFoto(Sender: TObject);
    procedure MeuTerminate(Sender: TObject);
    procedure GestureFoto(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  UntFrame;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  LThread       : TThread;
begin
  LThread :=
    TThread.CreateAnonymousThread(
      procedure ()
      var
        LTabItem      : TTabItem;
        LLabelTitulo  : TLabel;
        LImagem       : TImage;
        LLabelDescr   : TLabel;
        LFrame        : TFrameBottom;
        I             : Integer;
      begin
        if not QryProdutos.Active then
          QryProdutos.Active := True;

        QryProdutos.First;

        for I := tbcPrincipal.TabCount downto 0 do
          tbcPrincipal.Tabs[I].DisposeOf;

        tbcPrincipal.BeginUpdate;
        QryProdutos.DisableControls;
        while not QryProdutos.EOF do
        begin
          //TabItem
          TThread.Synchronize(
            TThread.CurrentThread,
            procedure ()
            begin
              LTabItem := TTabItem.Create(nil);
              LTabItem.Parent                    := tbcPrincipal;
              LTabItem.Name                      := Format('tbiProduto%4.4d', [qryProdutosID.AsInteger]);

              LLabelTitulo                       := TLabel.Create(Self);
              LLabelTitulo.Parent                := LTabItem;
              LLabelTitulo.Name                  := Format('lblTitulo%4.4d', [qryProdutosID.AsInteger]);
              LLabelTitulo.Text                  := qryProdutosTITULO.AsString;
              LLabelTitulo.Align                 := TAlignLayout.Top;
              LLabelTitulo.Margins.Left          := 8;
              LLabelTitulo.Margins.Right         := 8;

              LImagem                            := TImage.Create(Self);
              LImagem.Parent                     := LTabItem;
              LImagem.Name                       := Format('imgFoto1%4.4d', [qryProdutosID.AsInteger]);
              LImagem.Align                      := TAlignLayout.Client;
              LImagem.Touch.GestureManager       := GestureManager1;
              LImagem.Touch.StandardGestures     := [TStandardGesture.sgLeftRight, TStandardGesture.sgRightLeft];
              LImagem.OnGesture                  := GestureFoto;
              LImagem.Bitmap.Assign(qryProdutosFOTO);

              LLabelDescr                        := TLabel.Create(Self);
              LLabelDescr.Parent                 := LTabItem;
              LLabelDescr.Name                   := Format('lblDescr%4.4d', [qryProdutosID.AsInteger]);
              LLabelDescr.Align                  := TAlignLayout.Bottom;
              LLabelDescr.Margins.Bottom         := 10;
              LLabelDescr.Margins.Left           := 8;
              LLabelDescr.Margins.Right          := 8;
              LLabelDescr.Margins.Top            := 10;
              LLabelDescr.Text                   := qryProdutosDESCRICAO.AsString;
              LLabelDescr.Height                 := 60;
              LLabelDescr.TextSettings.HorzAlign := TTextAlign.Leading;
              LLabelDescr.TextSettings.VertAlign := TTextAlign.Leading;
              LLabelDescr.TextSettings.WordWrap  := True;
              LLabelDescr.TextSettings.Font.Size := 14;
              LLabelDescr.StyledSettings         := [];

              LFrame                             := TFrameBottom.Create(Self);
              LFrame.Parent                      := LTabItem;
              LFrame.Name                        := Format('frameBottom%4.4d', [qryProdutosID.AsInteger]);
              LFrame.Align                       := TAlignLayout.Bottom;

              LFrame.imgFoto1.Bitmap.Assign(qryProdutosFOTO);
              LFrame.imgFoto2.Bitmap.Assign(qryProdutosFOTO2);
              LFrame.imgFoto3.Bitmap.Assign(qryProdutosFOTO3);

              LFrame.imgFoto1.OnClick            := ChangeFoto;
              LFrame.imgFoto2.OnClick            := ChangeFoto;
              LFrame.imgFoto3.OnClick            := ChangeFoto;

              LFrame.speLeft.OnClick             := PreviousTab;
              LFrame.speRight.OnClick            := NextTab;
            end
          );

          tbcPrincipal.AddObject(LTabItem);
          QryProdutos.Next;
        end;
        tbcPrincipal.EndUpdate;
        QryProdutos.EnableControls;
      end
    );

  LThread.OnTerminate := MeuTerminate;
  LThread.FreeOnTerminate := True;
  LThread.Start;
end;

procedure TForm1.MeuTerminate(Sender: TObject);
begin
  QryProdutos.First;
  tbcPrincipal.First();
end;

procedure TForm1.NextTab(Sender: TObject);
begin
  //if not qryProdutos.EOF then
  //begin
    tbcPrincipal.Next();
    if qryProdutos.Active then
      qryProdutos.Next;
  //end;
end;

procedure TForm1.PreviousTab(Sender: TObject);
begin
  //if not qryProdutos.BOF then
  //begin
    tbcPrincipal.Previous();
    if qryProdutos.Active then
      qryProdutos.Prior;
  //end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  I : Integer;
begin
  for I := tbcPrincipal.TabCount downto 0 do
    tbcPrincipal.Tabs[I].DisposeOf;
end;

procedure TForm1.ChangeFoto(Sender: TObject);
var
  ImgFotoPrincipal : TComponent;
  LNome            : string;
begin
  LNome := Format('imgFoto1%4.4d', [qryProdutosID.AsInteger]);
  ImgFotoPrincipal := Application.MainForm.FindComponent(LNome);

  case TImage(Sender).Tag of
    1: TImage(ImgFotoPrincipal).Bitmap.Assign(qryProdutosFOTO);
    2: TImage(ImgFotoPrincipal).Bitmap.Assign(qryProdutosFOTO2);
    3: TImage(ImgFotoPrincipal).Bitmap.Assign(qryProdutosFOTO3);
  end;
end;

procedure TForm1.fdConnBeforeConnect(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
    fdConn.Params.Values['Database'] :=
      'D:\4. Exemplos Lives\Rolo de fotos\database\Produtos.db';
  {$ELSE}
    fdConn.Params.Values['OpenMode'] := 'ReadWrite';
    fdConn.Params.Values['Database'] :=
      TPath.Combine(TPath.GetDocumentsPath,'Produtos.db');
  {$ENDIF}
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  tbcPrincipal.TabPosition := TTabPosition.None;
end;

procedure TForm1.GestureFoto(Sender: TObject; const EventInfo: TGestureEventInfo;
  var Handled: Boolean);
begin
  if EventInfo.GestureID = sgiRightLeft then
  begin
    PreviousTab(Sender);
    Handled := True;
  end
  else if EventInfo.GestureID = sgiLeftRight then
  begin
    NextTab(Sender);
    Handled := True;
  end;
end;

end.
