--CHECKLISTE

/*

Security
gemischt oder nur Windows Auth
wenn gemischt, dann: sa deaktiviert -- Ersatzkonto
SA - nicht löschen



RAM (nur der Datenpuffer gemeint)
MAX RAM= Garantie für andere (OS..)
MIN RAM= 0, weils nix bringt


CPU
MAXDOP = Anzahl der Kerne, aber nicht mehr als 8
gilt pro Abfrage

HDD
DB besteht aus 2 DAteien: .mdf (daten)   .ldf (log)
Trenne die beiden physikalisch (mehrere HDDs)

Volumewartungstask --Lokalen Sicherheitsrichtlinien -- zuweisen von Benutzerechten
aktivieren

Durchführen von Volumewartungsaufgaben
Mit dieser Sicherheitseinstellung wird festgelegt, welche Benutzer und Gruppen Wartungsaufgaben auf einem Volume ausführen können, zum Beispiel eine Remotedefragmentierung.
Gehen Sie beim Zuweisen dieses Benutzerrechts vorsichtig vor. Benutzer mit diesem Benutzerrecht können Datenträger durchsuchen und Dateien in den Speicher erweitern, der andere Daten enthält. Wenn die erweiterten Dateien geöffnet werden, kann der Benutzer möglicherweise die so erlangten Daten lesen und ändern.
Standardwert: Administratoren

TempDB
Eigene HDDs
Trenne Log von Daten
Anzahl der Datendateien: = Anzahl der Kerne , aber nicht mehr als 8
-Traceflags 1117 / 1118

--DB Settings

Startgrößen  Akt Größe freier Platz
Automatisch: Statistiken erstellen /aktulaisiert

SystemDBs regelmäßig sichern--> Wartungsplan






























*/