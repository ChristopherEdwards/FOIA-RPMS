LR7OEVNT ;slc/dcm - Process MAS events ;8/11/97
 ;;5.2T9;LR;**1018**;Nov 17, 2004
 ;;5.2;LAB SERVICE;**121,226,230,256**;Sep 27, 1994
 ;
 ;This routine invokes IA #2576
 ;
EN(DFN,DGPMT,DGPMA,DGPMP,TASK) ;Route MAS events
 Q:'$D(DFN)  Q:'$D(DGPMT)  Q:$G(DGPMP)
 ;If both DGPMA and DGPMP have values, it's an edit.
 ;If only DGPMA has values it's new
 ;If only DGPMP has values it's a deletion
 I $G(TASK) D  Q
 . N ZTSK,ZTRTN,ZTDTH,ZTSAVE,ZTDESC,ZTIO
 . S ZTDTH=$H,ZTIO="OR MOVEMENT RESOURCE",ZTSAVE("DFN")="",ZTSAVE("DGPMA")="",ZTSAVE("DGPMT")=""
 . S ZTRTN="EN1^LR7OEVNT",ZTDESC="Auto-cancel labs on "_$S(DGPMT=1:"ADMIT",DGPMT=3:"DISCHARGE",DGPMT=6:"SPECIALTY TRANSFER",1:"???")
 . D ^%ZTLOAD
 . I '$D(ZTSK) W !!,$C(7),"Lab auto-cancel failed to task!",!,"Check to make sure you have the resource device OR MOVEMENT RESOURCE defined."
EN1 ;Tasked entry point
 N LRDFN,REASON
 Q:'$D(DFN)  Q:'$D(DGPMT)
 S LRDFN=$$LRDFN^LR7OR1(DFN)
 Q:'LRDFN
 I $D(ZTQUEUED) S ZTREQ="@"
 I DGPMT=1 G ADM
 I DGPMT=2 G XFER
 I DGPMT=6 G XFER
 I DGPMT=3 G DIS
 Q
ADM ;Process Admit event
 Q:'$P($G(^LAB(69.9,1,"OR")),"^",3)
 S REASON=$O(^ORD(100.03,"C","ORADMIT",0))
 D 69(REASON)
 Q
DIS ;Process Discharge event
 Q:'$P($G(^LAB(69.9,1,"OR")),"^",4)
 S REASON=$O(^ORD(100.03,"C","ORDIS",0))
 D 69(REASON)
 Q
XFER ;Process Service Transfer event
 Q:'$P($G(^LAB(69.9,1,"OR")),"^",5)
 N LOC,X,LRODT,LRSN
 I '$$TSCHANGE(DGPMA) Q  ;no change in T.S.
 S REASON=$O(^ORD(100.03,"C","ORSPEC",0))
 D 69(REASON)
 Q
69(REASON) ;Do 69
 N LRODT,LRSN,X,I,TST,NATURE
 I $G(REASON) S NATURE=$$DC1^LROR6(REASON)
 I '$D(ZTQUEUED),'$G(DGQUIET) W !,"Canceling uncollected Lab orders..."
 S LRODT=0
 F  S LRODT=$O(^LRO(69,"D",LRDFN,LRODT)) Q:LRODT<1  S LRSN=0 F  S LRSN=$O(^LRO(69,"D",LRDFN,LRODT,LRSN)) Q:LRSN<1  I $D(^LRO(69,LRODT,1,LRSN,0)),'$D(^(1)) S X=^(0) D
 . I $P(X,"^",4)="SP",$P(X,"^",8)'<$P($$NOW^XLFDT,".") Q  ;Keep if Send Patient for future orders & 'todays' orders
 . S TST=0 F  S TST=$O(^LRO(69,LRODT,1,LRSN,2,TST)) Q:TST<1  I $D(^(TST,0)),'$P(^(0),"^",11) S X=^(0) D
 .. S I(+X)=""
 . I $O(I(0)) D NEW^LR7OB1(LRODT,LRSN,"OC",$G(NATURE),.I) S I=0 D
 .. F  S I=$O(^LRO(69,LRODT,1,LRSN,2,I)) Q:I<1  S X=^(I,0) I $D(I(+X)) S $P(^(0),"^",9,11)="CA^L^"_DUZ
 Q
 ;Admission - don't cancel if SP & Startdate>NOW
 ;Transfer -  don't cancel if SP & Startdate>NOW
 ;Discharge - don't cancel if SP & Startdate>NOW
TSCHANGE(NODE) ; -- return 1 if specialty changed, otherwise 0
 N CA,CHANGE,DFN,ID,TS,LAST,%,%H,%I,VAERR,VAIN
 S CHANGE=0,DFN=$P(NODE,"^",3),VAINDT=+NODE
 D INP^VADPT
 S TS=$G(VAIN(3)),DFN=$P(NODE,"^",3),VAINDT=+NODE-.000001
 D INP^VADPT
 S LAST=$G(VAIN(3))
 I TS'=LAST S CHANGE=1
 Q CHANGE
