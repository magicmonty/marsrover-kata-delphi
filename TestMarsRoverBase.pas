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

    procedure CheckDirectionEquals(
      const AExpected: TDirection;
      Message: string = '');
    procedure CheckPositionEquals(
      const AExpectedX, AExpectedY: Integer;
      Message: string = ''
    );
    procedure CheckPositionAndDirection(
      const X, Y: Integer;
      const Direction: TDirection;
      const Message: string = '');

    procedure SetRoverCenterPosition;
    procedure SurroundCenterPositionWithObstacles;
    procedure SetRoverDirection(const ANewDirection: TDirection);
    procedure SetRoverPosition(const ANewPosition: TPoint);
    procedure SetPositionAndDirection(
      const X, Y: Integer;
      const Direction: TDirection);
  end;

const
  GRID_WIDTH = 100;
  GRID_HEIGHT = 50;

  GRID_TEST_POS_X = 50;
  GRID_TEST_POS_Y = 25;

  MIN_X = 0;
  MIN_Y = 0;

  MAX_X = GRID_WIDTH - 1;
  MAX_Y = GRID_HEIGHT - 1;

implementation

uses
  SysUtils;

procedure TMarsRoverBase.SetRoverCenterPosition;
begin
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
end;

procedure TMarsRoverBase.SetRoverDirection(const ANewDirection: TDirection);
begin
  FMarsRover.Init(FGrid, FMarsRover.Position, ANewDirection);
end;

procedure TMarsRoverBase.SetRoverPosition(const ANewPosition: TPoint);
begin
  FMarsRover.Init(FGrid, ANewPosition, FMarsRover.Direction);
end;

procedure TMarsRoverBase.SurroundCenterPositionWithObstacles;
begin
  Grid.SetObstacleAt(GRID_TEST_POS_X, GRID_TEST_POS_Y + 1);
  Grid.SetObstacleAt(GRID_TEST_POS_X + 1, GRID_TEST_POS_Y);
  Grid.SetObstacleAt(GRID_TEST_POS_X, GRID_TEST_POS_Y - 1);
  Grid.SetObstacleAt(GRID_TEST_POS_X - 1, GRID_TEST_POS_Y);
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
  const AExpectedX, AExpectedY: Integer;
  Message: string = '');
begin
  if Message <> '' then
    Message := Message + ': ';

  CheckEquals(AExpectedX, MarsRover.Position.X, Trim(Message + 'X Position should match'));
  CheckEquals(AExpectedY, MarsRover.Position.Y, Trim(Message + 'Y Position should match'));
end;

procedure TMarsRoverBase.CheckDirectionEquals(
  const AExpected: TDirection;
  Message: string = '');
begin
  if Message <> '' then
    Message := Message + ': ';

  CheckEquals(Ord(AExpected), Ord(FMarsRover.Direction), Trim(Message + 'Direction should match'));
end;

procedure TMarsRoverBase.CheckPositionAndDirection(
  const X, Y: Integer;
  const Direction: TDirection;
  const Message: string = '');
begin
  CheckPositionEquals(X, Y, Message);
  CheckDirectionEquals(Direction, Message);
end;

end.
