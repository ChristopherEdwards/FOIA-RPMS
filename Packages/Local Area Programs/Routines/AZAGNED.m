BMEGNED ; IHS/PHXAO/TMJ - UNIX GENERIC FILE READER ; [ 06/11/03  3:25 PM ]
 ;1.0;BME MEDICAID UTILITIES;NOVEMBER 12, 2003
 ;
 ;
 ;This Reader Routine works on Cache, NT, or Unix
 ;It Calls OPEN^%ZISH to read file
 ;It Call STATUS^%ZISH to quit at End of File
 ;
 ;This Routine Reads the AHCCCS Medicaid Eligibility Roster Unix File
 ;Then sets a Monthly Temporary Global - ^AZAGMED(
 ;The Routine ^AZAMED $ORDERS through this Global and Populates
 ;The Monthly Temporary No Match File, the RPMS Master File, and
 ;The RPMS MEDICAID ELIGIBILITY FILE
 ;
MAIN ; --  this is the main program loop
 S AZAERROR=0
 S BEGTIME=0,ENDTIME=0,UNIXTIME=0
 D ^XBKVAR
 K ^AZAGMED
 D AZAG I AZAERROR=1 G END
 S BEGTIME=$$NOW^XLFDT
 D OPENAZAG
 D END
 S ENDTIME=$$NOW^XLFDT
 S UNIXTIME=ENDTIME-BEGTIME
 Q
 ;
AZAG ; -- this sets up the device and sets the file name
 S AZALSTN="" ;Last Log IEN # for Last File processed
 S AZALSTNM="" ;Actual File Name in Log
 S AZALSTN=$P($G(^AZAMEDLG(0)),U,3)
 I AZALSTN="" G FIRST
 S AZALSTNM=$P($G(^AZAMEDLG(AZALSTN,0)),U,8)
 I AZALSTNM="" W !!,"Last File Name does NOT exist in Log.  Contact Site Manager!" S AZAERROR=1 Q
 D PROCESS Q
 ;
FIRST ;FILENAME FOR 1ST TIME RUN AT FACILTY - HARD CODED
 ;
 I AZALSTN="" S FILE="MED012001.TXT" D FIRST1 Q
 ;
PROCESS ;Process file here
 S MM=$E(AZALSTNM,4,5) S YY=$E(AZALSTNM,6,9)
 S MM=MM+1 I MM>12 S YY=YY+1,MM="01"
 I $L(MM)=1 S MM="0"_MM
 S NEXTFDT=MM_YY
 S FILE="MED"_NEXTFDT_".TXT"
 ;Q
 ;
FIRST1 ;Called from First
 S PATH="c:\inetpub\ftproot\pub\" ;**Hard Code this line at each Site NT or Unix**
 ;
 Q
 ;
 ;
OPENAZAG ; -- this uses the device and reads in the records from the file
 ;
 D OPEN^%ZISH("AHCCCS",PATH,FILE,"R")
 I POP U IO(0) W !,"Can't open Host File Server" Q
 U IO(0) W !,"Reading this file",!
 ;
 ;
 F AZAGI=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X Q:$$STATUS^%ZISH
 .S ^AZAGMED(AZAGI)=$E(X,1,420)
 Q
END ; -- close the device here a kill variables
 S AZAGITOT=AZAGI-2
 ;W !,"Total Records Processed: "_AZAGITOT
 D ^%ZISC
 K AZAGI,%FN,AZAGPTR,AZAGX,PATH,X
 Q
