BAREDP03 ; IHS/SD/LSL - EDI CLAIM & POSTING ELEMENTS ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,20**;OCT 26,2005
 ;
 ; IHS/SD/LSL - 09/16/03 - V1.7 Patch 4 - HIPAA
 ;
 ; ********************************************************************
 ;
EN(TRDA,IMPDA) ; EP
 ; Process segments into claims with postable data
 D SETVAR
 W !,"Processing Record Values into Postable Claims",!
 S COUNT=1
 K ^TMP($J,"REC"),IMGDA,CLMDA
 ;clear 'processing image' & 'claims'
 K ^BAREDI("I",DUZ(2),IMPDA,30)
 K ^BAREDI("I",DUZ(2),IMPDA,40)
 S ^BAREDI("I",DUZ(2),IMPDA,40,0)="^^^"_DT_"^"
 S (CLMDA,LINE)=0
 ; pull records to scan for variable pulling and processing
 D ENPM^XBDIQ1(90056.0202,"IMPDA,0",".01;.03;.04;1.01","^TMP($J,""REC"",")
 S REC="^TMP($J,""REC"")"
 ; loop and check if record has posting variables
 ; if so, processes the segment, elements, variables' pocessing
 ; build claims demographics & adjustments
 S RECDA=""
 F  S RECDA=$O(@REC@(RECDA)) Q:RECDA'>0  D
 . S SEGDA=$P(@REC@(RECDA,.04),",",2) ;pull segment da from path
 . ; check index for variables to pull
 . I '$D(^BAREDI("1T",TRDA,10,SEGDA,10,"C")) Q
 . D PULLVARS
 ;
 W " ",COUNT,!
 ; set claims' status to B 'Built'
 K DIE,DIC,DR,DA
 S DIE=$$DIC^XBDIQ1(90056.0205)
 S DA(1)=IMPDA
 S DR=".02////B"
 S CLMDA=0
 S CLPAMT=0 K CLP  ;bar*1.8*20 REQ5
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA)) Q:CLMDA'>0  D
 .S DA=CLMDA
 .D ^DIE
 .;start new code bar*1.8*20 REQ5
 .S IENS=CLMDA_","_IMPDA_","
 .S CLPAMT=$$GET1^DIQ(90056.0205,IENS,".04")
 .S CLMCK=$$GET1^DIQ(90056.0205,IENS,201)
 .S CLP(CLMCK)=+$G(CLP(CLMCK))+CLPAMT
 S CKDA=0,FLG=0
 W $$EN^BARVDF("IOF")
 W !,"Checking balance of each check within ERA...",!
 F  S CKDA=$O(^BAREDI("I",DUZ(2),IMPDA,5,CKDA)) Q:'CKDA  D
 .S IENS=CKDA_","_IMPDA_","
 .S CK=$$GET1^DIQ(90056.02011,IENS,".01")
 .S CKAMT=$$GET1^DIQ(90056.02011,IENS,".03")
 .S PLBAMT=$$GET1^DIQ(90056.02011,IENS,".09")
 .W:FLG=0 !?40,"(CLP04)",?55,"(PLB)",?70,"(BPR02)"
 .I (+$G(CLP(CK))-PLBAMT)'=CKAMT W !,"Check "_CK_" does NOT balance "
 .I (+$G(CLP(CK))-PLBAMT)=CKAMT W !,"Check "_CK_" balances "
 .W ?35,$J($FN(+$G(CLP(CK)),",",2),12)_" - "_$S(+$$GET1^DIQ(90056.02011,IENS,".09")=0:"  NO PLB ",1:$J($FN(+PLBAMT,",",2),10))_" <> "_$J($FN(+CKAMT,",",2),12),!
 .S FLG=1
 ;end new code REQ5
 ;
 Q
 ; *********************************************************************
 ;
PULLVARS  ;EP
  ; pull and process posting variables from segments
 M XREC=@REC@(RECDA)
 ;XREC(1.01)=raw segment XREC(.04) is path
 ;
 S D0S=XREC(.04)_",0" ; path,0
 ; pull elements and build Sequence array  SEQ(piece)=varname
 K ELM,SEQ
 D ENPM^XBDIQ1(90056.0102,D0S,".03;.08","ELM(")
 S ELMDA=0
 F  S ELMDA=$O(ELM(ELMDA)) Q:ELMDA'>0  D
 . Q:ELM(ELMDA,.08)=""
 . S SEQ(ELM(ELMDA,.03)+1)=ELM(ELMDA,.08)
 ;
 ;BAR*1.8*1 SRS PATCH 1 ADDENDUM
 ;NEED TO CLEAR OUT VARIABLES SO NONE
 ;LINGER FROM SEGMENT REPEATS
 S PIECE=""
 F  S PIECE=$O(SEQ(PIECE)) Q:PIECE=""  D
 .S VARNM=SEQ(PIECE)
 .K @VARNM
 ;END BAR*1.8*1 SRS PATCH 1 ADDENDUM
 ; store lines into 'PROCESSING IMAGE'
 ; store claim information
 K RECORD ; RECORD IMAGE
 ;initialize image
 ;initialize Claims
 D ENP^XBDIQ1(90056.0202,"IMPDA,RECDA",10,"RECORD(")
 S PIECE=0
 F  S PIECE=$O(SEQ(PIECE)) Q:PIECE'>0  D
 . S VARNM=SEQ(PIECE)
 . S @VARNM=$G(^BAREDI("I",DUZ(2),IMPDA,20,RECDA,10,PIECE-1,0))
 . S VARVAL=RECORD(10,PIECE-1)
 . D IMAGE
 . ; the next line executes the table routine if the 
 . ; variable has a routine to perform entered into the tables
 . ; otherwise function point processing
 . I $D(VAR(VARNM)) D @VAR(VARNM)
 Q
 ; *********************************************************************
 ;
IMAGE ; EP
 ; increment and store list of processing variables into image
 Q:'$L(VARVAL)
 S X=VARNM_"     "_@VARNM
 S IMGDA=$G(IMGDA)+1
 S ^BAREDI("I",DUZ(2),IMPDA,40,IMGDA,0)=X
 Q
 ; *********************************************************************
 ;
SETVAR ; EP
 ; pull names of variables for triggering processing points
 ; as VAR("NEWBILL")="NEWBILL^BAREDPA3"
 K VAR,VARM
 D ENPM^XBDIQ1(90056.0111,"TRDA,0",".01;.02","VARM(")
 S VARDA=""
 F  S VARDA=$O(VARM(VARDA)) Q:VARDA'>0  D
 . S NM=VARM(VARDA,.01)
 . S ROU=VARM(VARDA,.02)
 . S ROU=$TR(ROU,"|","^")
 . S VAR(NM)=ROU
 K VARM
 Q
