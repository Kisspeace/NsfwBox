{ ❤ 2022 by Kisspeace - https://github.com/Kisspeace --------- }
{ ❤ Part of NsfwBox ❤- https://github.com/101427274/505234915 }
unit NsfwBox.WindowsTitlebar;

interface
uses
  Classes, System.SysUtils, System.Types, NsfwBox.Graphics.Rectangle,
  Alcinoe.FMX.Objects, FMX.Forms, FMX.Types, System.UITypes, Fmx.Controls,
  Windows;

type

  TNBoxFormTitleBar = Class(TAlRectangle)
    public const
      DEF_HEIGHT: single = 30;
    protected
      FMouseDown: boolean;
      FDownPosition: TPoint;
      FForm: TForm;
      procedure DoOnMouseDown(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Single);
      procedure DoOnMouseMove(Sender: TObject; Shift: TShiftState; X,
        Y: Single);
      procedure DoOnMouseUp(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Single);
      procedure DoOnMouseLeave(Sender: TObject);
      procedure DoOnDblClick(Sender: TObject);
      { Buttons events ------ }
      procedure BtnCloseOnTap(Sender: TObject; const Point: TPointF);
      procedure BtnMinMaxOnTap(Sender: TObject; const Point: TPointF);
      procedure BtnHideOnTap(Sender: TObject; const Point: TPointF);
    public
      BtnTitle: TRectButton;
      BtnClose: TRectButton;
      BtnMaxMin: TRectButton;
      BtnHide: TRectButton;
      procedure DoMyJobWithMe(AControl: TControl);
      Constructor Create(AOwner: TComponent); override; // Create with TForm as owner
  End;

implementation
uses unit1;
{ TNBoxFormTitleBar }

procedure TNBoxFormTitleBar.BtnCloseOnTap(Sender: TObject;
  const Point: TPointF);
begin
  Application.Terminate; // Killing application
end;

procedure TNBoxFormTitleBar.BtnHideOnTap(Sender: TObject; const Point: TPointF);
begin
  FForm.WindowState := TWindowState.wsMinimized;
end;

procedure TNBoxFormTitleBar.BtnMinMaxOnTap(Sender: TObject;
  const Point: TPointF);
begin
  if (FForm.WindowState = TWindowState.wsNormal)
  and (not FForm.FullScreen) then begin
    FForm.WindowState := TWindowState.wsMaximized;
    FForm.Left := 0;
    FForm.Top := 0;
  end else
    FForm.WindowState := TWindowState.wsNormal;
end;

constructor TNBoxFormTitleBar.Create(AOwner: TComponent);
begin
  inherited;
  FMouseDown := False;
  FForm := AOwner As TForm;
  Parent := FForm;
  Align := TAlignLayout.MostTop;
  Size.Height := DEF_HEIGHT;
  DoMyJobWithMe(Self);

  BtnTitle := Unit1.Form1.CreateDefButton(Self);
  with BtnTitle do begin
    Parent := Self;
    Align := TAlignLayout.left;
    Size.Width := 200;
  end;
  DoMyJobWithMe(BtnTitle);

  BtnClose := Unit1.Form1.CreateDefButton(Self, BTN_STYLE_ICON3);
  with BtnClose do begin
    Parent := self;
    Align := TAlignLayout.MostRight;
    Size.Width := Size.Height;
    OnTap := Self.BtnCloseOnTap;
  end;

  BtnMaxMin := Unit1.Form1.CreateDefButton(Self, BTN_STYLE_ICON3);
  with BtnMaxMin do begin
    Parent := self;
    Align := TAlignLayout.Right;
    Size.Width := Size.Height;
    OnTap := Self.BtnMinMaxOnTap;
  end;

  BtnHide := Unit1.Form1.CreateDefButton(Self, BTN_STYLE_ICON3);
  with BtnHide do begin
    Parent := self;
    Align := TAlignLayout.Right;
    Position.X := 0;
    Size.Width := Size.Height;
    OnTap := Self.BtnHideOnTap;
  end;

end;

procedure TNBoxFormTitleBar.DoMyJobWithMe(AControl: TControl);
begin
  With AControl do begin
    OnMouseDown := DoOnMouseDown;
    OnMouseMove := DoOnMouseMove;
    OnMouseLeave := DoOnMouseLeave;
    OnMouseUp := DoOnMouseUp;
    OnDblClick := DoOnDblClick;
  end;
end;

procedure TNBoxFormTitleBar.DoOnDblClick(Sender: TObject);
begin
  Self.BtnMinMaxOnTap(BtnMaxMin, TPointF.Create(0, 0));
end;

procedure TNBoxFormTitleBar.DoOnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if (Button = TMouseButton.mbLeft) and (not FForm.FullScreen) then begin
    FMouseDown := True;
    FDownPosition := TPoint.Create(Round(X), Round(Y));
  end;
end;

procedure TNBoxFormTitleBar.DoOnMouseLeave(Sender: TObject);
begin
  FMouseDown := False;
end;

procedure TNBoxFormTitleBar.DoOnMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
begin
  if FMouseDown then begin
    if FForm.WindowState = TWindowState.wsMaximized then begin
      var LPos: TPoint;
      FForm.WindowState := TWindowState.wsNormal;
      GetCursorPos(LPos);
      FForm.Left := Round(LPos.X / 2);
      FForm.Top := Round(LPos.Y / 2);
    end;

    FForm.Top := FForm.Top + round(Y - FDownPosition.Y);
    FForm.Left := FForm.Left + round(X - FDownPosition.X);
  end;
end;

procedure TNBoxFormTitleBar.DoOnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  FMouseDown := False;
end;

end.
