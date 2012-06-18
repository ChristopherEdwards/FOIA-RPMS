PXRMPCIN ; SLC/PKR - Computed findings for primary care info. ;01/18/2000
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;
 ;=======================================================================
PROVIDER(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for a patient's
 ;primary care provider. Value is the name which is the .01 node
 ;of file #200 the NEW PERSON file.
 N PP
 S DATE=DT
 S PP=$P($$OUTPTPR^SDUTL3(DFN,DT),U,2)
 I PP="" S TEST=0
 E  D
 . S TEST=1
 . S VALUE=PP
 Q
 ;
 ;=======================================================================
TEAM(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding for a patient's primary
 ;care team. Value is the name which is the .01 node
 ;of file 404.51 the TEAM file.
 N PT
 S DATE=DT
 S PT=$P($$OUTPTTM^SDUTL3(DFN,DT),U,2)
 I PT="" S TEST=0
 E  D
 . S TEST=1
 . S VALUE=PT
 Q
 ;
