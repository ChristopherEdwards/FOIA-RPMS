BLRAG05D ; IHS/MSC/SAT - SUPPORT FOR LABORATORY ACCESSION GUI RPCS ; Nov 30, 2012
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997;Build 185
 ;
 ;
LROE2 ;
 I $D(^LRO(69,LRODT,1,DA,1)),$P(^(1),U,4)="C" S LRNONE=2,LRCHK=LRCHK+1
 K LRSN
 S (LRSN,LRSN(DA))=+DA
 I '$D(^LRO(69,LRODT,1,LRSN,0)) Q
 ; S M9=$G(M9)+1,LRZX=^LRO(69,LRODT,1,LRSN,0),LRDFN=+LRZX,LRDPF=$P(^LR(LRDFN,0),U,2),DFN=$P(^(0),U,3) D PT^LRX W !,PNM,?30,SSN S LRWRDS=LRWRD
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1027
 S M9=$G(M9)+1
 S LRZX=^LRO(69,LRODT,1,LRSN,0)
 S LRDFN=+LRZX
 S LRDPF=$P(^LR(LRDFN,0),U,2)  S DFN=$P(^(0),U,3)
 D PT^LRX
 ;W !,PNM,?30,HRCN
 S LRWRDS=$G(LRWRD)  ;ZSAT: where is this set up?
 ;----- END IHS MODIFICATIONS LR*5.2*1027
 ;W ?45,"Requesting location: ",$P(LRZX,U,7) S Y=$P(LRZX,U,5) D DD^LRX W !,"Date/Time Ordered: ",Y,?45,"By: ",$S($D(^VA(200,+$P(LRZX,U,2),0)):$P(^(0),U),1:"")
 ;S LRSVSN=LRSN D ORDER^LROS S LRSN=LRSVSN
 Q
 ;
YN ;
 Q
 ;
TASK ;
 S IOP=$P($G(^LAB(69.9,1,3.5,+DUZ(2),0)),U,3)
 D ^%ZIS
 S LRLABLIO=ION_";"_IOST_";"_IOM_";"_IOSL
 D ^%ZISC
 ;D CLOSE^%ZISUTL("LRLABEL")
 I $D(LRLABLIO),$D(LRLBL) D
 .S ZTRTN="ENT^LRLABLD",ZTDTH=$H,ZTDESC="LAB LABELS",ZTIO=LRLABLIO,ZTSAVE("LRLBL(")=""
 .D ^%ZTLOAD
 K LRLBL
 D ^%ZISC
 D STOP^LRCAPV K LRCOM,LRSPCDSC,LRCCOM,LRTCOM
 Q
 ;
 ;
END K DIR,DIRUT,GOT
 D ^LRORDK,LROEND^LRORDK,STOP^LRCAPV
 Q
 ;
 ;
GOT(ORD,ODT) ;See if all tests have been canceled
 N I,SN,ODT
 S (GOT,ODT,SN)=0
 F  S ODT=$O(^LRO(69,"C",ORD,ODT)) Q:ODT<1  D
 . S SN=0 F  S SN=$O(^LRO(69,"C",ORD,ODT,SN)) Q:SN<1!(GOT)  D
 . . Q:'$D(^LRO(69,ODT,1,SN,0))
 . . S I=0 F  S I=$O(^LRO(69,ODT,1,SN,2,I)) Q:I<1  I $D(^(I,0)),'$P(^(0),"^",11) S GOT=1 Q
 Q GOT
 ;
 ;
UNL69 ;
 L -^LRO(69,"C",+$G(LRORD))
 TCOMMIT
 Q
UNL69ERR ;
 L -^LRO(69,"C",+$G(LRORD))
 TROLLBACK
 Q
 ;
