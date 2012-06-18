AGEDBEA ; IHS/ASDS/TPF - EDIT/DISPLAY BENEFITS COORDINATOR - MAIN SCREEN ;    
 ;;7.1;PATIENT REGISTRATION;**1,2,8**;AUG 25, 2005
 ;
EN ;
 S NEWENTRY=0    ;BD0=DFN  THIS SCREEN DISPLAYS ALL CURRENT ENTRIES
 ;                NEW ENTRIES ARE MADE ON OTHER SCREENS
 ;
VAR D DRAW
 W !,AGLINE("EQ")
 K DIR
 I '$D(AGSEENLY) D
 .;I AG("N")=0 S DIR("A")="Add <C>ase or <A>uthorization"
 .;E  S DIR("A")="Change which item (1-"_AG("N")_") OR Add <C>ase or <A>uthorization"
 .;BEGIN NEW CODE IHS/SD/TPF AG*7.1*1 ITEM 14
  .S DIR("A")="Change which item (1-"_AG("N")_") OR Add <C>ase or <A>uthorization, or <V>iew closed cases"
 .I AG("N")=0,'($G(CLOSED)) S DIR("A")="Add <C>ase or <A>uthorization,"
 .;I AG("N")=0,($G(CLOSED)) S DIR("A")="Add <C>ase or <A>uthorization, or <V>iew closed cases"
 .I '$D(^XUSEC("AGZCREOPN",DUZ)),AG("N")=0,($G(CLOSED)) S DIR("A")="Add <C>ase or <A>uthorization, or <V>iew closed cases"  ;AG*7.1*8
 .I $D(^XUSEC("AGZCREOPN",DUZ)),AG("N")=0,($G(CLOSED)) S DIR("A")="Add <C>ase or <A>uthorization, <R>e-open or <V>iew closed cases"  ;AG*7.1*8
 .I AG("N"),'$G(CLOSED) S DIR("A")="Change which item (1-"_AG("N")_") OR Add <C>ase or <A>uthorization"
 .;I AG("N"),$G(CLOSED) S DIR("A")="Change which item (1-"_AG("N")_") OR Add <C>ase or <A>uthorization, or <V>iew closed cases"
 .I '$D(^XUSEC("AGZCREOPN",DUZ)),AG("N"),$G(CLOSED) S DIR("A")="Change which item (1-"_AG("N")_") OR Add <C>ase or <A>uthorization, or <V>iew closed cases"  ;AG*7.1*8
 .I $D(^XUSEC("AGZCREOPN",DUZ)),AG("N"),$G(CLOSED) S DIR("A")="Change which item (1-"_AG("N")_") OR Add <C>ase or <A>uthorization, <R>e-open or <V>iew closed cases"  ;AG*7.1*8
 .N CTDIR S CTDIR=0
 .S CTDIR=CTDIR+1,DIR("?",CTDIR)="You may enter the item number of the field you wish to edit,"
 .S CTDIR=CTDIR+1,DIR("?",CTDIR)="OR you can enter 'P#' where P stands for 'page' and '#' stands for"
 .S CTDIR=CTDIR+1,DIR("?",CTDIR)="the page you wish to jump to, OR enter '^' to go back one page"
 .S CTDIR=CTDIR+1,DIR("?",CTDIR)="OR, enter '^^' to exit the edit screens, OR RETURN to go to the next screen."
 .S CTDIR=CTDIR+1,DIR("?",CTDIR)="OR 'C' to enter a new case,"
 .S CTDIR=CTDIR+1,DIR("?",CTDIR)="OR 'A' to enter a new authorization,"
 .I $G(CLOSED) S CTDIR=CTDIR+1,DIR("?",CTDIR)="OR 'R' to re-open a closed case,"
 .I $G(CLOSED) S CTDIR=CTDIR+1,DIR("?",CTDIR)="OR 'V' to view closed cases."
 I $D(AGSEENLY) D
 .;S DIR("A")="Enter item number to view"
 .;S DIR="LO^1"_AG("N")
 .;BEGIN NEW CODE IHS/SD/TPF AG*7.1*1 ITEM 14
 .I AGSEENLY="" D
 ..S DIR("A")="Enter item number to view"
 ..S DIR(0)="LO^1"_AG("N")
 .I AGSEENLY=2 D
 ..S DIR("A")="Enter item number to view or <R>esume editing"
 ..S DIR(0)="F"_U_"1:"_$L(AG("N"))
 ..S DIR("B")="R"
 D READ^AGED1
 G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) END
 G:$D(AG("ED"))&'$D(AGXTERN) @("^AGED"_AG("ED"))
 G END:$D(DLOUT)!(Y["N")!$D(DUOUT),VAR:$D(AG("ERR"))
 G:$D(DFOUT)!$D(DTOUT) END
 ;BEGIN NEW CODE IHS/SD/TPF AG*7.1*1 ITEM 14
 I $G(AGSEENLY)=2 D   G:'$D(AGSEENLY) VAR
 .I +X'=X,(X'="R") S X="R" W !,"Enter an R to Resume editing or a item number" Q
 .I X="R" K AGSEENLY Q
 I Y="V" S AGSEENLY=2 G VAR
 I Y="R",$D(^XUSEC("AGZCREOPN",DUZ)),($G(CLOSED)) D CLS^AGEDBEI(DFN,CLOSED) G VAR
 I Y="R" G VAR
 ;END NEW CODE
 ;ENTER ROUTINES TO ADD ENTRY
 I $G(Y)="C"!($G(Y)="A") D @$S(Y="C":"EN^AGEDBEB("""","""",1)",1:"EN^AGEDBEC("""","""",1)") G VAR
 ;IF NUMBER CHOSEN THEN THE USER WANTS TO EDIT ONE OF THE ITEMS LISTED ON THE SCREEN
 I AG("N")=0 W !,"There are no items to select!" H 3 G VAR
 I $D(DQOUT)!(+Y<1)!(+Y>AG("N")) W !!,"You must enter a number from 1 to ",AG("N") H 2 G VAR
 ;DEPENDING ON USER CHOICE ITEM MAY BE A CASE OR AN AUTH.
 ;ENTER ROUTINES TO EDIT
 I $D(CHOICES(+Y)) S DORTN=$S($P(CHOICES(+Y),U)[9000044:"EN^AGEDBEB",1:"EN^AGEDBEC"),PARAM1=$P(CHOICES(+Y),U,2),PARAM2=$P(CHOICES(+Y),U,3) S DORTN=DORTN_"("_PARAM1_","_PARAM2_","_"0)" D @DORTN G VAR
 D UPDATE1^AGED(DUZ(2),DFN,3,"")
 K AGI,AGY
 G VAR
END K DORTN
 K DLOUT,DTOUT,DFOUT,DQOUT,DA,DIC,DR,AGSCRN,Y,ADA,WDA,ADT,WDT,ADFN,WDFN,REC,NEWENTRY,BD0,BD1,ROUTID
 Q:$D(AGXTERN)
 Q:$D(DIROUT)
 Q:$D(AGSEENLY)
 G ^AGED4A:$D(DUOUT)
 G ^AGED13
 Q
DRAW ;EP
 K CHOICES
 S AG("PG")="5BEA"
 S ROUTID=$P($T(+1)," ")
 D ^AGED  ;SCREEN HEADER ROUTINE
 D GETAW
 Q
GETAW ;DISP
 S:'$D(AUPNPAT) AUPNPAT=$G(DFN)
 I AUPNPAT="" W !!,"PATIENT IEN NOT DEFINED!" H 2 Q
 S BD0=$O(^AUPNBENR("B",AUPNPAT,""))  ;GET CASE IEN OF PATIENT THEN GET ALL CASES ASSIGNED TO BEN. COORD.
 S CD0=$O(^AUPNAUTH("B",AUPNPAT,""))  ;GET AUTHORIZATION IEN
 K CHOICES  ;RESET THE ALLOWABLE CHOICES
 K AG("C")
 S ITEM=0
 F AG=1:1 D  Q:$G(AGSCRN)[("*END*")
 . ;S AGSCRN=$P($T(@2+AG),";;",2,15)  ;OPTIONAL DISP
 . I $G(AGSEENLY)=2 S AGSCRN=$P($T(@3+AG),";;",2,15)  ;CLOSED DISPLAY - AG*7.1*8
 . E  S AGSCRN=$P($T(@2+AG),";;",2,15)  ;OPTIONAL DISP - AG*7.1*8
 . Q:AGSCRN[("*END*")
 . S CAPTION=$P(AGSCRN,U)  ;FLD CAP
 . I $E(CAPTION)="-" W !,$E(CAPTION,2,199) Q  ;- DENOTES SECTION 
 . S DIC=$P(AGSCRN,U,3)    ;FILE OR SUBFILE #
 . S VDR=$P(AGSCRN,U,4)      ;FLD #
 . S NEWLINE=$P(AGSCRN,U,5)  ;NEWLINE OR INDENT
 . S CAPDENT=$P(AGSCRN,U,2)   ;CAP INDENT
 . S ITEMNUM=$P(AGSCRN,U,6)   ;ITEM #
 . S TAGCALL=$P($P(AGSCRN,U,7),"|",1)   ;TAG TO CALL TO EDIT THIS FLD
 . S EXECUTE=$P(AGSCRN,"|",2)      ;USE TO DISP FLD WHICH IS DEPENDENT ON ANOTHER FLD
 . S PREEXEC=$P(AGSCRN,"|",3)     ;PLACE CODE TO BE XECUTED PRIOR TO DISP OF THE FLD
 . S PRECAPEX=$P(AGSCRN,"|",4)   ;PLACE CODE TO EXECUTE BEF CAP/FLD LBL
 . S POSTEXEC=$P(AGSCRN,"|",5)    ;PLACE CODE HERE TO BE EXECUTED AFT DISP OF THE FLD
 . S:TAGCALL'="" $P(AG("C"),",",ITEMNUM)=TAGCALL   ;SELECTION STRING
 . W @NEWLINE
 . W ITEMNUM
 . W $S(ITEMNUM'="":". ",1:"")
 . I PRECAPEX="" W @CAPDENT,$S($G(CAPTION)'="":CAPTION_": ",$G(CAPTION)="":"",1:$P($G(^DD(DIC,VDR,0)),U)_": ")
 . I PRECAPEX'="" X PRECAPEX I $T W @CAPDENT,$S($G(CAPTION)'="":CAPTION_": ",$G(CAPTION)="":"",1:$P($G(^DD(DIC,VDR,0)),U)_": ")
 .;IF EDITING DISPLAY DATA ONLY
 .;E DISP ONLY THE CAPS
 .D
 .. S VD0=BD0
 .. I DIC'["." S VD0=D0_"," D
 ... ;LOOP TO HANDLE MULTIPLE DR'S FOR ONE DIC
 ... N PIECE
 ... F PIECE=1:1 S DR=$P(VDR,";",PIECE) Q:DR=""  D
 .... I $P(PREEXEC,";",PIECE)'="" X $P(PREEXEC,";",PIECE)
 .... I $P(EXECUTE,";",PIECE)="" W $$GET1^DIQ(DIC,VD0,DR)
 .... I $P(EXECUTE,";",PIECE)'="" S VD0=$TR(D0,",") X $P(EXECUTE,";",PIECE)
 .... I $P(POSTEXEC,";",PIECE)'="" X $P(POSTEXEC,";",PIECE)
 ...K PIECE
 ...;NOW LETS HANDLE THE CASE DATE SUBFILE
 .. I DIC["9000044."  D
 ... I $G(BD0)="" S BD0="NOREF"
 ... I '$O(^AUPNBENR(BD0,11,0)) W !,"PATIENT HAS NO CASE DATE ENTRIES!",! Q
 ... S CLOSED=0
 ... S NOTCLOSE=0
 ... ;
 ... ;Start of new (modified) code for AG*7.1*8
 ... ;
 ... ;Get list of closed cases, sort by complete date
 ... N CLCASE,CLIEN,CDT
 ... S CLIEN=0 F  S CLIEN=$O(^AUPNBENR(VD0,11,CLIEN)) Q:'CLIEN  D
 .... ;
 .... ;Get a list of cases - Closed view is sorted by completed date, Other View is by IEN
 .... S D0=CLIEN_","_VD0_","
 .... ;I $$GET1^DIQ(DIC,D0,.07)="CLOSED",('$D(AGSEENLY)) S CLOSED=CLOSED+1 Q  ;SKIP CLOSED RECORDS
 .... ;BEGIN NEW CODE IHS/SD/TPF AG*7.1*1 ITEM 14
 .... I $G(AGSEENLY)=2 S CDT=$$GET1^DIQ(9000044.11,CLIEN_","_VD0_",",.11,"I") S:CDT="" CDT="~"
 .... I $G(AGSEENLY)'=2 S CDT=$G(CDT)-1
 .... I $$GET1^DIQ(DIC,D0,.07)="CLOSED",($G(AGSEENLY)="") S CLOSED=CLOSED+1 Q  ;SKIP CLOSED RECORDS
 .... I $$GET1^DIQ(DIC,D0,.07)="OPEN"!($$GET1^DIQ(DIC,D0,.07)=""),($G(AGSEENLY)="") S NOTCLOSE=NOTCLOSE+1  ;COUNT OPEN RECORDS
 .... I $$GET1^DIQ(DIC,D0,.07)="OPEN"!($$GET1^DIQ(DIC,D0,.07)=""),($G(AGSEENLY)=2) Q  ;IHS/SD/TPF AG*7.1*1 ITEM 14 SKIP OPEN RECORDS IF IN VIEW CLOSED RECORDS MODE
 .... S CLCASE(CDT,CLIEN)=DIC_U_VD0_U_CLIEN
 ... ;
 ... ;Loop through list and display
 ... S CDT="" F  S CDT=$O(CLCASE(CDT),-1) Q:CDT=""  S BD1="" F  S BD1=$O(CLCASE(CDT,BD1)) Q:'BD1  D
 .... ;
 .... S ITEM=ITEM+1
 .... S CHOICES(ITEM)=CLCASE(CDT,BD1)
 .... S D0=BD1_","_VD0_","
 .... ;
 .... ;End of modified code for AG*7.1*8
 .... ;
 .... I ITEM=1 W ?0,ITEM_"."
 .... E  W !,ITEM_"."
 .... N PIECE
 .... F PIECE=1:1 S DR=$P(VDR,";",PIECE) Q:DR=""  D 
 ..... I $P(PREEXEC,";",PIECE)'="" X $P(PREEXEC,";",PIECE)
 ..... I $P(EXECUTE,";",PIECE)="" D
 ...... W $S(DR=.02:$E($$GET1^DIQ(DIC,D0,DR),1,15),DR=.12:$E($$GET1^DIQ(DIC,D0,DR),1,25),1:$$GET1^DIQ(DIC,D0,DR))
 ..... I $P(EXECUTE,";",PIECE)'="" X $P(EXECUTE,";",PIECE)
 ..... I $P(POSTEXEC,";",PIECE)'="" X $P(POSTEXEC,";",PIECE)
 ....K PIECE
 ...;I 'NOTCLOSE,CLOSED W !,"PATIENT HAS "_CLOSED_" CLOSED CASES",!
 ... I $G(CLOSED) W !,"PATIENT HAS "_CLOSED_" CLOSED CASE"_$S(CLOSED>1:"S",1:""),!  ;IHS/SD/TPF AG*7.1*1 ITEM 14
 .. I DIC["9000046."  D
 ... I $G(CD0)="" W !,"PATIENT HAS NO AUTHORIZATION ENCOUNTER DATES!",! Q
 ... I '$O(^AUPNAUTH(CD0,11,0)) W !,"PATIENT HAS NO AUTHORIZATION ENCOUNTER DATES!",!
 ... S BD1=0
 ... F  S BD1=$O(^AUPNAUTH(CD0,11,BD1)) Q:'BD1  D
 .... S ITEM=ITEM+1
 .... S CHOICES(ITEM)=DIC_U_CD0_U_BD1
 .... S D0=BD1_","_CD0_","
 .... W !,ITEM_"."
 .... N PIECE
 .... F PIECE=1:1 S DR=$P(VDR,";",PIECE) Q:DR=""  D 
 ..... I $P(PREEXEC,";",PIECE)'="" X $P(PREEXEC,";",PIECE)
 ..... I $P(EXECUTE,";",PIECE)="" D
 ......W $S(DR=.03:$E($$GET1^DIQ(DIC,D0,DR,"I")),DR=.04:$E($$GET1^DIQ(DIC,D0,DR,"E"),1,20),1:$$GET1^DIQ(DIC,D0,DR))
 ..... I $P(EXECUTE,";",PIECE)'="" X $P(EXECUTE,";",PIECE)
 ..... I $P(POSTEXEC,";",PIECE)'="" X $P(POSTEXEC,";",PIECE)
 ....K PIECE
 S AG("N")=$G(ITEM)
 W !,$G(AGLINE("-"))
 D VERIF^AGUTILS
 Q
 ;
 ; ****************************************************************
 ; ON LINES BELOW:
 ; U "^" DELIMITED
 ; AGSCRN CONTAINS THE $TEXT OF EACH LINE BELOW STARTING AT TAG '1'
 ; PIECE  VAR       DESC
 ; -----  --------  -----------------------------------------------
 ; 1      CAPTION    FLD CAP ASSIGNED BY PROGRAMMER OVERRIDES FLD LBL IF POPULATED
 ; 2      CAPDENT    POSITION ON LINE TO DISP CAP
 ; 3      DIC        FILE OR SUBFILE #
 ; 4      DR         FLD # - THESE CAN BE SEPARATED BY ";" THIS ALLOWS
 ;                   MULTIPLE FLDS TO BE PRINTED WITH THE SAME CAP AS IN
 ;                   'CITY,STATE,ZIP'
 ; 5      NEWLINE    NEW LINE OR NOT (MUST BE EITHER A '!' OR '?#') USE THIS TO INDENT THE LINE
 ; 6      ITEMNUM    ITEM # ASSIGNMENT. USE THIS TO ASSIGN THE ITEM # USED TO CHOOSE THIS
 ;                   FLD ON THE SCREEN
 ; 7      TAGCALL    TAG TO CALL WHEN THIS FLD IS CHOSEN BY USER TO BE EDITED
 ; 
 ; BAR "|" DELIMITED
 ; PIECE  VAR        DESC
 ; -----  --------   ----------------------------------------------
 ; 2      EXECUTE    EXECUTE CODE TO GET FLD THAT ANOTHER IS POINTING TO.
 ;                   EXECUTED TO PRINT THE FLD. IF MUTLIPLE FLDS ARE PRINTED
 ;                   THEN MULTIPLE EXECUTE CODES CAN BE SEPARATED BY ";".
 ; 3      PREEXEC    EXECUTE CODE TO DO BEF FLD PRINTS. USE TO SCREEN OUT
 ;                   PRINTING A FLD VALUE. FOR MULTIPLES SEPARATE BY ";"
 ; 4      PRECAPEX   EXECUTE CODE TO DO BEF PRINTING THE CAP OR FLD LBL.
 ;                   USE TO SCREEN OUT PRINTING A CAP/FLD LBL
 ; 5      POSTEXEC   EXECUTE CODE TO DO AFT PRINTING THE FLD DATA.
 ;                   FOR MULTIPLES SEPARATE BY ";"
1 ;
 ;;^?0^9000044.11^.01;.02;.03;.12;.07^!^^||W "CASE DATE: ";W ?45,"to ";W ?72,"by ";W !?10,"Reason: ";W ?60,"Status: "
 ;;-================================================================================
 ;;-PRIOR AUTHORIZATION   DATE       INSURER
 ;;---------------------------------------------------------------------------------
 ;;^?3^^^!^2^EDITPRE
 ;;*END*
 ;
 ;ALTERNATE DISPLAY
2 ;
 ;;-                             BENEFITS COORDINATION
 ;;-================================================================================
 ;;-CASE DATE          ASSIGNED TO     ASSIGNED BY       REASON        
 ;;---------------------------------------------------------------------------------
 ;;^?0^9000044.11^.01;.02;.03;.12^?0^^|;;;;W $S($$GET1^DIQ(DIC,D0,DR)="":"OPEN",1:$$GET1^DIQ(DIC,D0,DR))|;W ?19;W ?35;W ?53;W ?70
 ;;-================================================================================
 ;;-PRIOR AUTHORIZATION  ENCOUNTER DATE  ADMISSION DATE  INSURER              TYPE
 ;;---------------------------------------------------------------------------------
 ;;^?0^9000046.11^.06;.01;.02;.04;.03^?0^^EDITPRE||;W ?21;W ?37;W ?52;W ?75
 ;;*END*
 ;
 ;CLOSED VIEW DISPLAY
3 ;
 ;;-                             BENEFITS COORDINATION
 ;;-================================================================================
 ;;-COMPLETED DATE  CASE DATE       ASSIGNED TO       REASON
 ;;---------------------------------------------------------------------------------
 ;;^?0^9000044.11^.11;.01;.02;.12^?0^^|;;;;;W $S($$GET1^DIQ(DIC,D0,DR)="":"OPEN",1:$$GET1^DIQ(DIC,D0,DR))|;W ?17;W ?33;W ?51
 ;;-================================================================================
 ;;-PRIOR AUTHORIZATION  ENCOUNTER DATE  ADMISSION DATE  INSURER              TYPE
 ;;---------------------------------------------------------------------------------
 ;;^?0^9000046.11^.06;.01;.02;.04;.03^?0^^EDITPRE||;W ?21;W ?37;W ?52;W ?75
 ;;*END*
