---Virtualisierung


/* Ausstattung

16 GB

4 log Prozessoren

Gesamt - 4 GB (wg HyperV)--> 12 GB


				RAM				KERNE
HV-DC          1500-2000				1
HV-SQL1			6000 (fix)			4
HV-SQL2         4000 (fix)			4


NUMA

64GB  -- SQL Server 50GB
------------------------------------
		S1 S2				S3 S4


SOCKEL1	K1  K2     Sockel 2 KA  KB
		K3  K4				KC  KD
------------------------------------



VM
64GB  -- SQL Server 64B-- woher weiss die VM, welche Kerne optimalerweise verwendet werden?

------------------------------------
		S1 S2				


		K1  KA    
		K3  KC				
------------------------------------



Vorsicht beim Kopieren / Migrieren von VMs--> Hardwareausstattung steckt in KonfigFiles
--die nun evtl nicht mehr stimmt

* NUMA ) Zuordnung der Sockets zu Slots




C:\_SQLDBS\
C:\_SQLDBS\
C:\BACKUP


