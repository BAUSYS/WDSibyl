Unit myDrawGrid;

Interface

Uses
  Classes, Forms, Grids;

{Deklariere neue Klasse}
Type
  TmyDrawGrid=Class(TDrawGrid)
  Protected
    Procedure SetupComponent; Override;
  Public
    Destructor Destroy; Override;
  End;

{Zu exportierende Komponenten definieren}
{Sie kînnen eine Seite der Komponentenpalette und eine Bitmapdatei fÅr die Komponente angeben}
Exports
  TmyDrawGrid,'BAUSYS','';

Implementation

Procedure TmyDrawGrid.SetupComponent;
Begin
  Inherited SetupComponent;
End;

Destructor TmyDrawGrid.Destroy;
Begin
  Inherited Destroy;
End;

Initialization
  {Klassen registrieren}
  RegisterClasses([TmyDrawGrid]);
End.

