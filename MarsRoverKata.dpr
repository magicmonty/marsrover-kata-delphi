program MarsRoverKata;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  XmlTestRunner in 'XmlTestRunner.pas',
  TestMarsRoverTurning in 'TestMarsRoverTurning.pas',
  uMarsRover in 'uMarsRover.pas',
  TestMarsRoverMoving in 'TestMarsRoverMoving.pas',
  TestMarsRoverBase in 'TestMarsRoverBase.pas',
  TestMarsRoverLookahead in 'TestMarsRoverLookahead.pas',
  TestMarsRoverController in 'TestMarsRoverController.pas';

{$R *.RES}

begin
  if IsConsole then
    XmlTestRunner.RunTestsAndClose
  else
    GUITestRunner.RunRegisteredTests;
end.

