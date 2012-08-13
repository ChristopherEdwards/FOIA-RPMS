VENPCCMB ; IHS/OIT/GIS - SITE PREFERENCE MANAGER ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ; DEAD CODE IN 2.5
 ; 
NEW N EF,CPT,PGRP,LIST,STATUS,X,Y,%,TITLE,DTOUT,DUOUT,DIRUT,%Y,DG,%D,%E,VENDUZ0,OSET
 I '$D(LOOP) N LOOP S LOOP=""
INIT S (CPT,EF)="",PGRP=0
 S VENDUZ0=$G(DUZ(0)),DUZ(0)="@"
RUN W:$D(IOF) @IOF W !!!?20,"*****  USER PREFERENCE MANAGER  *****"
 W !!!
 I $O(^VEN(7.93,"AX",0)) D
 . D WAIT^DICD
 . S %="^VEN(7.93,""AX"")" K @%
 . S DIK="^VEN(7.93,",DIK(1)=.09
 . D ENALL^DIK,^XBFMK ; MAKE SURE THE INDEX IS CLEAN
 . W $C(13),?79,$C(13)
 . Q
LOOP I LOOP S %=$$NEXT(EF,CPT,PGRP) Q:'%  W !!! S EF=$P(%,";"),CPT=$P(%,";",2),PGRP=$P(%,";",3) G LST
 S %=$O(^VEN(7.92,0)) I '% S OSET="" G LCPT ; NO ORDER SETS DEFINED
 I '$O(^VEN(7.92,%)) S OSET=% G LCPT ; ONLY ONE ORDER SET DEFINED
 S OSET=$$OS I 'OSET W !!,"No order set defined!  Request terminated...",!! Q
 S EF=$$EF(OSET)
LCPT S CPT=$$CPT(CPT) I CPT="" Q
LGRP S PGRP=$$PGRP I PGRP="" Q
LST S LIST=$$LIST(+EF,+CPT,PGRP)
 S TITLE=$$TITLE(+EF,CPT,PGRP)
EDIT S STATUS=$$STATUS(+EF,+CPT,LIST) W !!,$P(STATUS,U,3)
 W !,TITLE
 W ! D SHOW(LIST)
 I $L(LIST) W !!,"Select from 'ADD', 'EDIT', 'DELETE', 'COPY', 'SUBMIT', 'NEXT LIST', 'QUIT'" S DIR(0)="SBO^A:ADD;E:EDIT;D:DELETE;C:COPY;S:SUBMIT;N:NEXT LIST;Q:QUIT"
 I '$L(LIST) W !!,"Select from 'ADD', 'COPY', 'NEXT LIST', 'QUIT'" S DIR(0)="SBO^A:ADD;C:COPY;N:NEXT LIST;Q:QUIT"
 S DIR("A")="Your choice" KILL DA D ^DIR KILL DIR
 I Y=U!($D(DTOUT)) Q
 I LOOP,Y="" G LOOP
 I Y="A" S LIST=$$ADD(LIST,STATUS) G EDIT
 I Y="D" S LIST=$$DEL^VENPCCMD(LIST,STATUS) G EDIT
 I Y="C" S LIST=$$COPY(LIST,STATUS,TITLE,EF,CPT) G EDIT
 I Y="E" S LIST=$$UPDATE(LIST,STATUS) G EDIT
 I Y="S" G RUN:$$SUBMIT(LIST,EF,CPT,PGRP),EDIT
 I Y="N" G LCPT
 D ^XBFMK
 I $L($G(VENDUZ0)) S %=$C(68,85,90),@%@(0)=VENDUZ0
 Q
 ; 
EF(OS) ; RETURN THE PRIMARY ENCOUNTER FORM FOR THE OS
 N EFIEN
 S EFIEN=$O(^VEN(7.41,"AG",OS,0))
 Q EFIEN
 ; 
