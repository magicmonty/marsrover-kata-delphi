unit TestMarsRoverTurning;

interface

uses
  TestFramework,
  TestMarsRoverBase,
  uMarsRover;

type
  TMarsRoverTurningTest = class(TMarsRoverBase)
  strict private
    procedure CheckTurnRight(const ABeforeTurn, AExpectedAfterTurn: TDirection);
    procedure CheckTurnLeft(const ABeforeTurn, AExpectedAfterTurn: TDirection);
  published
    procedure IfDirectionIsNorthAndTurnedRightTheDirectionShouldBeEast;
    procedure IfDirectionIsEastAndTurnedRightTheDirectionShouldBeSouth;
    procedure IfDirectionIsSouthAndTurnedRightTheDirectionShouldBeWest;
    procedure IfDirectionIsWestAndTurnedRightTheDirectionShouldBeNorth;

    procedure IfDirectionIsNorthAndTurnedLeftTheDirectionShouldBeWest;
    procedure IfDirectionIsEastAndTurnedLeftTheDirectionShouldBeNorth;
    procedure IfDirectionIsSouthAndTurnedLeftTheDirectionShouldBeEast;
    procedure IfDirectionIsWestAndTurnedLeftTheDirectionShouldBeSouth;
  end;

implementation

uses
  Types;

procedure TMarsRoverTurningTest.IfDirectionIsNorthAndTurnedRightTheDirectionShouldBeEast;
begin
  CheckTurnRight(NORTH, EAST);
end;

procedure TMarsRoverTurningTest.IfDirectionIsEastAndTurnedRightTheDirectionShouldBeSouth;
begin
  CheckTurnRight(EAST, SOUTH);
end;

procedure TMarsRoverTurningTest.IfDirectionIsSouthAndTurnedRightTheDirectionShouldBeWest;
begin
  CheckTurnRight(SOUTH, WEST);
end;

procedure TMarsRoverTurningTest.IfDirectionIsWestAndTurnedRightTheDirectionShouldBeNorth;
begin
  CheckTurnRight(WEST, NORTH);
end;

procedure TMarsRoverTurningTest.IfDirectionIsNorthAndTurnedLeftTheDirectionShouldBeWest;
begin
  CheckTurnLeft(NORTH, WEST);
end;

procedure TMarsRoverTurningTest.IfDirectionIsEastAndTurnedLeftTheDirectionShouldBeNorth;
begin
  CheckTurnLeft(EAST, NORTH);
end;

procedure TMarsRoverTurningTest.IfDirectionIsSouthAndTurnedLeftTheDirectionShouldBeEast;
begin
  CheckTurnLeft(SOUTH, EAST);
end;

procedure TMarsRoverTurningTest.IfDirectionIsWestAndTurnedLeftTheDirectionShouldBeSouth;
begin
  CheckTurnLeft(WEST, SOUTH);
end;

procedure TMarsRoverTurningTest.CheckTurnLeft(const ABeforeTurn,
  AExpectedAfterTurn: TDirection);
begin
  SetRoverDirection(ABeforeTurn);
  MarsRover.TurnLeft;
  CheckDirectionEquals(AExpectedAfterTurn);
end;

procedure TMarsRoverTurningTest.CheckTurnRight(
  const ABeforeTurn, AExpectedAfterTurn: TDirection);
begin
  SetRoverDirection(ABeforeTurn);
  MarsRover.TurnRight;
  CheckDirectionEquals(AExpectedAfterTurn);
end;

initialization
  RegisterTest(TMarsRoverTurningTest.Suite);
end.
