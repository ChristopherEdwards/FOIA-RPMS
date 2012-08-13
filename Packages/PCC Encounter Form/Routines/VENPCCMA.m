VENPCCMA ; IHS/OIT/GIS - USER PREFERENCE MANAGER FOR DIAGNOSES AND ICD CODES ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ; 
NEW N EF,PRV,PGRP,LIST,STATUS,X,Y,%,TITLE,DTOUT,DUOUT,DIRUT,%Y
 I '$D(LOOP) N LOOP S LOOP=""
INIT S (PRV,EF)="",PGRP=0
RUN W:$D(IOF) @IOF W !!!?20,"*****  USER PREFERENCE MANAGER FOR DIAGNOSES  *****"
 W !!!
LOOP I LOOP S %=$$NEXT(EF,PRV,PGRP) Q:'%  W !!! S EF=$P(%,";"),PRV=$P(%,";",2),PGRP=$P(%,";",3) G LST
LEF S EF=$$EF(EF) I EF="" Q
LPRV S PRV=$$PRV(PRV) I PRV="" Q
LGRP S PGRP=$$PGRP() I PGRP="" Q
LST S LIST=$$LIST(+EF,+PRV,+PGRP)
 S TITLE=$$TITLE(EF,PRV,PGRP)
EDIT S STATUS=$$STATUS(+EF,LIST) W !!,$P(STATUS,U,3)
 W !,TITLE
 W ! D SHOW(LIST)
 I $L(LIST) W !!,"Select from 'ADD', 'EDIT', 'DELETE', 'COPY', 'SUBMIT', 'NEXT LIST', 'QUIT'" S DIR(0)="SBO^A:ADD;E:EDIT;D:DELETE;C:COPY;S:SUBMIT;N:NEXT LIST;Q:QUIT"
 I '$L(LIST) W !!,"Select from 'ADD', 'COPY', 'NEXT LIST', 'QUIT'" S DIR(0)="SBO^A:ADD;C:COPY;N:NEXT LIST;Q:QUIT"
 S DIR("A")="Your choice" KILL DA D ^DIR KILL DIR
 I Y=U!($D(DTOUT)) Q
 I LOOP,Y="" G LOOP
 I Y="A" S LIST=$$ADD(LIST,STATUS) G EDIT
 I Y="D" S LIST=$$DEL(LIST,STATUS) G EDIT
 I Y="C" S LIST=$$COPY(LIST,STATUS,TITLE,EF,PRV) G EDIT
 I Y="E" S LIST=$$UPDATE(LIST,STATUS) G EDIT
 I Y="S" G RUN:$$SUBMIT(LIST,EF,PRV,PGRP),EDIT
 I Y="N" G LPRV
 Q
 ; 
EF(EF) ; 
 N DIC,X,Y,%
 S DIC="^VEN(7.41,",DIC(0)="AEQ"
 S DIC("A")="Encounter form name: "
 I $L($G(EF)) S DIC("B")=$P(EF,U,2)
 D ^DIC I Y=-1 Q ""
 Q Y
PRV(PRV) ;
 N DIC,X,Y,%
 S DIC="^VA(200,",DIC(0)="AEQ"
 S DIC("A")="Provider: "
 I $L($G(PRV)) S DIC("B")=$P(PRV,U,2)
 D ^DIC I Y=-1 Q ""
 Q Y
PGRP(DFLT) ; 
 N DIC,X,Y,%
 N DIR,DTOUT,DIRUT,DUOUT
 S DIR(0)="S^1:Infants;2:Children;3:Teen Males;4:Teen Females;5:Adult Males;6:Adult Females;7:Senior Males;8:Senior Females"
 I $G(DFLT),DFLT>0,DFLT<9 S %=$P(DIR(0),(DFLT_":"),2) S %=$P(%,";") Q DFLT_U_%
 S DIR("A")="Patient group" KILL DA D ^DIR KILL DIR
 I 'Y Q ""
 Q Y_U_Y(0)
 ; 
