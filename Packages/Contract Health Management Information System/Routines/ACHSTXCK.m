ACHSTXCK ; IHS/ITSC/PMF - EXPORT DATA  [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - Keep test routine up to date.
 ; this is the pre-export check list routine.
 ; we do a whole series of things to prepare for exporting,
 ; most of which may cause us to stop.
 ;
 ;OUTPUT:
 ;    STOP       0 if not stopping
 ;               1 if stopping and there is nothing else to do
 ;               2 if stopping and !!!!!
 ;
 ;if this is a 638, ask them if they want to check the data
 ;if they do, do it and stop
 I ACHSF638 S STOP=$$STATCHK I STOP Q
 ;
 ;if anybody is fiddling with the POs and has them locked,
 ;   say so and stop
 S STOP='$$LOCK^ACHS("^ACHSF(DUZ(2),""D"")","+") I STOP W *7,!! W:$$DIR^XBDIR("E","CHS DATA ENTRY IN PROGRESS -- JOB CANCELLED - <RETURN> TO CONTINUE") "" Q
 ;
 ;verify the facility
 W !!,"Export data will be made for ",$$LOC^ACHS
 S STOP='$$DIR^XBDIR("Y","Is this Correct (Y/N) ","YES","","Export data will be made for "_$$LOC^ACHS,"",2) I $D(DUOUT)!$D(DTOUT) S STOP=1
 I STOP Q
 ;
 ;if an export file for today already exists,
 ;   tell them so and ask if the y want to continue
 I $$EXFILE D  S STOP='$$DIR^XBDIR("Y","Continue","N","","","^D HELP^ACHS(""FILEHELP"",""ACHSTX"")",1) I STOP Q
 . W !!,*7
 . D HELP^ACHS("FILEHELP","ACHSTX")
 .Q
 ;
 ;if not REEXporting, and export was done today, say so and stop
 I 'ACHSREEX,$D(^ACHSTXST("C",DT,DUZ(2))) W !!,"EXPORT PROGRAM ALREADY RUN THIS DATE FOR THIS FACILITY",*7 S STOP=1 Q
 ;
 ;fetch the area contracting number and verify it
 S ACHSARCO=$P(^ACHSF(DUZ(2),0),U,11)
 ;I +ACHSARCO<1!($L(ACHSARCO)'=3) U IO(0) W *7,!!,"MISSING AREA CONTRACTING NUMBER - JOB CANCELLED" S STOP=1 Q;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 I '(ACHSARCO?3UN) U IO(0) W *7,!!,"Area Contracting Number is not 3 Upper-case Alpha-Numerics",!,"JOB CANCELLED" S STOP=1 Q  ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 ;
 ;get the date
 S ACHSMDAT=$$DTAO I $D(DUOUT)!$D(DTOUT) S STOP=1 Q
 ;
 ;clean up the work globals
 D KILLGLBS
 ;
 ;get the device for the report
 K %ZIS S %ZIS("A")="ENTER OUTPUT REPORT DEVICE # ",%ZIS="P" W !
 D ^%ZIS
 I POP S STOP=1 Q
 ;
 ;if it's a slave printer, set it up
 I $D(IO("S")) D SLV^ACHSFU
 S ACHSIO=IO
 D ^%ZISC,HOME^%ZIS
 ;
 Q
 ;
KILLGLBS ;EP - Kill unsubscripted work globals.
 ; ^ACHSDATA( - DHR (REC #2)
 ; ^ACHSTXPT( - Holds Patients to be exported. (Rec # 3)
 ; ^ACHSTXVN( - Holds Vendor IENs to be exported. (Rec # 4)
 ; ^ACHSTXOB( - Holds Document/Transaction to be exported. (Rec # 5)
 ; ^ACHSTXPD( - Holds Paid Doc info to be exported to Area Office. (Rec # 6)
 ; ^ACHSTXPG( - Holds Docs with statistical info to be exported to Data Center. (Rec # 7)
 ;
 N ACHS
 F ACHS="^ACHSDATA","^ACHSTXPT","^ACHSTXVN","^ACHSTXOB","^ACHSTXPD","^ACHSTXPG" D
 . W !,"Resetting ",ACHS,"(0)"
 . I $$KILLOK^ZIBGCHAR($P(ACHS,U,2)) W !,$$ERR^ZIBGCHAR($$KILLOK^ZIBGCHAR($P(ACHS,U,2)))
 . K @ACHS
 . S @(ACHS_"(0)")=""
 .Q
 Q
 ;
DTAO() ;EP - Prompt for date sent to Area Office.
 Q $$DIR^XBDIR("D^"_DT_":"_$$HTFM^XLFDT($H+5),"ENTER DATE SENT TO AREA OFFICE ","T")
 ;
STATCHK() ; Check 638 stat data prior to export.
 D HELP^ACHSTX7X
 I $$DIR^XBDIR("Y","Run pre-export data check first","YES","","","^D HELP^ACHSTX7X",2) D ^ACHSTX7X Q 1
 Q 0
 ;
EXFILE() ; Does export file exist?
 NEW X,Y,Z
 S Y=$$ASF^ACHS(DUZ(2))
 I $$OS^ACHS=2 S Y=$E(Y,3,6)
 S Y="ACHS"_Y_"."_$$JDT^ACHS(DT)
 I $$LIST^%ZISH($$EX^ACHS,Y,.X)
 S Z=""
 F  S Z=$O(X(Z)) Q:'Z  I X(Z)=Y Q
 Q $S('Z:0,1:1)
 ;
FILEHELP ;EP -  ?? help text, from ACHS via DIR.
 ;;
 ;;     ***   AN EXPORT FILE FOR TODAY ALREADY EXISTS   ***
 ;;
 ;;An export file already exists in your export directory for today.
 ;;You will overwrite the file if you continue.  If the file was
 ;;correctly generated, the data in the file will be lost.  If you
 ;;are certain that the data in the file was incorrectly generated,
 ;;then proceed, forewarned.
 ;;
 ;;###
