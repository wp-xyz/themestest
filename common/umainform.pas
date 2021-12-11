unit uMainForm;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  {$IFDEF FPC}
  LCLType,
  {$ELSE}
  Windows, UxTheme,
  {$ENDIF}
  Classes, SysUtils, Types, Forms, Controls, Graphics, Dialogs, StdCtrls,
  TypInfo, Themes, ExtCtrls, Spin;

type

  { TMainForm }

  TMainForm = class(TForm)
    cbDrawText: TCheckBox;
    cbWhiteBackground: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edDetailSize: TEdit;
    lbMainItems: TListBox;
    lbSubItems: TListBox;
    PaintBox: TPaintBox;
    seCustomWidth: TSpinEdit;
    seCustomHeight: TSpinEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure cbDrawTextChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbMainItemsClick(Sender: TObject);
    procedure lbSubItemsClick(Sender: TObject);
    procedure PaintboxPaint(Sender: TObject);
  private
    FDetailName: string;
    FTypeInfo: PTypeInfo;
    FDetails: TThemedElementDetails;
    FDetailSize: TSize;
    FSelected: boolean;
    procedure FillListBox(LBox: TListBox; pti: PTypeInfo);
    procedure SelectMainItem;
    procedure SelectSubItem;
    procedure UpdatePaintbox(AllSelected: Boolean);
  public
  end;

var
  MainForm: TMainForm;

implementation

{$IFDEF FPC}
 {$R *.lfm}
{$ELSE}
 {$R *.dfm}
{$ENDIF}

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
  {$IFNDEF FPC}
  else if TypeName = 'teDatePicker' then
    Result := TypeInfo(TThemedDatePicker)
  else if TypeName = 'teFlyOut' then
    Result := TypeInfo(TThemedFlyOut)
  else if TypeName = 'teLink' then
    Result := TypeInfo(TThemedLink)
  else if TypeName = 'teMenuBand' then
    Result := TypeInfo(TThemedMenuBand)
  else if TypeName = 'teMonthCal' then
    Result := TypeInfo(TThemedMonthCal)
  else if TypeName = 'teNavigation' then
    Result := TypeInfo(TThemedNavigation)
  else if TypeName = 'teTaskDialog' then
    Result := TypeInfo(TThemedTaskDialog)
  else if TypeName = 'teTextStyle' then
    Result := TypeInfo(TThemedTextStyle)
  {$ENDIF}
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
  {$IFNDEF FPC}
  else if TypeName = 'teDatePicker' then
    Result := ThemeServices.GetElementDetails(TThemedDatePicker(Element))
  else if TypeName = 'teFlyOut' then
    Result := ThemeServices.GetElementDetails(TThemedFlyOut(Element))
  else if TypeName = 'teLink' then
    Result := ThemeServices.GetElementDetails(TThemedLink(Element))
  else if TypeName = 'teMenuBand' then
    Result := ThemeServices.GetElementDetails(TThemedMenuBand(Element))
  else if TypeName = 'teMonthCal' then
    Result := ThemeServices.GetElementDetails(TThemedMonthCal(Element))
  else if TypeName = 'teNavigation' then
    Result := ThemeServices.GetElementDetails(TThemedNavigation(Element))
  else if TypeName = 'teTaskDialog' then
    Result := ThemeServices.GetElementDetails(TThemedTaskDialog(Element))
  else if TypeName = 'teTextStyle' then
    Result := ThemeServices.GetElementDetails(TThemedTextStyle(Element))
  {$ENDIF}
  else
    raise Exception.Create('Unexpected type name ' + TypeName);
end;

function Size(X, Y:Integer): TSize;
begin
  Result.CX := X;
  Result.cy := Y;
end;

{$IFNDEF FPC}
function GetDetailSize(Details: TThemedElementDetails): TSize;
begin
  // default values here
  // -1 mean that we do not know size of detail
  Result := Size(-1, -1);
  case Details.Element of
    teButton:
      if Details.Part in [BP_RADIOBUTTON, BP_CHECKBOX] then
        Result := Size(13, 13)
      else
      if Details.Part = BP_PUSHBUTTON then
        Result := Size(75, 23);
    teRebar:
      if Details.Part = RP_GRIPPER then
        Result.cy := 30
      else
      if Details.Part = RP_GRIPPERVERT then
        Result.cx := 30;
    teToolBar:
      if Details.Part in [TP_SPLITBUTTONDROPDOWN, TP_DROPDOWNBUTTON] then
        Result.cx := 12;
    teTreeView:
      if Details.Part in [TVP_GLYPH, TVP_HOTGLYPH] then
        Result := Size(9, 9);
    teWindow:
      if Details.Part in [WP_SMALLCLOSEBUTTON, WP_MDICLOSEBUTTON, WP_MDIHELPBUTTON, WP_MDIMINBUTTON, WP_MDIRESTOREBUTTON, WP_MDISYSBUTTON] then
        Result := Size(9, 9);
    teHeader:
      if Details.Part in [HP_HEADERSORTARROW] then
        Result := Size(8, 5);
  end;
  if (Result.cx>0) then
    Result.cx := MulDiv(Result.cx, Screen.PixelsPerInch, 96);
  if (Result.cy>0) then
    Result.cy := MulDiv(Result.cy, Screen.PixelsPerInch, 96);