P15 ;from LRVER,LRVR,LRGV  (P15^LROE1)
 N COMB
 ;S E=0 F  S E=$O(^LRO(69,LRODT,1,LRSN,2,E)) Q:'E  W !,$P(^LAB(60,+^(E,0),0),"^")
 ;store estimated date/time of collection
 ;D TIME^LROE Q:LRCDT<1  S LRUN=$P(LRCDT,"^",2),LRTIM=+LRCDT,LRNT=LRTIM S $P(^LRO(69,LRODT,1,LRSN,0),U,8)=LRTIM
 S LRCDT=$G(BLRCDT)_"^"
 S LRUN=$P(LRCDT,"^",2),LRTIM=+LRCDT,LRNT=LRTIM
 S $P(^LRO(69,LRODT,1,LRSN,0),U,8)=LRTIM
 S:$P($G(^LRO(69,LRODT,1,LRSN,1)),U,1)="" $P(^LRO(69,LRODT,1,LRSN,1),U,1)=LRTIM
 S:($P($G(^LRO(69,LRODT,1,LRSN,1)),U,3)="")&$G(BLRCUSR) $P(^LRO(69,LRODT,1,LRSN,1),U,3)=BLRCUSR
 I '$D(LRCDT) S (LRCDT,LRTIM,LRNT)=$P(^LRO(69,LRODT,1,LRSN,0),U,8),LRUN=""
 ;if lab collect and a collection node, set REPORT ROUTING LOCATION and ORDERING LOCATION, then call P15A for more collection storage
 ;I $P(^LRO(69,LRODT,1,LRSN,0),U,4)="LC",$D(^(1)) S LRLLOC=$P(^(0),U,7),LROLLOC=$P(^(0),U,9),LRNT=$S($D(LRNT):LRNT,$D(LRTIM):LRTIM,$D(LRCDT):+LRCDT,1:"") D P15A Q
 I $P(^LRO(69,LRODT,1,LRSN,0),U,4)'="",$D(^(1)) S LRLLOC=$P(^(0),U,7),LROLLOC=$P(^(0),U,9),LRNT=$S($D(LRNT):LRNT,$D(LRTIM):LRTIM,$D(LRCDT):+LRCDT,1:"") D P15A Q
 S COMB=$P($G(^LRO(69,LRODT,1,LRSN,1)),"^",7)
 ;store collection node
 S ^LRO(69,LRODT,1,LRSN,1)=LRTIM_"^"_LRUN_"^"_BLRCUSR_"^"_LRSTATUS_"^^^"_COMB_"^"_DUZ(2)
 S:LRSTATUS="C" ^LRO(69,"AA",+$G(^LRO(69,LRODT,1,LRSN,.1)),LRODT_"|"_LRSN)=""
 Q
 ;
P15A ;from LROE1, LRPHEXPT   (P15^LRPHITEM)
 N LRORIFN,LRX712,LRUIDA
 N BLRSETUP
 ;
 Q:'$D(^LRO(69,LRODT,1,LRSN,1))  Q:$L($P(^LRO(69,LRODT,1,LRSN,1),U,4))  S J1=^(1),LRX712=^(0)
 S LRDFN=+LRX712 K LRDPF
 D
 . N LRRB
 . D PT^LRX
 S LROLLOC=$P(LRX712,U,9)
 S LRTREA=+$G(VAIN(3))
 S LRORIFN=$P(LRX712,U,11)
 S LRNT=$$NOW^XLFDT
 ;
 ;S ^LRO(69,LRODT,1,LRSN,1)=$P(J1,U,1,2)_"^"_DUZ_"^"_$P(J1,U,4)_"^^"_$P(J1,U,6)_"^"_$P(J1,U,7)
 S:$P($G(^LRO(69,LRODT,1,LRSN,1)),U,3)="" $P(^LRO(69,LRODT,1,LRSN,1),U,3)=BLRCUSR
 ;
 S $P(^LRO(69,LRODT,1,LRSN,3),U)=LRNT,^LRO(69,LRODT,1,"AC",LRLLOC,LRSN)=""
 S (LRAA,LRAD,LRAN,LRTN)=0
 F  S LRTN=$O(^LRO(69,LRODT,1,LRSN,2,LRTN)) Q:LRTN<1  D
 . I '$D(^LRO(69,LRODT,1,LRSN,2,LRTN,0)) Q
 . S X=^LRO(69,LRODT,1,LRSN,2,LRTN,0),LRAA=+$P(X,U,4),LRAD=+$P(X,U,3),LRAN=+$P(X,U,5),LRORIFN=$P(X,U,7)
 . S:'$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U,1) $P(^LRO(68,LRAA,1,LRAD,1,LRAN,3),U,1)=$G(BLRCDT),$P(^LRO(68,LRAA,1,LRAD,1,LRAN,3),U,5)=9999999-$G(BLRCDT)
 . S BLRSETUP=$$SETUP^BLRAGUT1()
 . S:$G(MSCRLCLA)="" MSCRLCLA=$G(BLRRLCLA)
 . D P15A^LRPHITEM
 . S BLRRLCLA=MSCRLCLA
 . I $D(^LRO(68,LRAA,1,LRAD,1,LRAN,3)) D
 . . S $P(^LRO(68,LRAA,1,LRAD,1,LRAN,3),U,3)=LRNT
 . . S ^LRO(68,LRAA,1,LRAD,1,"E",LRNT,LRAN)=""
 ;
 I +$G(LRDPF)=2 D
 . N CONTROL
 . S CONTROL=$S($L(LRORIFN):"SC",1:"SN")
 . D NEW^LR7OB1(LRODT,LRSN,CONTROL,,,6)
 ;
 N LRX
 S LRX=""
 F  S LRX=$O(LRUIDA(LRX)) Q:LRX=""  D EN^LA7ADL(LRX)
 Q
 ;
