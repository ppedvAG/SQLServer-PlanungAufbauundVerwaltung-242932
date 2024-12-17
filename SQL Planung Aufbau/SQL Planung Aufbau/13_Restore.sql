--Unser Kurs---



--Backup/Restore



/* Varianten

V ollständige Sicherung
1. Checkpoint  11:45
2. Sicherung aller Seiten, Größe der Dateien und Pfade
ein Zeitpunkt


D ifferentielle Sicherung
sichert alle Blöcke weg in denen sich seit der letzte V Sicherung etwas geändert
ein Zeitpunkt


T ransakt.prot Sicherung
merkt sich den Weg , wie Daten geändert wurden
kann auf Sek einen Restore organisieren

 Orig : 100
 +1
 *4
 -10
 +4
 -6
 +123
 ...


!V
	T
	T
	T
D
	T
	T
	T
!D
!	T
!	T (alle 15min)
!	T 11:00

Was ist der kürzeste Restore?
V
--> mach so oft es geht V Sicherungen

Wie lange dauert der Restore des vorletzten T? in min ca
dauert so lange, wie die TX im realen Leben dauerten (max 15min)

D verkürzt dramtiksch den Restore

V TTTTTTTTTTTTTTTTTTTTTTTTTDTTT







--RecoveryModel

Einfach
TX werden nach Commit entfernt. Tlog leert sich automatisch
--> keine Sicherung des Tlog
--> wird weniger protokolliert Bulk nur rudimentär


Massenprotkolliert
wie einfach, aber es wird nichts gelöscht
--> Log muss gesichert werden. 
--> man kann mit Hilfe des Log restoren

!! Nur die Sicherung des TLog leert das Tlog


Vollständig
wird mehr protokolliert
--wächst stärker 
---> man kann auf Sekunde restoren

---ProduktivDB sollten immer Voll (kommt von model)



/*
WAS KANN PASSIEREN */ --RecovModel=Full 

1. Fall
User manipuliert versehentlich Daten (falsch)

Idee: a) Restore der letzten Sicherung vor der Änderung
      b) Restore der DB  unter anderen Namen 




2. Fall
DB weist Fehler auf (Integrität verletzt, Fehlerverdächtig)
ZUgriff nicht mehr möglich

Idee: Restore der Db, Reperatur scheitert

3. Fall
Server tot inkl HDDs

Idee: Restore auf anderen Server (Pfade, Login)


4. Fall
Server tot aber HDDs leben . Datendateien sind noch vorhanden
Server tot aber HDDs leben . Nur Datendatei ist vorhanden / Log ist weg
Server tot aber HDDs leben . Nur Log ist vorhanden / Datendatei ist weg

Idee: kein Restore , sondern Dateien an SQL Prozeß anhängen



5. Fall
Wenn ich wüsste , dass gleich was passieren kann...

Idee: keine reguläre Sicherung

*/














--Fall 1
USE [master]
RESTORE DATABASE [Northwind1100] FROM  DISK = N'C:\_SQLBACKUP\nw.bak' WITH  FILE = 2,  MOVE N'Northwind' TO N'C:\_SQLDATA\northwnd.mdf',  MOVE N'Northwind_log' TO N'C:\_SQLLDF\northwnd.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Northwind1100] FROM  DISK = N'C:\_SQLBACKUP\nw.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind1100] FROM  DISK = N'C:\_SQLBACKUP\nw.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind1100] FROM  DISK = N'C:\_SQLBACKUP\nw.bak' WITH  FILE = 12,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind1100] FROM  DISK = N'C:\_SQLBACKUP\nw.bak' WITH  FILE = 13,  NOUNLOAD,  STATS = 5

GO


--FALL 3: Restore auf denen Server

--Kopiere das Backup dorthin, wo der SQL Server seine Backup erwartet!
--auf Server XY
USE [master]
RESTORE DATABASE [Northwind] FROM  DISK = N'C:\_SQLBACKUPHR\nw.bak' WITH  FILE = 2,  MOVE N'Northwind' TO N'C:\_SQLDB\northwnd.mdf',  MOVE N'Northwind_log' TO N'C:\_SQLDB\northwnd.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Northwind] FROM  DISK = N'C:\_SQLBACKUPHR\nw.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'C:\_SQLBACKUPHR\nw.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'C:\_SQLBACKUPHR\nw.bak' WITH  FILE = 12,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Northwind] FROM  DISK = N'C:\_SQLBACKUPHR\nw.bak' WITH  FILE = 13,  NOUNLOAD,  STATS = 5

GO


--Fall 4: Dateien vorhanden 
USE [master]
GO
CREATE DATABASE [Northwind] ON 
( FILENAME = N'C:\_SQLDB\northwnd.mdf' ),
( FILENAME = N'C:\_SQLDB\northwnd.ldf' )
 FOR ATTACH
GO

