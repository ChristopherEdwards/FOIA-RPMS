BLRLROS ; IHS/OIT/MKK - LAB ORDER STATUS ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;LR;**1034**;NOV 01, 1997;Build 88
 ;
 ; Cloned from LROS
 ; Will sort patient's data by Date, then by Order Number
 ;
EP ; EP
PEP ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S LRLOOKUP=1 ; Variable to indicate to lookup patients, prevent adding new entries in ^LRDPA
 ;
 K DIC,LRDPAF,%DT("B") S DIC(0)="A"
 D ^LRDPA G:(LRDFN=-1)!$D(DUOUT)!$D(DTOUT) LREND
 D L0 G EP
 ;
L0 ; EP
 D ENT S %DT="" D DT^LRX
 ;
L1 ; EP
 S LREND=0,%DT="E",%DT("A")="DATE to begin review: " D DATE^LRWU G LREND:Y<1
 S (LRSDT,LRODT)=Y S %DT="",X="T-"_$S($P($G(^LAB(69.9,1,0)),U,9):$P(^(0),U,9),1:30) D ^%DT S LRLDAT=Y
 ;
L2 ; EP
 S LRSN=$O(^LRO(69,LRODT,1,"AA",LRDFN,0))
 I LRSN<1 S Y=LRODT D DD^LRX S X1=LRODT,X2=-1 D C^%DTC S LRODT=X I LRODT<LRLDAT W !!,"NO REMAINING ACTIVE ORDERS",! G LREND
 ;
 K ^TMP("BLRLROS",$J)
 S LRODT=$$FMADD^XLFDT(LRODT,1)
 F  S LRODT=$O(^LRO(69,"D",LRDFN,LRODT),-1)  Q:LRODT<1  D
 . S LRSP=.9999999
 . F  S LRSP=$O(^LRO(69,"D",LRDFN,LRODT,LRSP))  Q:LRSP<1  D
 .. S ORDNUM=+$G(^LRO(69,LRODT,1,LRSP,.1))
 .. Q:ORDNUM<1
 .. S ^TMP("BLRLROS",$J,LRODT,ORDNUM,LRSP)=""
 ;
 D NEWHEAD
 ;
 S LRODT="A",LREND=""
 F  S LRODT=$O(^TMP("BLRLROS",$J,LRODT),-1)  Q:LRODT<1!($G(LREND))  D
 . S ORDNUM=""
 . F  S ORDNUM=$O(^TMP("BLRLROS",$J,LRODT,ORDNUM),-1)  Q:ORDNUM<1!($G(LREND))  D
 .. S LRSN=""
 .. F  S LRSN=$O(^TMP("BLRLROS",$J,LRODT,ORDNUM,LRSN))  Q:LRSN<1!($G(LREND))  D
 ... D ORDER
 ... Q:$G(LREND)
 ... I $Y>(IOSL-6) D HED
 ;
 I $G(LREND) D ^XBCLS  Q
 ;
 W !!
 K ^TMP("BLRLROS",$J)
 Q
 ;
 D WAIT:$Y>18 G LREND:LREND,L2:LRSN<1
 I LRSDT'=LRODT W !,"Orders for date: " S Y=LRODT D DD^LRX W Y," OK" S %=1 D YN^DICN I %'=1 G LREND
 D ENTRY G LREND:LREND S X1=LRODT,X2=-1 D C^%DTC S LRODT=X
 G L2
 ;
ENTRY D HED Q:LREND
 S LRSN=0 F  S LRSN=$O(^LRO(69,LRODT,1,"AA",LRDFN,LRSN)) Q:LRSN<1!($G(LREND))  D ORDER Q:$G(LREND)  D HED:$Y>(IOSL-2)
 Q
 ;
