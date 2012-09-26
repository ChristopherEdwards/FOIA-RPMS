VENPCCP2 ; IHS/OIT/GIS - PRINT DEAMON - MANAGE ERRORS ;
 ;;2.6;PCC+;**1,3**;APR 03, 2012;Build 24
 ;
 ; REGISTER ERRORS, DELETE ERRORS, UPDATE THE ERROR LOG, UPDATE ERROR MESSAGES, COUNT DOCUMENTS THAT FAILED TO PRINT, DISPLAY USER MESSAGE, DISPLAY SITE MANAGER INSTRUCTIONS
 ;
REG(EIEN,ERR) ; EP - REGISTER AN ERROR
 ; I $L($T(REG^VENPCCE1)),$D(MN),$D(FIEN) D REG^VENPCCE1(EIEN,ERR) Q  ; PCC+ ENTERPRISE EDITION
 N TYPE
 S ERR=$G(ERR)
 I '$D(^VEN(7.71,+$G(EIEN),0)) Q  ; MUST BE A VALID ERROR
 S TYPE=$P($G(^VEN(7.71,+$G(EIEN),0)),U,2) I 'TYPE Q  ; MUST HAVE A VALID ERROR TYPE
 D FILE(EIEN,TYPE,ERR)
 D FLAG(EIEN,TYPE)
 D MSG(EIEN,TYPE,ERR)
 Q
 ; 
FILE(EIEN,TYPE,ERR) ; EP-CREATE AN ERROR LOG ENTRY
 I '$L($G(FILE))!'$L($G(PATH)) Q
 I $G(DUZ(0))'="@" D
 . S %=$C(68,85,90)
 . S @%@(0)=$C(64)
 . Q
 I $E(FILE)="z" Q  ; ERROR ALREADY LOGGED
 I $G(EIEN)=4 D BEF(FILE,PATH) I 1 ; BLOCK INVALID TEMPLATE & REMOVE BAD FILE
 E  S FILE=$$RENAME(FILE,PATH) ; RENAME AS "z" FILE BEFORE ENTERING IT INTO THE LOG
 I TYPE'=1,'$D(^DPT(+$G(DFN),0)),'$G(MERR) Q
 NEW %,%DT,%H,%I,%Q,%Y,D,D0,DA,DI,DIC,DIE,DQ,DR,X,Y,DLAYGO,ACK
 S ACK=$S(TYPE=1:0,1:1)
 D NOW^%DTC S X=%
 S DIC="^VEN(7.7,",DIC(0)="L",DLAYGO=19707.7 D ^DIC
 I Y=-1 Q
 S DIE=DIC,DA=+Y
 S DR=".02////^S X=$G(VISIT);.03////^S X=$G(DUZ);.04////^S X=$G(DUZ(2));.05////^S X=$G(VENDEV);.11////^S X=$G(EIEN);.07////^S X=$G(DFN)"
 S DR=DR_";.08////^S X=$G(PGIEN);.09////^S X=$G(FILE);.06////^S X=$G(ACK);.12////^S X=$G(TYPE);.13////^S X=$G(DEFEF);.14////^S X=$G(IP);.15////^S X=$G(MRPFLAG);1////^S X=$G(ERR)"
 L +^VEN(7.7):2 I $T D ^DIE L -^VEN(7.7)
 Q
 ;
BEF(FILE,PATH) ; DELETE THE FILE AND TAKE THE TEMPLATE OUT OF SERVICE
 D DEL^VENPCCP1(PATH,FILE) ; DONT CREATE A Z FILE. JUST DELETE THE BAD FILE
 Q
 ; 
