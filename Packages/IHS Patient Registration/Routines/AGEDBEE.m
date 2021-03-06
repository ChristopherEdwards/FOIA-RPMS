AGEDBEE ; IHS/ASDS/TPF - EDIT/DISPLAY BENEFITS COORDINATOR - PATIENT APPLICATION SUBMISSIONS SCREEN ;    
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;AD0 AND AD1 WILL BE THE IENS NEEDED TO DISP THE 'PATIENTS APPLICATION
 ;SUBMISSION' WHICH WAS CHOSEN FROM THE PATIENT APPLICATIONS MAIN
 ;SCREEN (^AGEDBED)
EN(AD0,AD1,AD2,NEWENTRY) ;
 ;IF ITS A NEW ENTRY, DISP THE SCREEN, DISP A MESSAGE, THEN CALL THE
 ;EDITS TO FIELDS APPROPRIATE FOR ADDING A NEW ENTRY
 I NEWENTRY D DRAW,WMSG,NEWENTRY I $G(Y)<0 W !,"Entry not made." H 2 D END Q
 S NEWENTRY=0
 ;BELOW ASKS SEQUENCE OF QUESTIONS
 ;S EXIT=0
 ;I NEWENTRY D  Q:EXIT  S NEWENTRY=0
 ;.D DRAW,WMSG,NEWENTRY I $G(Y)<0 W !,"No entry made" H 2 S EXIT=1 Q
 ;.D APSUBVIA
 ;.D APPREAS
 ;.D APPSUBBY
 ;
