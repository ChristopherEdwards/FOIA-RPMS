BMXADOS ; IHS/CIHA/GIS - UPDATE THE BMX ADO SCHEMA FILE ;
 ;;4.0;BMX;;JUN 28, 2010
 ; ENABLES NAVIGATION TO SUBFILES PRIOR TO UPDATING THE SCHEMA FILE ENTRY
 ; 
 ; 
 ; 
UPDATE ; UPDATE THE SCHEMA FILE
 N DIC,X,Y,%,STOP,FIEN,FNAME,SNAME,SIEN
UDIC S DIC("A")="Enter schema name: " ; EP FROM VENPCCTU
 S DIC(0)="AEQLM",DIC="^BMXADO("
 D ^DIC I Y=-1 G FIN
SCHEMA S SNAME=$P(Y,U,2),SIEN=+Y
 S FIEN=$$FILE(SIEN) I 'FIEN G FIN
 I FIEN'=$P($G(^BMXADO(SIEN,0)),U,2) S DIE=DIC,DA=SIEN,DR=".02////^S X=FIEN" D ^DIE
 F  D FLD(FIEN,SIEN) I $G(STOP) Q  ; GET FIELD INFO
FIN D ^XBFMK
 Q
 ; 
FLD(FIEN,SIEN) ; GET THE FIELD
 N DIC,X,Y,DIE,DA,DR,FLDIEN,FLDNAME,FLDTYPE,FDEF,TRANS
 N %,%Y,HDR,DTYPE,LEN,FARR,I,TOT,PAUSE,PFLAG,IFLAG,IMSG,STG,READ
 D FLIST(.FARR,FIEN,0)
 S TOT=$O(FARR(9999),-1) I 'TOT S STOP=1 Q
 W !,"Select a field from this "_$S($D(^DD(FIEN,0,"UP")):"sub-",1:"")_"file: "
 S I=0 F  S I=$O(FARR(I)) Q:'I  S PAUSE=$$PAUSE(I) Q:PAUSE'=""  W I,?3,FARR(I)
 I $G(PAUSE)=U S STOP=1 Q
 I $G(PAUSE) S Y=PAUSE G FLD1
 S DIR(0)="NO^1:"_TOT_":",DIR("A")="Select a field from the list" K DA D ^DIR K DIR
 I 'Y S STOP=1 Q
