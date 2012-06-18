BIFMAN ;IHS/CMI/MWR - FILEMAN CALLS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CALLS TO FILEMAN WITH PRE- AND POST-CALL VARIABLE SETTING.
 ;
 ;
 ;----------
DIC(DIC,DIC0,BIY,DICA,DICB,DICS,BIX,BIPOP,DICDR) ;EP
 ;---> CALL TO ^DIC - File lookup and/or add new entry.
 ;---> Parameters:
 ;     1 - DIC=DIC         (req)
 ;     2 - DIC0=DIC(0)     (req)
 ;     3 - BIY             (ret) Equal to Y from call to ^DIC.
 ;     4 - DICA=DIC("A")   (opt) Prompt
 ;     5 - DICB=DIC("B")   (opt) DEFAULT
 ;     6 - DICS=DIC("S")   (opt) Screen
 ;     7 - BIX             (opt) Equal to X if DIC(0)'["A".
 ;     8 - BIPOP           (opt) BIPOP=1 if DTOUT or DUOUT
 ;     9 - DICDR=DIC("DR") (opt) To specify fields to be asked when
 ;                               adding a new entry.
 ;
 ;---> Example: D DIC^BIFMAN(9002086,"QEMAL",.Y,"   Select PATIENT: ")
 ;              To stuff an entry:
 ;              D DIC^BIFMAN(9002086,"QEML",.Y,,,,"NewEntry")
 ;
 N X,Y
 S:$G(BIX)]"" X=BIX
 I $G(DIC)']""!($G(DIC0)']"") S BIPOP=1 Q
 S BIPOP=0 S:DIC DLAYGO=$P(DIC,".")
 S DIC(0)=DIC0
 S:$G(DICA)]"" DIC("A")=DICA
 S:$G(DICB)]"" DIC("B")=DICB
 S:$G(DICDR)]"" DIC("DR")=DICDR
 S:$G(DICS)]"" DIC("S")=DICS
 D ^DIC
 S BIY=Y
 S:($D(DTOUT))!($D(DUOUT)) BIPOP=1
 D DKILLS
 Q
 ;
 ;
 ;----------
UPDATE(BIFN,BIIEN,BIFLD,BIERR,BIEXT) ;EP
 ;---> CALL TO UPDATE^DIE - To *ADD* new entry or subentry to a file.
 ;---> Parameters:
 ;     1 - BIFN   (req) File Number.
 ;     2 - BIIEN  (opt) IENS Array setting Seq Number=desire IEN in global.
 ;     3 - BIFLD  (req) Array of BIFLD(Field#)=Value, esp. need a .01 node,
 ;                      may need other required fields.
 ;     4 - BIERR  (ret) Text of error, if any.
 ;     5 - BIEXT  (opt) If BIEXT="E", tell UPDATE^DIE values are External.
 ;
 ;---> Example:  N BIERR,BIFLD,BIIEN
 ;               S BIIEN(1)=777  (This is to S DINUM=X; specify IEN in global)
 ;               S BIFLD(.01)=777
 ;               S BIFLD(.02)="This is a test of UPDATE~DIE."
 ;               D UPDATE^BIFMAN(9002084.33,.BIIEN,.BIFLD,.BIERR)
 ;               I $G(BIERR)]"" W !!?3,BIERR D DIRZ^BIUTL3()
 ;            OR
 ;               NOTE!: 2nd Parameter, BIIEN, is optional;
 ;                      But you must set BIFLD(.01)=something.
 ;               N BIERR,BIFLD
 ;               S BIFLD(.01)=BIDFN,BIFLD(.02)=BIPTR,BIFLD(.03)=BIREAS
 ;               D UPDATE^BIFMAN(9002084.11,,.BIFLD,.BIERR)
 ;
 N BIFDA,BIMSG,BISEQN
 ;
 ;---Check for valid File Number and Data Dictionary.
 I '$G(BIFN) D ERRCD^BIUTL2(671,.BIERR) Q
 I '$D(^DD($G(BIFN),0)) D ERRCD^BIUTL2(671,.BIERR) Q
 ;
 ;---> Set BISEQN is Sequence Number #1 set to ADD new top level entry.
 S BISEQN="+1,"
 ;---> Process External/Internal Flag value.
 S BIEXT=$S($G(BIEXT)=1:"E",1:"")
 ;
 ;---> Create FDA.
 N N S N=0
 F  S N=$O(BIFLD(N)) Q:'N  D
 .S BIFDA(BIFN,BISEQN,N)=BIFLD(N)
 ;
 D UPDATE^DIE(BIEXT,"BIFDA","BIIEN","BIMSG")
 ;
 S BIERR=$G(BIMSG("DIERR",1,"TEXT",1))
 I BIERR'="" S BIERR=BIERR_" (software error) #674"
 D DKILLS
 Q
 ;
 ;
 ;----------