VAR D DRAW
 W !,AGLINE("EQ")
 K DIR
 I '$D(AGSEENLY) D
 .S DIR("A")="Change which item (1-"_AG("N")_") OR Add <A>pplication Submission Status information"
 I $D(AGSEENLY) D
 .S DIR("A")="Press return to continue"
 .S DIR="FO"
 D READ^AGED1
 I $D(AGSEENLY) Q
 I $D(MYERRS("C","E")),(Y'?1N.N),(Y'="E") W !,"ERRORS ON THIS PAGE. PLEASE EDIT BEFORE EXITING!!" H 3 G VAR
 Q:Y=$G(AGOPT("ESCAPE"))
 G END:$D(DLOUT)!(Y["N")!$D(DUOUT),VAR:$D(AG("ERR"))
 Q:$D(DFOUT)!$D(DTOUT)
 I $G(Y)="A" D ADSUBSTA G VAR
 I $D(DQOUT)!(+Y<1)!(+Y>AG("N")) W !!,"You must enter a number from 1 to ",AG("N"),!,"or 'A' to add Application Submission Status information." H 3 G VAR
 ;DEPENDING ON USER'S CHOICE ITEM MAY BE AN EDIT ON THIS SCREEN OR
 ;IT MAY BE A PATIENT APPLICATION SUBMISSION WHICH IS ON ^AGEDBEE
 I $D(CHOICES(+Y)) S DORTN="APSUBDT",AD0=$P(CHOICES(+Y),U,2),AD1=$P(CHOICES(+Y),U,3),AD2=$P(CHOICES(+Y),U,4),AD3=$P(CHOICES(+Y),U,5) D @DORTN G VAR
 I $D(Y) D
 .S AGY=Y
 .F AGI=1:1 S AG("SEL")=+$P(AGY,",",AGI) Q:AG("SEL")<1!(AG("SEL")>AG("N"))  D @($P(AG("C"),",",AG("SEL")))
 ;I AGY=1,'$D(^AUPNAUTH(AD0,11,AD1,1,AD2)) D CLEAN(AD0,AD1,AD2) Q  ;USER HAS DELETED THE APP. SUBMITTED DATE
 ;                                      THEY CHOSE TO ENTER THIS SCREEN. IT IS GONE
 ;                                      SO RETURN TO PREV. SCREEN
 ;D CLEAN(AD0,AD1,AD2)
 I '$O(^AUPNAUTH(AD0,11,AD1,1,AD2,0)) Q
 D UPDATE1^AGED(DUZ(2),DFN,3,"")
 K AGI,AGY
 G VAR
CLEAN(AD0,AD1,AD2) ;CLEAN EMPTY RECORD. IF NO SUBMISSION DATES HAVE
 ;BEEN ENTERED THEN THE RECORD IS MEANINGLESS
 ;CHECK HERE TO SEE IF ENTRIES HAVE ACTUALLY BEEN ENTERED. IF NOT
 ;CLEAR THE RECORD SINCE NOTHING REALLY EXISTS IN THIS
 ;RECORD AUPNAPPS(D0,11,D1,1,0)
 I $O(^AUPNAPPS(AD0,11,AD1,1,0))="" D
 .D CLEANZER(AD0,AD1)
 .W !,"RECORD DELETED!" H 2
 Q
CLEANZER(AD0,AD1) ;EP
 K DIK,DA
 S DA(3)=AD0,DA(2)=AD1,DA=AD2,DIK="^AUPNAPPS("_DA(3)_",11,"_DA(2)_",1," D ^DIK
 Q
END ;CLEAN UP THE VARS USED
 K AG,DLOUT,DTOUT,DFOUT,DQOUT,DA,DIC,DR,AGSCRN,Y,ADA,WDA,ADT,WDT,ADFN,WDFN,REC,NEWENTRY,CHOICES
 Q
DRAW ;EP
 K CHOICES
 S AG("PG")="5BEE"
 S ROUTID=$P($T(+1)," ")
 D ^AGED
 D GETAW
 Q
GETAW ;DISP
 K AG("C")
 F AG=1:1 D  Q:$G(AGSCRN)[("*END*")
 . S AGSCRN=$P($T(@1+AG),";;",2,15)
 . Q:AGSCRN[("*END*")
 . S CAPTION=$P(AGSCRN,U)  ;FLD CAP
 . I $E(CAPTION)="-" D CAPPARSE(CAPTION) Q  ;PARSE OUT CAP
 . S DIC=$P(AGSCRN,U,3)    ;FILE OR SUBFILE #
 . S DR=$P(AGSCRN,U,4)      ;FLD #
 . S SKIPEXEC=$P(AGSCRN,"|",6)  ;SKIP LOGIC. IF THIS IS TRUE WE
 . ;                             DON'T DEAL WITH THIS FLD AT ALL
 . I SKIPEXEC'="" X SKIPEXEC Q:$T
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
 . I PRECAPEX="" W @CAPDENT,$S($G(CAPTION)'="":CAPTION_": ",$G(CAPTION)="":"",1:$P($G(^DD(DIC,DR,0)),U)_": ")
 . I PRECAPEX'="" X PRECAPEX I $T W @CAPDENT,$S($G(CAPTION)'="":CAPTION_": ",$G(CAPTION)="":"",1:$P($G(^DD(DIC,DR,0)),U)_": ")
 .;IF EDITING DISP DATA ONLY
 .;E DISPLAY ONLY THE CAPS
 .I 'NEWENTRY D
 .. ;LOOP TO HANDLE MULTIPLE DR'S FOR ONE CAP
 .. I DIC["9000045.1101"  D
 ... S D0=AD2_","_AD1_","_AD0_","
 ... N PIECE
 ... S VDR=DR
 ... F PIECE=1:1 S DR=$P(VDR,";",PIECE) Q:DR=""  D
 .... I $P(PREEXEC,";",PIECE)'="" X $P(PREEXEC,";",PIECE)
 .... I $P(EXECUTE,";",PIECE)="" W $$GET1^DIQ(DIC,D0,DR)
 .... I $P(EXECUTE,";",PIECE)'="" S D0=$TR(D0,",") X $P(EXECUTE,";",PIECE)
 .... I $P(POSTEXEC,";",PIECE)'="" X $P(POSTEXEC,";",PIECE)
 ...K PIECE
 ..;LIST SUBMISSION STATUS DATES
 .. I DIC["9000045.110101"  D
 ... S ITEM=4   ;PREVIOUS SECTION'S ITEMS END AT 4
 ... S VD0=AD0
 ... S VD1=AD1
 ... S VD2=AD2
 ... I '$O(^AUPNAPPS(VD0,11,VD1,1,VD2,1,0)) W !,"NO STATUSES ENTERED" Q
 ... S VD3=0
 ... F  S VD3=$O(^AUPNAPPS(VD0,11,VD1,1,VD2,1,VD3)) Q:'VD3  D
 .... S ITEM=ITEM+1
 .... S CHOICES(ITEM)=DIC_U_VD0_U_VD1_U_VD2_U_VD3
 .... S D0=VD3_","_VD2_","_VD1_","_VD0_","
 .... W !,ITEM_"."
 .... N PIECE
 .... F PIECE=1:1 S DR=$P(VDR,";",PIECE) Q:DR=""  D 
 ..... I $P(PREEXEC,";",PIECE)'="" X $P(PREEXEC,";",PIECE)
 ..... I $P(EXECUTE,";",PIECE)="" W $$GET1^DIQ(DIC,D0,DR)
 ..... I $P(EXECUTE,";",PIECE)'="" X $P(EXECUTE,";",PIECE)
 ..... I $P(POSTEXEC,";",PIECE)'="" X $P(POSTEXEC,";",PIECE)
 ....K PIECE
 S AG("N")=$G(ITEM)
 W !,$G(AGLINE("-"))
 K MYERRS,MYVARS
 D FETCHERR^AGEDERR(AG("PG"),.MYERRS)
 S MYVARS("DFN")=DFN,MYVARS("FINDCALL")="",MYVARS("SELECTION")=$G(AGSELECT),MYVARS("SITE")=DUZ(2)
 D EDITCHEK^AGEDERR(.MYERRS,.MYVARS,1)
 D VERIF^AGUTILS
 Q
CAPPARSE(CAPTION) ;EP - PARSE OUT THE CAP
 N LBRACKET,RBRACKET
 S LBRACKET="[",RBRACKET="]"
 I CAPTION'[LBRACKET W !,$E(CAPTION,2,199) Q  ;- DENOTES SIMPLE SECTION
 ;PARSE OUT AND INSERT FLD VALUES
 S FIELDS=$L(CAPTION,LBRACKET)
 W !,$E($P(CAPTION,LBRACKET),2,199)
 F PIECE=1:1:FIELDS D
 .S FIELD=$P($P(CAPTION,LBRACKET,PIECE),RBRACKET)
 .W $$GET1^DIQ($P(FIELD,";"),AD1_","_AD0_",",$P(FIELD,";",2))
 W $P(CAPTION,RBRACKET,2)
 K LBRACKET,RBRACKET
 Q
WMSG ;DISP THIS MSG IF THERE IS NO AUTHORIZATION DT FOUND
 W !,"You must first enter a APPLICATION SUBMISSION DATE"
 Q
 ;;;;;;;;;;;;;;;;;;;;;;;;;
 ; EDIT AUTHORIZATION FLDS
 ;;;;;;;;;;;;;;;;;;;;;;;;;
NEWENTRY ;EP - NEW ENTRY
APDTSUB ;APPLICATION SUBMISSION DT
 K DIC,DIE,DR,DA
 S DA(1)=AD1
 S DA(2)=AD0
 S DIC="^AUPNAPPS("_DA(2)_",11,"_DA(1)_",1,"
 S DIC(0)="ALMEQ"
 K DD,DO
 D ^DIC
 I +Y>0 S AD2=+Y Q
 Q
APSUBVIA ;EP - EDIT APPLICATION SUBMITTED VIA
 K DIC,DR,DIE,DA,DD,DO
 S DA(1)=AD1
 S DA(2)=AD0
 S DA=AD2
 S DIE="^AUPNAPPS("_DA(2)_",11,"_DA(1)_",1,"
 S DR=.02
 D ^DIE
 K DIC,DR,DIE,DA
 Q
APPREAS ;EP - EDIT REASON FOR SUBMISSION
 K DIC,DR,DIE,DA,DD,DO
 S DA(1)=AD1
 S DA(2)=AD0
 S DA=AD2
 S DIE="^AUPNAPPS("_DA(2)_",11,"_DA(1)_",1,"
 S DR=".03"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
APPSUBBY ;EP - EDIT REASON FOR SUBMISSION
 K DIC,DR,DIE,DA,DD,DO
 S DA(1)=AD1
 S DA(2)=AD0
 S DA=AD2
 S DIE="^AUPNAPPS("_DA(2)_",11,"_DA(1)_",1,"
 S DR=".04"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
ADSUBSTA ;EP - ADD APPLICATION SUBMISSION DT
 K DIC,DIE,DR,DA
 S DA(2)=AD1
 S DA(3)=AD0
 S DA(1)=AD2
 S DIC="^AUPNAPPS("_DA(3)_",11,"_DA(2)_",1,"_DA(1)_",1,"
 S DIC(0)="ALMEQ"
 K DD,DO
 D ^DIC
 Q:+Y<0
 S AD3=+Y
 D APSUBST
 Q
APSUBDT ;EP - EDIT APPLICATION SUBMISSION STATUS DT
 K DIC,DR,DIE,DA,DD,DO
 S DA(2)=AD1
 S DA(3)=AD0
 S DA(1)=AD2
 S DA=AD3
 S DIE="^AUPNAPPS("_DA(3)_",11,"_DA(2)_",1,"_DA(1)_",1,"
 S DR=".01"
 D ^DIE
 Q:'$D(DA)  ;SUBMISION STATUS DT DELETED
 K DIC,DR,DIE,DA
 D APSUBST
 Q
APSUBST ;EP - EDIT SUBMISSION STATUS
 K DIC,DR,DIE,DA,DD,DO
 S DA(2)=AD1
 S DA(3)=AD0
 S DA(1)=AD2
 S DA=AD3
 S DIE="^AUPNAPPS("_DA(3)_",11,"_DA(2)_",1,"_DA(1)_",1,"
 S DR=".02"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
EDDTSUB ;EDIT DT APPLICATION SUBMITTED
 K DIC,DR,DIE,DA,DD,DO
 S DA(1)=AD1
 S DA(2)=AD0
 S DA=AD2
 S DIE="^AUPNAPPS("_DA(2)_",11,"_DA(1)_",1,"
 S DR=".01"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
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
 ; 5      NEWLINE    NEW LINE OR NOT (MUST BE EITHER A '!' OR '?#')
 ;                   USE THIS TO INDENT THE LINE
 ; 6      ITEMNUM    ITEM # ASSIGNMENT. USE THIS TO ASSIGN THE ITEM #
 ;                   USED TO ALLOW USER TO CHOOSE THIS FLD TO EDIT
 ; 7      TAGCALL    TAG TO CALL WHEN THIS FLD IS CHOSEN BY USER TO BE EDITED
 ;
 ; BAR "|" DELIMITED
 ; PIECE  VAR        DESC
 ; -----  --------   ----------------------------------------------
 ; 2      EXECUTE    EXECUTE CODE TO GET FLD THAT ANOTHER IS POINTING TO.
 ;                   EXECUTED AFT FLD PRINT. IF MUTLIPLE FLDS ARE PRINTED
 ;                   THEN MULTIPLE EXECUTE CODES CAN BE SEPARATED BY ";".
 ; 3      PREEXEC    EXECUTE CODE TO DO BEF FLD PRINTS. USE TO SCREEN OUT
 ;                   PRINTING A FLD VALUE. FOR MULTIPLES SEPARATE BY ";"
 ; 4      PRECAPEX   EXECUTE CODE TO DO BEF PRINTING THE CAP OR FLD LBL.
 ;                   USE TO SCREEN OUT PRINTING A CAP/FLD LBL
 ; 5      POSTEXEC   EXECUTE CODE TO DO AFT PRINTING THE FLD DATA
 ;                   FOR MULTIPLES SEPARATE BY ";"
 ; 6      SKIPEXEC   EXECUTE CODE TO SKIP ENTIRE FLD
 ;
1 ;
 ;;--APPLICATION SUBMISSION DATA---------------------------------------------------
 ;;Date Submitted^?0^9000045.1101^.01^!?0^1^EDDTSUB||
 ;;App. Submitted via^?0^9000045.1101^.02^?40^2^APSUBVIA
 ;;Submission Reason^?0^9000045.1101^.03^!^3^APPREAS
 ;;Submitted by^?0^9000045.1101^.04^!^4^APPSUBBY
 ;;-
 ;;--SUBMISSION STATUS DATE------------SUBMISSION STATUS----------------------------
 ;;^?0^9000045.110101^.01;.02^?0^^APPSTADT||;W ?40
 ;;*END*
 ;;^?0^9000045.110101^.02^?40^4^APPSTAT
