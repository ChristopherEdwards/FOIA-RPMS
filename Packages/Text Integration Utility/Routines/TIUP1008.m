TIUP1008 ;IHS/MSC/MGH - After installing TIU*1*1008;28-Jan-2011 15:41;DU
 ;;1.0;Text Integration Utilities;**1008**;Jun 20, 1997;Build 15
 ; Run this after installing patch 1008
 ;Use option: TIU1008 DDEFS & RULES, PRF
 ; External References
 ;   DBIA 4127  MAIN^USRPS24
BEGIN ; Create DDEFS
 W !!,"This option creates Document Definitions for patch 1008 "
 W ! K IOP S %ZIS="Q" D ^%ZIS I POP K POP Q
 I $D(IO("Q")) K IO("Q") D  Q
 .S ZTRTN="MAIN^TIUP1008"
 .S ZTDESC="Create DDefs - TIU*1*1008"
 .D ^%ZTLOAD W !,$S($D(ZTSK):"Request Queued!",1:"Request Canceled!")
 .K ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
 .D HOME^%ZIS
 U IO D MAIN,^%ZISC
 Q
 ;
MAIN ; Create DDEFS for Discharge instructions
 ; -- Check for dups created after the install but before this option:
 K ^XTMP("TIU1008","DUPS"),^TMP("TIU1008",$J)
 D SETXTMP^TIUE1008
 N TIUDUPS,TMPCNT,SILENT S TMPCNT=0
 S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)=""
 S TMPCNT=1,^TMP("TIU1008",$J,TMPCNT)="         ***** Document Definitions for HEADERS/FOOTERS *****"
 S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)=""
 S SILENT=1
 D TIUDUPS^TIUE1008(.TIUDUPS,SILENT)
 ; -- If potential duplicates exist, quit:
 I $G(TIUDUPS) D  G MAINX
 . S ^XTMP("TIU1008","DUPS")=1
 . S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="Duplicate problem.  See description for patch TIU*1*1008,"
 . S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="in the National Patch Module."
 ; -- Set file data, other data for DDEFS:
 D SETDATA^TIU1008D
 N NUM S NUM=0
 F  S NUM=$O(^XTMP("TIU1008","BASICS",NUM)) Q:'NUM  D
 . N IEN,YDDEF,TIUDA
 . ; -- If DDEF was previously created by this patch,
 . ;    say so and quit:
 . S IEN=+$G(^XTMP("TIU1008","BASICS",NUM,"DONE"))
 . I IEN D  Q
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)=^XTMP("TIU1008","FILEDATA",NUM,.04)_" "_^XTMP("TIU1008","BASICS",NUM,"NAME")
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="    was already created in a previous install."
 . . K ^XTMP("TIU1008","FILEDATA",NUM)
 . . K ^XTMP("TIU1008","DATA",NUM)
 . ; -- If not, create new DDEF:
 . S YDDEF=$$CREATE(NUM)
 . I +YDDEF'>0!($P(YDDEF,U,3)'=1) D  Q
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="Couldn't create a "_^XTMP("TIU1008","FILEDATA",NUM,.04)_" named "_^XTMP("TIU1008","BASICS",NUM,"NAME")_".",TMPCNT=TMPCNT+1
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="    Please contact National VistA Support for help."
 . S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)=^XTMP("TIU1008","FILEDATA",NUM,.04)_" named "_^XTMP("TIU1008","BASICS",NUM,"NAME")
 . S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="    created successfully."
 . S TIUDA=+YDDEF
 . ; -- File field data:
 . D FILE(NUM,TIUDA,.TMPCNT)
 . K ^XTMP("TIU1008","FILEDATA",NUM)
 . ; -- Add item to parent:
 . D ADDITEM(NUM,TIUDA,.TMPCNT)
 . K ^XTMP("TIU1008","DATA",NUM)
MAINX ;Exit
 S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)=""
 S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="                           *************"
 D PRINT
 K ^TMP("TIU1008",$J)
 Q
 ;
PRINT ; Print out results
 N TIUCNT,TIUCONT
 I $D(ZTQUEUED) S ZTREQ="@" ; Tell TaskMan to delete Task log entry
 I $E(IOST)="C" W @IOF,!
 S TIUCNT="",TIUCONT=1
 F  S TIUCNT=$O(^TMP("TIU1008",$J,TIUCNT)) Q:TIUCNT=""  D  Q:'TIUCONT
 . S TIUCONT=$$SETCONT Q:'TIUCONT
 . W ^TMP("TIU1008",$J,TIUCNT),!
 Q:'TIUCONT
 S TIUCNT=""
PRINTX Q
 ;
STOP() ;on screen paging check
 ; quits TIUCONT=1 if cont. ELSE quits TIUCONT=0
 N DIR,Y,TIUCONT
 S DIR(0)="E" D ^DIR
 S TIUCONT=Y
 I TIUCONT W @IOF,!
 Q TIUCONT
 ;
