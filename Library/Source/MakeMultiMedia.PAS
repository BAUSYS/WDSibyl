Program makeMultiMedia;

{ Compilier-Reihenfolge
  MakeRTL		(Src_RTL+Src_RTL_OS+Src_RC)
  MakeTP70		(Src_RTL+Src_TP70)
  MakeSPCC		(Src_SPCC)
  MakeDB		(Src_DB)
  MakeCompnt		(Src_Compnt)
  MakeDialog		(Src_Dialog)
  MakeInternet		(Src_Inter)
  MakeMultiMedia	(Src_MM)
  MakeRest		(Src_TP70)

  MakeIDE		(?)
}

Uses uMediaPlayer,
     uMMDevices,
     MMedia,
     OpenGL,
     uDart;

begin
end.


{ -- date -- -- from -- -- changes ----------------------------------------------
  05-Jul-04  WD         Erstellung des Projektes.
  11-Nov-05  WD         Die Unit uDart ins Projekt aufgenommen
  26-Apr-20  RG         optisch
  
}

