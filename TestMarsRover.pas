unit TestMarsRover;

interface

uses
  TestFramework,
  uMarsRover;

type
  TMarsRoverTest = class(TTestCase)
  strict private
    FMarsRover: TMarsRover;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMarsRover;
  end;

implementation

{ TMarsRoverTest }

procedure TMarsRoverTest.Setup;
begin
  FMarsRover := TMarsRover.Create;
end;

procedure TMarsRoverTest.TearDown;
begin
  FMarsRover.Free;
end;

procedure TMarsRoverTest.TestMarsRover;
begin

end;

initialization
  RegisterTest('', TMarsRoverTest.Suite);
end.
