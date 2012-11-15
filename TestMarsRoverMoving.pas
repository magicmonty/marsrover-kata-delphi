unit TestMarsRoverMoving;

interface

uses
  TestFramework,
  TestMarsRoverBase,
  uMarsRover;

type
  TMoveFunction = (mfForward, mfBackward);
  TMinMaxPosition = (posMin, posMax);

  TMarsRoverMovingTest = class(TMarsRoverBase)
  strict private
    procedure SetTestPositionAndDirection(const Direction: TDirection);
    procedure CheckStandardMove(
      const MoveFunction: TMoveFunction;
      const Direction: TDirection;
      const OffsetX, OffsetY: Integer);
    procedure CheckWrapAroundMove(
      const MoveFunction: TMoveFunction;
      const Direction: TDirection;
      const MinX, MinY: TMinMaxPosition);

    function ExpectedXWrapPosition(const MinPos: TMinMaxPosition): Integer;
    function ExpectedYWrapPosition(const MinPos: TMinMaxPosition): Integer;
    function CurrentXTestPosition(const MoveFunction: TMoveFunction; const Direction: TDirection): Integer;
    function CurrentYTestPosition(const MoveFunction: TMoveFunction; const Direction: TDirection): Integer;
    procedure MoveRover(const MoveFunction: TMoveFunction);
    procedure MoveRoverForward;
    procedure MoveRoverBackward;
    procedure CheckObstacleForwardException(const Direction: TDirection);
    procedure CheckObstacleBackwardException(const Direction: TDirection);
  published
    procedure IfFacingNorthAndMovingForwardsTheYPosShouldBeIncreasedByOne;
    procedure IfFacingEastAndMovingForwardsTheXPosShouldBeIncreasedByOne;
    procedure IfFacingSouthAndMovingForwardsTheYPosShouldBeDecreasedByOne;
    procedure IfFacingWestAndMovingForwardsTheXPosShouldBeDecreasedByOne;

    procedure IfFacingNorthAndMovingForwardsTheYPosShouldWrapAround;
    procedure IfFacingEastAndMovingForwardsTheXPosShouldWrapAround;
    procedure IfFacingSouthAndMovingForwardsTheYPosShouldWrapAround;
    procedure IfFacingWestAndMovingForwardsTheXPosShouldWrapAround;

    procedure IfFacingNorthAndMovingBackwardsTheYPosShouldBeDecreasedByOne;
    procedure IfFacingEastAndMovingBackwardsTheXPosShouldBeDecreasedByOne;
    procedure IfFacingSouthAndMovingBackwardsTheYPosShouldBeIncreasedByOne;
    procedure IfFacingWestAndMovingBackwardsTheXPosShouldBeIncreasedByOne;

    procedure IfFacingNorthAndMovingBackwardsTheYPosShouldWrapAround;
    procedure IfFacingEastAndMovingBackwardsTheXPosShouldWrapAround;
    procedure IfFacingSouthAndMovingBackwardsTheYPosShouldWrapAround;
    procedure IfFacingWestAndMovingBackwardsTheXPosShouldWrapAround;

    procedure IfObstacleAheadThrowObstacleAheadException;
    procedure IfObstacleBehindThrowObstacleBehindException;
  end;


implementation

uses
  SysUtils,
  Types;

procedure TMarsRoverMovingTest.IfFacingNorthAndMovingForwardsTheYPosShouldBeIncreasedByOne;
begin
  CheckStandardMove(mfForward, NORTH, 0, 1);
end;

procedure TMarsRoverMovingTest.IfFacingEastAndMovingForwardsTheXPosShouldBeIncreasedByOne;
begin
  CheckStandardMove(mfForward, EAST, 1, 0);
end;

procedure TMarsRoverMovingTest.IfFacingSouthAndMovingForwardsTheYPosShouldBeDecreasedByOne;
begin
  CheckStandardMove(mfForward, SOUTH, 0, -1);
end;

procedure TMarsRoverMovingTest.IfFacingWestAndMovingForwardsTheXPosShouldBeDecreasedByOne;
begin
  CheckStandardMove(mfForward, WEST, -1, 0);
end;

procedure TMarsRoverMovingTest.IfFacingNorthAndMovingForwardsTheYPosShouldWrapAround;
begin
  CheckWrapAroundMove(mfForward, NORTH, posMax, posMin);
end;

procedure TMarsRoverMovingTest.IfFacingEastAndMovingForwardsTheXPosShouldWrapAround;
begin
  CheckWrapAroundMove(mfForward, EAST, posMin, posMax);
end;

procedure TMarsRoverMovingTest.IfFacingSouthAndMovingForwardsTheYPosShouldWrapAround;
begin
  CheckWrapAroundMove(mfForward, SOUTH, posMin, posMax);
end;

procedure TMarsRoverMovingTest.IfFacingWestAndMovingForwardsTheXPosShouldWrapAround;
begin
  CheckWrapAroundMove(mfForward, WEST, posMax, posMin);
end;

procedure TMarsRoverMovingTest.IfFacingNorthAndMovingBackwardsTheYPosShouldBeDecreasedByOne;
begin
  CheckStandardMove(mfBackward, NORTH, 0, -1);
end;

procedure TMarsRoverMovingTest.IfFacingEastAndMovingBackwardsTheXPosShouldBeDecreasedByOne;
begin
  CheckStandardMove(mfBackward, EAST, -1, 0);
end;

procedure TMarsRoverMovingTest.IfFacingSouthAndMovingBackwardsTheYPosShouldBeIncreasedByOne;
begin
  CheckStandardMove(mfBackward, SOUTH, 0, 1);
end;