--Fall 4 : Logfile fehlt -- Datenverlust 
USE [master]
GO
CREATE DATABASE [Northwind] ON 
( FILENAME = N'C:\_SQLDB\northwnd.mdf' )
 FOR ATTACH
GO

--Fall 4: mdf Datei weg -- Logfile vorhanden--schlecht



--Fall 1-- restore der DB direkt

--Letztes Back 10:30 T
--T Sicherung jede Stunde: 11:30
--Meldung: Problem Daten manipuliert 11:13
--bitte Db restoren mit geringstmöglichen Datenverlust (11:12)



--Idee: Restore 10:30--Datenverlust 44min

--Idee: wir warten auf 11:30 und dann resore bis auf 11:12  
--DV : 18min


--Idee: wir sicherung um 11:14 T und dann restore von 11:12
--DV:  2min


--Sind sicherungen online?--> Ja
--Was wäre, wenn das TLog Backup ca 10min dauern würde
--Der Verlust ist eigtl größer, weil online Backup online
--und neue TX (Daten) nicht erfasst..




--besser: ohne DV


--Idee: Wir werfen die Leute runter keine neuen Datenänderungen
--erstaml kein Datenverlust.. weil alle DAten in der DB bzw im Backup
--


--------------------TSQL  aus anderem Kurs.. aber gleiche Fälle



---RESTORE
--Fall 3 :  jemand manipuliert versehentlich Daten
--DB restoren, aber unter anderern Namen.
--Wenn man die Chance und die Infos besitzt, die versehentlich veränderten
--Daten zu korrigieren...
--Korrektur per TSQL



--11:31 problem .. wann ... 11:29 (9Uhr)
--Workaround: unter einen anderen Namen restoren
--und anschlissend per TSQL irgendwie die Daten korrigieren in der OrgDB

--V letzte D und alle nachfolgenden Ts

USE [master]
RESTORE DATABASE [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 1,  MOVE N'Kurs2014DB' TO N'D:\_SQLDB\Kurs2014DBxxALT.mdf',  MOVE N'Kurs2014DB_log' TO N'D:\_SQLDB\Kurs2014DBAxxLT_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5

GO


--FALL 6: DB fehlerverdächtig.. Sie 
--muss zum letztmöglichen Zeitpukt restored werden



--möglichst ohne Datenverlust:
--V  D TTT

--Restore geht nur wenn keine Verbidungen auf der DB sind..


/*
alle Verbindungen schliessen.. Aktivitätsmonitr oder Kill Prozessnummer
Backup LOG
restore V
Restore D
Restore aller Ts.  (Zeitpunkt 11:27:39
--jetzt 11:50 ..also würde alles, was seit 11:27 I U D war weg sein...


jetzt nochmal einen T Sicherung 11:50:00
Restore von 11:34:13

Protokollfragment= der ungesichterte teil des Logfiles



*/

--Retsore ohne Datenverlust
--Allerdings sind neuere Daten im Backup und nicht in der DB..
--Die Fragmentsicherung sichert vor dem Restore automatisch den Teil des
--Protokolls, der noch nicht gesichert wurde...

USE [master]
ALTER DATABASE [Kurs2014DB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
BACKUP LOG [Kurs2014DB] TO  DISK = N'D:\_BACKUP\Kurs2014DB_LogBackup_2021-02-23_11-54-09.bak' WITH NOFORMAT, NOINIT,  NAME = N'Kurs2014DB_LogBackup_2021-02-23_11-54-09', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5
ALTER DATABASE [Kurs2014DB] SET MULTI_USER

GO


USE [master]
GO
ALTER DATABASE [KursDB] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'KursDB'
GO

-----Fall 1---------------------------------------
--Wenn das Logfile weg oder defekt ist
USE [master]
GO
CREATE DATABASE [KursDB] ON 
( FILENAME = N'D:\_SQLDB\KursDB.mdf' )
 FOR ATTACH
GO

USE [master]
GO
CREATE DATABASE [KursDB] ON 
( FILENAME = N'D:\_SQLDB\KursDB.mdf' ),
( FILENAME = N'D:\_SQLDB\KursDB_log.ldf' )
 FOR ATTACH
GO

--resore aus Backup auf anderen server
USE [master]
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 1,  MOVE N'Kurs2014DB' TO N'D:\_HRDB\Kurs2014DB.mdf',  MOVE N'Kurs2014DB_log' TO N'D:\_HRDB\Kurs2014DB_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5

GO


--Fall 5: Wir wissen, dass etwas gleich passieren kann
--SP Installation


--der Snapshot kopiert Seiten vor Änderungen in die Snapshotdatei
USE master
GO

-- Create the database snapshot..nur lesbar, daher keine Tlog
CREATE DATABASE SN_KursDb2014_1330 ON
(	NAME = Kurs2014DB, --logischer Dateiname der OriginalDB
	FILENAME = 'D:\_SQLDB\SN_KursDb2014_1330.mdf' )--der Name der Datendatei des Snapshot
AS SNAPSHOT OF Kurs2014DB;
GO

--Mit Hilfe des Snapshot wollen wir Restoren

--1: Alle User müssen von der SnapshotDB runter
---- und auch von der OrigDB

use master -- am besten selbst nicht auf einer der DB sein;-)
select * from sysprocesses where dbid in (DB_ID('northwind'),db_id('snnwind')
KILL 72
KILL 77


--dauert 1 Sekunde....Obwohl die DB 1 GB groß war....!!
restore database Kurs2014DB
from database_snapshot='SN_KursDb2014_1330'

--es ersetzt keine normale Sicherung...

--man kann nur den Zeitpunkt restoren, zu dem man den Snapshot machte

--Kann man einen Snapshot sichern.. ?
--Nein

--Kann man eine DB sichern, die einen Snapshot besitzt.. ?
--Ja klar

--Kann man einen Snapshot restoren?
--Hä?  Ohne Sicherung kein restore .. 


--Kann man einen DB  restoren, die einen Snapshot besitzt?
--Leider nein, aber falls alle Snapshots gelöscht werden, geht auch der Restore wieder
--Ein Snapshot kann keine Garantie haben, was die Lebensdauer betrifft
--EIN DB kann aber durchaus mehrer Snapshots haben

--Wie kann User von der DB werfen...
--aber sollte man das so tun...? ;-)

USE [master]
GO
ALTER DATABASE Kurs2014DB SET  MULTI_USER WITH NO_WAIT
GO

select * from sysprocesses where dbid = db_id('Kurs2014DB')


--NUR DIE SICHERUNG DES TLOGS LEERT DAS TLOG!!!!!!!!

---ALSO Sicherungsstrategie

--20 GB
--Arbeitszeiten: Mo bis Fr  7 Uhr  bis 18 Uhr
--DB Ausfallszeit: 30min (Reaktionszeit+Restorezeit)
--Maximaler Verlust in Zeit ausgedrückt  15min

--Was wäre , wenn Verlust in Zeit = 0 sein soll==> Hochverfügbarkeit (Cluster, Spiegeln, AVG))
--Was wäre, wenn ich das mit dderDB zeitlich hinbringe

