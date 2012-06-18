BWLETPR ;IHS/ANMC/MWR -  BW PRINT LETTERS.  [ 06/06/99  8:10 AM ];15-Feb-2003 21:56;PLS
 ;;2.0;WOMEN'S HEALTH;**6,8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALLED BY OPTION: "BW PRINT INDIVIDUAL LETTERS" TO PRINT A
 ;;  LETTER FOR A SINGLE INDIVIDUAL (AS OPPOSED TO ALL THOSE QUEUED).
 ;;IHS/CMI/LAB PATCHED AT LINE LABELS SELECT AND NONE.  PATCH 6
 ;
 ;/IHS/ANMC/DLG 21JUN2002  I haven't found who/what sets IOF = null,
 ; but somehow it's happening and it's causing SYNTAX errors.  I slapped bandaids here & there.
 D SETVARS^BWUTL5 S (BWPOP1,BWPOP)=0
 N BWDA,BWTITLE
 F  S BWPOP=0 D  Q:BWPOP1
 .D SELECT Q:BWPOP
 .D DEVICE Q:BWPOP
 .S BWCRT=$S($E(IOST)="C":1,1:0)
 .D PRINT
 D ^%ZISC
 ;
EXIT ;EP
 D KILLALL^BWUTL8
 Q
 ;
