unit TestMarsRoverController;

interface

uses
  TestFramework,
  Types,
  Generics.Collections,
  SysUtils,
  TestMarsRoverBase,
  uMarsRover;

type
  TMarsRoverControllerTest = class(TMarsRoverBase)
  strict private
    FController: IMarsRoverController;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMoveCommandsWithoutObstacles;
    procedure TestMoveCommandsWithObstacles;
    procedure TestTurnCommands;
    procedure TestTurnRight;
    procedure TestTurnLeft;
    procedure TestBadCommand;
  end;

implementation

type
  TCommandTest = record
    Command: string;
    InitialPosition: TPoint; InitialDirection: TDirection;
    ExpectedPosition: TPoint; ExpectedDirection: TDirection;
  end;

procedure TMarsRoverControllerTest.SetUp;
begin
  inherited;
  FController := TMarsRoverController.Create(MarsRover);
end;

procedure TMarsRoverControllerTest.TearDown;
begin
  FController := nil;
end;

procedure TMarsRoverControllerTest.TestMoveCommandsWithoutObstacles;
const
  TESTS: array [0..9] of TCommandTest = (
    (Command: 'ffrff';
       InitialPosition: (X: MIN_X; Y: MIN_Y); InitialDirection: NORTH;
       ExpectedPosition: (X: MIN_X + 2; Y: MIN_Y + 2); ExpectedDirection: EAST),
    (Command: 'fflff';
       InitialPosition: (X: MIN_X; Y: MAX_Y); InitialDirection: SOUTH;
       ExpectedPosition: (X: MIN_X + 2; Y: MAX_Y - 2); ExpectedDirection: EAST),
    (Command: 'bf';
       InitialPosition: (X: MIN_X; Y: MIN_Y); InitialDirection: NORTH;
       ExpectedPosition: (X: MIN_X; Y: MIN_Y); ExpectedDirection: NORTH),
    (Command: 'frfrfrfr';
       InitialPosition: (X: MIN_X; Y: MIN_Y); InitialDirection: NORTH;
       ExpectedPosition: (X: MIN_X; Y: MIN_Y); ExpectedDirection: NORTH),
    (Command: 'flflflfl';
       InitialPosition: (X: MIN_X; Y: MIN_Y); InitialDirection: NORTH;
       ExpectedPosition: (X: MIN_X; Y: MIN_Y); ExpectedDirection: NORTH),
    (Command: 'brbrbrbr';
       InitialPosition: (X: MIN_X; Y: MIN_Y); InitialDirection: NORTH;
       ExpectedPosition: (X: MIN_X; Y: MIN_Y); ExpectedDirection: NORTH),
    (Command: 'blblblbl';
       InitialPosition: (X: MIN_X; Y: MIN_Y); InitialDirection: NORTH;
       ExpectedPosition: (X: MIN_X; Y: MIN_Y); ExpectedDirection: NORTH),
    (Command: 'f';
       InitialPosition: (X: MIN_X; Y: MAX_Y); InitialDirection: NORTH;
       ExpectedPosition: (X: MIN_X; Y: MIN_Y); ExpectedDirection: NORTH),
    (Command: 'ff';
       InitialPosition: (X: MIN_X; Y: MAX_Y); InitialDirection: NORTH;
       ExpectedPosition: (X: MIN_X; Y: MIN_Y + 1); ExpectedDirection: NORTH),
    (Command: 'ffff';
       InitialPosition: (X: MIN_X; Y: MAX_Y - 2); InitialDirection: NORTH;
       ExpectedPosition: (X: MIN_X; Y: MIN_Y + 1); ExpectedDirection: NORTH)
  );
var
  test: TCommandTest;
begin
  for test in TESTS do
  begin
    SetPositionAndDirection(
      test.InitialPosition.X,
      test.InitialPosition.Y,
      test.InitialDirection);

    CheckTrue(FController.ExecuteCommands(test.Command), test.Command);

    CheckPositionAndDirection(
      test.ExpectedPosition.X,
      test.ExpectedPosition.Y,
      test.ExpectedDirection,
      test.Command);

    CheckEqualsString('', FController.LastError);
  end;
end;

procedure TMarsRoverControllerTest.TestTurnCommands;
begin
  CheckTrue(FController.ExecuteCommands('lr'), 'lr');
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
end;

procedure TMarsRoverControllerTest.TestTurnRight;
begin
  CheckTrue(FController.ExecuteCommands('r'), 'r NORTH -> EAST');
  CheckPositionAndDirection(MIN_X, MIN_Y, EAST);
  CheckEqualsString('', FController.LastError);
  CheckTrue(FController.ExecuteCommands('r'), 'r EAST -> SOUTH');
  CheckPositionAndDirection(MIN_X, MIN_Y, SOUTH);
  CheckEqualsString('', FController.LastError);
  CheckTrue(FController.ExecuteCommands('r'), 'r SOUTH -> WEST');
  CheckPositionAndDirection(MIN_X, MIN_Y, WEST);
  CheckEqualsString('', FController.LastError);
  CheckTrue(FController.ExecuteCommands('r'), 'r WEST -> NORTH');
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
  CheckEqualsString('', FController.LastError);
  CheckTrue(FController.ExecuteCommands('rrrr'), 'rrrr');
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
  CheckEqualsString('', FController.LastError);
end;

procedure TMarsRoverControllerTest.TestTurnLeft;
begin
  CheckTrue(FController.ExecuteCommands('l'), 'l NORTH -> WEST');
  CheckPositionAndDirection(MIN_X, MIN_Y, WEST);
  CheckEqualsString('', FController.LastError);
  CheckTrue(FController.ExecuteCommands('l'), 'l WEST -> SOUTH');
  CheckPositionAndDirection(MIN_X, MIN_Y, SOUTH);
  CheckEqualsString('', FController.LastError);
  CheckTrue(FController.ExecuteCommands('l'), 'l SOUTH -> EAST');
  CheckPositionAndDirection(MIN_X, MIN_Y, EAST);
  CheckEqualsString('', FController.LastError);
  CheckTrue(FController.ExecuteCommands('l'), 'l EAST -> NORTH');
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
  CheckEqualsString('', FController.LastError);
  CheckTrue(FController.ExecuteCommands('llll'), 'llll');
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
  CheckEqualsString('', FController.LastError);
end;

procedure TMarsRoverControllerTest.TestBadCommand;
begin
  CheckFalse(FController.ExecuteCommands('kkkk'));
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
end;

procedure TMarsRoverControllerTest.TestMoveCommandsWithObstacles;
begin
  Grid.SetObstacleAt(MIN_X, MIN_Y + 2);
  CheckFalse(FController.ExecuteCommands('ffff'));
  CheckPositionAndDirection(MIN_X, MIN_Y + 1, NORTH);
  CheckEqualsString(
    Format('Could not move forward: Obstacle ahead. Current Position: %d/%d, facing North', [MIN_X, MIN_Y + 1]),
    FController.LastError
  );

  CheckFalse(FController.ExecuteCommands('rfflflff'));
  CheckPositionAndDirection(MIN_X + 1, MIN_Y + 2, WEST);
  CheckEqualsString(
    Format('Could not move forward: Obstacle ahead. Current Position: %d/%d, facing West', [MIN_X + 1, MIN_Y + 2]),
    FController.LastError
  );
end;

initialization
  RegisterTest(TMarsRoverControllerTest.Suite);
end.