FLAG(EIEN,TYPE) ; EP-SET TMP GBL
 I $G(EIEN)=4 D DEL^VENPCCP1(PATH,FILE) Q  ; NO ERROR FLAG NEEDED WITH INVALID FORM
 N TMP,ID,COUNT,MAX,OVER,TOT
 S TMP="^TMP(""VEN ERROR FLAG"")"
 S ID=$S(TYPE=2:$G(PGIEN),1:0) I TYPE=2,'ID Q
 S COUNT=+$$COUNT($G(PATH),TYPE,ID,EIEN)
 I TYPE=1 G FLAG1
 S MAX=$P($G(^VEN(7.4,+$G(PGIEN),2)),U,1) I 'MAX S MAX=20
 I COUNT>MAX D
 . D FILES(PATH,"^TMP(""VEN MAX CLEAN"",$J)")
 . S OVER=COUNT-MAX
 . S FILE="z" F TOT=1:1:OVER S FILE=$O(^TMP("VEN MAX CLEAN",$J,FILE)) Q:'$L(FILE)  D DEL^VENPCCP1(PATH,FILE)
 . S COUNT=MAX
 . K ^TMP("VEN MAX CLEAN",$J)
 . Q
FLAG1 S @TMP@(TYPE,ID,EIEN)=COUNT
 Q
 ; 
MSG(EIEN,TYPE,ERR) ; EP-CREATE AN ERROR MESSAGE
 N MSG,TXT
 I EIEN'=10 S TXT=$P($G(^VEN(7.71,+$G(EIEN),0)),U)
 E  S TXT=$G(ERR)
 I '$L(TXT) Q
 S MSG=$S(TYPE=1:"FATAL ",1:"")_"ERROR: "_TXT
 S ^TMP("VEN TASK",$J)=MSG
 Q
 ; 
