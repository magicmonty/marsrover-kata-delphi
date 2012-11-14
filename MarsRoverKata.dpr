program MarsRoverKata;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  XmlTestRunner in 'XmlTestRunner.pas',
  TestMarsRover in 'TestMarsRover.pas',
  uMarsRover in 'uMarsRover.pas';

{$R *.RES}

begin
  if IsConsole then
    XmlTestRunner.RunTestsAndClose
  else
    GUITestRunner.RunRegisteredTests;
end.