OS() ; ORDER SET
 N SIEN,TIEN,SET,TEMP,X,%,OS
 S OS=""
 I '$O(^VEN(7.92,0)) W !,"No order sets defined!" Q OS
 W !,"Order set and associated templates...",!
 S SET="" F  S SET=$O(^VEN(7.92,"B",SET)) Q:SET=""  S SIEN=$O(^VEN(7.92,"B",SET,0)) I SIEN D
 . W !,SET
 . S TIEN=0 F  S TIEN=$O(^VEN(7.41,"AG",SIEN,TIEN)) Q:'TIEN  S TEMP=$P($G(^VEN(7.41,TIEN,0)),U) I $L(TEMP) W !?5,TEMP
 . Q
 S DIC="^VEN(7.92,",DIC(0)="AEQM"
 S DIC("A")="Select order set: " W !
 D ^DIC
 I Y'=-1 S OS=+Y
 Q OS
 ; 
CPT(CPT) ;
 N DIC,X,Y,%
 S DIC="^VEN(7.98,",DIC(0)="AEQ"
 S DIC("A")="Section of form: "
 I $L($G(CPT)) S DIC("B")=$P(CPT,U,2)
 S DIC("S")="N % S %=$P(^(0),U) I %'=""PHYSICAL EXAM"",%'=""HEALTH MAINTENANCE REMINDERS"""
 D ^DIC I Y=-1 Q ""
 Q Y
PGRP() ; 
 N DIC,X,Y,%
 N DIR,DTOUT,DIRUT,DUOUT
 S DIR(0)="S^1:Infants;2:Children;3:Adult Males;4:Adult Females",DIR("A")="Patient group" KILL DA D ^DIR KILL DIR
 I 'Y Q ""
 Q Y
 ; 
STATUS(EF,CPT,X) ; SHOW MAX ENTRIES POSSIBLE
 N DISP,MAX
 S DISP=$L(X,U)
 I X="" S DISP=0
 S MAX=$$MAX(+EF,+CPT)
 S X="There is room for "_MAX_" entries on this form" I DISP S X=X_" and you have selected "_DISP_$S(DISP=1:" entry",1:" entries")
 Q MAX_U_DISP_U_X
 ; 
TITLE(EF,CPT,G) ; TITLE OF LIST
 Q $P(EF,U,2)_"/"_$P(CPT,U,2)_"/"_$S(G=1:"INFANTS",G=2:"CHILDREN",G=3:"ADULT MALES",1:"ADULT FEMALES")
 ; 
LIST(EF,CPT,PGRP) ;  EP-LIST THE ITEMS
 N MN,GRP,SIEN,REC,HDR,SET
 S MN=$P($G(^VEN(7.98,CPT,0)),U,3)
 S GRP=PGRP_MN,SIEN=0,REC="",SET=""
 I $G(EF) S SET=$P($G(^VEN(7.41,EF,0)),U,9) ; GET THE ORDER SET IF NECESSARY
 I 'SET F  S SIEN=$O(^VEN(7.93,"AC",GRP,SIEN)) Q:'SIEN  D LIST1(SIEN) ; IF NO ORDERABLE SETS HAVE BEEN DEFINED
 I SET F  S SIEN=$O(^VEN(7.93,"AX",SET,GRP,SIEN)) Q:'SIEN  D LIST1(SIEN) ; IF ORDER SETS DEFINED
 Q REC
 ; 
LIST1(SIEN) ; EP-BUILD THE ORDERABLE STRING REC
 N X,NAME,CTAG,STAG,CODE
 S X=$G(^VEN(7.93,SIEN,0)) I '$L(X) Q
 S NAME=$P(X,U),CODE=$P(X,U,6)
 S CTAG=$TR($G(^VEN(7.93,SIEN,1)),U,"|")
 S STAG=$TR($G(^VEN(7.93,SIEN,2)),U,"|")
 I $L(REC) S REC=REC_U
 S REC=REC_NAME_";"_CODE_";"_CTAG_";"_STAG
 Q
 ; 
SHOW(X) ; DISPLAY THE LIST
 N NAME,CODE,I,Y,STOP
 F I=1:1:$L(X,U) D  I $G(STOP) Q
 . W !
 . I '(I#20),'$$WAIT^VENPCCU S STOP=1 Q
 . S Y=$P(X,U,I)
 . I Y="" W:I=1 "No entries found!" S STOP=1 Q
 . S NAME=$P(Y,";"),CODE=$P(Y,";",2)
 . W I,?5,NAME," ",CODE
 . Q
 Q
 ; 
