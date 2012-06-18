BMEMLOAD ; IHS/PHXAO/TMJ - LOAD THE MEDICAID FILE DRIVER ROUTINE ; 
 ;;1.0T1;MEDICAID ELIGIBILITY DOWNLOAD;;JUN 25, 2003
 ;
MAIN ; -- this is the main program loop    
 ;This Routine runs either the Flat File 560 Routines
 ;or the 834 Transaction Routines
 ;
 ;The Site Parameter Global BMEPARM Determines the Type of Run
 ;based upon Field #.03 Type of Transaction
 ;If Type = F Flat File 560 - Runs BMEMED and BMEMED0
 ;If Type = 8 834 Transaction - Runs BME834 and BME8340
 ;The Fall Off Routines runs independently of Type
 ;
 S BMEQUIT=0 ;Quit Variable to NOT run 834 Transaction
 ;
TYPE ;Determine the type of Run
 ;
 S BMEFIEN=$O(^BMEPARM("B",DUZ(2),0)) ;Get Facility IEN
 Q:'BMEFIEN  ;Quit if No Facility Entry in Site Parameter
 S BMETYPE=$P($G(^BMEPARM(BMEFIEN,0)),U,3) ; Get Type
 ;
 Q:BMETYPE=""
 I BMETYPE="F" D FLATFILE
 I BMETYPE=8 D TRAN834
 D END
 Q
 ;
FLATFILE ;Run the Download from the Unix Flat File
 D UNIX
 D UPLOAD
 D FALLOFF
 D END
 Q
 ;
 ;
TRAN834 ;Run the Download from the 834 Transaction/GIS
 D P834
 D LOAD834
 D FALLOFF
 D END
 Q
 ;
 ;
UNIX ;Reads the Unix AHCCCS Elig. Roster to ^BMEGMED(GLOBAL
 ;This Global is Killed off each month at time of new run
 ;
 D ^BMEGMED
 Q
 ;
UPLOAD ;Upload Eligibility Data to RPMS From ^BMEGMED(GLOBAL
 ;Creates Monthly Temporary No Match File ^BMETMED(GLOBAL
 ;This Temporary File is Killed off each month at time of new run
 ;Populates RPMS Master Elig. File ^BMEMSTR(GLOBAL
 ;
 ;Check to make sure a complete Unit File has been read
 ;& the ^BMEGMED( Global has completed to the final record
 ;The last Record in Global should match the 20-24 position
 ;for record count (Plus One).  Quit if incomplete ^BMEGMED
 ;Global is created.
 ;^BMEGMED(60167)=XX200105019999980006016600000000000
 ;
 S BMELASTR=$O(^BMEGMED(""),-1) ;Get Last Record
 S BMELASTD=$E(^BMEGMED(BMELASTR),20,24) ;Get Pos 20-24
 S BMELASTD=BMELASTD+1 ;Add one count for check
 I BMELASTR'=BMELASTD W !!,"Incomplete Global",! Q  ;Quit if incomplete
 ;
 D ^BMEMED
 Q
 ;
FALLOFF ;Run the Eligibility Fall Off Patients
 ;This Routine runs through the RPMS Master File and provides
 ;a List of Pts (who were Eligible the previous Month's Run)
 ;but are not included in the current Month's Roster
 ;Populates the RPMS Master Elig. File with Fall Off Date
 ;
 I BMEQUIT'=1 D ^BMEMFALL
 Q
 ;
 ;
MSG ;Message Displays - Don't Use on TaskMan
 ;Would utilize only if User Ran Process
 ;W !!,"Finished loading the State of Arizona Medicaid File"
 ;W !!,"Now uploading the State information into the RPMS database..."
 ;Q
 ;
 ;
P834 ;Process the 834 Transaction load from GIS
 ;THIS ROUTINE HAS NOT BEEN WRITTEN.  It should take the
 ;834 data from the GIS and Populate the BME MEDICAID HOLDING
 ;File - Global ^BMEHOLD.  Once populated, the Holding File
 ;Global will be utilized to run the ^BME834 Routine which
 ;conducts the Actual Download of Data into the RPMS Files
 ;
 ;Will want to call Routine BHLXRFL and pass in
 ;XMSG = Message 834
 ;DIR = Directory for the File
 ;PRE = 834* 
 ;XTF = Test or Production
 ;
 ;
 ;Quit as GIS is not Available yet
 S BMEQUIT=1
 ;
 Q
 ;
LOAD834 ;Upload the Eligibility Data to RPMS from the Holding
 ;File Global ^BMEHOLD(
 ;This Temporary Holding File is killed off each month for
 ;the new run - The BMEMSTR(Global is also populated
 ;
 I BMEQUIT'=1 D ^BME834 ;Run Only if GIS is now programmed
 Q
 ;
END ; -- write the final message
 ;W !!,"Finished, uploading the medicaid information into RPMS"
 ;W !!,"The new information is in the RPMS database"
 ;Q
 ;
 K BMEFIEN,BMETYPE
 Q