ORDER ; EP - call with LRSN, from LROE, LROE1, LRORD1, LROW2, LROR1
 NEW ORDERNUM,LRDOC
 ;
 K D,LRTT S LREND=0
 Q:'$D(^LRO(69,LRODT,1,LRSN,0))
 ;
 S LROD0=^LRO(69,LRODT,1,LRSN,0),LROD1=$S($D(^(1)):^(1),1:""),LROD3=$S($D(^(3)):^(3),1:"")
 ;
 S ORDERNUM=$$GET1^DIQ(69.01,LRSN_","_LRODT,9.5,"I")
 S LRDOC=$$GET1^DIQ(69.01,LRSN_","_LRODT,7)
 ;
 D ORDERHED
 D WAITBAN Q:$G(LREND)
 S X=$P(LROD0,U,3),X=$S(X:$S($D(^LAB(62,+X,0)):$P(^(0),U),1:""),1:""),X4="" I $D(^LRO(69,LRODT,1,LRSN,4,1,0)),+^(0) S X4=+^(0),X4=$S($D(^LAB(61,X4,0)):$P(^(0),U),1:"")
 I $E($P(LROD1,U,6))="*" W !?3,$P(LROD1,U,6) D HEDBAN  Q:$G(LREND)
 I $G(^LRO(69,LRODT,1,LRSN,"PCE")) W !,?5,"Visit Number(s): ",$G(^("PCE")) D HEDBAN Q:$G(LREND)
 W !?2,X,"  " W:X'[X4 X4 S I=0 F  S I=$O(^LRO(69,LRODT,1,LRSN,6,I)) Q:I<1!($G(LREND))  W !?5,": ",^(I,0) D HEDBAN Q:$G(LREND)
 S LRACN=0 F  S LRACN=$O(^LRO(69,LRODT,1,LRSN,2,LRACN)) Q:LRACN<1!($G(LREND))  I $D(^(LRACN,0))#2 S LRACN0=^(0) D TEST
 Q
 ;
TEST ; EP
 N LRY,LRURG
 S LRROD=$P(LRACN0,U,6),(Y,LRLL,LROT,LROS,LROSD,LRURG)="",X3=0
 I $P(LRACN0,"^",11) G CANC
 S X=$P(LROD0,U,4),LROT=$S(X="WC":"Requested (WARD COL)",X="SP":"Requested (SEND PATIENT)",X="LC":"Requested (LAB COL)",X="I":"Requested (IMM LAB COL)",1:"undetermined")
 S X=$P(LROD1,U,4),(LROOS,LROS)=$S(X="C":"Collected",X="U":"Uncollected, cancelled",1:"On Collection List") S:X="C" LROT=""
 I '(+LRACN0) W !!,"BAD ORDER ",LRSN,!,$C(7) D HEDBAN Q
 G NOTACC:LROD1="" ;,NOTACC:$P(LROD1,"^",4)="U"
 ;
TST1 ; EP
 S X1=+$P(LRACN0,U,4),X2=+$P(LRACN0,U,3),X3=+$P(LRACN0,U,5)
 G NOTACC:'$D(^LRO(68,X1,1,X2,1,X3,0)),NOTACC:'$D(^(3)) S LRACD=$S($D(^(9)):^(9),1:"")
 I '$D(LRTT(X1,X2,X3)) S LRTT(X1,X2,X3)="",I=0 F  S I=$O(^LRO(68,X1,1,X2,1,X3,4,I)) Q:I<.5!($G(LREND))  S LRACC=^(I,0),LRTSTS=+LRACC D TST2
 I $E($P(LROD1,U,6))="*" W !,?20,$P(LROD1,U,6) D HEDBAN
 Q
 ;
TST2 ; EP
 N I
 S LRURG=+$P(LRACC,U,2) I LRURG>49 Q
 I 'LRTSTS W !!,"BAD ACCESSION TEST POINTER: ",LRTSTS Q
 S LROT="",LROS=LROOS,LRLL=$P(LRACC,U,3),Y=$P(LRACC,U,5) I Y S LROS=$S($E($P(LRACC,U,6))="*":$P(LRACC,U,6),1:"Test Complete") D DATE S LROSD=Y D WRITE  Q:LREND  D COM(1.1),COM(1) Q
 S Y=$P(LROD3,U) D DATE S LROSD=Y I LRLL S LROS="Testing In Progress"
 I $P(LROD1,"^",4)="U" S (LROS,LROOS)=""
 D WRITE,COM(1.1),COM(1)
 Q
 ;