ADD(LIST,STAT) ; ADD AN ENTRY
 N DIRUT,DUOUT,DTOUT,X,Y,%,DIC,POS,NAME,CODE,DIROUT
ADD1 S X=$P(STAT,U)-$P(STAT,U,2)
 I X>0 W !,"You have room for "_X_" more "_$S(X>1:"entries",1:"entry")
 E  W !,"You are over the limit for adding new entries!"
 W !
POS ; 
 I '$L(LIST) S POS=1 G NAME
 S DIR("A")="Insert new entry at what position? (1 - END of list)"
 S DIR(0)="F^1:3",DIR("B")="END" KILL DA D ^DIR KILL DIR S POS=Y
 I $D(DIRUT) K DIRUT,DTOUT,DUOUT,DIROUT Q LIST
P1 I POS=$E("END of list",1,$L(POS)) W $E("END of list",$L(POS)+1,99) S POS=1+$P(STAT,U,2) G NAME
 I POS,POS>0,POS'>$P(STAT,U,2)
 E  W "  ??" G POS
NAME ; 
 S DIR(0)="F^1:30",DIR("A")="Name of entry" KILL DA D ^DIR KILL DIR
 I '$D(DIRUT),'$D(DUOUT),'$D(DTOUT) S NAME=Y G CODE
 K DIRUT,DTOUT,DIROUT,DUOUT Q LIST
CODE ; 
 S CODE="",DIR(0)="FO^1:6",DIR("A")="CPT Code" KILL DA D ^DIR KILL DIR
 I $D(DUOUT)!($D(DTOUT)) Q LIST
 S CODE=Y
ENT ; 
 I $P(LIST,U,POS)="" S $P(LIST,U,POS)=NAME_";"_CODE
 E  S %=$P(LIST,U,POS) S $P(LIST,U,POS)=NAME_";"_CODE_U_%
 S %=$P(STAT,U,2)+1 S $P(STAT,U,2)=%
 W ! D SHOW(LIST) W !
 W !!,"Want to add another entry" S %=1
 D YN^DICN I %'=1 Q LIST
 G ADD1
 ; 
DEL(LIST,STAT) ; DELETE AN ENTRY
 N DIRUT,DUOUT,DTOUT,X,Y,%,POS
DEL1 S %=$P(STAT,U,2) I '% W !,"There are no entries to delete!" Q ""
 S %=((+STAT)-($P(STAT,U,2))) I %<0 S %=%*-1 W !,"You should delete at least "_%_" entries..."
DEL2 S DIR(0)="NO^1:"_$P(STAT,U,2)_":",DIR("A")="Delete entry from what position" KILL DA D ^DIR KILL DIR
 I '+Y Q LIST
 S POS=+Y
 W !,"Sure you want to delete "_$P($P(LIST,U,POS),";")
 S %=1 D YN^DICN I $D(DIRUT)!($D(DTOUT)) Q LIST
 I %'=1 G DEL2
 I POS=$P(STAT,U,2) S LIST=$P(LIST,U,1,POS-1) G DEL3
 I POS=1 S LIST=$P(LIST,U,2,99) G DEL3
 S LIST=$P(LIST,U,1,POS-1)_U_$P(LIST,U,POS+1,99)
DEL3 S %=$P(STAT,U,2)-1 S $P(STAT,U,2)=%
 W ! D SHOW(LIST) W !
 W !!,"Want to delete another entry" S %=1
 D YN^DICN I %'=1 Q LIST
 G DEL1
 ; 
COPY(LIST,STAT,TITLE,EF,CPT) ; COPY IN ANOTHER LIST
 N PGRP,CTITLE,CLIST,DUOUT,DIRUT,DTOUT,I
 W !!,"Define the Patient Group to copy from =>"
 S PGRP=$$PGRP I PGRP="" Q LIST
 S CLIST=$$LIST(+EF,+CPT,PGRP) I CLIST="" W !,"Unable to copy because no entries found!" H 3 Q LIST
 S CTITLE=$$TITLE(EF,CPT,PGRP)
 W !,CTITLE
 W ! D SHOW(CLIST)
 W !,"OK to copy non-redundant entries from this list"
 S %=1 D YN^DICN I %'=1 Q LIST
 F I=1:1:$L(CLIST,U) S X=$P(CLIST,U,I) I LIST'[X S:LIST'="" LIST=LIST_U S LIST=LIST_X
 W !!,"Source list: ",TITLE
 W ! D SHOW(LIST)
 Q LIST
 ; 
