--CHECKLISTE

/*

Security
gemischt oder nur Windows Auth
wenn gemischt, dann: sa deaktiviert -- Ersatzkonto
SA - nicht l�schen



RAM (nur der Datenpuffer gemeint)
MAX RAM= Garantie f�r andere (OS..)
MIN RAM= 0, weils nix bringt


CPU
MAXDOP = Anzahl der Kerne, aber nicht mehr als 8
gilt pro Abfrage

HDD
DB besteht aus 2 DAteien: .mdf (daten)   .ldf (log)
Trenne die beiden physikalisch (mehrere HDDs)

Volumewartungstask --Lokalen Sicherheitsrichtlinien -- zuweisen von Benutzerechten
aktivieren

Durchf�hren von Volumewartungsaufgaben
Mit dieser Sicherheitseinstellung wird festgelegt, welche Benutzer und Gruppen Wartungsaufgaben auf einem Volume ausf�hren k�nnen, zum Beispiel eine Remotedefragmentierung.
Gehen Sie beim Zuweisen dieses Benutzerrechts vorsichtig vor. Benutzer mit diesem Benutzerrecht k�nnen Datentr�ger durchsuchen und Dateien in den Speicher erweitern, der andere Daten enth�lt. Wenn die erweiterten Dateien ge�ffnet werden, kann der Benutzer m�glicherweise die so erlangten Daten lesen und �ndern.
Standardwert: Administratoren

TempDB
Eigene HDDs
Trenne Log von Daten
Anzahl der Datendateien: = Anzahl der Kerne , aber nicht mehr als 8
-Traceflags 1117 / 1118

--DB Settings

Startgr��en  Akt Gr��e freier Platz
Automatisch: Statistiken erstellen /aktulaisiert

SystemDBs regelm��ig sichern--> Wartungsplan






























*/