end;
{$ENDIF}


{ TMainForm }

procedure TMainForm.cbDrawTextChange(Sender: TObject);
begin
  PaintBox.Invalidate;
end;

procedure TMainForm.FillListBox(LBox: TListBox; pti: PTypeInfo);
var
  s: string;
  i, n1, n2: NativeInt;
  {$IFNDEF FPC}
  ptd: PTypeData;
  {$ENDIF}
begin
  {$IFDEF FPC}
  n1 := 0;
  n2 := GetEnumNameCount(pti) - 1;
  {$ELSE}
  ptd := getTypeData(pti);
  n1 := ptd^.MinValue;
  n2 := ptd^.MaxValue;
  {$ENDIF}
  LBox.Clear;
  for i := n1 to n2 do
  begin
    s := GetEnumName(pti, i);
    LBox.AddItem(s, TObject({%H-}Pointer(i)));
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FSelected := false;
  FillListBox(lbMainItems, TypeInfo(TThemedElement));
end;

procedure TMainForm.lbMainItemsClick(Sender: TObject);
begin
  SelectMainItem;
end;

procedure TMainForm.lbSubItemsClick(Sender: TObject);
begin
  SelectSubItem;
end;

procedure TMainForm.PaintboxPaint(Sender: TObject);
var
  R: TRect;
  drawTxt: boolean;
  clr: TColor;
begin
  if cbWhiteBackground.Checked then
  begin
    clr := PaintBox.Canvas.Brush.Color;
    PaintBox.Canvas.Brush.Color := clWhite;
    PaintBox.Canvas.FillRect(Rect(0, 0, Paintbox.Width, Paintbox.Height));
    PaintBox.Canvas.Brush.Color := clr;
  end;
  
  if FSelected then
  begin
    drawTxt := cbDrawText.State=cbChecked;
    R := Rect(50, 10, 50+FDetailSize.cx, 10+FDetailSize.cy);
    ThemeServices.DrawElement(PaintBox.Canvas.Handle, FDetails, R);
    if drawTxt then
      ThemeServices.DrawText(PaintBox.Canvas.Handle, FDetails, 'preferred', R, DT_CENTER or DT_VCENTER or DT_NOCLIP, 0);
    
    R := Rect(150,10, 150+16, 10+16);
    ThemeServices.DrawElement(PaintBox.Canvas.Handle, FDetails, R);
    if drawTxt then
      ThemeServices.DrawText(PaintBox.Canvas.Handle, FDetails, '16x16', R, DT_CENTER or DT_VCENTER, 0);

    R := Rect(250, 10, 250+32, 10+32);
    ThemeServices.DrawElement(PaintBox.Canvas.Handle, FDetails, R);
    if drawTxt then
      ThemeServices.DrawText(PaintBox.Canvas.Handle, FDetails, '32x32', R, DT_CENTER or DT_VCENTER, 0);

    R := Rect(350, 10, 350+64, 10+64);
    ThemeServices.DrawElement(PaintBox.Canvas.Handle, FDetails, R);
    if drawTxt then
      ThemeServices.DrawText(PaintBox.Canvas.Handle, FDetails, '64x64', R, DT_CENTER or DT_VCENTER, 0);
  
    R := Rect(450, 10, 450+seCustomWidth.Value, 10+seCustomHeight.Value);
    ThemeServices.DrawElement(PaintBox.Canvas.Handle, FDetails, R);
    if drawTxt then
      ThemeServices.DrawText(PaintBox.Canvas.Handle, FDetails, Format('%dx%d', [seCustomWidth.Value, seCustomHeight.Value]), R, DT_CENTER or DT_VCENTER, 0);
  end;
end;

procedure TMainForm.SelectMainItem;
begin
  FDetailName := GetEnumName(TypeInfo(TThemedElement), lbMainItems.ItemIndex);
  FTypeInfo := GetTI(FDetailName);
  FillListBox(lbSubItems, FTypeInfo);
  UpdatePaintbox(false);
end;

procedure TMainForm.SelectSubItem;
begin
  FDetails := GetTDetail(FDetailName, lbSubItems. ItemIndex);
  {$IFDEF FPC}
  FDetailSize := ThemeServices.GetDetailSize(FDetails);
  {$ELSE}
  FDetailSize := GetDetailSize(FDetails);
  {$IFEND}
  edDetailSize.Text := Format('cx = %d; cy = %d', [FDetailSize.cx, FDetailSize.cy]);
  UpdatePaintbox(true);
end;

procedure TMainForm.UpdatePaintbox(AllSelected: Boolean);
begin
  FSelected := AllSelected;
  Paintbox.Invalidate;
end;


end.

