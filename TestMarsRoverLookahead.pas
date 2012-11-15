unit TestMarsRoverLookahead;

interface

uses
  TestFramework,
  TestMarsRoverBase,
  uMarsRover;

const
  SURROUND = True;
  DONT_SURROUND = FALSE;

type
  TMoveFunction = (mfForward, mfBackward);
  TMinMaxPosition = (posMin, posMax);

  TMarsRoverLookaheadTest = class(TMarsRoverBase)
  strict private
    procedure SetRoverToCenterAndFacing(const Direction: TDirection);
    procedure SetupTest(
      const Direction: TDirection;
      const SurroundWithObstacles: Boolean);
  private
    procedure CheckLookAhead(const SurroundPositionByObstacles,
      ExpectedResult: Boolean);
    procedure CheckLookBehind(const SurroundPositionByObstacles,
      ExpectedResult: Boolean);
  published
    procedure IfNoObstacleIsInNextFieldLookAheadShouldReturnFalse;
    procedure IfNoObstacleIsInPreviousFieldLookBehindShouldReturnFalse;
    procedure IfAnObstacleIsInNextFieldLookAheadShouldReturnTrue;
    procedure IfAnObstacleIsInPreviousFieldLookBehindShouldReturnTrue;
  end;


implementation

uses
  Types;

const
  NO_OBSTACLE = False;
  OBSTACLE_FOUND = True;

procedure TMarsRoverLookaheadTest.IfNoObstacleIsInNextFieldLookAheadShouldReturnFalse;
begin
  CheckLookAhead(DONT_SURROUND, NO_OBSTACLE);
end;

procedure TMarsRoverLookaheadTest.IfNoObstacleIsInPreviousFieldLookBehindShouldReturnFalse;
begin
  CheckLookBehind(DONT_SURROUND, NO_OBSTACLE);
end;

procedure TMarsRoverLookaheadTest.IfAnObstacleIsInNextFieldLookAheadShouldReturnTrue;
begin
  CheckLookAhead(SURROUND, OBSTACLE_FOUND);
end;

procedure TMarsRoverLookaheadTest.IfAnObstacleIsInPreviousFieldLookBehindShouldReturnTrue;
begin
  CheckLookBehind(SURROUND, OBSTACLE_FOUND);
end;

procedure TMarsRoverLookaheadTest.CheckLookAhead(
  const SurroundPositionByObstacles: Boolean;
  const ExpectedResult: Boolean);
var
  direction: TDirection;
begin
  for direction := Low(TDirection) to High(TDirection) do
  begin
    SetupTest(direction, SurroundPositionByObstacles);
    CheckEquals(ExpectedResult, MarsRover.IsObstacleAhead);
  end;
end;

procedure TMarsRoverLookaheadTest.CheckLookBehind(
  const SurroundPositionByObstacles: Boolean;
  const ExpectedResult: Boolean);
var
  direction: TDirection;
begin
  for direction := Low(TDirection) to High(TDirection) do
  begin
    SetupTest(direction, SurroundPositionByObstacles);
    CheckEquals(ExpectedResult, MarsRover.IsObstacleBehind);
  end;
end;

procedure TMarsRoverLookaheadTest.SetRoverToCenterAndFacing(
  const Direction: TDirection);
begin
  SetRoverCenterPosition;
  SetRoverDirection(Direction);
end;

procedure TMarsRoverLookaheadTest.SetupTest(
  const Direction: TDirection;
  const SurroundWithObstacles: Boolean);
begin
  SetRoverToCenterAndFacing(Direction);
  if SurroundWithObstacles then
    SurroundCenterPositionWithObstacles;
end;

initialization
  RegisterTest(TMarsRoverLookaheadTest.Suite);
end.