COUNT(PATH,TYPE,ID,EIEN) ; EP-COUNT FILES WAITING TO BE PROCESSED
 I '$L($G(PATH)) Q 0
 N FILE,CNT,TMP
 S CNT=0,TMP="^TMP(""VEN ERR CNT"","""_$J_""")" K @TMP
 D FILES(PATH,TMP) I '$D(@TMP) Q 0
 S FILE="z" F  S FILE=$O(@TMP@(FILE)) Q:$E(FILE)'="z"  D
 . I FILE'[".txt" Q
 . I '$$OK(FILE,TYPE,ID,EIEN) Q
 . S CNT=CNT+1
 . Q
 K @TMP
 Q CNT
 ; 
OK(FILE,TYPE,ID,EIEN) ; EP-DETERMINE IF A Z FILE IN PRINT DEAMON QUEUE MEETS SEARCH CRITERIA
 N OK,ERIEN,STG,ETYP,EID,MRPFLAG,PRGIEN
 S OK=0
 I $E(FILE)'="z",$E(FILE)'="Z" Q 0 ; ONLY COUNT "FAILED" FILES
 S ERIEN=$O(^VEN(7.7,"F",FILE,0)) I ERIEN="" Q 0 ; FAILED ER LOG LOOKUP
 I TYPE=1 Q 1
 S STG=$G(^VEN(7.7,ERIEN,0)) I '$L(STG) Q 0
 S ETYP=$P(STG,U,12),EID=$P(STG,U,11) I ETYP,EID
 E  Q 0
 I TYPE=4,EID=EIEN Q 1
 I TYPE'=2 Q 0
 I TYPE=2,ETYP=11,$P($G(^VEN(7.4,+$G(ID),0)),U,2) Q 1 ; MED REC PRINT GROUP BEING CALLED IN THIS TRANSACTION & MRPG ERROR IS ACTIVE
 S PRGIEN=$P(STG,U,8) I 'PRGIEN Q 0
 I EID=EIEN,PRGIEN=ID,ETYP=2 Q 1
 Q 0
 ;
MERGFAIL(ACK,MRPFLAG,PGIEN) ; EP-MAIL MERGE FAILURES
 I '$L(ACK) D REG(1,"Print service starts but fails to respond during mail merge process") Q  ; MAIL MERGE RESPONCE FAILURE
 I ACK=-1 D REG(4,"Microsoft Word Mail Merge failure") Q  ; GENL PRINT SVC ERROR
 I ACK=-2,MRPFLAG D REG(11,"Medical Records Printer is turned off or is out of paper") Q  ; OUT OF PAPER
 I ACK=-2 D REG(5,"Printer is turned off or is out of paper") Q  ; OUT OF PAPER
 I ACK=-3 D REG(6,"An invalid printer group was requested during check in") Q  ; INVALID PRINTER GROUP
 I ACK=-4 D REG(7,"Destination printer not found by Win 2K") Q  ; INVALID PRINTER
 I ACK=-5 D REG(2,"Print Service unable to comply with request because it is too busy") Q  ; PRINT SERVICE BUSY
 I ACK=-6 D REG(8,"Check sum error detected during data transmission") Q  ; CHECKSUM ERROR
 I ACK=-7 D REG(9,"Print Service reports it is unable to start successfully") Q  ; START FAILURE
 I ACK=-11 D REG(12,"Print job failure.  Can't access printer via LAN") Q  ; PRINT JOB FAILURE
 Q
 ; 
UMSG(DEPTIEN,DEFEF,DEFHS,VARS) ; EP-USER MESSAGE
 N TMP,EIEN,%,CNT
 S TMP="^TMP(""VEN ERROR FLAG"")"
 I '$D(@TMP) W !,"PCC PLUS IS CURRENTLY OPERATING PROPERLY" D DOCS^VENPCC Q 0 ; FATAL ERRORS
 I $D(@TMP@(1)) D  Q 1
 . S EIEN=$O(@TMP@(1,0,0)) I 'EIEN Q
 . S CNT=@TMP@(1,0,EIEN)
 . D WARN(EIEN,1,CNT)
 . Q
 I $D(@TMP@(4)) D  Q 0 ; SYSTEM ERRORS
 . S EIEN=$O(@TMP@(4,0,0)) I 'EIEN Q
 . S CNT=@TMP@(4,0,EIEN)
 . D WARN(EIEN,4,CNT)
 . Q
 I 'DEPTIEN Q 0
 N PGIEN,PGNAME ; PRINT GROUP ERRORS
 I $G(DEFEF) S PGNAME=$$PG^VENPCC1(DEPTIEN,"e1") D UM1 Q 0
 I $G(DEFHS) S PGNAME=$$PG^VENPCC1(DEPTIEN,"h1") D UM1 Q 0
 I VARS["OGFLAG=1" S PGNAME=$$PG^VENPCC1(DEPTIEN,"g1") D UM1 Q 0
 Q 0
 ; 
UM1 I '$L(PGNAME) Q
 S PGIEN=+$O(^VEN(7.4,"B",PGNAME,0))
 I 'PGIEN Q
 I '$D(@TMP@(2,+$G(PGIEN))) Q
 S EIEN=$O(@TMP@(2,PGIEN,0)) I 'EIEN Q
 S CNT=@TMP@(2,PGIEN,EIEN)
 D WARN(EIEN,1,CNT)
 Q
 ; 
WARN(EIEN,TYPE,CNT) ; EP-PRINT USER WARNING
 N %
 S %=$P($G(^VA(200,+$G(DUZ),0)),U) I %="" Q
 S %=$P(%,",",2,99)_" "_$P(%,",")
 W !!?10,"***** Important message for ",%," *****",!
 D LIST(EIEN,1)
 W !!,"Site manager contact info: "
 S %=$G(^VEN(7.5,+$$CFG^VENPCCU,4)) I %="" S %="(NOT AVAILABLE)"
 W %
 W !!,"There ",$S(CNT=1:"is",1:"are")," currently ",CNT," document",$S(CNT=1:"",1:"s")," on the waiting list that failed to print."
 W !,"ERROR ID #: ",EIEN,"    (Note this ID #.  It may be requested by the site manager)"
 W !!
 Q
 ; 
LIST(EIEN,SS) ; EP-LIST THE WP MESSAGE
 N MIEN
 S MIEN=0 F  S MIEN=$O(^VEN(7.71,+$G(EIEN),SS,MIEN)) Q:'MIEN  D
 . W !
 . I '(MIEN#20),$$MORE Q
 . W $G(^VEN(7.71,EIEN,SS,MIEN,0))
 . Q
 Q
 ; 
MORE() ; EP-HOLD SCROLLING AT 20 LINES
 N %
 W "<Press RETURN to keep scrolling>"
 R %:$G(DTIME,60) E  Q 1
 I %?1."^" Q 1
 W $C(13),?79,$C(13)
 Q 0
 ;
SMSG ; EP-SITE MANAGER MESSAGE
 N EIEN,X,DIC,Y,%,TYPE,ID,TMP
 S TMP="^TMP(""VEN ERROR FLAG"")",TYPE=0
 S TYPE=$O(@TMP@(TYPE)) I TYPE S ID=+$O(@TMP@(TYPE,"")) I $L(ID) S %=$O(@TMP@(TYPE,ID,0)) I % S DIC("B")=%
 S DIC("A")="Error ID NUMBER reported by Check-in Clerk: "
 S DIC="^VEN(7.71,",DIC(0)="AEQM"
 D ^DIC I Y=-1 Q
 S EIEN=+Y
 W !!,"CAUSE OF PROBLEM: "
 D LIST(EIEN,2)
 W !! I $$MORE Q
 W "POSSIBLE SOLUTION: "
 D LIST(EIEN,3)
 Q
 ;
FILES(PATH,TMP) ; EP-PUT LIST OF FILES TO BE PRINTED IN A ^TMP ARRAY
 I $L(PATH),$L(TMP)
 E  Q
 N STG,X,CNT,I,F,NEXT,PATH2,PATHX,CMD,%,FILE,CFIGIEN
 S (NEXT,STG)=""
UNIX I $$OS^VENPCCU D  Q  ; ALL UNIX SYSTEMS
 . S CFIGIEN=$$CFG^VENPCCU
 . S PATH2=$G(^VEN(7.5,CFIGIEN,3)),PATHX=$E(PATH,1,$L(PATH)-1)
 . S FILE="ven_"_+$J_".temp",CMD="ls "_PATHX_" > "_PATH2_FILE
 . D UCMD^VENPCCP(CMD)
 . S POP=$$OPN^VENPCCP(PATH2,FILE,"R","F  R X Q:'$L(X)  S @TMP@(X)=""""")
 . D DEL^VENPCCP1(PATH2,FILE)
 . Q