WRITE ; EP+
 W !?2,$S($D(^LAB(60,+LRTSTS,0)):$P(^(0),U),1:"BAD TEST POINTER")
 I $X>19 W ! D WAITBAN Q:(LREND)
 W ?20,$S($D(^LAB(62.05,+LRURG,0)):$P(^(0),U),1:"")," " D WAITBAN  Q:$G(LREND)
 I $X>28 W ! D WAITBAN Q:$G(LREND)
 W ?28,LROT," ",LROS,?43," ",LROSD
 W:X3 ?62,$S($D(^LRO(68,X1,1,X2,1,X3,.2)):^(.2),1:"")
 I LRROD W !?46,"  See order: " D REVIDEO^BLRUTIL3(" "_LRROD_" ")  D WAITBAN  Q:$G(LREND)
 ;
 D:$L($G(^LRO(69,LRODT,1,LRSN,2,LRACN,9999999))) CLININDD
 ;
 Q
 ;
CLININDD ; EP - Display 'Clinical Indication' Data
 NEW ORDIEN,CLININD,ICD,ICDCODE,ICDIEN,ICDSTR,SNOMED,TAB,UID
 ;
 S ORDIEN=LRACN_","_LRSN_","_LRODT
 S CLININD=$$GET1^DIQ(69.03,ORDIEN,9999999.1)
 S SNOMED=$$GET1^DIQ(69.03,ORDIEN,9999999.2)
 S UID=$P($G(^LRO(68,+$G(X1),1,+$G(X2),1,+$G(X3),.3)),"^")
 S TAB=5
 ;
 W:$L(SNOMED)!($L(UID)) !
 ;
 W:$L(SNOMED) ?9,"SNOMED: ",SNOMED
 W:$L(UID) ?57,"UID: ",UID
 ;
 I $L(CLININD) W !,?9,"Clinical Indication: "  D LINEWRAP^BLRGMENU($X,CLININD,(IOM-$X))
 ;
 S ICD=0,ICDCNT=0
 F  S ICD=$O(^LRO(69,LRODT,1,LRSN,2,LRACN,2,ICD))  Q:ICD<1  D
 . W !
 . S ICDIEN=$$GET1^DIQ(69.05,ICD_","_ORDIEN,.01,"I")
 . S ICDSTR=$$ICDDX^ICDEX(ICDIEN)
 . W ?9,"ICD:",$P(ICDSTR,"^",2)
 . D LINEWRAP^BLRGMENU(24,$P(ICDSTR,"^",4),56)
 Q
 ;
COM(LRMMODE) ; EP
 Q:LREND
 ;Write comments
 ;LRMMODE=comments node to display
 N LRTSTI
 S:'$G(LRMMODE) LRMMODE=1
 S LRTSTI=$O(^LRO(69,LRODT,1,LRSN,2,"B",+LRTSTS,0)) Q:'LRTSTI
 D COMWRT(LRODT,LRSN,LRTSTI,LRMMODE,3)
 Q
 ;
COMWRT(LRODT,LRSN,LRTSTI,NODE,TAB) ; EP
 ;Write comment node
 I $S('LRODT:1,'LRSN:1,'LRTSTI:1,'NODE:1,1:0) Q
 Q:'$D(^LRO(69,LRODT,1,LRSN,2,LRTSTI))
 S TAB=$G(TAB,3)
 N LRI,LINES,STR
 S (LINES,LRI)=0
 F  S LRI=$O(^LRO(69,LRODT,1,LRSN,2,LRTSTI,NODE,LRI)) Q:LRI<1!($G(LREND))  D
 . S STR=$G(^LRO(69,LRODT,1,LRSN,2,LRTSTI,NODE,LRI,0))
 . Q:$L(STR)<1
 . ;
 . W !,?TAB,": "
 . D LINEWRAP^BLRGMENU(TAB+2,STR,(IOM-TAB))
 . D WAIT
 Q
 ;
NOTACC ; EP
 I $G(LROD3)="" S LROS="" G NO2
 I $P(LROD3,U,2)'="" S LROS=" ",Y=$P(LROD3,U,2) G NO2
 S Y=$P(LROD3,U) S LROS=" "
 ;