/*
V  jeden Tag     (Mo bis Fr) abends um 19
D  alle 4 T oder eben jede Stunde (Mo bis Fr 8:20  - bis 18:20)
T  alle 15min nur Mo bis Fr (7:15 - 18:15)


Sicherungsintegrität, Prüfsummen bei Fehler fortsetzen

*/



-----BACKUP

/*

Vollständige V
Diffrentielle D
Transaktionspro T


Recoverymodel Wiederherstellungsmodel (model)

---------------------------
TXok  TXok TXok TXx TXok
--------------------------


Einfach
INS UP DEL rudim bulk
TX werden autom gelöscht
keine Sicherung des T
rel wenig protokolliert
TestDB Dev Server


Massenprotokoll
wie Einfach
es werden keine TX gelöscht
dsa T muss gesichert werden
TX werden "herausgesichert"
sichert einen Zeitpunkt




Vollständig
wie bulk aber auch IX Stat
im Prinzp alles aus Lesen
-- Restore auf Sekunde
Produktive DB



!V
	T
	T
	T
D
	T
	T
	T
!D
!	T
!	T
!	T

Volls
alles zu einem best Zeitpunkt
Pfade, Dateiname, Größe

Diff 
sichert alle geänderten Blöcke seit des letzten V

Tlog
merkt sich den Weg (TX)

Welche Sicherung stellt den schnellsten Restore dar
V


Wie lange dauert der Restore des vorletzten T
Solange wie die TX im realfall benötigten


Was kann passieren?

1) DB gelöscht

2) Daten(user weg) versehentlich manipuliert
..wenn man weiss, was geschehen ist
DB restore unter anderen Namen
Pfade oder Dateinamen ändern
Fragmentsicherung deaktiveren


3) Server tot - HDD nicht 
	Dateien anfügen
	evtl Log entfernen, wenn ldf fehlt

4) Server tot -Daten ok , aber log tot

5) Server komplett tot
Backup Restore auf  anderen Server
evtl Pfade anpassen

6) DB fehlerverdächtig
	Rep scheitert-- DB restoren


7) wenn ich wüsste, dass gleich was passieren könnte

select * from sysfiles


update customers set city = 'BGH'
where customerid = 'ALFKI'

8) DB muss restored werden mit geringst möglichen DAtenverlust	
	DB läuft noch aber evtl DAtenmanipuliert 




8:00
10:15 T letzte Sicherung

10:45  Error
10:47 Ein Fehler wird gemeldet -- Restore der DB

11:00 T geplant (dauert 5min)


--warten auf 11 Uhr, dann restore von 10:44

--Datenverlust?


10:48 Backup T -- 10:53

10:48 kill user
10:44 Restore und ersetzen