DDS(DDSFILE,DR,DA,DDSPARM,DDSSAVE,BIPOP) ;EP
 ;---> CALL TO ^DDS
 ;---> NOTE: Screenman automatically uses incremental locks.
 ;---> Parameters:
 ;     1 - DDSFILE=FILE# (req)
 ;     2 - DR=FORM       (req)
 ;     3 - DA=RECORD     (req)
 ;     4 - DDSPARM (C/E) (opt) C=Register change in DDSCHANG
 ;     5 - DDSSAVE       (ret) $G(DDSSAVE)=1 if user saved changes.
 ;     6 - BIPOP         (ret) FAIL/QUIT/TIMEOUT
 ;
 ;---> Examples:
 ;     D DDS^BIFMAN(9002086.02,"[BI SITE PARAMS-FORM-1]",+Y)
 ;     D DDS^BIFMAN(9002086.1,"[BI PROC-FORM-LAB]",DA,"C",.BICHG,.BIPOP)
 ;
 N BIDA,X,Y S BIDA=DA,BIPOP=0
 I DDSFILE S DDSFILE=^DIC(DDSFILE,0,"GL")
 I $G(BIDA) L +@(DDSFILE_BIDA_")"):5 I '$T S BIPOP=1 D LOCKED^BIUTL3 Q
 K ^TMP("DDS",$J)
 I '$D(IOST(0)) D HOME^%ZIS,ENS^%ZISS
 D ^DDS
 S:$D(DTOUT) BIPOP=1
 I $D(DIMSG)!($D(DIERR)) D  S BIPOP=1
 .W !?5,"* The Screen Manager could not edit this record."
 .W !?7,"Please contact your Site Manager." D DIRZ^BIUTL3(.BIPOP)
 I $G(BIDA) L -@(DDSFILE_BIDA_")")
 D DKILLS
 Q
 ;
 ;
 ;----------
DIE(DIE,DR,DA,BIPOP,Z) ;EP
 ;---> CALL TO ^DIE - Edit entry in a file.
 ;---> Parameters:
 ;     1 - DIE=DIE (req)
 ;     2 - DR=DR   (req)
 ;     3 - DA=DA   (req)
 ;     4 - BIPOP   (ret) BIPOP=1 indicates failure/quit
 ;     5 - Z       (opt) Z=1 if user should *NOT* be notified
 ;                            record was locked.
 ;
 ;---> Example: D DIE^BIFMAN(9002086,DR,+Y,.BIPOP)
 ;              (+Y from DIC call, DR could be literal if short.)
 ;
 N BIDA,X,Y S BIDA=DA,BIPOP=0
 I DIE S DIE=^DIC(DIE,0,"GL")
 L +@(DIE_BIDA_")"):5 I '$T S BIPOP=1 D:'$G(Z) LOCKED^BIUTL3 Q
 D ^DIE
 S:($D(DTOUT))!($D(Y)) BIPOP=1
 L -@(DIE_BIDA_")")
 D DKILLS
 Q
 ;
 ;
 ;----------