FLD1 S %=FARR(+Y)
 S FLDIEN=+$P(%,"  [",2),FLDNAME=$P(%,"  [")
 I $$FDEL(SIEN,FLDIEN) Q  ; FIELD DELETED
 S X=$$FDEF(FIEN,FLDIEN) I '$L(X)  W " ??" Q
 S DTYPE=$E(X),LEN=+$E(X,2,6)
 S DIR(0)="F^1:30",DIR("A")="Column header",DIR("B")=FLDNAME D ^DIR K DIR
 S HDR=Y,TRANS=0
 S %=$P($G(^DD(FIEN,FLDIEN,0)),U,2) ; CHECK FM DD TO SEE IF FIELD IS REQUIRED
 I %["R" W !,"FileMan requires a non-null value for this field" S %=2
 E  W !,"Is null allowed" S %=$S(FLDIEN=.01:2,1:1) D YN^DICN I %Y?1."^" Q
 I %=2 S TRANS=1 ; NON NULL VALUE REQUIRED TO COMPLETE THE TRANSACTION OR THERE WILL BE ROLLBACK
 I $G(PFLAG) D  ; IF POINTER, ASK IF USER WANTS TO AUTOMATICALLY INSERT THE LOOKUP VALUE FIELD IN THE SCHEMA
 . W !,"This field is a pointer value (IEN)."
 . W !,"Want to automatically insert the lookup value in the schema"
 . S %=2 D YN^DICN W ! I %=1 S PFLAG=2
 . Q
IFLG I $G(IFLAG) D  ; NON-POINTER .01 FIELD.  ASK IF USER WANTS TO REFERENCE IDENTIFIER EP
 . W !,"Want to display identifiers with this field"
 . S %=2 D YN^DICN W ! I %'=1 Q
 . S IMSG="Respond with a valid entry point in the format 'TAG^ROUTINE'."
 . W !,"Entry Point to generate Identifiers: " R Y:$G(DTIME,60) E  Q  ; IHS/OIT/HMW SAC Exemption Applied For
 . I Y?1."^" Q
 . I Y?1."?" W !,IMSG S IFLAG(0)="!" Q
 . I Y'?1U.7UN1"^"1U.7UN S IFLAG(0)="!" W "  ??"
 . I $L(Y)>2 S IFLAG(0)=Y,IFLAG=2
 . Q
 I $G(IFLAG(0))="!" W !,IMSG K IPFLAG(0),IMSG W !!! G IFLG
 S DA(1)=SIEN,DIC="^BMXADO("_DA(1)_",1,"
 S DIC("P")=90093.991,DIC(0)="L",X=FLDIEN
 I '$D(^BMXADO(SIEN,1,0)) S ^BMXADO(SIEN,1,0)="^90093.991^^"
 D ^DIC I Y=-1 Q
 S READ=($P($G(^DD(FIEN,FLDIEN,0)),U,2)["C") ; COMPUTED FIELDS ARE READ ONLY!
 S DIE=DIC,DA=+Y
 S DR=".02///^S X=DTYPE;.03///^S X=LEN;.04///^S X=HDR;.05///^S X=READ;.06///0;.07///^S X=('TRANS)"
 D ^DIE
 I $G(IFLAG)=2 D ID
 I $G(PFLAG)'=2 Q
LKUP ; AUTOMATICALLY ADD A LOOKUP FIELD TO THE SCHEMA
 S X=FLDIEN_"IEN"
 D ^DIC I Y=-1 Q
 W !,"The LOOKUP field '"_X_"' has been added to the schema",!
 S HDR=HDR_"_IEN",DTYPE="I",LEN="00009"
 S DIE=DIC,DA=+Y
 S DR=".02///^S X=DTYPE;.03///^S X=LEN;.04///^S X=HDR;.05///^S X=READ;.06///0;.07///^S X=('TRANS)"
 D ^DIE
 Q
 ; 
ID ; AUTOMATICALLY ADD AN IDENTIFIER REFERENCE
 N X,Y,DIE,DR,DA,REF
 S X=".01ID",DA(1)=SIEN
 S REF=IFLAG(0) I '$L(REF) Q
 D ^DIC I Y=-1 Q
 W !,"The identifier field '"_X_"' has been added to the schema",!
 S HDR=HDR_"_ID",DTYPE="T",LEN="00017"
 S DIE=DIC,DA=+Y
 S DR=".02///^S X=DTYPE;.03///^S X=LEN;.04///^S X=HDR;.05///^S X=READ;.06///0;.07///^S X=('TRANS);1///^S X=REF"
 D ^DIE
 Q
 ; 
FDEL(SIEN,FIELD) ; DELETE AN EXISTING ENTRY FROM THE 'FIELD' MULTIPLE.  RETURN '1' IF THE RECORD WAS DELETED
 N FIEN,DA,DIK
 S FIEN=$O(^BMXADO(SIEN,1,"B",FIELD,0)) I 'FIEN Q 0  ; THIS IS A NEW ENTRY
 W !,"This field already is attached to the schema.  Want to delete it"
 S %=2 D YN^DICN
 I %'=1 Q 0
 S DA(1)=SIEN,DIK="^BMXADO("_DA(1)_",1,",DA=FIEN
 D ^DIK
 S FIEN=$O(^BMXADO(SIEN,1,"B",(FIELD_"IEN"),0))
 I FIEN S DA=FIEN D ^DIK ; DELETE LOOKUP VALUE FIELD AS WELL
 W " Done!",!
 Q 1
 ; 
FDEF(FILE,FIELD) ;EP - GIVEN A FILEMAN FILE AND FIELD, RETURN THE DATA DEFINITION IN ADO FORMAT
 N %,X,Y,Z,STG,I,DTYPE,FNAME,LEN,DNAME
 I '$D(^DD(+$G(FILE),+$G(FIELD),0)) Q ""
 S STG=$G(^DD(FILE,FIELD,0)) I '$L(STG) Q "" ; GET DATA DEF STRING
DTYPE S %="DNSFWCPVM",X=$P(STG,U,2),DTYPE="" ; GET DATA TYPE
 F I=1:1:$L(%) S Y=$E(%,I) I X[Y S DTYPE=Y Q
 I DTYPE="" Q ""
FNAME S DNAME=$P(STG,U) I '$L(DNAME) Q "" ; FIELD NAME
DDA ; ADO FORMAT
 I DTYPE="D" D  Q "D"_LEN_DNAME
 . S LEN="00021"
 . I STG["S %DT=" S %=$P(STG,"S %DT=",2),%=$P(%,$C(34))
 . I $G(FLDIEN)=.01 S IFLAG=1
 . I %["S" S LEN="00019" Q
 . I %["T" S LEN="00018" Q
 . Q
 I DTYPE="N",STG["1N.N" D  Q:'LEN "" Q "I"_LEN_DNAME ; INTEGER
 . S %=+$P(STG,"K:+X'=X!(X>",2)
 . S Y=$L(%)
 . S LEN=$E("00000",1,5-$L(Y))_Y
 . Q
 I DTYPE="N" D  Q:'LEN ""  Q "N"_LEN_DNAME ; NUMBER (COULD HAVE A DECIMAL VALUE)
 . S %=+$P(STG,"!(X?.E1"".""",2)
 . S X=+$P(STG,"K:+X'=X!(X>",2)
 . S Y=%+($L(+X))
 . S LEN=$E("00000",1,5-$L(Y))_Y
 . Q
 I DTYPE="F" D  Q:'LEN "" Q "T"_LEN_DNAME
 . S Y=+$P(STG,"K:$L(X)>",2)
 . S LEN=$E("00000",1,5-$L(Y))_Y
 . I 'LEN S LEN="00030"
 . I $G(FLDIEN)=.01 S IFLAG=1
 . Q
 I DTYPE="S" D  Q:'LEN "" Q "T"_LEN_DNAME
 . S X=$P(STG,U,3),Y=0
 . F I=1:1:$L(X,":") S Z=$P(X,":",2),Z=$P(Z,";"),%=$L(Z) I %>Y S Y=%
 . S LEN=$E("00000",1,5-$L(Y))_Y
 . Q
 I DTYPE="P" S PFLAG=1 Q "T00030"_DNAME
 I DTYPE="W" Q "T05000"_DNAME
 I DTYPE="V" Q ""
 Q "T00250"_DNAME
 ; 
FILE(SIEN) ; GET THE FILE OR SUBFILE NUMBER
 N FNO,FIEN,DIC,X,Y,%,FILE,NSTG,GBL,FNAME,SUB,FARR,TOT,I
 S (FILE,FNO)=$P(^BMXADO(SIEN,0),U,2)
OLD I FNO D  I $G(FIEN) Q FIEN
 . S NSTG=$O(^DD(FNO,0,"NM",""))
 . F  S FNO=$G(^DD(FNO,0,"UP")) Q:'FNO  S NSTG=$O(^DD(FNO,0,"NM",""))_"/"_NSTG
OLD1 . W !,$S(NSTG["/":"Sub-",1:""),"File #",FILE," (",NSTG,") is linked to this schema."
 . W !,"Want to keep it" S %=1
 . D YN^DICN I %'=2 W:%=1 " OK" S FIEN=FILE Q
 . W !!,"If you change or delete this file number,",!,"all the information in this schema will be deleted."
 . W !,"Are you sure you want to do this" S %=2 D YN^DICN
 . I %'=1 W !! G OLD1
 . S GBL="^BMXADO("_SIEN_")"
 . K @GBL@(1),@GBL@(2)
 . S $P(@GBL@(0),U,2)=""
 . W !,"This schema definition has been deleted.  You may redefine it now"
 . Q
NEW S DIC=1,DIC(0)="AEQM" D ^DIC I Y=-1 Q ""
 S FNO=+Y,FNAME=$P(Y,U,2)
NEW1 D SC(.FARR,FNO,1)
 S TOT=$O(FARR(999999),-1) I 'TOT Q FNO ; NO SUBFILES FOUND
 W !!,"The ",FNAME," file contains the following sub-file" I TOT>1 W "s"
 W !
 S I=0 F  S I=$O(FARR(I)) Q:'I  S PAUSE=$$PAUSE(I) Q:PAUSE'=""  W I,?3,FARR(I)
 I $G(PAUSE)=U Q ""
 I $G(PAUSE) S Y=PAUSE G NEW2
 W !!,"Is the schema linked to a sub-file in this list"
 S %=2 D YN^DICN I %=2 Q FNO
 S DIR(0)="NO^1:"_TOT_":",DIR("A")="Select a sub-file from the list" K DA D ^DIR K DIR
 I 'Y Q ""
NEW2 Q +$P(FARR(+Y),"  (",2)
 ; 
PAUSE(I) ; SCROLL CHECK
 N %
 W !
 I (I#20) Q ""
 W "Select a number from the list (1-",(I-1),") or press <ENTER> to continue: "
 R %:$G(DTIME,60) E  Q ""  ; IHS/OIT/HMW SAC Exemption Applied For
 I %?1."^" Q U
 I $L(%),$D(FARR(I)) Q %
 I $L(%) W " ??" H 2
 W $C(13),?79,$C(13)
 Q ""
 ; 
SC(OUT,FILE,MODE) ;EP - SUB CRAWLER.  GIVEN A FILE NUMBER RETURN ALL OF ITS DESCENDANT FILES IN AN ARRAY
 I '$D(^DD(FILE,"SB")) Q  ; NO DESCENDANTS
 N TOT,FNO,FNAME,FIEN,LEVEL,NODE,SARR,STG,X,%,UP,ARR
 S FIEN=FILE,TOT=0
 D PASS1
 I '$O(ARR(0)) Q
SC2 ; SECOND PASS. BUILD THE INTERMEDIATE ARRAY
 S FNO=0 F  S FNO=$O(ARR(FNO)) Q:'FNO  D
 . I $P($G(^DD(FNO,.01,0)),U,2)["W" K ARR(FNO) Q  ; WORD PROCESSING FIELDS DO NOT COUNT
 . S STG=FNO,UP=FNO
 . F  S UP=$G(^DD(UP,0,"UP")) Q:'UP  S STG=UP_","_STG ; BUILD DESCENDANT STRING
 . I $G(MODE) S STG=$$ASTG(STG)
 . S STG=$P(STG,",",2,99) ; DONT NEED TOP LEVEL FILE
 . I '$L(STG) Q  ; SOMETHING IS SCREWED UP
 . S LEVEL=$L(STG,",")
 . S FNAME=$O(^DD(FNO,0,"NM",""))
 . S X="SARR("_STG_")"
 . S @X=FNAME_U_LEVEL_U_FNO
 . K ARR(FNO)
 . Q
SC3 ; 3RD PASS.  BUILD OUTPUT ARAY
 S NODE="SARR"
 F  S NODE=$Q(@NODE) Q:NODE=""  D
 . S X=@NODE
 . S TOT=TOT+1
 . S FNAME=$P(X,U)
 . S LEVEL=$P(X,U,2)
 . S FNO=$P(X,U,3)
 . S OUT(TOT)=$E("          ",1,LEVEL)_FNAME_"  ("_FNO_")"
 . Q
 Q
 ;
PASS1 ; PASS 1.  BUILD THE ARRAY OF ALL SUBFILES
 N FNO S FNO=0
 F  S FNO=$O(^DD(FIEN,"SB",FNO)) Q:'FNO  D
 . S ARR(FNO)=""
 . I '$D(^DD(FNO,"SB")) Q
 . N FIEN S FIEN=FNO
 . D PASS1 ; RECURSION!!
 . Q
 Q
 ; 
ASTG(STG) ; CONVERT STRING FROM FILE NUMBERS TO FILE NAMES
 N PCE,LEV,FNO,NAME
 S LEV=$L(STG,",")
 F PCE=1:1:LEV S FNO=+$P(STG,",",PCE) D  I '$L(STG) Q ""
 . S NAME=$O(^DD(FNO,0,"NM",""))
 . I $E(NAME)="*" S NAME=$E(NAME,2,99)
 . I '$L(NAME) S STG="" Q
 . S $P(STG,",",PCE)=""""_NAME_""""
 . Q
 Q STG
 ;
FLIST(OUT,FILE,MODE) ;EP - GIVEN A FILE RETURN THE FILEDS IN AN ARRAY  MODE=0: NUMERIC ORDER, MODE=1: ALPHA ORDER
 ; ONLY NON MULTIPLES AND WORD PROCESSING FIELDS ARE LISTED
 N FLD,TOT,NAME,ARR,SS,%,WP
 S FLD=0,TOT=0
F1 F  S FLD=$O(^DD(FILE,FLD)) Q:'FLD  D  ; PASS 1
 . S STG=$G(^DD(FILE,FLD,0)) I '$L(STG) Q
 . S %=$P(STG,U,2)
 . I %,$P($G(^DD(%,.01,0)),U,2)'["W" Q  ; EXCLUDE ALL MULTIPLE FIELDS EXCEPT WORD PROCESSING FIELDS
 . S WP=0 I % S WP=1
 . S NAME=$P(STG,U)
 . S SS=FLD
 . I $G(MODE)=1 S %=NAME S:$E(%)="*" %=$E(%,2,99) S SS=%
 . S ARR(SS)=FLD_U_NAME_U_WP
 . Q
F2 S SS=""
 F  S SS=$O(ARR(SS)) Q:SS=""  D
 . S TOT=TOT+1
 . S %=ARR(SS)
 . S OUT(TOT)=$P(%,U,2)_"  ["_+%_"]"_$S($P(%,U,3):"  (word processing)",1:"")
 . K ARR(SS)
 . Q
 Q
 ; 
