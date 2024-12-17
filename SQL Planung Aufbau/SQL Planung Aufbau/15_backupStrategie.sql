

--Wie würden wir eine Sicherung machen


--Größe der DB: 10 GB
--Wie lange darf die DB/Server ausfallen: 1h
--Wieviel Datenverlust darf man max in Zeit erleiden?: 15min 

--Arbeitszeit: Mo bis  Fr
--             6:00 - 21:00



--Vollsicherung:
jeden Tag ausser Sa/So  22 Uhr

--Tlogsicherung
-- alle 15min Mo bis Fr 6:15 -- 21:00


--Different
--jede 1h (alle 4 Tlog) Mo bis Fr ab 7:10   bis 20:10


--Wie würden wir eine Sicherung machen


--Größe der DB: 2000 GB
--Wie lange darf die DB/Server ausfallen: 30min
--Wieviel Datenverlust darf man max in Zeit erleiden?: 15min 

--Hochverfügbarkeit ein muss, da der Restore in der Zeit nicht schaffbar sein wird

--Sicherung V 1mal pro Woche evtl
--D 1 Stunde
--T alle 15 min




--Wie sichern wir ?

/*
Wie lange darf der Server bzw die DB ausfallen in Zeit?

Wie groß dar der Datenverlust in Zeit sein?


DB Größe: 350 GB
7:00 - 17:00
Mo bis FR

select 350000/500/60

Stillstandzeit: gar nicht -->HADR Hochverfügbarkeit (ent)
			    ab 30min per Restore machbar

Datenverlust:   0 --> HADR (ent)
			    15min 



Vollsicherung:
Dauer liegt bei etwa 10 bis 20 min---< 200GB Backupfile
so oft wie möglich

Täglich ausser Sa und So um 19:15



TLogsicherung
Mo bis Fr alle 15Min , aber ab 7:15 bis 17:15


Diff
alle  4 Tlogsicherung eine D



--Jetzt testen?