SETCONT() ; D form feed, Set TIUCONT
 N TIUCONT
 S TIUCONT=1
 I $E(IOST)="C" G SETX:$Y+5<IOSL
 I $E(IOST)="C" S TIUCONT=$$STOP G SETX
 G:$Y+8<IOSL SETX
 W @IOF
SETX Q TIUCONT
 ;
PARENT(NUM) ; Return IEN of parent new DDEF should be added to
 N PIEN,PNUM
 ; Parent node has form:
 ; -- PIEN node = IEN of parent if known, or if not,
 ;    PNUM node = DDEF# of parent
 S PIEN=$G(^XTMP("TIU1008","DATA",NUM,"PIEN"))
 ; -- If parent IEN is known, we're done:
 I +PIEN G PARENTX
 ; -- If not, get DDEF# of parent
 S PNUM=$G(^XTMP("TIU1008","DATA",NUM,"PNUM"))
 I 'PNUM Q 0
 ; -- Get Parent IEN from "DONE" node, which was set
 ;    when parent was created:
 S PIEN=+$G(^XTMP("TIU1008","BASICS",PNUM,"DONE"))
PARENTX Q PIEN
 ;
ADDITEM(NUM,TIUDA,TMPCNT) ; Add DDEF to Parent; Set item fields
 N PIEN,MENUTXT,TIUFPRIV,TIUFISCR
 N DIE,DR
 S TIUFPRIV=1
 S PIEN=$$PARENT(NUM)
 I 'PIEN!'$D(^TIU(8925.1,PIEN,0))!'$D(^TIU(8925.1,TIUDA,0)) K PIEN G ADDX
 N DA,DIC,DLAYGO,X,Y
 N I,DIY
 S DA(1)=PIEN
 S DIC="^TIU(8925.1,"_DA(1)_",10,",DIC(0)="LX"
 S DLAYGO=8925.14
 ;S X="`"_TIUDA
 ; -- If TIUDA is say, x, and Parent has x as IFN in Item subfile,
 ;    code finds item x under parent instead of creating a new item,
 ;    so don't use "`"_TIUDA:
 S X=^XTMP("TIU1008","BASICS",NUM,"NAME")
 ; -- Make sure the DDEF it adds is TIUDA and not another w same name:
 S TIUFISCR=TIUDA ; activates screen on fld 10, Subfld .01 in DD
 D ^DIC I Y'>0!($P(Y,U,3)'=1) K PIEN G ADDX
 ; -- Set Menu Text:
 S MENUTXT=$G(^XTMP("TIU1008","DATA",NUM,"MENUTXT"))
 I $L(MENUTXT) D
 . N DA,DIE,DR
 . N D,D0,DI,DQ
 . S DA(1)=PIEN
 . S DA=+Y,DIE=DIC
 . S DR="4////^S X=MENUTXT"
 . D ^DIE
ADDX ; -- Tell user about adding to parent:
 I '$G(PIEN) D
 . S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="  Couldn't add entry to parent.  Please contact National VistA Support"
 . S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="    for help."
 E  S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="  Entry added to parent."
 Q
 ;
FILE(NUM,TIUDA,TMPCNT) ; File fields for new entry TIUDA
 ; Files ALL FIELDS set in "FILEDATA" nodes of ^XTMP:
 ;   ^XTMP("TIU1008","FILEDATA",NUM,Field#)
 N TIUFPRIV,FDA,TIUERR
 S TIUFPRIV=1
 M FDA(8925.1,TIUDA_",")=^XTMP("TIU1008","FILEDATA",NUM)
 D FILE^DIE("TE","FDA","TIUERR")
 I $D(TIUERR) S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="  Problem filing data for entry. Please contact National VistA Support."
 E  S TMPCNT=TMPCNT+1,^TMP("TIU1008",$J,TMPCNT)="  Data for entry filed successfully."
 Q
 ;
CREATE(NUM) ; Create new DDEF entry
 N DIC,DLAYGO,DA,X,Y,TIUFPRIV
 S TIUFPRIV=1
 ;S (DIC,DLAYGO)="^TIU(8925.1,"
 ;CACHE won't take global root for DLAYGO; use file number:
 S DIC="^TIU(8925.1,",DLAYGO=8925.1
 S DIC(0)="LX",X=^XTMP("TIU1008","BASICS",NUM,"NAME")
 S DIC("S")="I $P(^(0),U,4)="_""""_^XTMP("TIU1008","BASICS",NUM,"INTTYPE")_""""
 D ^DIC
 ; -- If DDEF was just created, set "DONE" node = IEN
 I $P(Y,U,3)=1 S ^XTMP("TIU1008","BASICS",NUM,"DONE")=+$G(Y)
 Q $G(Y)
