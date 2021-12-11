unit umainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  TypInfo,Themes, ExtCtrls, Spin,types, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    cbDrawText: TCheckBox;
    cbWhiteBackground: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edDetailSize: TEdit;
    ListBox1: TListBox;
    ListBox2: TListBox;
    PaintBox: TPaintBox;
    seCustomWidth: TSpinEdit;
    seCustomHeight: TSpinEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    procedure _dtchange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintboxPaint(Sender: TObject);
    procedure SelectMainItem(Sender: TObject; {%H-}User: boolean);
    procedure SelectSubItem(Sender: TObject; {%H-}User: boolean);
  private
    FDetailName: string;
    FTypeInfo: PTypeInfo;
    FDetails: TThemedElementDetails;
    FDetailSize: TSize;
    FSelected: boolean;
    procedure FillListBox(LBox: TListBox; pti: PTypeInfo);
    procedure UpdatePaintbox(AllSelected: Boolean);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FillListBox(LBox: TListBox; pti: PTypeInfo);
var
  s: string;
  i: PtrInt;
begin
  LBox.Clear;
  for i:=0 to GetEnumNameCount(pti)-1 do
  begin
    s := GetEnumName(pti, i);
    LBox.AddItem(s, TObject({%H-}Pointer(i)));
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FSelected := false;
  FillListBox(ListBox1, TypeInfo(TThemedElement));
end;

function GetTI(TypeName: string): PTypeInfo;
begin
  case TypeName of
    'teButton': Result := TypeInfo(TThemedButton);
    'teClock': Result := TypeInfo(TThemedClock);
    'teComboBox': Result := TypeInfo(TThemedComboBox);
    'teEdit': Result := TypeInfo(TThemedEdit);
    'teExplorerBar': Result := TypeInfo(TThemedExplorerBar);
    'teHeader': Result := TypeInfo(TThemedHeader);
    'teListView': Result := TypeInfo(TThemedListView);
    'teMenu': Result := TypeInfo(TThemedMenu);
    'tePage': Result := TypeInfo(TThemedPage);
    'teProgress': Result := TypeInfo(TThemedProgress);
    'teRebar': Result := TypeInfo(TThemedRebar);
    'teScrollBar': Result := TypeInfo(TThemedScrollBar);
    'teSpin': Result := TypeInfo(TThemedSpin);
    'teStartPanel': Result := TypeInfo(TThemedStartPanel);
    'teStatus': Result:= TypeInfo(TThemedStatus);
    'teTab': Result := TypeInfo(TThemedTab);
    'teTaskBand': Result := TypeInfo(TThemedTaskBand);
    'teTaskBar': Result := TypeInfo(TThemedTaskBar);
    'teToolBar': Result := TypeInfo(TThemedToolBar);
    'teToolTip': Result := TypeInfo(TThemedToolTip);
    'teTrackBar': Result := TypeInfo(TThemedTrackBar);
    'teTrayNotify': Result := TypeInfo(TThemedTrayNotify);
    'teTreeview': Result := TypeInfo(TThemedTreeview);
    'teWindow': Result := TypeInfo(TThemedWindow);
  end;
end;

function GetTDetail(TypeName: string; Element: integer): TThemedElementDetails;
begin
  case TypeName of
    'teButton': Result := ThemeServices.GetElementDetails(TThemedButton(Element));
    'teClock': Result := ThemeServices.GetElementDetails(TThemedClock(Element));
    'teComboBox': Result := ThemeServices.GetElementDetails(TThemedComboBox(Element));
    'teEdit': Result := ThemeServices.GetElementDetails(TThemedEdit(Element));
    'teExplorerBar': Result := ThemeServices.GetElementDetails(TThemedExplorerBar(Element));
    'teHeader': Result := ThemeServices.GetElementDetails(TThemedHeader(Element));
    'teListView': Result := ThemeServices.GetElementDetails(TThemedListView(Element));
    'teMenu': Result := ThemeServices.GetElementDetails(TThemedMenu(Element));
    'tePage': Result := ThemeServices.GetElementDetails(TThemedPage(Element));
    'teProgress': Result := ThemeServices.GetElementDetails(TThemedProgress(Element));
    'teRebar': Result := ThemeServices.GetElementDetails(TThemedRebar(Element));
    'teScrollBar': Result := ThemeServices.GetElementDetails(TThemedScrollBar(Element));
    'teSpin': Result := ThemeServices.GetElementDetails(TThemedSpin(Element));
    'teStartPanel':result:=ThemeServices.GetElementDetails(TThemedStartPanel(Element));
    'teStatus': Result := ThemeServices.GetElementDetails(TThemedStatus(Element));
    'teTab': Result := ThemeServices.GetElementDetails(TThemedTab(Element));
    'teTaskBand': Result := ThemeServices.GetElementDetails(TThemedTaskBand(Element));
    'teTaskBar': Result := ThemeServices.GetElementDetails(TThemedTaskBar(Element));
    'teToolBar': Result := ThemeServices.GetElementDetails(TThemedToolBar(Element));
    'teToolTip': Result := ThemeServices.GetElementDetails(TThemedToolTip(Element));
    'teTrackBar': Result := ThemeServices.GetElementDetails(TThemedTrackBar(Element));
    'teTrayNotify': Result := ThemeServices.GetElementDetails(TThemedTrayNotify(Element));
    'teTreeview': Result := ThemeServices.GetElementDetails(TThemedTreeview(Element));
    'teWindow': Result := ThemeServices.GetElementDetails(TThemedWindow(Element));
  end;