FDIE(BIFN,BIIENS,BIFLD,BIERR,BIEXT) ;EP - Call to FILE^DIE.
 ;---> CALL TO FILE^DIE - File validated data into an *EXISTING* entry in a file.
 ;---> Parameters:
 ;     1 - BIFN   (req) File Number.
 ;     2 - BIIENS (req) IENS comma-delimited String.
 ;     3 - BIFLD  (req) Array of BIFLD(Field#)=Value
 ;     4 - BIERR  (ret) Text of error, if any.
 ;     5 - BIEXT  (opt) If BIEXT=1, tell FILE^DIE values are External.
 ;
 ;---> Example:
 ;---> Build FDA field=value array.
 ;N BIFLD
 ;S BIFLD(.08)=E
 ;S BIFLD(.09)=C
 ;S BIFLD(.1)=B
 ;S BIFLD(.11)=D
 ;
 ;---> Store edit data.
 ;---> Example: D FDIE^BIFMAN(9002084,+BIIEN,.BIFLD,.BIERR)
 ;
 ;
 N BIDA,BIFDA,BIGBL,BIMSG
 ;
 ;---Check for valid File Number and Data Dictionary.
 I '$G(BIFN) D ERRCD^BIUTL2(671,.BIERR) Q
 I '$D(^DD($G(BIFN),0)) D ERRCD^BIUTL2(671,.BIERR) Q
 ;
 ;---> Check for valid IEN.
 I '$G(BIIENS) D ERRCD^BIUTL2(672,.BIERR) Q
 ;---> Append mandatory terminating comma to IENS if not present.
 S:($E(BIIENS,$L(BIIENS))'=",") BIIENS=BIIENS_","
 S BIDA=$P(BIIENS,",",($L(BIIENS,",")-1))
 ;
 ;---Check for valid global.
 S BIGBL=$G(^DIC(BIFN,0,"GL"))
 I BIGBL="" D ERRCD^BIUTL2(601,.BIERR) Q
 ;
 ;---> Check for existence of the top level entry to be edited.
 I '$D(@(BIGBL_BIDA_",0)")) D ERRCD^BIUTL2(673,.BIERR) Q
 ;
 ;---> Lock entry or quit if unavailable.
 L +@(BIGBL_BIDA_")"):5 I '$T D ERRCD^BIUTL2(670,.BIERR) Q
 ;
 ;---> Process External/Internal Flag value.
 S BIEXT=$S($G(BIEXT)=1:"E",1:"")
 ;
 ;---> Create FDA.
 N N S N=0
 F  S N=$O(BIFLD(N)) Q:'N  D
 .S BIFDA(BIFN,BIIENS,N)=BIFLD(N)
 ;
 D FILE^DIE(BIEXT,"BIFDA","BIMSG")
 L -@(BIGBL_BIDA_")")
 S BIERR=$G(BIMSG("DIERR",1,"TEXT",1))
 I BIERR'="" S BIERR=$E(BIERR,1,($L(BIERR)-1))_" (software error). #674"
 D DKILLS
 Q
 ;
 ;
 ;----------
DIR(DIR0,Y,BIPOP,DIRA,DIRB,DIRQ,DIRQ1) ;EP
 ;---> Call to ^DIR - General purpose reader, for prompts, etc.
 ;---> Parameters:
 ;     1 - DIR0=DIR(0)      (req) Indicate type of read
 ;     2 - Y                (ret) From call to ^DIR
 ;     3 - BIPOP            (ret) BIPOP=1 if DIRUT
 ;     4 - DIRA=DIR("A")    (opt) Prompt
 ;     5 - DIRB=DIR("B")    (opt) Default
 ;     6 - DIRQ=DIR("?")    (opt) Help
 ;     7 - DIRQ1=DIR("?",1) (opt) Addtional help
 ;
 ;---> Example: D DIR^BIFMAN("SAM",.Y,.BIPOP,"   Select FORMAT: ")
 ;
 I $G(DIR0)']"" S BIPOP=1 Q
 N DIR,X S BIPOP=0,DIR(0)=DIR0
 S:$G(DIRA)]"" DIR("A")=DIRA
 S:$G(DIRB)]"" DIR("B")=DIRB
 S:$G(DIRQ)]"" DIR("?")=DIRQ
 S:$G(DIRQ1)]"" DIR("?",1)=DIRQ1
 D ^DIR
 S:$D(DIRUT) BIPOP=1
 D DKILLS
 Q
 ;
 ;