SUB(LIST,EF,CPT,PGRP) ; EP-FOR SUBMITTING AN EXTERNALY GENERATED LIST
 N EFLAG S EFLAG=1
 G S1
 ; 
SUBMIT(LIST,EF,CPT,PGRP) ; ENTER THE LIST
S1 N %,CODE,DIR,Y,DIRUT,DTOUT,DUOUT
 I $G(EFLAG) S Y="A" G S2
 I $G(EF),$G(CPT) S %=$L(LIST,U)-$$MAX(+EF,+CPT) I %>0 W !!,"You have exceeded the maximum number of items allowed!",!,"Delete ",%," item",$S(%>1:"s",1:"")," before proceeding",!  H 2 Q 0
 W !,"The following list will be saved: ",TITLE
 ; D SHOW(LIST)
 W !,"Are you sure everything is OK"
 S %=1 D YN^DICN I %'=1 Q 0
 S %=$P($P(LIST,U),";",2) S CODE=$L(%)
 I CODE S DIR(0)="S^A:ALPHABETIZE THE LIST AND SAVE;C:SORT BY CODE AND SAVE;S:SAVE"
 E  S DIR(0)="S^A:ALPHABETIZE THE LIST AND SAVE;S:SAVE"
 S DIR("A")="Your choice" KILL DA D ^DIR KILL DIR
S2 I Y="A" S LIST=$$ALPH(LIST,1) D SAVE(LIST,EF,CPT,PGRP) Q 1
 I Y="C" S LIST=$$ALPH(LIST,2) D SAVE(LIST,EF,CPT,PGRP) Q 1
 I Y="S" D SAVE(LIST,EF,CPT,PGRP) Q 1
 Q 0
 ; 
ALPH(LIST,PCE) ; ALPHABETIZE THE LIST
 N I,X,Y,Z,STG
 F I=1:1:$L(LIST,U) S X=$P(LIST,U,I) I $L(X) D
 . S Y=$P(X,";",PCE)
 . I $L(Y) S LIST(Y,I)=""
 . Q
 S I=0,STG=""
 S Y="" F  S Y=$O(LIST(Y)) Q:Y=""  S Z=0 F  S Z=$O(LIST(Y,Z)) Q:'Z  D
 . S I=I+1
 . S $P(STG,U,I)=$P(LIST,U,Z)
 . Q
 Q STG
 ; 
SAVE(LIST,EF,CPT,PGRP) ; EP-DELETE THE OLD LIST AND SAVE THE NEW ONE
 I $D(^VEN(7.98,+$G(CPT),0)),$L(LIST),PGRP,PGRP=PGRP\1,PGRP>0,PGRP<5
 E  Q
 N CTAG,D,D0,DI,DIE,DIG,DIH,DIU,DIV,DQ,DR,HDR,PCE,STAG,DIK,DIC,IX,MN,DA,HIEN,MN,IX,CODE,DIW,HDR,STAG,CTAG,DICR,%,%Y,SET
 S DIK="^VEN(7.93,"
 S MN=$P($G(^VEN(7.98,+CPT,0)),U,3)
 S IX=PGRP_MN,DA=0,SET=""
 I $G(EF) S SET=$P($G(^VEN(7.41,EF,0)),U,9) ; GET THE ORDER SET IF NECESSARY
 I 'SET F  S DA=$O(^VEN(7.93,"AC",IX,DA)) Q:'DA  D ^DIK ; IF NO ORDERABLE SETS HAVE BEEN DEFINED
 I SET F  S DA=$O(^VEN(7.93,"AX",SET,IX,DA)) Q:'DA  D ^DIK ; IF ORDER SETS DEFINED
 S DIC=DIK,DIC(0)="L",DIE=DIC,DLAYGO=19707.93
 F PCE=1:1:$L(LIST,U) D
 . S %=$P(LIST,U,PCE)
 . S CODE=$P(%,";",2),CTAG=$P(%,";",3),STAG=$P(%,";",4)
 . S X=""""_$P(%,";")_"""",HDR=MN_PCE
 . S HIEN=$O(^VEN(7.42,"B",HDR,0)) I 'HIEN Q
 . D ^DIC I Y=-1 Q
 . S DA=+Y,DR=".02////"_$P($G(^VEN(7.41,+$G(EF),0)),U,9)_";.03////"_HIEN_";.06////"_CODE_";.09////"_+PGRP_";.11////"_+EF_";1////"_$TR(CTAG,"|",U)_";2////"_$TR(STAG,"|",U)
 . L +^VEN(7.93,DA):5 E  Q
 . D ^DIE L -^VEN(7.93,DA)
 . Q
 W !!,"Done!" H 1
 Q
 ; 
