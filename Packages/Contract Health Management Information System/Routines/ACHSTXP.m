ACHSTXP ; IHS/ITSC/FCJ - 4 YR. EXPORT STAT DATA ;  [ 11/09/2004  3:31 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**11**;June 11,2001
 ;IHS/ITSC/FCJ ACHS*3.1*11 9.17.04 NEW ROUTINE FOR EXPORT OF DATA FR
 ;  OCT 1,2000 THRU SEPT 30, 2004 ORIGINAL RTN ACHSTX
 ;
 I '$$LOCK^ACHS("^ACHSF(DUZ(2),""D"")","+") W *7,!! W:$$DIR^XBDIR("E","CHS DATA ENTRY IN PROGRESS -- JOB CANCELLED - <RETURN> TO CONTINUE") "" G KILL^ACHSTX8
 D ^ACHSVAR
 S ACHSRCT=0,ACHSREEX=0
L2 ;
 W !!,"Export data from October 1, 2000 thru September 30,2004 will be made for ",!,$$LOC^ACHS
 G END:'$$DIR^XBDIR("Y","Is this Correct (Y/N) ","YES","","Export data will be made for "_$$LOC^ACHS,"",2)
 G END:$D(DUOUT)!$D(DTOUT)
 I $$EXFILE D  I '$$DIR^XBDIR("Y","Continue","N","","","^D HELP^ACHS(""FILEHELP"",""ACHSTX"")",1) G END
 . W !!,*7
 . D HELP^ACHS("FILEHELP","ACHSTX")
 .Q
 ;NOTE SHOULD NOT STORE THE FOUR YEAR EXPORT
 ;K DIC,X,Y
 ;S DIC="^ACHSTXST("_DUZ(2)_",1,",DIC(0)="Z",X=DT
 ;D ^DIC
 ;K DIC,X
 ;I Y>0,$P(Y(0),U,10)="N" G ^ACHSTXTT
 S ACHSARCO=$P(^ACHSF(DUZ(2),0),U,11)
 I '(ACHSARCO?3UN) U IO(0) W *7,!!,"Area Contracting Number is not 3 Upper-case Alpha-Numerics",!,"JOB CANCELLED" G ERROR ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 U IO(0)
 S ACHSCRTN=""
L3 ;
 S ACHSMDAT=$$DTAO
 G END:$D(DUOUT)!$D(DTOUT)
 ;
 K %ZIS,ACHSPPC,ACHSPPO
 ;
 S %ZIS("A")="ENTER OUTPUT REPORT DEVICE # ",%ZIS="P"
 W !
 D ^%ZIS
 G END:POP
 I $D(IO("S")) D SLV^ACHSFU
 S ACHSIO=IO,ACHSION=ION
 D ^%ZISC,HOME^%ZIS
 ;
 D ^ACHSTXP2
 Q
 ;
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
 . ;2/25/02  pmf  changes for cache
 . ;I $$KILLOK^ZIBGCHAR($P(ACHS,U,2)) W !,$$ERR^ZIBGCHAR($$KILLOK^ZIBGCHAR($P(ACHS,U,2)))
 . ;K @ACHS
 . S @(ACHS_"(0)")=""
 . S ACHSG=ACHS_"(0)" F  S ACHSG=$Q(@ACHSG) Q:ACHSG=""  K @ACHSG
 . Q
 K ACHSG
 Q
 ;
DTAO() ;EP - Prompt for date sent to Area Office.
 Q $$DIR^XBDIR("D^"_DT_":"_$$HTFM^XLFDT($H+5),"ENTER DATE SENT TO AREA OFFICE ","T")
 ;
ERROR ;EP.
 X:$D(ACHSPCC) ACHSPPC
 U IO(0)
 W !!,*7,*7,*7,"AN ERROR HAS OCCURRED DURING EXPORT PLEASE NOTIFY AREA OFFICE "
 D ^%ZISC
 G JOBABEND^ACHSTX8
 ;
END ;
 W !!?10,"JOB TERMINATED BY OPERATOR"
 G JOBABEND^ACHSTX8
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