YESNO ; EP
 ;---> * NOT USED! *
 ;---> Sample Code for Yes/No question.
 W !!?3,"Should this patient's Status be Yes or No?",!
 N DIR
 S DIR(0)="YA"  ; Add "O" (YAO) to make answer optional.
 ;              ; "A" means Append nothing to the DIR("A") prompt.
 S DIR("A")="   Enter Yes or No: "  ; Prompt.
 S DIR("B")="NO"  ; Default.
 S DIR("?",1)="     Enter YES to say Yes."  ; First line of "?" help.
 S DIR("?")="     Enter No to say No."  ; Last line of "?" help.
 D ^DIR W !
 ;---> If answer is YES, Y=1.
 D:Y=1
 .N BIFLD,BIERR S BIFLD(.08)="",BIFLD(.16)=""
 .D FDIE^BIFMAN(9002084,BIDFN,.BIFLD,.BIERR,1)
 .I $G(BIERR)]"" W !!?3,BIERR D DIRZ^BIUTL3() S BIPOP=1
 Q
 ;
 ;
 ;----------
FILE(DIC,X,DIC0,DICDR,DINUM,Y,BIPOP) ; EP - Call FILE^DICN
 ;---> Add a new entry to a file.
 ;---> Parameters:
 ;     1 - DIC    (req) DIC, numeric or global ref
 ;     2 - X      (req) .01 value to be added
 ;     3 - DIC0   (req) DIC(0), input parameter string
 ;     4 - DICDR  (opt) DIC("DR")
 ;     5 - DINUM  (opt) IEN of entry to be added
 ;     6 - Y      (ret) Value of Y returned by ^DICN
 ;     7 - BIPOP  (ret) BIPOP=1 if DTOUT OR DUOUT
 ;
 ;---> Example: D FILE^BIFMAN(9002084.35,N,"ML",".02////3")
 ;
 K DD,DO
 I DIC S DLAYGO=DIC,DIC=^DIC(DIC,0,"GL")
 S:$G(DICDR)]"" DIC("DR")=DICDR S DIC(0)=DIC0
 D FILE^DICN
 S BIPOP=$S(($D(DTOUT)!($D(DUOUT))):1,1:0)
 D DKILLS
 Q
 ;
 ;
 ;----------
DIK ; EP - CALL ^DIK
 D ^DIK
 D DKILLS
 Q
 ;
 ;
 ;----------
DIQ ; EP - CALL ^DIQ
 D EN^DIQ
 D DKILLS
 Q
 ;
 ;
 ;----------
DIQ1 ; EP - CALL ^DIQ1
 D EN^DIQ1
 D DKILLS
 Q
 ;
 ;
 ;----------
DKILLS ;EP
 K D,D0,D1,DA,DD,DDH,DI,DIADD,DIC,DIC1,DICR,DIE,DIG,DIH,DIK,DILC
 K DINUM,DIRUT,DIQ,DIQ2,DIR,DIU,DIW,DIWF,DIWL,DIWR,DIWT,DK,DL
 K DLAYGO,DN,DQ,DR,DTOUT,DUOUT,DX
 D CLEAN^DILF
 Q
