BLRSGNSP ; IHS/MSC/MKK - Delete Order even though in SiGN or SYmptom Process ; 31-Jul-2015 06:30 ; MKK
 ;;5.2;LR;**1033,1035,1036**;NOV 1, 1997;Build 10
 ;
 ; Code cloned from LRCENDEL routine.
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
EP ; EP - ORDERN = Order Number
GETRID(ORDERN) ; EP - Cancel ALL Tests on an Order
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,ORDERN,U,XPARSYS,XQXFLG)
 ;
 S LRORT=+$G(^TMP("BLRDIAG",$J,"ORDER","ADDTST"))
 I LRORT  D GETRID1(ORDERN,LRORT)  Q
 ;
 S (DELCNT,LRODT)=0
 F  S LRODT=$O(^LRO(69,"C",ORDERN,LRODT))  Q:LRODT<1  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,"C",ORDERN,LRODT,LRSP))  Q:LRSP<1  D
 .. ;
 .. D OERRSTSC^BLRUTIL7(LRODT,LRSP)  ; IHS/MSC/MKK - LR*5.2*1035 
 .. ;
 .. S LRORT=0
 .. F  S LRORT=$O(^LRO(69,LRODT,1,LRSP,2,LRORT))  Q:LRORT<1  D
 ... S STR=$G(^LRO(69,LRODT,1,LRSP,2,LRORT,0))
 ... ;
 ... ; Skip if already cancelled
 ... Q:$L($P(^LRO(69,LRODT,1,LRSP,2,LRORT,0),"^",11))
 ... ;
 ... S FDAIENS=LRORT_","_LRSP_","_LRODT_","
 ... K FDA
 ... S FDA(69.03,FDAIENS,8)="CA"
 ... S FDA(69.03,FDAIENS,11)=$G(DUZ)
 ... D FILE^DIE("KS","FDA","ERRS")
 ... ; I $D(ERRS) D SHOWERRS^BLRADDCD("Order File")  Q
 ... I $D(ERRS) D ERRMSG^BLRSGNS3("GETRID: FILE^DIE","BLRSGNSP")  Q   ; IHS/MSC/MKK - LR*5.2*1035
 ... D MAKEMESG(LRODT,LRSP,LRORT)
 ... S DELCNT=DELCNT+1
 ... D DELACC(LRODT,LRSP,LRORT)
 ;
 K ^TMP("BLRDAIG",$J,"ORDER")
 K ^TMP("BLR SNOMED GET",$J,"HDR")
 Q:DELCNT<1
 ;
 W !!,"All Tests on Order ",ORDERN,":",!
 S LRODT=0
 F  S LRODT=$O(^LRO(69,"C",ORDERN,LRODT))  Q:LRODT<1  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,"C",ORDERN,LRODT,LRSP))  Q:LRSP<1  D
 .. S LRORT=0
 .. F  S LRORT=$O(^LRO(69,LRODT,1,LRSP,2,LRORT))  Q:LRORT<1  D
 ... S IENS=LRORT_","_LRSP_","_LRODT
 ... W ?4,$$GET1^DIQ(69.03,IENS,.01)," ",$$GET1^DIQ(69.03,IENS,8),!
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
GETRID1(ORDERN,LRORT) ; EP - Cancel One Test on an Order
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRORT,ORDERN,U,XPARSYS,XQXFLG)
 ;
 S LRODT=0
 F  S LRODT=$O(^LRO(69,"C",ORDERN,LRODT))  Q:LRODT<1  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,"C",ORDERN,LRODT,LRSP))  Q:LRSP<1  D
 .. S STR=$G(^LRO(69,LRODT,1,LRSP,2,LRORT,0))
 .. Q:$L(STR)<1
 .. ;
 .. ; Skip if already cancelled
 .. Q:$L($P(^LRO(69,LRODT,1,LRSP,2,LRORT,0),"^",11))
 .. ;
 .. D OERRSTSO^BLRUTIL7(LRODT,LRSP,LRORT)  ; IHS/MSC/MKK - LR*5.2*1035
 .. ;
 .. S FDAIENS=LRORT_","_LRSP_","_LRODT_","
 .. K FDA
 .. S FDA(69.03,FDAIENS,8)="CA"
 .. S FDA(69.03,FDAIENS,11)=$G(DUZ)
 .. D FILE^DIE("KS","FDA","ERRS")
 .. ; I $D(ERRS) D SHOWERRS^BLRADDCD("Order File")  Q
 .. ; I $D(ERRS) D ERRMSG("GETRID1: FILE^DIE")  Q
 .. I $D(ERRS) D ERRMSG^BLRSGNS3("GETRID1: FILE^DIE","BLRSGNSP")  Q   ; IHS/MSC/MKK - LR*5.2*1035
 .. D MAKEMESG(LRODT,LRSP,LRORT)
 .. ;
 .. D DELACC(LRODT,LRSP,LRORT)
 ;
 K ^TMP("BLRDAIG",$J,"ORDER")
 K ^TMP("BLR SNOMED GET",$J,"HDR")
 ;
 W !!,"Test on Order ",ORDERN,":",!
 F  S LRODT=$O(^LRO(69,"C",ORDERN,LRODT))  Q:LRODT<1  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,"C",ORDERN,LRODT,LRSP))  Q:LRSP<1  D
 .. S STR=$G(^LRO(69,LRODT,1,LRSP,2,LRORT,0))
 .. Q:$L(STR)<1
 .. S IENS=LRORT_","_LRSP_","_LRODT
 .. W ?4,$$GET1^DIQ(69.03,IENS,.01)," ",$$GET1^DIQ(69.03,IENS,8),!
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
DELACC(LRODT,LRSP,LRORT) ; EP - Cancel Test on Accession and add note on Lab Data File
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRODT,LRORT,LRSP,U,XPARSYS,XQXFLG)
 ;
 S STR=$G(^LRO(69,LRODT,1,LRSP,2,LRORT,0))
 ;
 S LRAD=+$P(STR,"^",3),LRAA=+$P(STR,"^",4),LRAN=+$P(STR,"^",5)
 Q:LRAD<1!(LRAA<1)!(LRAN<1)    ; Skip if no Accession
 ;
 S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),LRIDT=$P($G(^(3)),"^",5)
 ;
 ; Need to get File 68 variables
 S LROTF60=+$G(STR)  ; File 60 Pointer
 ;
 S (FOUND,LRAT)=0
 F  S LRAT=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRAT))  Q:LRAT<1!(FOUND)  D
 . S:+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRAT,0))=LROTF60 FOUND=LRAT
 ;
 Q:FOUND<1      ; Skip if cannot find Test on Accession
 ;
 ; File 68 "NOT PERFORMED"
 D ^XBFMK
 S IENS=FOUND_","_LRAN_","_LRAD_","_LRAA_","
 K FDA,ERRS
 S FDA(68.04,IENS,3)=$G(DUZ)
 S FDA(68.04,IENS,4)=$$NOW^XLFDT
 S FDA(68.04,IENS,5)="*Not Performed"
 D FILE^DIE("KS","FDA","ERRS")
 ; I $D(ERRS) D SHOWERRS^BLRADDCD("Accession File")  Q
 I $D(ERRS) D ERRMSG^BLRSGNS3("File 68 - DELACC: FILE^DIE","BLRSGNSP")  Q  ; IHS/MSC/MKK - LR*5.2*1035
 ;
 ; File 63 "NOT PERFORMED"
 S F60NAME=$$GET1^DIQ(60,LROTF60,"NAME")
 S DEL1="*"_F60NAME_" Not Performed: "_$$HTE^XLFDT($H,"5MPZ")_" by "_$G(DUZ)
 S DEL2="*NP Reason: User Quit During Clinical Indication Selection."
 K IENS,FDA,ERRS
 S IENS(1)=$O(^LR(LRDFN,"CH",LRIDT,1,"B"),-1)+1  ; Get next COMMENT line
 S FDA(63.041,"+1,"_LRIDT_","_LRDFN_",",.01)=DEL1
 D UPDATE^DIE(,"FDA","IENS","ERRS")
 ; I $D(ERRS) D SHOWERRS^BLRADDCD("Lab Data File") Q
 ; I $D(ERRS) D ERRMSG("File 63.041 - DELACC: UPDATE^DIE")  Q
 I $D(ERRS) D ERRMSG^BLRSGNS3("File 63.041 - DELACC: UPDATE^DIE","BLRSGNSP")  Q      ; IHS/MSC/MKK - LR*5.2*1035
 ;
 K IENS,FDA,ERRS
 S IENS(1)=$O(^LR(LRDFN,"CH",LRIDT,1,"B"),-1)+1  ; Get next COMMENT line
 S FDA(63.041,"+1,"_LRIDT_","_LRDFN_",",.01)=DEL2
 D UPDATE^DIE(,"FDA","IENS","ERRS")
 ; I $D(ERRS) D SHOWERRS^BLRADDCD("Lab Data File")
 ; I $D(ERRS) D ERRMSG("File 63.041, Line 2 - DELACC: UPDATE^DIE")  Q
 I $D(ERRS) D ERRMSG^BLRSGNS3("File 63.041, Line 2 - DELACC: UPDATE^DIE","BLRSGNSP")  Q   ; IHS/MSC/MKK - LR*5.2*1035
 Q
 ;
 ; ----- Begin IHS/MSC/MKK - LR*5.2*1036
