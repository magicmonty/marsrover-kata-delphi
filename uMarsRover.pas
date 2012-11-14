unit uMarsRover;

interface

uses
  SysUtils,
  Generics.Collections,
  Types;

type
  TDirection = (NORTH, EAST, SOUTH, WEST);

  IGrid = interface
    ['{9CA1FB62-D34E-47FD-8F9D-2C6AAC0DA942}']
    function GetWidth: Integer;
    property Width: Integer read GetWidth;

    function GetHeight: Integer;
    property Height: Integer read GetHeight;

    procedure SetObstacleAt(const X, Y: Integer);
    function IsObstacleAt(const Position: TPoint): Boolean;
  end;

  TObstacles = TList<TPoint>;

  TGrid = class(TInterfacedObject, IGrid)
  strict private
    FWidth: Integer;
    FHeight: Integer;
    FObstacles: TObstacles;
  public
    function GetWidth: Integer;
    property Width: Integer read GetWidth;

    function GetHeight: Integer;
    property Height: Integer read GetHeight;

    constructor Create(const AWidth, AHeight: Integer);
    destructor Destroy; override;
    procedure SetObstacleAt(const X, Y: Integer);
    function IsObstacleAt(const Position: TPoint): Boolean;
  end;

  IMarsRover = interface
    ['{ED875292-FD22-4EC3-86D5-5DA2496FEE3D}']

    function Position: TPoint;
    function Direction: TDirection;

    procedure Init(
      const AGrid: IGrid;
      const APosition: TPoint;
      const ADirection: TDirection);

    procedure TurnRight;
    procedure TurnLeft;

    procedure MoveForward;
    procedure MoveBackward;

    function IsObstacleAhead: Boolean;
    function IsObstacleBehind: Boolean;
  end;

  TMarsRover = class(TInterfacedObject, IMarsRover)
  strict private
    FGrid: IGrid;
    FPosition: TPoint;
    FDirection: TDirection;

    procedure MoveByOffset(const AOffset: Integer);

    function CalcMovePosition(const AOffset: Integer): TPoint;
    function FixGridWrap(const APosition: TPoint): TPoint;
  public
    constructor Create(
      const AGrid: IGrid;
      const APosition: TPoint;
      const ADirection: TDirection);

    procedure Init(
      const AGrid: IGrid;
      const APosition: TPoint;
      const ADirection: TDirection);

    function Position: TPoint;
    function Direction: TDirection;

    procedure TurnRight;
    procedure TurnLeft;

    procedure MoveForward;
    procedure MoveBackward;

    function IsObstacleAhead: Boolean;
    function IsObstacleBehind: Boolean;
  end;

  TObstacleException = class(Exception)
  strict private
    FCurrentPosition: TPoint;
    FCurrentDirection: TDirection;
  public
    property CurrentPosition: TPoint read FCurrentPosition;
    property CurrentDirection: TDirection read FCurrentDirection;

    constructor Create(
      const Message: string;
      const ACurrentPosition: TPoint;
      const ACurrentDirection: TDirection
    );
  end;

  TObstacleAheadException = class(TObstacleException)
  public
    constructor Create(
      const CurrentPosition: TPoint;
      const CurrentDirection: TDirection
    );
  end;

  TObstacleBehindException = class(TObstacleException)
  public
    constructor Create(
      const CurrentPosition: TPoint;
      const CurrentDirection: TDirection
    );
  end;

  IMarsRoverController = interface
    ['{0F1FA10E-2757-4BFF-8579-EA362EA044D9}']

    function ExecuteCommands(const ACommands: string): Boolean;
    function LastError: string;
  end;

  TMarsRoverController = class(TInterfacedObject, IMarsRoverController)
  strict private
    FRover: IMarsRover;
    FLastError: string;
    function ExecuteCommand(const ACommand: Char): Boolean;
  public
    constructor Create(const ARover: IMarsRover);
    function ExecuteCommands(const ACommands: string): Boolean;
    function LastError: string;
  end;

implementation

{$region 'TGrid'}
constructor TGrid.Create(const AWidth, AHeight: Integer);
begin
  inherited Create;
  FWidth := AWidth;
  FHeight := AHeight;
  FObstacles := TObstacles.Create;
end;

destructor TGrid.Destroy;
begin
  FObstacles.Free;
  inherited;
end;

function TGrid.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TGrid.GetWidth: Integer;
begin
  Result := FWidth;
end;

function TGrid.IsObstacleAt(const Position: TPoint): Boolean;
begin
  Result := FObstacles.Contains(Position);
end;

procedure TGrid.SetObstacleAt(const X, Y: Integer);
begin
  if not IsObstacleAt(Point(X, Y)) then
    FObstacles.Add(Point(X, Y));
end;
{$endregion 'TGrid'}

{$region 'TMarsRover'}
constructor TMarsRover.Create(
  const AGrid: IGrid;
  const APosition: TPoint;
  const ADirection: TDirection);
begin
  inherited Create;
  Init(AGrid, APosition, ADirection);
end;

procedure TMarsRover.Init(
  const AGrid: IGrid;
  const APosition: TPoint;
  const ADirection: TDirection);
begin
  FGrid := AGrid;
  FPosition := APosition;
  FDirection := ADirection;
