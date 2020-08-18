unit UntFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TFrameBottom = class(TFrame)
    Layout3: TLayout;
    Layout4: TLayout;
    Path2: TPath;
    Layout5: TLayout;
    Path1: TPath;
    Layout6: TLayout;
    HorzScrollBox1: THorzScrollBox;
    imgFoto1: TImage;
    imgFoto2: TImage;
    imgFoto3: TImage;
    speLeft: TSpeedButton;
    speRight: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