ERRMSG(MSG,ERRFRTN) ; EP - Left in for other routines to call.
 D ERRMSG^BLRSGNS3(MSG,ERRFRTN)
 Q
 ; ----- End IHS/MSC/MKK - LR*5.2*1036
 ;
MAKEMESG(LRODT,LRSN,LRI) ; EP - Create the cancel reason in 69 - some code cloned from LRHYDEL routine.
 NEW II,ORIFN,LRMSTATI,LRNATURE,LRSTATUS
 ;
 S ORIFN=$P(^LRO(69,LRODT,1,LRSN,2,LRI,0),U,7)
 S X=1+$O(^LRO(69,LRODT,1,LRSN,2,LRI,1.1,"A"),-1),X(1)=$P($G(^(0)),U,4)
 S ^LRO(69,LRODT,1,LRSN,2,LRI,1.1,X,0)="OTHER CANCEL REASON: *NP Reason:User Quit During Clinical Indication Selection."
 S X=X+1,X(1)=X(1)+1
 S ^LRO(69,LRODT,1,LRSN,2,LRI,1.1,X,0)="*NP Action:"_$$HTE^XLFDT($H,"5MZ")
 S ^LRO(69,LRODT,1,LRSN,2,LRI,1.1,0)="^^"_X_"^"_X(1)_"^"_DT
 S $P(^LRO(69,LRODT,1,LRSN,2,LRI,0),"^",9)="CA",$P(^(0),U,10)="L",$P(^(0),U,11)=DUZ
 S:$D(^LRO(69,LRODT,1,LRSN,"PCE")) ^LRO(69,"AE",DUZ,LRODT,LRSN,LRI)=""
 Q
 ;
 W @IOF N LRCANK,LRTN
 S BLROPT="DELORD",BLROPT(0)=$P($G(XQY0),U)