CACHE I $$VEN^VENPCCU=2 X ("F CNT=0:1 S FILE=$S('CNT:(PATH_""*.txt""),1:"""") S X="_$C(36,90)_"SEARCH(FILE) Q:'$L(X)  S X=$P(X,""\"",$L(X,""\"")) S @TMP@(X)=""""") Q  ; CACHE/NT
MSM S %="S X=$"_"Z"_"O" X (%_"S(12,"""_PATH_"*.txt"",0)") I '$L(X) Q  ; MSM/NT
 S @TMP@($P(X,U))=""
 F  D  I '$L(X) Q
 . X (%_"S(13,X)")
 . I '$L(X) Q
 . S @TMP@($P(X,U))=""
 . Q
 Q
 ; 
RENAME(FILE,PATH) ; EP-IF TRANSMISSION FAILS RENAME FILE AS A "z" FILE.
 N %,R,CMD,STG,%
 S %=$P(FILE,".")
 S R="z"_$E(%,3,99)_$E(FILE)_".txt"
 S R=$$LOW^XLFSTR(R) ; ALL FILES SHOULD HAVE LOWERCASE NAMES
 S STG=" "_PATH_FILE_" "_PATH_R
 I $$VEN^VENPCCU=2 S CMD="copy"_STG X ("S %=$"_"Z"_"F(-1,CMD)") D DEL^VENPCCP1(PATH,FILE) H 1 Q R
 I $$OS^VENPCCU S CMD="cp"_STG D UCMD^VENPCCP(CMD) D DEL^VENPCCP1(PATH,FILE) Q R
 X ("S %=$"_"ZO"_"S(3,PATH_FILE,PATH_R)")
 Q R
 ; 