procedure TMarsRoverMovingTest.IfFacingWestAndMovingBackwardsTheXPosShouldBeIncreasedByOne;
begin
  CheckStandardMove(mfBackward, WEST, 1, 0);
end;

procedure TMarsRoverMovingTest.IfFacingNorthAndMovingBackwardsTheYPosShouldWrapAround;
begin
  CheckWrapAroundMove(mfBackward, NORTH, posMin, posMax);
end;

procedure TMarsRoverMovingTest.IfFacingEastAndMovingBackwardsTheXPosShouldWrapAround;
begin
  CheckWrapAroundMove(mfBackward, EAST, posMax, posMin);
end;

procedure TMarsRoverMovingTest.IfFacingSouthAndMovingBackwardsTheYPosShouldWrapAround;
begin
  CheckWrapAroundMove(mfBackward, SOUTH, posMax, posMin);
end;

procedure TMarsRoverMovingTest.IfFacingWestAndMovingBackwardsTheXPosShouldWrapAround;
begin
  CheckWrapAroundMove(mfBackward, WEST, posMin, posMax);
end;

procedure TMarsRoverMovingTest.IfObstacleAheadThrowObstacleAheadException;
var
  Direction: TDirection;
begin
  SurroundCenterPositionWithObstacles;

  for Direction := Low(TDirection) to High(TDirection) do
    CheckObstacleForwardException(Direction);
end;

procedure TMarsRoverMovingTest.IfObstacleBehindThrowObstacleBehindException;
var
  Direction: TDirection;
begin
  SurroundCenterPositionWithObstacles;

  for Direction := Low(TDirection) to High(TDirection) do
    CheckObstacleBackwardException(Direction);
end;

procedure TMarsRoverMovingTest.CheckObstacleForwardException(const Direction: TDirection);
begin
  SetTestPositionAndDirection(Direction);

  try
    MoveRoverForward;
    Check(False, 'Exception not thrown');
  except
    on E: TObstacleAheadException do
    begin
      CheckPositionAndDirection(GRID_TEST_POS_X, GRID_TEST_POS_Y, Direction);
    end;
    on E: Exception do
      Check(False, 'Wrong exception thrown: ' + E.Message);
  end;
end;

procedure TMarsRoverMovingTest.CheckObstacleBackwardException(const Direction: TDirection);
begin
  SetTestPositionAndDirection(Direction);

  try
    MoveRoverBackward;
    Check(False, 'Exception not thrown');
  except
    on E: TObstacleBehindException do
    begin
      CheckPositionAndDirection(GRID_TEST_POS_X, GRID_TEST_POS_Y, Direction);
    end;
    on E: Exception do
      Check(False, 'Wrong exception thrown: ' + E.Message);
  end;
end;

procedure TMarsRoverMovingTest.MoveRoverForward;
begin
  MoveRover(mfForward);
end;

procedure TMarsRoverMovingTest.MoveRoverBackward;
begin
  MoveRover(mfBackward);
end;

function TMarsRoverMovingTest.ExpectedYWrapPosition(const MinPos: TMinMaxPosition): Integer;
begin
  if MinPos = posMin then
    Result := MIN_Y
  else
    Result := MAX_Y;
end;

procedure TMarsRoverMovingTest.SetTestPositionAndDirection(const Direction: TDirection);
begin
  SetPositionAndDirection(GRID_TEST_POS_X, GRID_TEST_POS_Y, Direction);
end;

procedure TMarsRoverMovingTest.CheckStandardMove(
  const MoveFunction: TMoveFunction;
  const Direction: TDirection;
  const OffsetX, OffsetY: Integer);
begin
  SetTestPositionAndDirection(Direction);

  MoveRover(MoveFunction);

  CheckPositionAndDirection(
    GRID_TEST_POS_X + OffsetX,
    GRID_TEST_POS_Y + OffsetY,
    Direction);
end;

procedure TMarsRoverMovingTest.CheckWrapAroundMove(
  const MoveFunction: TMoveFunction;
  const Direction: TDirection;
  const MinX, MinY: TMinMaxPosition);
begin
  SetPositionAndDirection(
    CurrentXTestPosition(MoveFunction, Direction),
    CurrentYTestPosition(MoveFunction, Direction),
    Direction);

  MoveRover(MoveFunction);

  CheckPositionAndDirection(
    ExpectedXWrapPosition(MinX),
    ExpectedYWrapPosition(MinY),
    Direction);
end;

procedure TMarsRoverMovingTest.MoveRover(const MoveFunction: TMoveFunction);
begin
  if MoveFunction = mfForward then
    MarsRover.MoveForward
  else
    MarsRover.MoveBackward;
end;

function TMarsRoverMovingTest.CurrentXTestPosition(
  const MoveFunction: TMoveFunction;
  const Direction: TDirection): Integer;
begin
  if ((Direction in [NORTH, EAST]) and (MoveFunction = mfForward))
  or ((Direction in [SOUTH, WEST]) and (MoveFunction = mfBackward)) then
    Result := MAX_X
  else
    Result := MIN_Y;
end;

function TMarsRoverMovingTest.CurrentYTestPosition(
  const MoveFunction: TMoveFunction;
  const Direction: TDirection): Integer;
begin
  if ((Direction in [NORTH, EAST]) and (MoveFunction = mfForward))
  or ((Direction in [SOUTH, WEST]) and (MoveFunction = mfBackward)) then
    Result := MAX_Y
  else
    Result := MIN_Y;
end;

function TMarsRoverMovingTest.ExpectedXWrapPosition(const MinPos: TMinMaxPosition): Integer;
begin
  if MinPos = posMin then
    Result := MIN_X
  else
    Result := MAX_X;
end;

initialization
  RegisterTest(TMarsRoverMovingTest.Suite);
end.
