ACHSTXIT ; IHS/ITSC/PMF - EXPORT DATA (1/9) ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 ; This is the lead program of the export process.  You
 ;start here if you are exporting or REexporting
 ;
 ; In this program, we go through a whole series of checks,
 ;any one of which may stop the process or redirect it.  If
 ;the program flow gets to the just above the first tag, then
 ;we are going to list POs to report on.
 ;
 ;
 ;if this is a 638 facility, ask them if they want to
 ;run a check first.  If so, do it and quit
 I $$PARM^ACHS(0,8)="Y" Q:$$STATCHK
 ;
 ;if the docs are locked, say so and quit
 I '$$LOCK^ACHS("^ACHSF(DUZ(2),""D"")","+") W *7,!! W:$$DIR^XBDIR("E","CHS DATA ENTRY IN PROGRESS -- JOB CANCELLED - <RETURN> TO CONTINUE") "" G KILL^ACHSTX8
 ;get vars
 D INIT
 ;
 ;verify the facility
 D  I 'OK D END Q
 .W !!,"Export data will be made for ",$$LOC^ACHS
 .S OK=$$DIR^XBDIR("Y","Is this Correct (Y/N) ","YES","","Export data will be made for "_$$LOC^ACHS,"",2)
 .I $D(DUOUT)!$D(DTOUT) S OK=0
 .Q
 ;
 ;if an export file already exists for today,
 ;  tell them about it
 ;  explain the consequences
 ;  ask them if they are sure
 I $$EXFILE D  I 'OK D END Q
 . W !!,*7
 . D HELP^ACHS("FILEHELP","ACHSTX")
 . S OK='$$DIR^XBDIR("Y","Continue","N","","","^D HELP^ACHS(""FILEHELP"",""ACHSTX"")",1)
 . Q
 ;
 ;
 ;check to see if there is a record of exporting today.
 K DIC,X,Y
 S DIC="^ACHSTXST("_DUZ(2)_",1,",DIC(0)="Z",X=DT
 D ^DIC
 K DIC,X
 ;
 ;if an export happened today, and the tape save failed,
 ;  go off and do it again
 I Y>0,$P(Y(0),U,10)="N" G ^ACHSTXTT
 ;
 ;if an export happened today, and we are not REexporting,
 ;  say so and quit
 I 'ACHSREEX,$D(^ACHSTXST("C",DT,DUZ(2))) G TXFEF^ACHSTX8
 ;
 ;get the area accounting number.  if it doesn't look right,
 ;  say so and quit
 S ACHSARCO=$P(^ACHSF(DUZ(2),0),U,11)
 ;I +ACHSARCO<1!($L(ACHSARCO)'=3) U IO(0) W *7,!!,"MISSING AREA CONTRACTING NUMBER - JOB CANCELLED" G ERROR ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 I '(ACHSARCO?3UN) U IO(0) W *7,!!,"Area Contracting Number is not 3 Upper-case Alpha-Numerics",!,"JOB CANCELLED" G ERROR ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 ;
 ;
 ;set the date for export.  when is it not today?
 S ACHSMDAT=$$DIR^XBDIR("D^"_DT_":"_$$HTFM^XLFDT($H+5),"ENTER DATE SENT TO AREA OFFICE ","T")
 I $D(DUOUT)!$D(DTOUT) D END Q
 ;
 ;set device to report to
 K %ZIS
 S %ZIS("A")="ENTER OUTPUT REPORT DEVICE # ",%ZIS="P"
 W !
 D ^%ZIS
 ;
 ;if getting or opening the device failed, stop
 I POP D END Q
 ;
 I $D(IO("S")) D SLV^ACHSFU
 ;
 S ACHSIO=IO
 ;
 ;close the device until later
 D ^%ZISC,HOME^%ZIS
 ;
 ;MADE IT this far?  now go get the POs to report on, and export them
 D ^ACHSTX22
 Q
 ;
 ;END of main program, start of sub routines
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
ERROR ;EP.
 X:$D(ACHSPPC) ACHSPPC
 U IO(0)
 W !!,*7,*7,*7,"AN ERROR HAS OCCURRED DURING EXPORT PLEASE NOTIFY AREA OFFICE "
 D ^%ZISC
 G JOBABEND^ACHSTX8
 ;
END ;
 W !!?10,"JOB TERMINATED BY OPERATOR"
 G JOBABEND^ACHSTX8
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
INIT ;
 ;get vars
 D ^ACHSVAR
 ;
 S ACHSRCT=0,ACHSCRTN=""
 ;
 Q
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