Q15 ; (^LROE2)
 Q:'$D(^LRO(69,LRODT,1,LRSN,0))
 ;store collection data if not collected
 I $D(^LRO(69,LRODT,1,LRSN,1)),$P(^LRO(69,LRODT,1,LRSN,1),"^",4)="U" D
 .I $G(BLRUNC)'=1 S BLRRET="BLRAG05: This specimen has already been marked as UNCOLLECTED." S BLREF=1 Q  ;ZSAT: 5) Continue if uncollected is OK?
 .I $G(BLRUNC)=1 S ^LRO(69,LRODT,1,LRSN,1)=LRTIM_"^^"_BLRCUSR,DA=LRSN,DA(1)=LRODT,DIE="^LRO(69,"_DA(1)_",1,",DR=16 D ^DIE
 Q:BLREF
 ;store patient confirmation data
 D:(BLRPTCM'="")&(BLRPTCU'="") PTCS(LRODT,LRSN,BLRPTCU,$$NOW^XLFDT(),BLRPTCM)
 S DA=DT,LRDFN=+^LRO(69,LRODT,1,LRSN,0),LRDPF=+$P(^LR(LRDFN,0),U,2)
 ;
 ;if no collection node, go make one
 ;IF '$D(^LRO(69,LRODT,1,LRSN,1)) S LRSTATUS="C",DA=LRODT I '$D(LRSND) D P15 Q:LRCDT<1
 ;updates to collection node
 ;I $D(LRSND),$P(^LRO(69,LRODT,1,LRSN,0),U,4)="",$D(^(1)) S LRLLOC=$P(^(0),U,7),LROLLOC=$P(^(0),U,9),LRNT=$S($D(LRNT):LRNT,$D(LRTIM):LRTIM,$D(LRCDT):+LRCDT,1:"") D P15A G PH
 ;I $D(LRSND) N COMB S COMB=$P($G(^LRO(69,LRODT,1,LRSN,1)),"^",7) S ^LRO(69,LRODT,1,LRSN,1)=LRTIM_"^"_LRUN_"^"_BLRCUSR_"^"_LRSTATUS_"^^^"_COMB_"^"_DUZ(2) S:LRSTATUS="C" ^LRO(69,"AA",+$G(^LRO(69,LRODT,1,LRSN,.1)),LRODT_"|"_LRSN)=""
 ;