EN1 ; EP FOR LOOPING THROUGH ALL CPT & PATIENT GROUPS IN A TEMPLATE
 N LOOP S LOOP=1
 G NEW
 Q
 ; 
NEXT(EF,CPT,PGRP) ;
 N CIEN,NAME
 I EF="" S EF=$$EF("") I '$L(EF) Q 0
 S PGRP=PGRP+1 I PGRP=5 S PGRP=1
 I PGRP>1 Q EF_";"_CPT_";"_PGRP
N1 S CIEN=$O(^VEN(7.98,+CPT)),NAME=$P($G(^VEN(7.98,+CIEN,0)),U),CPT=CIEN_U_NAME
 I 'CPT W !!,"You have successfully edited this template!" Q 0
 I NAME="HEALTH MAINTENANCE REMINDERS" G N1
 I NAME="PHYSICAL EXAM" G N1
 Q EF_";"_CPT_";"_PGRP
 ; 
MAX(EF,CPT) ; EP-MAX ITEMS
 N MN,X,I,Y,SS,PCE,MAX,FMN,CNT
 S MN=$P($G(^VEN(7.98,CPT,0)),U,2)
 I '$L(MN) Q ""
 S X="EXA;1;3^HMR;1;4^IMM;1;5^INJ;1;6^LAB;1;7^EDU;1;8^PEX;1;9^RAD;2;1^SUP;2;2^TRE;2;3"
 F I=1:1:$L(X,U) S Y=$P(X,U,I) I $P(Y,";")=MN S SS=$P(Y,";",2),PCE=$P(Y,";",3) Q
 I '$G(PCE) Q ""
 S MAX=$P($G(^VEN(7.41,EF,SS)),U,PCE)
FLY I MAX="" D  S MAX=CNT ; COMPUTE ABSOLUTE MAX ON THE FLY
 . S FMN=$P($G(^VEN(7.98,CPT,0)),U,3),CNT=0
 . I '$L(FMN) Q
 . S %=FMN F  S %=$O(^VEN(7.42,"B",%)) Q:(($E(%)'=FMN)!($E(%,2)'?1N))  I $E($RE(%))?1N S CNT=CNT+1
 . Q
 Q MAX
 ; 
UPDATE(LIST,STAT) ; EDIT AN ENTRY IN THE LIST
 N DIR,X,Y,%,ENTRY,POS,NAME,CODE,DIRUT,DUOUT,DTOUT
U1 S DIR(0)="NO^1:"_$P(STAT,U,2)_":",DIR("A")="Edit entry from what position" KILL DA D ^DIR KILL DIR
 I '+Y Q LIST
 S POS=+Y
 S ENTRY=$P(LIST,U,POS) I '$L(ENTRY) Q LIST
 S DIR(0)="F^1:30",DIR("A")="Name of entry" S DIR("B")=$P(ENTRY,";")
 D ^DIR KILL DIR
 I '$D(DIRUT),'$D(DUOUT),'$D(DTOUT) S NAME=Y G U2
 Q LIST
U2 ; 
 S CODE="",DIR(0)="FO^1:6",DIR("A")="CPT Code" S DIR("B")=$P(ENTRY,";",2)
 D ^DIR KILL DIR
 I $D(DUOUT)!($D(DTOUT)) Q LIST
 S CODE=Y
 S $P(ENTRY,";",1,2)=NAME_";"_CODE
 S $P(LIST,U,POS)=ENTRY
 W ! D SHOW(LIST) W !
 W !!,"Want to edit another entry" S %=1
 D YN^DICN I %'=1 Q LIST
 G U1
 ; 
