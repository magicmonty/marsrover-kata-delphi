unit TestMarsRoverBase;

interface

uses
  Types,
  TestFramework,
  uMarsRover;

type
  TMarsRoverBase = class(TTestCase)
  strict private
    FMarsRover: IMarsRover;
    FGrid: IGrid;
  protected
    property MarsRover: IMarsRover read FMarsRover;
    property Grid: IGrid read FGrid;

    procedure SetUp; override;
    procedure TearDown; override;

    procedure CheckDirectionEquals(const AExpected: TDirection);
    procedure CheckPositionEquals(const AExpectedX, AExpectedY: Integer);
    procedure CheckPositionAndDirection(
      const X, Y: Integer;
      const Direction: TDirection);

    procedure SetRoverDirection(const ANewDirection: TDirection);
    procedure SetRoverPosition(const ANewPosition: TPoint);
    procedure SetPositionAndDirection(
      const X, Y: Integer;
      const Direction: TDirection);
  end;

const
  GRID_WIDTH: Integer = 100;
  GRID_HEIGHT: Integer = 50;

  GRID_TEST_POS_X: Integer = 50;
  GRID_TEST_POS_Y: Integer = 25;

  MIN_X: Integer = 0;
  MIN_Y: Integer = 0;

  MAX_X: Integer = 99; // GRID_WIDTH - 1
  MAX_Y: Integer = 49; // GRID_HEIGHT - 1

implementation

procedure TMarsRoverBase.SetRoverDirection(const ANewDirection: TDirection);
begin
  FMarsRover.Init(FGrid, FMarsRover.Position, ANewDirection);
end;

procedure TMarsRoverBase.SetRoverPosition(const ANewPosition: TPoint);
begin
  FMarsRover.Init(FGrid, ANewPosition, FMarsRover.Direction);
end;

procedure TMarsRoverBase.SetPositionAndDirection(
  const X, Y: Integer;
  const Direction: TDirection);
begin
  SetRoverDirection(Direction);
  SetRoverPosition(Point(X, Y));
end;

procedure TMarsRoverBase.SetUp;
begin
  FGrid := TGrid.Create(GRID_WIDTH, GRID_HEIGHT);
  FMarsRover := TMarsRover.Create(FGrid, Point(MIN_X, MIN_Y), NORTH);
end;

procedure TMarsRoverBase.TearDown;
begin
  FMarsRover := nil;
  FGrid := nil;
end;

procedure TMarsRoverBase.CheckPositionEquals(
  const AExpectedX, AExpectedY: Integer);
begin
  CheckEquals(AExpectedX, MarsRover.Position.X, 'X Position should match');
  CheckEquals(AExpectedY, MarsRover.Position.Y, 'Y Position should match');
end;

procedure TMarsRoverBase.CheckDirectionEquals(const AExpected: TDirection);
begin
  CheckEquals(Ord(AExpected), Ord(FMarsRover.Direction), 'Direction should match');
end;

procedure TMarsRoverBase.CheckPositionAndDirection(
  const X, Y: Integer;
  const Direction: TDirection);
begin
  CheckPositionEquals(X, Y);
  CheckDirectionEquals(Direction);
end;

end.
