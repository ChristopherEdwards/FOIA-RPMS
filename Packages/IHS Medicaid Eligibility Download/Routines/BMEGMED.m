BMEGMED ; IHS/PHXAO/TMJ - UNIX GENERIC FILE READER ; 
 ;;1.0T1;MEDICAID ELIGIBILITY DOWNLOAD;;JUN 25, 2003
 ;
 ;
 ;This Reader Routine works on Cache, NT, or Unix
 ;It Calls OPEN^%ZISH to read file
 ;It Call STATUS^%ZISH to quit at End of File
 ;
 ;This Routine Reads the AHCCCS Medicaid Eligibility Roster Unix File
 ;Then sets a Monthly Temporary Global - ^BMEGMED(
 ;The Routine ^BMEMED $ORDERS through this Global and Populates
 ;The Monthly Temporary No Match File, the RPMS Master File, and
 ;The RPMS MEDICAID ELIGIBILITY FILE
 ;
MAIN ; --  this is the main program loop
 S BMEERROR=0
 S BMEBTIME=0,BMEETIME=0,BMEUTIME=0
 D ^XBKVAR
 K ^BMEGMED
 D BMEG I BMEERROR=1 G END
 S BMEBTIME=$$NOW^XLFDT
 D OPENBMEG
 D END
 S BMEETIME=$$NOW^XLFDT
 S BMEUTIME=BMEETIME-BMEBTIME
 Q
 ;
BMEG ; -- this sets up the device and sets the file name
 S BMELSTN="" ;Last Log IEN # for Last File processed
 S BMELSTNM="" ;Actual File Name in Log
 S BMELSTN=$P($G(^BMEMEDLG(0)),U,3)
 I BMELSTN="" G FIRST
 S BMELSTNM=$P($G(^BMEMEDLG(BMELSTN,0)),U,8)
 I BMELSTNM="" W !!,"Last File Name does NOT exist in Log.  Contact Site Manager!" S BMEERROR=1 Q
 D PROCESS Q
 ;
FIRST ;FILENAME FOR 1ST TIME RUN AT FACILTY - HARD CODED
 ;
 I BMELSTN="" S BMEFILE="MED062003.TXT" D FIRST1 Q
 ;
PROCESS ;Process file here
 S BMEMM=$E(BMELSTNM,4,5) S BMEYY=$E(BMELSTNM,6,9)
 S BMEMM=BMEMM+1 I BMEMM>12 S BMEYY=BMEYY+1,BMEMM="01"
 I $L(BMEMM)=1 S BMEMM="0"_BMEMM
 S NEXTFDT=BMEMM_BMEYY
 S BMEFILE="MED"_NEXTFDT_".TXT"
 ;Q
 ;
FIRST1 ;Called from First
 S PATH="c:\inetpub\ftproot\pub\" ;**Hard Code this line at each Site NT or Unix**
 ;
 Q
 ;
 ;
OPENBMEG ; -- this uses the device and reads in the records from the file
 ;
 D OPEN^%ZISH("AHCCCS",PATH,BMEFILE,"R")
 I POP U IO(0) W !,"Can't open Host File Server" Q
 U IO(0) W !,"Reading this file",!
 ;
 ;
 F BMEGI=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X Q:$$STATUS^%ZISH
 .Q:"01^XX"'[$E(X,1,2)   ;*** TESTING - AEF *** 3031002 - QUIT IF NOT A DATA RECORD
 .S ^BMEGMED(BMEGI)=$E(X,1,420)
 Q
END ; -- close the device here a kill variables
 S BMEGITOT=BMEGI-2
 ;W !,"Total Records Processed: "_BMEGITOT
 D ^%ZISC
 K BMEGI,%FN,BMEGPTR,BMEGX,PATH,X
 Q