PH G Q16:LRORD Q
Q16 S J=0 D CHECK^LROW2 I J S BLRRET="BLRAG05: The ORDER NUMBER (LRDFN) is in use, contact the site manager.  This order has been CANCELED, you will need to re-order." S BLREF=1 Q
Q16A ;I $D(LRLONG),$D(LRSND) S LRSN=LRSND,^TMP("LROE",$J,"LRORD")=LRORD_U_LRODT_U_LRTIM_U_PNM_U_SSN
 I $D(LRLONG),$D(LRSND) S LRSN=LRSND,^TMP("LROE",$J,"LRORD")=LRORD_U_LRODT_U_LRTIM_U_PNM_U_HRCN  ;IHS/ANMC/CLS 08/18/96
 K DR S LRTSTS=0
 N MSCLRSN
 S LRSN=0 F  S LRSN=$O(LRSN(LRSN)) Q:'LRSN  S MSCLRSN=LRSN D Q17 S LRSN=MSCLRSN
 ;I $D(LRLONG),$D(LRSND) S LRSN=LRSND D LROE^LRFAST S X=^TMP("LROE",$J,"LRORD"),LRORD=+X,LRODT=$P(X,"^",2),LRTIM=$P(X,"^",3),LRLONG="",PNM=$P(X,"^",4),SSN=$P(X,"^",5)
 I 0,$D(LRLONG),$D(LRSND) S LRSN=LRSND D LROE^LRFAST S X=^TMP("LROE",$J,"LRORD"),LRORD=+X,LRODT=$P(X,"^",2),LRTIM=$P(X,"^",3),LRLONG="",PNM=$P(X,"^",4),SSN=$P(X,"^",5),HRCN=$P(X,"^",5)  ;IHS/ANMC/CLS 08/18/96
 Q
Q17 ;S I=$O(^LRO(69,LRODT,1,LRSN,6,0)),J=$O(^(1)) S:'$D(IOM) IOM=80 K LRSPCDSC S:J LRSPCDSC=^(J,0) S:I DA=LRSN,DA(1)=LRODT,DR=6,DIC="^LRO(69,"_LRODT_",1," D EN^DIQ:I D LRSPEC^LROE1
 S I=$O(^LRO(69,LRODT,1,LRSN,6,0)),J=$O(^LRO(69,LRODT,1,LRSN,6,1)) S:'$D(IOM) IOM=80 K LRSPCDSC S:J LRSPCDSC=^LRO(69,LRODT,1,LRSN,6,J,0) S:I DA=LRSN,DA(1)=LRODT,DR=6,DIC="^LRO(69,"_LRODT_",1," D:$D(^LRO(69,LRODT,1,LRSN,0)) LRSPEC^LROE1
 D OLD K ^TMP("LR",$J,"TMP")
 ;store collected status, institution, and xref
 S $P(^LRO(69,LRODT,1,LRSN,1),U,4)="C",$P(^LRO(69,LRODT,1,LRSN,1),U,8)=DUZ(2),^LRO(69,"AA",+$G(^LRO(69,LRODT,1,LRSN,.1)),LRODT_"|"_LRSN)=""
 Q
 ;
