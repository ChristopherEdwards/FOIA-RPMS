BCHUADD ; IHS/TUCSON/LAB - ADD NEW CHR ACTIVITY RECORDS ;  [ 01/24/05  7:13 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**15,16**;OCT 28, 1996
 ;
 ;add new records
 ;get all items for a record, check record, file record
 ;if not complete record, issue warning and delete record
ADDR ;EP
 D FULL^VALM1
 I '$D(BCHPROV) W !!,"Provider not entered." Q
 I '$D(BCHDATE) W !!,"Date not entered." Q
 I '$D(BCHPROG) W !!,"Program not entered." Q
 S BCHQUIT=0
 ;create record with DICN
 ;use abbreviated form or regular form
 D CREATE
 I BCHQUIT D EXIT Q
RECD ;
 D GETRECD
 I BCHQUIT D EXITMSG,EXIT Q
 D RECCHECK^BCHUADD1
 I $D(BCHERROR) D EXITMSG,EXIT Q
PAT ;
 ;if number served '=1 don't ask patient
 I $P(^BCHR(BCHR,0),U,12)'=1,'$$NF(BCHR) G CHECK
 ;if a service code is 1-6 lookup patient
 S (X,Y,BCHPTSV)=0 F  S X=$O(^BCHRPROB("AD",BCHR,X)) Q:X'=+X!(Y)  I $P(^BCHRPROB(X,0),U,4)]"",$P(^BCHTSERV($P(^BCHRPROB(X,0),U,4),0),U,6) S Y=Y+1,BCHPTSV=1
 I 'Y G CHECK
 D GETPAT
 I BCHQUIT D EXITMSG,EXIT Q
MEAS ;
 I DFN!($P($G(^BCHR(BCHR,11)),U)]"") D GETMEAS
CHECK ;check record
 ;DO PCC LINK
 S BCHEV("TYPE")="A" ;add,edit or delete
 D PROTOCOL^BCHUADD1 ;protocol to announce chr record event
 D EXIT
 Q
CREATE ;create new record
 W !,"Creating new CHR record...",! K DD,D0,DO,DINUM,DIC,DA,DR S DIC("DR")=".02////"_+BCHPROG_";.03////"_+BCHPROV_";.16////"_DUZ_";.22///^S X=DT;.26///H;.17///^S X=DT"
 S DIC(0)="EL",DIC="^BCHR(",DLAYGO=90002,DIADD=1,X=BCHDATE K DD,DO D FILE^DICN D FMKILL
 I Y=-1 W !!,$C(7),$C(7),"Unable to create CHR Record record, record not complete!!  Deleting Record.",! D DEL S BCHQUIT=1 Q
 S BCHR=+Y
 Q
GETPAT ; GET PATIENT
 D GETPAT^BCHUADD1
 Q
GETRECD ;
 S APCDOVRR=""
 W !
 S DA=BCHR,DDSFILE=90002,DR=$S('$G(BCHUABFO):"[BCH ENTER CHRIS II DATA]",1:"[BCHB ENTER CHRIS II DATA]") D ^DDS
 D FMKILL
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG Q
 Q
GETSUBJ ;
 S DIR(0)="Y",DIR("A")="Do you want to enter SUBJECTIVE/OBJECTIVE INFORMATION",DIR("B")="N" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 Q:'Y
 S DA=BCHR,DDSFILE=90002,DR="[BCH ENTER/EDIT SUBJ/OBJ]" D ^DDS
 D FMKILL
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG Q
 Q
GETMEAS ;
 I '$D(DFN),'$G(^BCHR(BCHR,11))="" Q  ;no patient so no measurements
 I 'BCHPTSV Q  ;no patient related services so no measurements
 W !
 S DIR(0)="Y",DIR("A")=$S('$G(BCHUABFO):"Any MEASUREMENTS, TESTS or REPRODUCTIVE FACTORS",1:"Any MEASUREMENTS/TESTS"),DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 S DA=BCHR,DDSFILE=90002,DR=$S('$G(BCHUABFO):"[BCH ENTER MEASUREMENTS/TESTS]",1:"[BCHB ENTER MEASUREMENTS/TESTS") D ^DDS
 D FMKILL
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG Q
 Q
DEL ;
 S BCHVDLT=$P(^BCHR(BCHR,0),U,15)
 S BCHRDEL=BCHR
 D EN^BCHUDEL
 W !,"Record deleted." D PAUSE^BCHUTIL1
 Q
DR ;set up BCHDR string
 I '$D(BCHDR) S BCHDR=""
 I BCHDR="" S BCHDR=BCHF_"///"_BCHV
 S BCHDR=BCHDR_";"_BCHF_"///"_BCHV
 Q
FMKILL ;EP
 K DIE,DR,DA,D,DIU,DIY,DIV,DIW,DIG,DDSFILE,DIC,DIADD,DLAYGO,X,D0,DD,D1,DO
 Q
DIRX ;EP
 K DIR,X,Y,DIC,DA,DIRUT,DUOUT,DTOUT,DIG
 K BCHF,BCHV
 Q
EXITMSG ;display message, delete record, q
 W !,"Incomplete record.  Deleting record.  " D DEL
 Q
EXIT ;CLEAN UP AND EXIT
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER^BCHUARL
 S VALMCNT=BCHRCNT
 D HDR^BCHUAR
 K BCHV,BCHF,BCHDR,DFN,BCHR,BCHQUIT,BCHRDEL,BCHV,BCHVDLT,BCHNAME,BCHPTSV,BCHX,DFN,BCHERROR,BCHR0
 D DIRX^BCHUADD,FMKILL^BCHUADD
 Q
 ;
BV ;EP - called from protocol
 D ^BCHVD
 D EXIT
 Q
NF(R) ;not found?
 I '$G(R) Q ""
 NEW X,Y
 S (X,Y)=0 F  S X=$O(^BCHRPROB("AD",R,X)) Q:X'=+X!(Y)  I $P(^BCHRPROB(X,0),U,4)]"",$P(^BCHTSERV($P(^BCHRPROB(X,0),U,4),0),U,3)="NF" S Y=1
 Q Y