STATUS(EF,X) ; SHOW MAX ENTRIES POSSIBLE
 N DISP,MAX
 S DISP=$L(X,U)
 I X="" S DISP=0
 S MAX=+$P($G(^VEN(7.41,+EF,1)),U,2)
 S X="There is room for "_MAX_" entries on this form" I DISP S X=X_" and you have selected "_DISP_$S(DISP=1:" entry",1:" entries")
 Q MAX_U_DISP_U_X
 ; 
TITLE(EF,PRV,G) ; TITLE OF LIST
 Q $P(EF,U,2)_"/"_$P(PRV,U,2)_"/"_$P(PGRP,U,2)
 ; 
LIST(EF,PRV,PGRP) ; 
 N INDX,SIEN,REC,X,NAME,CODE,HDR
 S INDX=PRV_"."_PGRP,SIEN=0,REC=""
 F  S SIEN=$O(^VEN(7.1,"AG",INDX,SIEN)) Q:'SIEN  D
 . S X=$G(^VEN(7.1,SIEN,0)) I '$L(X) Q
 . S NAME=$P(X,U,3),CODE=$P(X,U,2)
 . I $L(REC) S REC=REC_U
 . S REC=REC_NAME_";"_CODE
 . Q
 Q REC
 ; 
SHOW(X) ; DISPLAY THE LIST
 N NAME,CODE,I,Y,STOP
 F I=1:1:$L(X,U) D  I $G(STOP) Q
 . S Y=$P(X,U,I)
 . I Y="" W:I=1 !,"No entries found!" Q
 . S NAME=$P(Y,";"),CODE=$P(Y,";",2) W !
 . I '(I#18) S STOP='$$WAIT^VENPCCU I STOP Q
 . W I,?5,NAME," ",CODE
 . Q
 Q
 ; 
ADD(LIST,STAT) ; ADD AN ENTRY
 N DIRUT,DUOUT,DTOUT,X,Y,%,DIC,POS,NAME,CODE
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
 K DIRUT,DTOUT,DUOUT Q LIST
CODE ; 
 S CODE="",DIR(0)="FO^1:6",DIR("A")="ICD Code" KILL DA D ^DIR KILL DIR
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
 N DIRUT,DUOUT,DTOUT,X,Y,%,POS,ITEM,CNT,TOT
DEL1 S %=$P(STAT,U,2) I '% W !,"There are no entries to delete!" Q ""
 S %=((+STAT)-($P(STAT,U,2))) I %<0 S %=%*-1 W !,"You should delete at least "_%_" entries..."
DEL2 S DIR(0)="FO^",DIR("A")="Delete entry from what position" K DA
 S (HELP,DIR("?"))="Enter a number, a range (e.g., '1-32'), or '*' (all)"
 D ^DIR K DIR
 I Y?1."^" Q LIST
 I Y=+Y,Y>0,Y=(Y\1) S POS=+Y G CKD
 I Y="*"!(Y="ALL")!(Y="all") S Y="*",POS=1,POS(1)=$P(STAT,U,2) G CKD
 I Y?1.3N1"-"1.3N S POS=+Y,POS(1)=$P(Y,"-",2)
 I '$G(POS) W !,HELP G DEL2
