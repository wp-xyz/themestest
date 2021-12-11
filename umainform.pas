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
  if TypeName = 'teButton' then 
    Result := TypeInfo(TThemedButton)
  else if TypeName = 'teClock' then
    Result := TypeInfo(TThemedClock)
  else if TypeName = 'teComboBox' then 
    Result := TypeInfo(TThemedComboBox)
  else if TypeName = 'teEdit' then
    Result := TypeInfo(TThemedEdit)
  else if TypeName = 'teExplorerBar' then 
    Result := TypeInfo(TThemedExplorerBar)
  else if TypeName = 'teHeader' then
    Result := TypeInfo(TThemedHeader)
  else if TypeName = 'teListView' then 
    Result := TypeInfo(TThemedListView)
  else if TypeName = 'teMenu' then
    Result := TypeInfo(TThemedMenu)
  else if TypeName = 'tePage' then
    Result := TypeInfo(TThemedPage)
  else if TypeName = 'teProgress' then
    Result := TypeInfo(TThemedProgress)
  else if TypeName = 'teRebar' then
    Result := TypeInfo(TThemedRebar)
  else if TypeName = 'teScrollBar' then 
    Result := TypeInfo(TThemedScrollBar)
  else if TypeName = 'teSpin' then
    Result := TypeInfo(TThemedSpin)
  else if TypeName = 'teStartPanel' then 
    Result := TypeInfo(TThemedStartPanel)
  else if TypeName = 'teStatus' then
    Result:= TypeInfo(TThemedStatus)
  else if TypeName = 'teTab' then
    Result := TypeInfo(TThemedTab)
  else if TypeName = 'teTaskBand' then
    Result := TypeInfo(TThemedTaskBand)
  else if TypeName = 'teTaskBar' then
    Result := TypeInfo(TThemedTaskBar)
  else if TypeName = 'teToolBar' then
    Result := TypeInfo(TThemedToolBar)
  else if TypeName = 'teToolTip' then
    Result := TypeInfo(TThemedToolTip)
  else if TypeName = 'teTrackBar' then
    Result := TypeInfo(TThemedTrackBar)
  else if TypeName = 'teTrayNotify' then
    Result := TypeInfo(TThemedTrayNotify)
  else if TypeName = 'teTreeview' then
    Result := TypeInfo(TThemedTreeview)
  else if TypeName = 'teWindow' then
    Result := TypeInfo(TThemedWindow)
  else
    Result := nil;
end;

function GetTDetail(TypeName: string; Element: integer): TThemedElementDetails;
begin
  if TypeName = 'teButton' then
    Result := ThemeServices.GetElementDetails(TThemedButton(Element))
  else if TypeName = 'teClock' then
    Result := ThemeServices.GetElementDetails(TThemedClock(Element))
  else if TypeName = 'teComboBox' then
    Result := ThemeServices.GetElementDetails(TThemedComboBox(Element))
  else if TypeName = 'teEdit' then
    Result := ThemeServices.GetElementDetails(TThemedEdit(Element))
  else if TypeName = 'teExplorerBar' then
    Result := ThemeServices.GetElementDetails(TThemedExplorerBar(Element))
  else if TypeName = 'teHeader' then
    Result := ThemeServices.GetElementDetails(TThemedHeader(Element))
  else if TypeName = 'teListView' then
    Result := ThemeServices.GetElementDetails(TThemedListView(Element))
  else if TypeName = 'teMenu' then
    Result := ThemeServices.GetElementDetails(TThemedMenu(Element))
  else if TypeName = 'tePage' then 
    Result := ThemeServices.GetElementDetails(TThemedPage(Element))
  else if TypeName = 'teProgress' then
    Result := ThemeServices.GetElementDetails(TThemedProgress(Element))
  else if TypeName = 'teRebar' then 
    Result := ThemeServices.GetElementDetails(TThemedRebar(Element))
  else if TypeName = 'teScrollBar' then 
    Result := ThemeServices.GetElementDetails(TThemedScrollBar(Element))
  else if TypeName = 'teSpin' then
    Result := ThemeServices.GetElementDetails(TThemedSpin(Element))
  else if TypeName = 'teStartPanel' then 
    Result := ThemeServices.GetElementDetails(TThemedStartPanel(Element))
  else if TypeName = 'teStatus' then  
    Result := ThemeServices.GetElementDetails(TThemedStatus(Element))
  else if TypeName = 'teTab' then
    Result := ThemeServices.GetElementDetails(TThemedTab(Element))
  else if TypeName = 'teTaskBand' then 
    Result := ThemeServices.GetElementDetails(TThemedTaskBand(Element))
  else if TypeName = 'teTaskBar' then 
    Result := ThemeServices.GetElementDetails(TThemedTaskBar(Element))
  else if TypeName = 'teToolBar' then 
    Result := ThemeServices.GetElementDetails(TThemedToolBar(Element))
  else if TypeName = 'teToolTip' then 
    Result := ThemeServices.GetElementDetails(TThemedToolTip(Element))
  else if TypeName = 'teTrackBar' then 
    Result := ThemeServices.GetElementDetails(TThemedTrackBar(Element))
  else if TypeName = 'teTrayNotify' then 
    Result := ThemeServices.GetElementDetails(TThemedTrayNotify(Element))
  else if TypeName = 'teTreeview' then
    Result := ThemeServices.GetElementDetails(TThemedTreeview(Element))
  else if TypeName = 'teWindow' then
    Result := ThemeServices.GetElementDetails(TThemedWindow(Element))
  else
    raise Exception.Create('Unexpected type name ' + TypeName);
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
    clr := PaintBox.Canvas.Brush.Color;
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