FIND ; EP
 S LREND=0 D ^LRPARAM I $G(LREND) G END
 K LRDFN,LRONE,LRNATURE
 W !?3,"If lab has received the sample (i.e. the test has an accession),",!,?3,"you can't change this order.  If so, use the REMOVE AN ACCESSION option",!,?3,"to change the test."  ; IHS/OIT/MKK - LR*5.2*1033
 D
 . N DIR
 . S DIR("A")="ENTER ORDER NUMBER: "
 . S DIR(0)="LO^1:9999999999"
 . S DIR("?")="Enter the number associated with the order. "
 . S DIR("??")="^D ^LROS"
 . S DIR("S")="I $O(^LRO(69,""C"",X,0))"
 . S DIR("T")=1800      ; IHS/MSC/MKK - LR*5.2*1035
 . D ^DIR
 G END:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT))
 S LRORD=X
 W @IOF D LOOK G FIND
 Q
 ;
LOOK ; EP
 S LRCNT=0,LRODT=$O(^LRO(69,"C",LRORD,0)) I LRODT<1 W !,"Not found." Q
 S (LRCANK,LROV,LRSN,LRCOL)=0
 F  S LRSN=$O(^LRO(69,"C",+LRORD,LRODT,LRSN)) Q:LRSN<1!($G(LREND))  D:'$G(LREND) SHOW^LROS S LRCNT=1 S:$S($D(^LRO(69,LRODT,1,LRSN,3)):$P(^(3),U,2),1:0) LROV=1 D
 . L +^LRO(69,"C",+LRORD):1 I '$T W !?5,"Someone Else is Editing this order, try later",! S LREND=1 Q
 . S LRTN=0 F  S LRTN=$O(^LRO(69,LRODT,1,LRSN,2,LRTN)) Q:LRTN<1  S X=^(LRTN,0) I '$P(X,"^",11) S LRCANK=1 Q
 I $G(LREND) D UNL69,END Q
 I LRCNT<1 W !,"No order found with that number." D UNL69,END Q
 I 'LRCANK W !!,"[ * All tests on this order # have already been dispositoned. * ]" D NAME Q
 I $G(LRCOL) D  D UNL69,END Q
 . W !!?5," You CAN NOT change the status of test(s) on this order."
 . W !,"Test sample(s) have already been received into the laboratory."
 . W !,"You must use the REMOVE AN ACCESSION option to have the test(s) status changed.",$C(7)
 D NAME
 S LRNOP=0  S %=1  ; I 'LROV F I=0:0 W !,"Change entire order" S %=2 D YN^DICN Q:%  W "Answer 'Y'es or 'N'o."
 I 'LROV G END:%=-1,OUT:%=1
 S LRT=0,J=0 F  S J=$O(LRT(J)) Q:J<1  S LRT=J
 I LRT<1 W !,$$CJ^XLFSTR(" Can't change status of test(s) on this order.",IOM),! D UNL69 Q