end;

function TMarsRover.Direction: TDirection;
begin
  Result := FDirection;
end;

function TMarsRover.Position: TPoint;
begin
  Result := FPosition;
end;

procedure TMarsRover.TurnLeft;
begin
  if FDirection > Low(TDirection) then
    Dec(FDirection)
  else
    FDirection := High(TDirection);
end;

procedure TMarsRover.TurnRight;
begin
  if FDirection < High(TDirection) then
    Inc(FDirection)
  else
    FDirection := Low(TDirection);
end;

procedure TMarsRover.MoveForward;
begin
  if not IsObstacleAhead then
    MoveByOffset(1)
  else
  begin
    raise TObstacleAheadException.Create(
      FPosition,
      FDirection
    );
  end;
end;

procedure TMarsRover.MoveBackward;
begin
  if not IsObstacleBehind then
    MoveByOffset(-1)
  else
  begin
    raise TObstacleBehindException.Create(
      FPosition,
      FDirection
    );
  end;
end;

procedure TMarsRover.MoveByOffset(const AOffset: Integer);
begin
  FPosition := CalcMovePosition(AOffset);
end;

function TMarsRover.CalcMovePosition(const AOffset: Integer): TPoint;
begin
  Result.X := FPosition.X;
  Result.Y := FPosition.Y;

  if FDirection = NORTH then
    Result.Y := Result.Y + AOffset
  else if FDirection = EAST then
    Result.X := Result.X + AOffset
  else if FDirection = SOUTH then
    Result.Y := Result.Y + (AOffset * -1)
  else
    Result.X := Result.X + (AOffset * -1);

  Result := FixGridWrap(Result);
end;

function TMarsRover.FixGridWrap(const APosition: TPoint): TPoint;
begin
  Result := APosition;

  if Result.Y >= FGrid.Height then
    Result.Y := 0
  else if Result.Y < 0 then
    Result.Y := FGrid.Height - 1;

  if Result.X >= FGrid.Width then
    Result.X := 0
  else if Result.X < 0 then
    Result.X := FGrid.Width - 1;
end;

function TMarsRover.IsObstacleAhead: Boolean;
begin
  Result := FGrid.IsObstacleAt(CalcMovePosition(1));
end;

function TMarsRover.IsObstacleBehind: Boolean;
begin
  Result := FGrid.IsObstacleAt(CalcMovePosition(-1));
end;
{$endregion 'TMarsRover'}

{$region 'TMarsRoverController'}
constructor TMarsRoverController.Create(const ARover: IMarsRover);
begin
  inherited Create;
  FRover := ARover;
  FLastError := '';
end;

function TMarsRoverController.ExecuteCommands(const ACommands: string): Boolean;
var
  i: Integer;
begin
  if Assigned(FRover) then
  begin
    FLastError := '';
    Result := True;
    for i := 1 to Length(ACommands) do
    begin
      Result := Result and ExecuteCommand( ACommands[i]);
      if not Result then
        break;
    end;
  end
  else
  begin
    Result := False;
    FLastError := 'No Rover assigned';
  end;
end;

function TMarsRoverController.LastError: string;
begin
  Result := FLastError;
end;

function TMarsRoverController.ExecuteCommand(const ACommand: Char): Boolean;
begin
  Result := True;
  try
    case ACommand of
      'l', 'L': FRover.TurnLeft;
      'r', 'R': FRover.TurnRight;
      'f', 'F': FRover.MoveForward;
      'b', 'B': FRover.MoveBackward;
    else
      Result := False;
    end;
  except
    on E: Exception do
    begin
      Result := False;
      FLastError := E.Message;
    end;
  end;
end;
{$endregion 'TMarsRoverController'}

{$region 'TObstacleException'}
constructor TObstacleException.Create(
  const Message: string;
  const ACurrentPosition: TPoint;
  const ACurrentDirection: TDirection);
begin
  inherited Create(Message);
  FCurrentPosition := ACurrentPosition;
  FCurrentDirection := ACurrentDirection;
end;

constructor TObstacleAheadException.Create(
  const CurrentPosition: TPoint;
  const CurrentDirection: TDirection);
var
  directionString: string;
begin
  case CurrentDirection of
    NORTH: directionString := 'North';
    EAST: directionString := 'East';
    SOUTH: directionString := 'South';
    WEST: directionString := 'West';
  end;

  inherited Create(
    Format(
      'Could not move forward: Obstacle ahead. Current Position: %d/%d, facing %s',
      [CurrentPosition.X, CurrentPosition.Y, directionString]
    ),
    CurrentPosition,
    CurrentDirection
  );
end;

constructor TObstacleBehindException.Create(
  const CurrentPosition: TPoint;
  const CurrentDirection: TDirection);
var
  directionString: string;
begin
  case CurrentDirection of
    NORTH: directionString := 'North';
    EAST: directionString := 'East';
    SOUTH: directionString := 'South';
    WEST: directionString := 'West';
  end;

  inherited Create(
    Format(
      'Could not move backward: Obstacle behind. Current Position: %d/%d, facing %s',
      [CurrentPosition.X, CurrentPosition.Y, directionString]
    ),
    CurrentPosition,
    CurrentDirection
  );
end;
{$endregion 'TObstacleException'}

end.