NO2 ; EP
 S:'Y Y=$P(LROD0,U,8) S Y=$S(Y:Y,+LROD3:+LROD3,+LROD1:+LROD1,1:LRODT) D DATE S LROSD=Y
 S LRTSTS=+LRACN0,LRURG=$P(LRACN0,U,2)
 S LROS=$S(LRROD:"Combined",1:LROS) S:LROS="" LROS="for: "
 I LRTSTS D WRITE,COM(1.1),COM(1) ;second call for backward compatibility - can be removed in future years (1/98)
 I $L($P(LROD1,U,6)) W !,?20,$P(LROD1,U,6) D WAIT
 Q
 ;
DATE ; EP
 S Y=$$FMTE^XLFDT(Y,"5MZ")
 Q
 ;
HED ; EP
 ; D:$E(IOST,1)="C"&($Y>18) WAIT
 Q:$G(LREND)
 Q:$Y<18
 ;
 W !
 K DIR,X,Y
 S DIR(0)="E"
 D ^DIR
 I +$G(DIRUT) S LREND=".^"[X  Q
 ;
 D NEWHEAD
 ;
ENT ; EP - from LROE, LROE1, LRORD1, LROW2
 Q
 ;
LREND I $E(IOST)="P" W @IOF
 S:$D(ZTQUEUED) ZTREQ="@"
 K LRLDAT,LRURG,LROSD,LRTT,LROS,LROOS,LRROD,X1,X2,X3,%,A,DFN,DIC,I,K,LRACC,LRACN,LRACN0,LRDFN,LRDOC,LRDPF,LREND,LRLL,LROD0,LROD1,LROD3,LRODT,LROT,LRSDT,LRSN,LRTSTS,X,X4,Y,Z,%Y,DIWL,DIWR,DPF,PNM
 Q
 ;
SHOW ; EP - call with LRSN,LRODT, from LRCENDEL, LRTSTJAN
 S LREND=0
 D NEWHEAD
 D ORDER
 Q
 ;
WAIT ; EP
 Q:$Y<(IOSL-6)
 I $E(IOST)'="C" W @IOF  Q
 ;
 W !
 K DIR,X,Y
 S DIR(0)="E"
 D ^DIR
 I +$G(DIRUT) S LREND=".^"[X  Q
 ;
 D NEWHEAD
 Q
 ;
CANC ; EP - For Canceled tests
 S LRTSTS=+$G(LRACN0),LROT="*Canceled by: "_$P(^VA(200,$P(LRACN0,"^",11),0),U)
 I LRTSTS D WRITE,COM(1.1),COM(1) ;second call for backward compatitility - can be removed in future years (1/98)
 Q
 ;
HEDBAN ; EP
 Q:$G(LREND)
 Q:$Y<18
 ;
 I $E(IOST)'="C" W @IOF Q
 ;
 W !
 K DIR,X,Y
 S DIR(0)="E"
 D ^DIR
 I +$G(DIRUT) S LREND=".^"[X  Q
 ;
 D NEWHEAD
 I +$G(PG)>1 D ORDERHED  W !
 Q
 ;
WAITBAN ; EP
 Q:$Y<(IOSL-4)
 I $E(IOST)'="C" W @IOF Q
 ;
 W !
 K DIR,X,Y
 S DIR(0)="E"
 D ^DIR
 I +$G(DIRUT) S LREND=".^"[X  Q
 ;
 D NEWHEAD
 I +$G(PG)>1 D ORDERHED  W !
 Q
 ;
ORDERHED ; EP
 I $Y+3>(IOSL-4) D NEWHEAD
 ; W !,$$COLHEAD^BLRGMENU("Order Date: "_$$FMTE^XLFDT(LRODT,"5DZ"),80)
 W !,"Lab Order #: " D:ORDERNUM REVIDEO^BLRUTIL3(" "_ORDERNUM_" ")
 W ?45,"Provider: ",$E(LRDOC,1,25)
 Q
 ;
NEWHEAD ; EP
 W @IOF
 W ?2,"Test",?20,"Urgency",?30,"Status",?62,"Accession"
 W !
 W $TR($J("",IOM)," ","-")
 S PG=1+$G(PG)
 Q