OLD ;to allow unchanged routines to still work, from LROE1, LRPHSET1  (OLD^LRORDST)
 N LRNT
 D DT^LRORDST,NOW^%DTC
 S LRNT=%
 I $P(LRPARAM,U,4),'$D(LRNOLABL),'$D(LRTJ),0 D ^BLRAG05A  ;ZSAT
 S LRQUIET=1
 D ^BLRAG05B
 ;
 ;if no collection node, go make one
 IF '$D(^LRO(69,LRODT,1,LRSN,1)) S LRSTATUS="C",DA=LRODT D P15 Q:LRCDT<1
 ;updates to collection node
 I $D(LRSND),$P(^LRO(69,LRODT,1,LRSN,0),U,4)'="",$D(^(1)) S LRLLOC=$P(^(0),U,7),LROLLOC=$P(^(0),U,9),LRNT=$S($D(LRNT):LRNT,$D(LRTIM):LRTIM,$D(LRCDT):+LRCDT,1:"") D P15A Q
 I $D(LRSND) N COMB S COMB=$P($G(^LRO(69,LRODT,1,LRSN,1)),"^",7) S ^LRO(69,LRODT,1,LRSN,1)=LRTIM_"^"_LRUN_"^"_BLRCUSR_"^"_LRSTATUS_"^^^"_COMB_"^"_DUZ(2) S:LRSTATUS="C" ^LRO(69,"AA",+$G(^LRO(69,LRODT,1,LRSN,.1)),LRODT_"|"_LRSN)=""
 Q
 ;
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1021
BLRRL ;EP - cmi/anch/maw 8/4/2004 added to check for shipping manifest and print
 ;cmi/anch/maw REF LAB
 ;cmi/anch/maw 9/28/2004 changed to write only when a shipping manifest
 K BLRINS,BLRDXS  ;cmi/7/1/2010 reference lab ledi variables
 Q:$G(BLRGUI)
 Q:'$G(^BLRSITE(DUZ(2),"RL"))  ;reference lab not set up
 Q:$P($G(^BLRSITE(DUZ(2),"RL")),U,22)
 I $D(^TMP("BLRRL",$J)) D
 . ;W !,"Printing Shipping Manifests for Reference Lab..."
 . D PRT^BLRSHPM
 Q
 ;----- END IHS MODIFICATIONS cmi/anch/maw end REF LAB LR*5.2*1021
 ;
PTCS(BLRDT,BLRSPN,BLRUSER,BLRDTCF,BLRMETH) ;
 ; BLRDT   = (required) order date in external format - pointer to LAB ORDER ENTRY file 69
 ; BLRSPN  = (required) specimen number - pointer to specimen multiple in LAB ORDER ENTRY file 69
 ; BLRUSER = (required) user that did confirmation - pointer to NEW PERSON file 200
 ; BLRDTCF = (optional) Date/Time of user confirmation in external format - defaults to 'today'
 ; BLRMETH = (optional) method of confirmation - free text
 ;
 ;if confirmation date is null, default to NOW
 I $G(BLRDTCF)="" S BLRDTCF=$$HTFM^XLFDT($H)
 E  D
 .;convert external date to FM format
 .S X=BLRDTCF,%DT="XT" D ^%DT S BLRDTCF=Y
 .;default to 'NOW' if invalid date passed in
 .S:$$FR^XLFDT($G(BLRDTCF)) BLRDTCF=$$HTFM^XLFDT($H)
 K BLRM
 S BLRM=""
 S FDA(69.01,BLRSPN_","_+BLRDT_",",21400)=BLRUSER
 S FDA(69.01,BLRSPN_","_+BLRDT_",",21401)=BLRDTCF
 S FDA(69.01,BLRSPN_","_+BLRDT_",",21402)=BLRMETH
 D FILE^DIE("","FDA","BLRM")
 I $D(BLRM("DIERR")) D ERR^BLRAGUT("BLRAG01: "_BLRM("DIERR",1,"TEXT",1)) L -^LRO(69,BLRDT,1,BLRSPN) TROLLBACK  Q
 Q
 ;
ERROR ;
 D ENTRYAUD^BLRUTIL("ERROR^BLRAG05D 0.0")   ; Store Error data
 NEW ERRORMSG
 S ERRORMSG="$"_"Z"_"E=""ERROR^BLRAG05D"""  ; BYPASS SAC Checker
 S @ERRORMSG  D ^%ZTER
 D ERR("RPMS Error")
 Q
 ;
ERR(BLRERR) ;Error processing
 ; BLRERR = Error text OR error code
 ; BLRAGI   = pointer into return global array
 D UNL69ERR^BLRAG05D
 I +BLRERR S BLRERR=BLRERR+134234112 ;vbObjectError
 S BLRAGI=BLRAGI+1
 S ^TMP("BLRAG",$J,BLRAGI)=2_U_BLRERR_$C(30)
 S BLRAGI=BLRAGI+1
 S ^TMP("BLRAG",$J,BLRAGI)=$C(31)
 Q