CKD I POS>$P(STAT,U,2)!(+$G(POS(1))>$P(STAT,U,2)) W !,"Select a number between 1 and ",$P(STAT,U,2) K POS G DEL2
 W !,"Sure you want to delete "_$S(Y=+Y:$P($P(LIST,U,POS),";"),Y["-":Y,1:"ALL")
 S %=1 D YN^DICN I $D(DIRUT)!($D(DTOUT)) Q LIST
 I %'=1 G DEL2
 I $G(POS(1)) S CNT=0,TOT=POS(1)-POS
DLOOP S ITEM=$TR($P(LIST,U,POS),";"," ")
 I POS=$P(STAT,U,2) S LIST=$P(LIST,U,1,POS-1) G DEL3
 I POS=1 S LIST=$P(LIST,U,2,99) G DEL3
 S LIST=$P(LIST,U,1,POS-1)_U_$P(LIST,U,POS+1,99)
DEL3 S %=$P(STAT,U,2)-1 S $P(STAT,U,2)=%
 W !,"  Deleting ",ITEM
 I $G(POS(1)) S CNT=CNT+1 I CNT'>TOT G DLOOP
 K ITEM,CNT,TOT,POS
 I '$L(LIST) G DEL1
 W !!,"Want to delete another entry" S %=1
 D YN^DICN I %'=1 Q LIST
 D SHOW(LIST)
 G DEL1
 ; 
COPY(LIST,STAT,TITLE,EF,PRV) ; COPY IN ANOTHER LIST
 N PGRP,CTITLE,CLIST,DUOUT,DIRUT,DTOUT,I
 W !,"Enter name of provider to copy from =>"
 S PRV1=$$PRV I 'PRV1 Q LIST
 W !!,"Define the Patient Group to copy from =>"
 S PGRP=$$PGRP I PGRP="" Q LIST
 S CLIST=$$LIST(+EF,+PRV1,+PGRP) I CLIST="" W !,"Unable to copy because no entries found!" H 3 Q LIST
 S CTITLE=$$TITLE(EF,PRV1,PGRP)
 W !,CTITLE
 W ! D SHOW(CLIST)
 W !,"OK to copy non-redundant entries from this list"
 S %=1 D YN^DICN I %'=1 Q LIST
 F I=1:1:$L(CLIST,U) S X=$P(CLIST,U,I) I LIST'[X S:LIST'="" LIST=LIST_U S LIST=LIST_X
 W !!,"Target list: ",TITLE
 Q LIST
 ; 
SUB(LIST,EF,PRV,PGRP) ; EP FOR SUBMITTING AN EXTERNALY GENERATED LIST
 N EFLAG S EFLAG=1
 G S1
 ; 
SUBMIT(LIST,EF,PRV,PGRP) ; ENTER THE LIST
S1 N %,CODE,DIR,Y,DIRUT,DTOUT,DUOUT
 I $G(EFLAG) S Y="A" G S2
 S %=$L(LIST,U)-(+$P($G(^VEN(7.41,+EF,1)),U,2)) I %>0 W !!,"You have exceeded the maximum number of items allowed!",!,"Delete ",%," item",$S(%>1:"s",1:"")," before proceeding",!  H 2 Q 0
 W !,"The following list will be saved: ",TITLE
 ; D SHOW(LIST)
 W !,"Are you sure you want to submit this list"
 S %=1 D YN^DICN I %'=1 Q 0
 S %=$P($P(LIST,U),";",2) S CODE=$L(%)
 I CODE S DIR(0)="S^A:ALPHABETIZE THE LIST AND SAVE;C:SORT BY CODE AND SAVE;S:SAVE AS IS"
 E  S DIR(0)="S^A:ALPHABETIZE THE LIST AND SAVE;S:SAVE"
 S DIR("A")="Your choice" KILL DA D ^DIR KILL DIR
S2 I Y="A" S LIST=$$ALPH(LIST,1) D SAVE(LIST,EF,+PRV,PGRP) Q 1
 I Y="C" S LIST=$$ALPH(LIST,2) D SAVE(LIST,EF,+PRV,PGRP) Q 1
 I Y="S" D SAVE(LIST,EF,PRV,PGRP) Q 1
 Q 0
 ; 
ALPH(LIST,TYPE) ; ORDER THE LIST: APLPHABETICAL OR BY CODE
 N I,X,Y,Z,CODE,NARR,STG,ENT
 I LIST="" Q ""
 I TYPE'=1,TYPE'=2 Q ""
 F I=1:1:$L(LIST,U) S X=$P(LIST,U,I) I $L(X) D
 . S NARR=$P(X,";",1),CODE=$P(X,";",2)
 . I TYPE=1,$L(NARR) S LIST(NARR,I)=CODE ; SORT BY NARRATIVE
 . I TYPE=2,$L(CODE) S LIST(CODE,I)=NARR ; SORT BY CODE
 . Q
 S I=0,STG=""
 S Y="" F  S Y=$O(LIST(Y)) Q:Y=""  S Z=0 F  S Z=$O(LIST(Y,Z)) Q:'Z  D
 . S I=I+1
 . S X=LIST(Y,Z)
 . I TYPE=1 S ENT=Y_";"_X
 . I TYPE=2 S ENT=X_";"_Y
 . S $P(STG,U,I)=ENT
 . Q
 Q STG
 ; 
SAVE(LIST,EF,PRV,PGRP) ; DELETE THE OLD LIST AND SAVE THE NEW ONE
 I $D(^VEN(7.41,+$G(EF),0)),$L(LIST)>1,$G(PGRP),PGRP=PGRP\1,PGRP>0,PGRP<9,$D(^VA(200,+$G(PRV),0))
 E  W !,"Invalid parameters. No changes made.  Contact site manager)" Q
 N CTAG,D,D0,DI,DIE,DIG,DIH,DIU,DIV,DQ,DR,HDR,PCE,DIK,DIC,IX,DA,MN,IX,CODE,DIW,HDR,DICR,%,%Y,DLAYGO,VENDUZ0
 S VENDUZ0=$G(DUZ(0))
 D WAIT^DICD
 S %="^VEN(7.1,""AG"")"  K @% ; JUST TO BE SAFE, FIRST KILL OFF THE ENTIRE AG INDEX
 S %=$C(68,85,90),@%@(0)=$C(64)
 S DIK="^VEN(7.1,",DIK(1)=.05 D ENALL^DIK K DIK ; THEN, REINDEX AG INDEX FOR THE ENTIRE FILE
 S DIK="^VEN(7.1,",IX=+PRV_"."_+PGRP
 I $D(^VEN(7.1,"AG",IX)) S DA=0 F  S DA=$O(^VEN(7.1,"AG",IX,DA)) Q:'DA  D ^DIK ; USING THE REFRESHED INDEX, DELETE ALL ENTRIES FOR THE SPECIFIED GROUP
 S DIC=DIK,DIC(0)="L",DIE=DIC,DLAYGO=19707.1 ; LAST STEP: RE-POPULATE THE FILE WITH THE NEW LIST
 F PCE=1:1:$L(LIST,U) D
 . S %=$P(LIST,U,PCE)
 . S CODE=$P(%,";",2),NAME=$P(%,";")
 . S X="""`"_+PRV_""""
 . D ^DIC I Y=-1 Q  ; MAKE A NEW ENTRY - REPOPULATE THE FILE
 . S DA=+Y,DR=".03////"_NAME_";.02////"_CODE_";.04////"_+PGRP
 . L +^VEN(7.1,DA):5 E  Q
 . D ^DIE L -^VEN(7.1,DA) ; FILL IN THE FIELDS
 . Q
EOJ D ^XBFMK
 W !,"Changes are now in effect..." H 3
 I $L($G(VENDUZ0)) S %=$C(68,85,90),@%@(0)=VENDUZ0
 Q
 ; 
EN1 ; EP FOR LOOPING THROUGH ALL ICD & PATIENT GROUPS IN A TEMPLATE
 N LOOP S LOOP=1
 G NEW
 Q
 ; 
NEXT(EF,PRV,PGRP) ;
 N CIEN,NAME
 I EF="" S EF=$$EF("") I '$L(EF) Q 0
 S PGRP=PGRP+1 I PGRP=9 S PGRP=1
 I PGRP>1 Q EF_";"_PRV_";"_PGRP
 S EF=$$EF("") I 'EF Q ""
 S PRV=$$PRV("") I 'PRV Q ""
 S PGRP=$$PGRP(PGRP) I 'PGRP Q ""
 Q EF_";"_PRV_";"_PGRP
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
 S CODE="",DIR(0)="FO^1:6",DIR("A")="ICD Code" S DIR("B")=$P(ENTRY,";",2)
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
CVT ;
 S DIE="^VEN(7.1,",DA=0
 F  S DA=$O(^VEN(7.1,DA)) Q:'DA  D
 . S X=$P($G(^VEN(7.1,DA,1)),U,1)
 . I 'X Q
 . S Y=$P($G(^VEN(7.91,X,0)),U) I '$L(Y) Q
 . S Z=$S(Y="INFANT":1,Y="CHILD":2,Y="TEEN MALE":3,Y="TEEN FEMALE":4,Y="ADULT MALE":5,Y="ADULT FEMALE":6,Y="SENIOR MALE":7,Y="SENIOR FEMALE":8,1:"")
 . S DR=".04////"_Z
 . L +^VEN(7.1,DA):0 I $T D ^DIE L -^VEN(7.1,DA)
 . Q
 Q
 ; 