end;

procedure TForm1.SelectMainItem(Sender: TObject; User: boolean);
begin
  FDetailName := GetEnumName(TypeInfo(TThemedElement), ListBox1.ItemIndex);
  FTypeInfo := GetTI(FDetailName);
  FillListBox(ListBox2, FTypeInfo);
  UpdatePaintbox(false);
end;

procedure TForm1.SelectSubItem(Sender: TObject; User: boolean);
begin
  FDetails := GetTDetail(FDetailName, ListBox2. ItemIndex);
  FDetailSize := ThemeServices.GetDetailSize(FDetails);
  edDetailSize.Caption := Format('cx = %d; cy = %d', [FDetailSize.cx, FDetailSize.cy]);
  UpdatePaintbox(true);
end;

procedure TForm1._dtchange(Sender: TObject);
begin
  PaintBox.Invalidate;
end;

procedure TForm1.PaintboxPaint(Sender: TObject);
var
  R: TRect;
  drawTxt: boolean;
  clr: TColor;
begin
  if cbWhiteBackground.Checked then
  begin
    clr:= PaintBox.Canvas.Brush.Color;
    PaintBox.Canvas.Brush.Color := clWhite;
    PaintBox.Canvas.FillRect(0, 0, Paintbox.Width, Paintbox.Height);
    PaintBox.Canvas.Brush.Color := clr;
  end;
  
  if FSelected then
  begin
    drawTxt := cbDrawText.State=cbChecked;
    R := Rect(10, 10, 10+FDetailSize.cx, 10+FDetailSize.cy);
    ThemeServices.DrawElement(PaintBox.Canvas.Handle, FDetails, R);
    if drawTxt then
      ThemeServices.DrawText(PaintBox.Canvas.Handle, FDetails, 'preferred', R, DT_CENTER or DT_VCENTER, 0);
    
    R := Rect(100,10, 100+16, 10+16);
    ThemeServices.DrawElement(PaintBox.Canvas.Handle, FDetails, R);
    if drawTxt then
      ThemeServices.DrawText(PaintBox.Canvas.Handle, FDetails, '16x16', R, DT_CENTER or DT_VCENTER, 0);

    R := Rect(200, 10, 200+32, 10+32);
    ThemeServices.DrawElement(PaintBox.Canvas.Handle, FDetails, R);
    if drawTxt then
      ThemeServices.DrawText(PaintBox.Canvas.Handle, FDetails, '32x32', R, DT_CENTER or DT_VCENTER, 0);

    R := Rect(300, 10, 300+64, 10+64);
    ThemeServices.DrawElement(PaintBox.Canvas.Handle, FDetails, R);
    if drawTxt then
      ThemeServices.DrawText(PaintBox.Canvas.Handle, FDetails, '64x64', R, DT_CENTER or DT_VCENTER, 0);
  
    R := Rect(400, 10, 400+seCustomWidth.Value, 10+seCustomHeight.Value);
    ThemeServices.DrawElement(PaintBox.Canvas.Handle, FDetails, R);
    if drawTxt then
      ThemeServices.DrawText(PaintBox.Canvas.Handle, FDetails, Format('%dx%d', [seCustomWidth.Value, seCustomHeight.Value]), R, DT_CENTER or DT_VCENTER, 0);
  end;
end;

procedure TForm1.UpdatePaintbox(AllSelected: Boolean);
begin
  FSelected := AllSelected;
  Paintbox.Invalidate;
end;


end.

