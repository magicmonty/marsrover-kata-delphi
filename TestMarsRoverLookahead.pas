unit TestMarsRoverLookahead;

interface

uses
  TestFramework,
  TestMarsRoverBase,
  uMarsRover;

type
  TMoveFunction = (mfForward, mfBackward);
  TMinMaxPosition = (posMin, posMax);

  TMarsRoverLookaheadTest = class(TMarsRoverBase)
  published
    procedure IfFacingNorthAndNoObstacleIsInNextFieldLookAheadShouldReturnFalse;
    procedure IfFacingEastAndNoObstacleIsInNextFieldLookAheadShouldReturnFalse;
    procedure IfFacingSouthAndNoObstacleIsInNextFieldLookAheadShouldReturnFalse;
    procedure IfFacingWestAndNoObstacleIsInNextFieldLookAheadShouldReturnFalse;

    procedure IfFacingNorthAndNoObstacleIsInNextFieldLookBehindShouldReturnFalse;
    procedure IfFacingEastAndNoObstacleIsInNextFieldLookBehindShouldReturnFalse;
    procedure IfFacingSouthAndNoObstacleIsInNextFieldLookBehindShouldReturnFalse;
    procedure IfFacingWestAndNoObstacleIsInNextFieldLookBehindShouldReturnFalse;

    procedure IfFacingNorthAndAnObstacleIsInNextFieldLookAheadShouldReturnTrue;
    procedure IfFacingEastAndAnObstacleIsInNextFieldLookAheadShouldReturnTrue;
    procedure IfFacingSouthAndAnObstacleIsInNextFieldLookAheadShouldReturnTrue;
    procedure IfFacingWestAndAnObstacleIsInNextFieldLookAheadShouldReturnTrue;

    procedure IfFacingNorthAndAnObstacleIsInNextFieldLookBehindShouldReturnTrue;
    procedure IfFacingEastAndAnObstacleIsInNextFieldLookBehindShouldReturnTrue;
    procedure IfFacingSouthAndAnObstacleIsInNextFieldLookBehindShouldReturnTrue;
    procedure IfFacingWestAndAnObstacleIsInNextFieldLookBehindShouldReturnTrue;
  end;


implementation

uses
  Types;

procedure TMarsRoverLookaheadTest.IfFacingNorthAndNoObstacleIsInNextFieldLookAheadShouldReturnFalse;
begin
  SetRoverDirection(NORTH);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  CheckFalse(MarsRover.IsObstacleAhead);
end;

procedure TMarsRoverLookaheadTest.IfFacingEastAndNoObstacleIsInNextFieldLookAheadShouldReturnFalse;
begin
  SetRoverDirection(EAST);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  CheckFalse(MarsRover.IsObstacleAhead);
end;

procedure TMarsRoverLookaheadTest.IfFacingSouthAndNoObstacleIsInNextFieldLookAheadShouldReturnFalse;
begin
  SetRoverDirection(SOUTH);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  CheckFalse(MarsRover.IsObstacleAhead);
end;

procedure TMarsRoverLookaheadTest.IfFacingWestAndNoObstacleIsInNextFieldLookAheadShouldReturnFalse;
begin
  SetRoverDirection(WEST);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  CheckFalse(MarsRover.IsObstacleAhead);
end;

procedure TMarsRoverLookaheadTest.IfFacingNorthAndNoObstacleIsInNextFieldLookBehindShouldReturnFalse;
begin
  SetRoverDirection(NORTH);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  CheckFalse(MarsRover.IsObstacleBehind);
end;

procedure TMarsRoverLookaheadTest.IfFacingEastAndNoObstacleIsInNextFieldLookBehindShouldReturnFalse;
begin
  SetRoverDirection(EAST);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  CheckFalse(MarsRover.IsObstacleBehind);
end;

procedure TMarsRoverLookaheadTest.IfFacingSouthAndNoObstacleIsInNextFieldLookBehindShouldReturnFalse;
begin
  SetRoverDirection(SOUTH);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  CheckFalse(MarsRover.IsObstacleBehind);
end;

procedure TMarsRoverLookaheadTest.IfFacingWestAndNoObstacleIsInNextFieldLookBehindShouldReturnFalse;
begin
  SetRoverDirection(WEST);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  CheckFalse(MarsRover.IsObstacleBehind);
end;

procedure TMarsRoverLookaheadTest.IfFacingNorthAndAnObstacleIsInNextFieldLookAheadShouldReturnTrue;
begin
  SetRoverDirection(NORTH);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  Grid.SetObstacleAt(GRID_TEST_POS_X, GRID_TEST_POS_Y + 1);
  CheckTrue(MarsRover.IsObstacleAhead);
end;

procedure TMarsRoverLookaheadTest.IfFacingEastAndAnObstacleIsInNextFieldLookAheadShouldReturnTrue;
begin
  SetRoverDirection(EAST);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  Grid.SetObstacleAt(GRID_TEST_POS_X + 1, GRID_TEST_POS_Y);
  CheckTrue(MarsRover.IsObstacleAhead);
end;

procedure TMarsRoverLookaheadTest.IfFacingSouthAndAnObstacleIsInNextFieldLookAheadShouldReturnTrue;
begin
  SetRoverDirection(SOUTH);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  Grid.SetObstacleAt(GRID_TEST_POS_X, GRID_TEST_POS_Y - 1);
  CheckTrue(MarsRover.IsObstacleAhead);
end;

procedure TMarsRoverLookaheadTest.IfFacingWestAndAnObstacleIsInNextFieldLookAheadShouldReturnTrue;
begin
  SetRoverDirection(WEST);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  Grid.SetObstacleAt(GRID_TEST_POS_X - 1, GRID_TEST_POS_Y);
  CheckTrue(MarsRover.IsObstacleAhead);
end;

procedure TMarsRoverLookaheadTest.IfFacingNorthAndAnObstacleIsInNextFieldLookBehindShouldReturnTrue;
begin
  SetRoverDirection(NORTH);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  Grid.SetObstacleAt(GRID_TEST_POS_X, GRID_TEST_POS_Y - 1);
  CheckTrue(MarsRover.IsObstacleBehind);
end;

procedure TMarsRoverLookaheadTest.IfFacingEastAndAnObstacleIsInNextFieldLookBehindShouldReturnTrue;
begin
  SetRoverDirection(EAST);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  Grid.SetObstacleAt(GRID_TEST_POS_X - 1, GRID_TEST_POS_Y);
  CheckTrue(MarsRover.IsObstacleBehind);
end;

procedure TMarsRoverLookaheadTest.IfFacingSouthAndAnObstacleIsInNextFieldLookBehindShouldReturnTrue;
begin
  SetRoverDirection(SOUTH);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  Grid.SetObstacleAt(GRID_TEST_POS_X, GRID_TEST_POS_Y + 1);
  CheckTrue(MarsRover.IsObstacleBehind);
end;

procedure TMarsRoverLookaheadTest.IfFacingWestAndAnObstacleIsInNextFieldLookBehindShouldReturnTrue;
begin
  SetRoverDirection(WEST);
  SetRoverPosition(Point(GRID_TEST_POS_X, GRID_TEST_POS_Y));
  Grid.SetObstacleAt(GRID_TEST_POS_X + 1, GRID_TEST_POS_Y);
  CheckTrue(MarsRover.IsObstacleBehind);
end;

initialization
  RegisterTest(TMarsRoverLookaheadTest.Suite);
end.
