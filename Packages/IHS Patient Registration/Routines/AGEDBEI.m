AGEDBEI ; VNGT/HS/BEE - DISPLAY/EDIT CLOSED CASES ;    
 ;;7.1;PATIENT REGISTRATION;**8**;AUG 25, 2005
 ;
 Q
 ;
CLS(DFN,CLOSED) N ROUTID,DORTN,PARAM1,PARAM2,DTOUT,DUOUT,DIROUT
 ;
VAR N CHOICES,DIR,DQOUT,Y
DRAW ;EP
 S AG("PG")="5BEI"
 S ROUTID=$P($T(+1)," ")
 D ^AGED  ;SCREEN HEADER ROUTINE
 D GETAW
 ;
 S DIR("A")="Select 1-"_AG("N")
 S DIR("?",1)="Enter the item number of the case you wish to reopen."
 S DIR(0)="N^1:"_AG("N")_":0"
 ;
 ;
 D READ^AGED1
 G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!('+Y) EXIT
 I AG("N")=0 W !,"There are no items to select!" H 3 G EXIT
 I $D(DQOUT)!(+Y<1)!(+Y>AG("N"))!'$D(CHOICES(+Y)) W !!,"You must enter a number from 1 to ",AG("N") H 2 K AG,CHOICES,DIR,DQOUT,Y G VAR
 S PARAM1=$P(CHOICES(+Y),U,2),PARAM2=$P(CHOICES(+Y),U,3)
 ;
 ;Remove Closed Status
 D STAT(PARAM1,PARAM2)
 ;
 ;Remove Completed By
 D COMBY(PARAM1,PARAM2)
 ;
 ;Remove Date Completed
 D COMDT(PARAM1,PARAM2)
 ;
 ;Update the registration
 D UPDATE1^AGED(DUZ(2),DFN,3,"")
 ;
 ;Edit the Case
 S DORTN="EN^AGEDBEB("_PARAM1_","_PARAM2_","_"0)" D @DORTN K AG,CHOICES,DIR,DQOUT,Y G VAR
 ;
EXIT K ROUTID,DORTN,PARAM1,PARAM2,DTOUT,DUOUT,DIROUT
 K AG,CHOICES,DIR,DQOUT,Y
 Q
GETAW ;DISP
 N AUPNPAT,BD0,ITEM,AGSCRN
 S AUPNPAT=$G(DFN)
 I AUPNPAT="" W !!,"PATIENT IEN NOT DEFINED!" H 2 Q
 ;
 S BD0=$O(^AUPNBENR("B",AUPNPAT,""))  ;GET CASE IEN OF PATIENT THEN GET ALL CASES ASSIGNED TO BEN. COORD.
 K AG("C")
 S ITEM=0
 F AG=1:1 D  Q:$G(AGSCRN)[("*END*")
 . N CAPTION,CAPDENT,DIC,EXECUTE,ITEMNUM,NEWLINE,POSTEXEC,PRECAPEX,PREEXEC,TAGCALL,VD0,VDR
 . S AGSCRN=$P($T(@2+AG),";;",2,15)  ;OPTIONAL DISP
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
 . ;
 . S VD0=BD0
 . ;
 . ;Pull Case Information
 . ;
 . I DIC["9000044."  D
 .. N CDT,BD1,D0
 .. I $G(BD0)="" S BD0="NOREF"
 .. I '$O(^AUPNBENR(BD0,11,0)) W !,"PATIENT HAS NO CASE DATE ENTRIES!",! Q
 .. ;
 .. ;Get list of closed cases, sort by complete date
 .. N CLCASE,CLIEN
 .. S CLIEN=0 F  S CLIEN=$O(^AUPNBENR(VD0,11,CLIEN)) Q:'CLIEN  D
 ... N ST,CDT
 ... ;
 ... ;Only retrieve closed cases
 ... S ST=$$GET1^DIQ(9000044.11,CLIEN_","_VD0_",",.07,"I") Q:ST'="C"
 ... S CDT=$$GET1^DIQ(9000044.11,CLIEN_","_VD0_",",.11,"I") Q:CDT=""
 ... S CLCASE(CDT,CLIEN)=""
 .. ;
 .. ;Loop through list and display
 .. S CDT="" F  S CDT=$O(CLCASE(CDT),-1) Q:CDT=""  S BD1="" F  S BD1=$O(CLCASE(CDT,BD1)) Q:'BD1  D
 ... S D0=BD1_","_VD0_","
 ... S ITEM=ITEM+1
 ... S CHOICES(ITEM)=DIC_U_VD0_U_BD1
 ... I ITEM=1 W ?0,ITEM_"."
 ... E  W !,ITEM_"."
 ... N PIECE,DR
 ... F PIECE=1:1 S DR=$P(VDR,";",PIECE) Q:DR=""  D 
 .... I $P(PREEXEC,";",PIECE)'="" X $P(PREEXEC,";",PIECE)
 .... I $P(EXECUTE,";",PIECE)="" D
 ..... W $S(DR=.02:$E($$GET1^DIQ(DIC,D0,DR),1,15),DR=.12:$E($$GET1^DIQ(DIC,D0,DR),1,29),1:$$GET1^DIQ(DIC,D0,DR))
 .... I $P(EXECUTE,";",PIECE)'="" X $P(EXECUTE,";",PIECE)
 .... I $P(POSTEXEC,";",PIECE)'="" X $P(POSTEXEC,";",PIECE)
 ...K PIECE,DR
 S AG("N")=$G(ITEM)
 W !,$G(AGLINE("-"))
 ;
 Q
 ;
STAT(RD0,RD1) ;Erase Closed Status
 K DIC,DR,DIE,DA,DD,DO
 S DA(1)=RD0
 S DA=RD1
 S DIE="^AUPNBENR("_DA(1)_",11,"
 S DR=".07////@"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
 ;
COMBY(RD0,RD1) ;Erase Completed By
 K DIC,DR,DIE,DA,DD,DO
 S DA(1)=RD0
 S DA=RD1
 S DIE="^AUPNBENR("_DA(1)_",11,"
 S DR=".09////@"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
 ;
COMDT(RD0,RD1) ;Erase Date Completed
 K DIC,DR,DIE,DA,DD,DO
 S DA(1)=RD0
 S DA=RD1
 S DIE="^AUPNBENR("_DA(1)_",11,"
 S DR=".11////@"
 D ^DIE
 K DIC,DR,DIE,DA
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
 ;
 ;CLOSED CASES DISPLAY
2 ;
 ;;-                             BENEFITS COORDINATION
 ;;-================================================================================
 ;;-COMPLETED DATE  CASE DATE       ASSIGNED TO       REASON
 ;;---------------------------------------------------------------------------------
 ;;^?0^9000044.11^.11;.01;.02;.12^?0^^|;;;;;W $S($$GET1^DIQ(DIC,D0,DR)="":"OPEN",1:$$GET1^DIQ(DIC,D0,DR))|;W ?17;W ?33;W ?51
 ;;*END*