SELECT ;EP
 ;---> SELECT PATIENT, THEN SELECT NOTIFICATION.
 ;N DIC,Y                                               ;IHS/CMI/LAB
 N BWNAM,DIC,X,Y                                        ;IHS/CMI/LAB
 D TITLE^BWUTL5("PRINT INDIVIDUAL PATIENT LETTERS")
 D PATLKUP^BWUTL8(.Y)
 I Y<0 S (BWPOP,BWPOP1)=1 Q
 S BWDFN=+Y,BWNAM=$$NAME^BWUTL1(BWDFN)
 ;---> On some systems DIC lookup needs to be by name   ;IHS/CMI/LAB
 ;---> rather than by DFN.                              ;IHS/CMI/LAB
 ;D DIC^BWFMAN(9002086.4,"EM",.Y,"","","",BWDFN,.BWPOP) ;IHS/CMI/LAB
 D DIC^BWFMAN(9002086.4,"EM",.Y,"","","",BWNAM,.BWPOP)  ;IHS/CMI/LAB
 I $D(DUOUT)!($D(DTOUT)) S BWPOP=1 Q
 I Y<0 D NONE S BWPOP=1 Q
 S BWDA=+Y
 ;
 ;---> IF FACILITIES OF LETTER AND USER DON'T MATCH, QUIT.
 N BWFACIL S BWFACIL=$P(^BWNOT(BWDA,0),U,7)
 I ((BWFACIL'=DUZ(2))&(BWFACIL)) D TEXT1,DIRZ^BWUTL3 S BWPOP=1 Q
 ;
 S BWPURP=$P(^BWNOT(BWDA,0),U,4)
 S BWTYPE=$P(^BWNOT(BWDA,0),U,3)
 ;
 ;---> CHECK IF PURPOSE HAS BEEN ENTERED.
 I 'BWPURP D  Q
 .W !!?5,"No Purpose has been entered for this Notification."
 .D DIRZ^BWUTL3 S BWPOP=1 Q
 ;
 ;---> CHECK IF THIS PURPOSE OF NOTIFICATION HAS A LETTER.
 I '$D(^BWNOTP(BWPURP,1,0)) D  Q
 .W !!!?5,"No letter has been entered for this Purpose of Notification."
 .W !?5,"Programmer information: Notification=^BWNOT("_BWDA_",0)."
 .W !?5,"                         Purpose IEN=",BWPURP
 .W !?5,"                         Patient IEN=",BWDFN
 .D DIRZ^BWUTL3 S BWPOP=1 Q
 ;
 ;---> CHECK IF TYPE OF NOTIFICATION FOR THIS NOTIFICATION IS PRINTABLE.
 I 'BWTYPE D CANTPRT Q
 I '$P(^BWNOTT(BWTYPE,0),U,2) D CANTPRT Q
 Q
 ;
CANTPRT ;EP
 ;---> CAN'T PRINT THIS NOTIFICATION.
 W !!?5,"This Type of Notification"
 W:BWTYPE ", ",$P(^BWNOTT(BWTYPE,0),U),"," W " is not printable."
 D DIRZ^BWUTL3 S BWPOP=1
 Q
 ;
DEVICE ;EP
 ;---> GET DEVICE AND POSSIBLY QUEUE TO TASKMAN.
 K %ZIS,IOP
 S ZTRTN="PRINT^BWLETPR",ZTSAVE("BWDA")=""
 D ZIS^BWUTL2(.BWPOP,1)
 Q
 ;
PRINT ;EP
 ;---> REQUIRED VARIABLE: BWDA=IEN IN ^BWNOT, ION=DEVICE
 ;---> NEXT LINE: IOP WILL INHIBIT ^DIWF FROM PROMPTING FOR DEVICE.
 D SETVARS^BWUTL5
 N BWDFN,BWPURP,IOP,BWIRAD,BWPDATE ;IHS/CMI/LAB patch 6 added 2 vars
 S IOP=ION
 ;---> IF FACILITIES OF LETTER AND USER DON'T MATCH, QUIT (IF NULL, OK).
 N BWFACIL S BWFACIL=$P(^BWNOT(BWDA,0),U,7)
 I ((BWFACIL'=DUZ(2))&(BWFACIL)) D TEXT1 H 5 S BWPOP=1 Q
 ;
 S BWDFN=$P(^BWNOT(BWDA,0),U)
 S BWPURP=$P(^BWNOT(BWDA,0),U,4)
 S BWIRAD=$P(^BWNOT(BWDA,0),U,6) I BWIRAD S BWIRAD=$P(^BWPCD(BWIRAD,0),U,35) ;IHS/CMI/LAB - patch 6
 S BWPDATE=$P(^BWNOT(BWDA,0),U,6) I BWPDATE S BWPDATE=$P(^BWPCD(BWPDATE,0),U,12) I BWPDATE]"" S BWPDATE=$$FMTE^XLFDT(BWPDATE) ;IHS/CMI/LAB - patch 6
 ;---> BWN=DATE OF "PRINT DATE", USE TO KILL "APRT" XREF BELOW.
 S:'$D(BWKDT) BWKDT=$P(^BWNOT(BWDA,0),U,11)
 ;---> IF NO PURPOSE (DELETED), KILL "APRT" XREF AND QUIT.
 I 'BWPURP D  Q
 .W !!?5,"No Purpose of Notification has been chosen; therefore, this"
 .W !?5,"notification cannot be printed."
 .D KILLXREF(BWDA,BWKDT)
 ;---> IF QUEUED AND BWCRT IS NOT SET, THEN SET IT.
 S:'$D(BWCRT) BWCRT=$S($E(IOST)="C":1,1:0)
 S DIWF="^BWNOTP(BWPURP,1,"
 S DIWF(1)=9002086
 S BY="INTERNAL(#.01)="_BWDFN
 ;/IHS/ANMC/DLG 21JUN2002  sometimes IOF is null.
 ;S:'BWCRT DIOEND="W @IOF"
 S:'BWCRT DIOEND=$S(IOF]"":"W @IOF",1:"W #")
 ;/DLG
 ;---> IF LOCKED, PROMPT DEVICE, QUIT AND LEAVE IN THE QUEUE.
 L +^BWNOT(BWDA):0 I '$T U IO D  D PROMPT Q
 .W !!?5,"The selected Notification is being edited by another user."
 .W !?5,"Programmer information: Notification=^BWNOT("_BWDA_",0)."
 .;/IHS/ANMC/DLG 21JUN2002  sometimes IOF is null
 .;W:'BWCRT @IOF
 .W:('BWCRT)&(IOF]"") @IOF W:('BWCRT)&(IOF="") #
 .;/DLG
 ;
 ;---> IF PATIENT IS DECEASED, DON'T PRINT LETTER; PRINT EXPLANATION,
 ;---> CHANGE THE STATUS OF THE NOTIFICATION TO "CLOSED", AND GIVE
 ;---> THE OUTCOME OF "PATIENT DECEASED".
 I $$DECEASED^BWUTL1(BWDFN) D DECEASED Q
 ;
 ;---> PRINT IT TO IOP, PRESERVE BWPOP.
 D EN2^DIWF
 D PROMPT
 ;---> DON'T STUFF "DATE PRINTED" IF IT ALREADY HAS A "DATE PRINTED".
 I $P(^BWNOT(BWDA,0),U,10)]"" D KILLXREF(BWDA,BWKDT) L -^BWNOT(BWDA) Q
 ;
 ;---> DON'T STUFF "DATE PRINTED" IF IT'S JUST TO THE SCREEN.
 I BWCRT D  Q
 .W !!?3,"NOTE: Because this letter was only displayed on a screen and"
 .W !?9,"not printed on a printer, it will NOT yet be logged by the"
 .W !?9,"program as having been ""PRINTED"".",!
 .L -^BWNOT(BWDA) D DIRZ^BWUTL3
 ;
 ;---> NEXT LINES KILL "APRT" XREF AND SET "DATE PRINTED"=TODAY.
 ;---> ("APRT" XREF INDICATE A NOTIFICATION IS QUEUED TO BE PRINTED.)
 D KILLXREF(BWDA,BWKDT)
 D DIE^BWFMAN(9002086.4,".1////"_DT,BWDA)
 L -^BWNOT(BWDA) Q
 Q
 ;
KILLXREF(BWDA,BWKDT) ;EP
 ;---> KILL "APRT" XREF (REMOVE LETTER FROM QUEUE).
 Q:'$G(BWDA)  Q:'$G(BWKDT)
 K ^BWNOT("APRT",BWKDT,BWDA)
 Q
 ;
DECEASED ;EP
 ;---> IF THE PATIENT IS DECEASED.
 ;---> DON'T STUFF "DATE PRINTED" IF IT'S JUST TO THE SCREEN.
 W !!?3,"NOTE: Because this patient, ",$$NAME^BWUTL1(BWDFN)," #"
 W $$HRCN^BWUTL1(BWDFN),", is now"
 W !?9,"registered as deceased, the letter will NOT be printed."
 W !?9,"Instead, this notification will be given a status of CLOSED"
 W !?9,"and an outcome of ""Patient Deceased""."
 ;/IHS/ANMC/DLG 21JUN2002  sometimes IOF is null
 ;D:BWCRT DIRZ^BWUTL3 W:'BWCRT @IOF
 D:BWCRT DIRZ^BWUTL3 W:('BWCRT)&(IOF]"") @IOF W:('BWCRT)&(IOF="") #
 ;/DLG
 S DR=".14////c;.05///Patient Deceased"
 D DIE^BWFMAN(9002086.4,DR,BWDA)
 ;---> KILL "APRT" XREF (FLAGS NOTIFICATION AS QUEUED TO BE PRINTED).
 D KILLXREF(BWDA,BWKDT)
 L -^BWNOT(BWDA)
 Q
 ;
PROMPT ;EP
 ;---> PROMPT IF NECESSARY, PROMPT DEVICE.
 D:BWCRT DIRZ^BWUTL3
 Q
 ;
NONE ;EP
 ;---> Patched message covers all possibilities.         ;IHS/CMI/LAB
 ;S BWTITLE="* There are no letters for this patient"    ;IHS/CMI/LAB
 ;S BWTITLE=BWTITLE_" waiting to be printed. *"          ;IHS/CMI/LAB
 S BWTITLE="* No letters selected for printing. *"       ;IHS/CMI/LAB
 D CENTERT^BWUTL5(.BWTITLE)
 W !!!!,BWTITLE,!!
 D DIRZ^BWUTL3
 Q
 ;
TEXT1 ;EP
 ;;
 ;;* NOTE: The Facility with which this letter is associated does not
 ;;        match the Facility under which you are currently logged on.
 ;;        To print this Notification, you must either edit the Facility
 ;;        for this Notification, or log off and log back in under the
 ;;        same Facility with which the Notification is associated.
 S BWTAB=5,BWLINL="TEXT1" D PRINTX
 Q
 ;
PRINTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
