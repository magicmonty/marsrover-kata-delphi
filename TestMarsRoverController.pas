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
  end;

implementation

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
begin
  CheckTrue(FController.ExecuteCommands('ffrff'), 'ffrff');
  CheckPositionAndDirection(2, 2, EAST);
  CheckEqualsString('', FController.LastError);

  SetPositionAndDirection(MIN_X, MAX_Y, SOUTH);
  CheckTrue(FController.ExecuteCommands('fflff'), 'fflff');
  CheckPositionAndDirection(2, MAX_Y - 2, EAST);
  CheckEqualsString('', FController.LastError);

  SetPositionAndDirection(MIN_X, MIN_Y, NORTH);
  CheckTrue(FController.ExecuteCommands('bf'), 'bf');
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
  CheckEqualsString('', FController.LastError);

  CheckTrue(FController.ExecuteCommands('frfrfrfr'), 'frfrfrfr');
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
  CheckEqualsString('', FController.LastError);

  CheckTrue(FController.ExecuteCommands('flflflfl'), 'flflflfl');
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
  CheckEqualsString('', FController.LastError);

  CheckTrue(FController.ExecuteCommands('brbrbrbr'), 'brbrbrbr');
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
  CheckEqualsString('', FController.LastError);

  CheckTrue(FController.ExecuteCommands('blblblbl'), 'blblblbl');
  CheckPositionAndDirection(MIN_X, MIN_Y, NORTH);
  CheckEqualsString('', FController.LastError);
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