MORE ; EP
 W !,?8,"entry",?15,"test",?40,"sample"
 S LRT=0,J=0 F  S J=$O(LRT(J)) Q:J<1  S LRT=J W !,?10,J,?15,$P(^LAB(60,$P(LRT(J),U,3),0),U),?40,$P(LRT(J),U,4)
 I LRT=0 W !,"All have been dispositioned from that order."
 Q
 ;
ONE ; EP
 R !,"Change status of which entry: ",LRJ:DTIME W:LRJ["?" !,"Pick one of the following entries:" G MORE:LRJ["?" Q:LRJ["^"!(LRJ="")
 I LRJ'=+LRJ!(LRJ<1)!(LRJ>LRT) W !,"Enter a number between 1 and ",LRT,! G ONE
 I '$D(LRT(LRJ)) W !,"You've already dispositioned that one.",! G MORE
 K LRNATURE
 D FX2^LRTSTOUT I $G(LREND) D UNL69,END Q
 K LRTSTI,LRMSTATI D EN1,UNL69 G LOOK
 Q
 ;
EN1 ; EP
 I '$D(^LRO(69,LRODT,1,LRSN,2,LRTSTI,0))#2 W !,"Does not exist ",! Q
 S LRX=^LRO(69,LRODT,1,LRSN,2,LRTSTI,0),LRAD=+$P(LRX,U,3),LRAA=+$P(LRX,U,4),LRAN=+$P(LRX,U,5),LRNOP=0,LRONE="",LRACC=0,ORIFN=$P(LRX,U,7)
 S LRSS=$P($G(^LRO(68,LRAA,0)),U,2)
 S LRTNM=$P($G(^LAB(60,LRTSTS,0)),U)
 I '$L($G(LRNATURE)) D DC^LROR6() I $G(LRNATURE)=-1 W !!,$C(7),"NOTHING CHANGED" Q
 S LRIDT=+$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U,5)
 I LRIDT L +^LR(LRDFN,LRSS,LRIDT):1 I '$T W !?5,"Someone else is editing this entry",! S LREND=1 Q
 D SET^LRTSTOUT I LRIDT L -^LR(LRDFN,LRSS,LRIDT)
 D UNL69
 Q
 ;
 D CEN1^LRCENDE1 K LRONE Q:LRACC&'$D(^XUSEC("LRLAB",DUZ))
 I LRTSTI,'$G(LRNOP) D
 . N LRI S LRI(LRTSN)=""
 . D NEW^LR7OB1(LRODT,LRSN,$S($G(LRMSTATI)=""!($G(LRMSTATI)=1):"OC",1:"SC"),$G(LRNATURE),.LRI,$G(LRMSTATI))
 . S $P(^LRO(69,LRODT,1,LRSN,2,LRTSTI,0),"^",3,6)="^^^",$P(^(0),"^",9,11)="CA^L^"_DUZ K T(LRJ)
 . S DIE="^LRO(69,LRODT,1,LRSN,2,",DA=LRTSTI,DA(1)=LRODT,DR=99 D ^DIE
 K LRI
 S X=DUZ D DUZ^LRX
 W:'LRNOP !!,"Status changed to Not Performed" G FIND:$O(LRT(0))<1,ONE
 ;
OUT ; EP
 Q:$G(LRNOP)  S LRJ=0
 D FX2^LRTSTOUT I $G(LREND) D UNL69,END Q
 S LRCCOMX=LRCCOM
 S LRJ=0 F  S LRJ=$O(LRT(LRJ)) Q:LRJ<1  S LRCCOM=LRCCOMX D
 . S LRSN=0
 . F  S LRSN=$O(^LRO(69,"C",LRORD,LRODT,LRSN))  Q:LRSN<1  D
 .. S LRTSTI=0
 .. F  S LRTSTI=$O(^LRO(69,LRODT,1,LRSN,2,LRTSTI))  Q:LRTSTI<1  D
 ... S IENS=LRTSTI_","_LRSN_","_LRODT_","
 ;
 K LRCCOMX D UNL69
 Q
 ;
 S LRSN=0 F  S LRSN=$O(^LRO(69,"C",+LRORD,LRODT,LRSN)) Q:LRSN<1  D
 . S LRX=^LRO(69,LRODT,1,LRSN,2,LRTSTI,0),LRAD=$P(LRX,U,3),LRAA=+$P(LRX,U,4),LRAN=+$P(LRX,U,5),LRNOP=0,LRONE="",LRACC=0,ORIFN=$P(LRX,U,7)
 ;
ALLDEL ; EP
 K LRNATURE G FIND
 ;
% ; EP
 K DIR,X,Y,%
 S DIR(0)="YO"
 S DIR("T")=1800   ; IHS/MSC/MKK - LR*5.2*1035
 D ^DIR
 S %=$E(X)
 Q
 ;
UNL69 ;
 L -^LRO(69,"C",+LRORD)
 Q
 ;
NAME ; EP 
 S LRDFN=+^LRO(69,LRODT,1,$O(^LRO(69,"C",+LRORD,LRODT,0)),0),LRDPF=$P(^LR(LRDFN,0),U,2),DFN=$P(^(0),U,3)
 D PT^LRX W !,PNM,?30,HRCN
 ;
EN ;from LRPHITE3
 K LRT S (J,LRSN,LRNOP)=0 F  S LRSN=$O(^LRO(69,"C",+LRORD,LRODT,LRSN)) Q:LRSN<1!($G(LRNOP))  D TSET
 Q
 ;
TSET ; EP
 I $D(^LRO(69,LRODT,1,LRSN,3)),$P(^(3),"^",2) D  Q
 . W !,$$CJ^XLFSTR("Test(s) already verified for this order, cannot change ENTIRE order",IOM)
 . W !,$$CJ^XLFSTR(" You must select individual test using the 'Delete Test from Accession' option.",IOM),!!
 . D UNL69 S LRNOP=1
 ;
 S I=0 F  S I=$O(^LRO(69,LRODT,1,LRSN,2,I)) Q:I<1  S X=^(I,0) D
 . Q:$P(X,"^",11)
 . I $P(X,U,3),'$D(LRLABKY) Q
 . S J=J+1,LRSPEC=$S($D(^LRO(69,LRODT,1,LRSN,4,1,0)):+^(0),1:""),LRT(J)=LRSN_U_I_U_+X_U_$S(LRSPEC:$P(^LAB(61,+LRSPEC,0),U),1:"")_U_$P(X,U,2,99)
 Q
 ;
END ; EP
 K %,A,AGE,DFN,DIC,DIE,DOB,DQ,DR,DWLW,HRCN,I,J,K,LRAA,LRACC,LRACN,LRACN0,LRAD,LRAN,LRCL,LRCNT,LRCOL
 K LRDOC,LRDPF,LRDTM,LREND,LRIDT,LRJ,LRNOW,LRLL,LRLLOC,LRNATURE,LRNOP,LROD0,LROD1,LROD3,LRODT
 K LROOS,LRORD,LROS,LROSD,LROT,LROV,LRROD,LRSCNXB,LRSN,LRSPEC,LRSS,LRTC,LRTP,LRTSTI,LRTSTS,LRT,LRTT
 K LRURG,LRUSI,LRUSNM,LRWRD,LRCANK,LRTN,LRCCOM,LRCCOM1
 K PNM,SEX,SSN,T,X,X1,X2,X3,X4,Y,Z,ORIFN
 D END^LRTSTOUT
 Q
