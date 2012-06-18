BMENLOAD ; IHS/PHXAO/TMJ - AZAM LOAD THE MEDICAID FILE DRIVER ROUTINE ; [ 06/11/03  3:36 PM ]
 ;1.0; AREA MEDICAID UTILITIES;February 14, 2001
 ;
MAIN ; -- this is the main program loop    
 ;
UNIX ;Reads the Unix AHCCCS Elig. Roster to ^AZAGMED(GLOBAL
 ;This Global is Killed off each month at time of new run
 ;
 D ^AZAGNED
 ;
 ;
UPLOAD ;Upload Eligibility Data to RPMS From ^AZAGMED(GLOBAL
 ;Creates Monthly Temporary No Match File ^AZAMED(GLOBAL
 ;This Temporary File is Killed off each month at time of new run
 ;Populates RPMS Master Elig. File ^AZAMSTR(GLOBAL
 ;
 ;Check to make sure a complete Unit File has been read
 ;& the ^AZAGMED( Global has completed to the final record
 ;The last Record in Global should match the 20-24 position
 ;for record count (Plus One).  Quit if incomplete ^AZAGMED
 ;Global is created.
 ;^AZAGMED(60167)=XX200105019999980006016600000000000
 ;
 S LASTREC=$O(^AZAGMED(""),-1) ;Get Last Record
 S LASTDATA=$E(^AZAGMED(LASTREC),20,24) ;Get Pos 20-24
 S LASTDATA=LASTDATA+1 ;Add one count for check
 I LASTREC'=LASTDATA W !!,"Incomplete Global",! Q  ;Quit if incomplete
 ;
 D ^AZANED
 ;
 ;
FALLOFF ;Run the Eligibility Fall Off Patients
 ;This Routine runs through the RPMS Master File and provides
 ;a List of Pts (who were Eligible the previous Month's Run)
 ;but are not included in the current Month's Roster
 ;Populates the RPMS Master Elig. File with Fall Off Date
 ;
 D ^AZANFALL
 ;
 ;
 ;
 ;End of Process Kill off Variables
 Q
 ;
 ;
MSG ;Message Displays - Don't Use on TaskMan
 ;Would utilize only if User Ran Process
 ;W !!,"Finished loading the State of Arizona Medicaid File"
 ;W !!,"Now uploading the State information into the RPMS database..."
 ;D ^AZAMED
 ;Q
 ;
END ; -- write the final message
 ;W !!,"Finished, uploading the medicaid information into RPMS"
 ;W !!,"The new information is in the RPMS database"
 ;Q
