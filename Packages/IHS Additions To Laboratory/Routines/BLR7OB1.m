BLR7OB1 ; IHS/MSC/MKK - Update an Order's OERR Status Flag ; 16-Jul-2015 06:30 ; MKK
 ;;5.2;LAB SERVICE;**1035**;NOV 01, 1997;Build 5
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ; In LR*5.2*1033, when an order is cancelled during the Clinical Indication process, the
 ; the OERR status is *NOT* updated.  This routine was written to correct those orders.
 ;
EP ; EP
PEP ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 ;
 Q:$$CHEKUSER()="Q"
 ;
 D ADDTMENU^BLRGMENU("OERRFIX^BLR7OB1","Update an Order's OERR Status")
 D ADDTMENU^BLRGMENU("ROERRSTS^BLR7OB1","Report on Orders OERR Status")
 D ADDTMENU^BLRGMENU("OERRAFIX^BLR7OB1","Update All Orders' OERR Status")
 ;
 ; Main Menu driver
 D MENUDRVR^BLRGMENU("RPMS Lab","Lab Order OERR Status Utilities")
 Q
 ;
 ;
OERRFIX ; EP - Update an Order's OERR Status Flag - Interactive version
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS("OERRFIX")
 ;
 S HEADER(1)="Fix A Cancelled Order's OERR PENDING Status"
 ;
 S ONGO="YES"
 F  Q:ONGO'="YES"  D
 . D HEADERDT^BLRGMENU
 . D ^XBFMK
 . S DIR(0)="PO^69:EMZ"
 . D ^DIR
 . I +X<1!(+$G(DIRUT)) S ONGO="NO"  Q
 . I $D(^LRO(69,"C",+X))<1  D BADSTUF2^BLRUTIL7("Order "_+X_" Not in File 69.  Try again.")  Q
 . ;
 . D FIXIT(+X)
 . F X=2:1:4  K HEADER(X)
 ;
 Q
 ;
 ;
FIXIT(ORDERN) ; EP - Fix the OERR Order
 D RESETHDR(ORDERN)
 ;
 D HEADERDT^BLRGMENU
 D SHOWOERR("BEFORE",ORDERN)
 ;
 S (CNT,LRODT)=0
 F  S LRODT=$O(^LRO(69,"C",ORDERN,LRODT))  Q:LRODT<1  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,"C",ORDERN,LRODT,LRSP))  Q:LRSP<1  D
 .. S (OKAY,LROT)=0
 .. F  S LROT=$O(^LRO(69,LRODT,1,LRSP,2,LROT))  Q:LROT<1  D
 ... S TORDIEN=LROT_","_LRSP_","_LRODT
 ... S CANCLRSN=$$GET1^DIQ(69.3991,1_","_TORDIEN,.01)
 ... Q:CANCLRSN'["Clinical Indication"
 ... ;
 ... S F60IEN=$$GET1^DIQ(69.03,TORDIEN,.01,"I")
 ... Q:F60IEN<1
 ... ;
 ... S TOERRIEN=+$$GET1^DIQ(69.03,TORDIEN,6)
 ... S TOERRSTS=$$GET1^DIQ(100,TOERRIEN,5)
 ... Q:TOERRSTS'["PEND"
 ... ;
 ... S TESTS(F60IEN)=""
 ... S OKAY=OKAY+1
 ... S CNT=CNT+1
 .. Q:OKAY<1
 .. ;
 .. D NEW(LRODT,LRSP,"OC",,.TESTS,1)
 ;
 I CNT<1 D BADSTUF2^BLRUTIL7("Order "_ORDERN_" has no 'Deleted' Test(s) with OERR Status = PENDING.",10)  Q
 ;
 D SHOWOERR("AFTER",ORDERN)
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
 ;
RESETHDR(ORDERN) ; EP - Create rest of HEADER array
 S HEADER(2)="Order #:"_ORDERN
 S HEADER(3)=" "
 S $E(HEADER(4),15)="F60IEN"
 S $E(HEADER(4),25)="F60 Description"
 S $E(HEADER(4),55)="OERR #"
 S $E(HEADER(4),65)="OERR Status"
 Q
 ;
 ;
SHOWOERR(MSG,ORDERN) ; EP - Show the Status of OERR Numbers
 NEW F60DESC,F60IEN,LRODT,LRSP,LROT,OERRNUM,OERRSTS
 ;
 S LRODT=0
 F  S LRODT=$O(^LRO(69,"C",ORDERN,LRODT))  Q:LRODT<1  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,"C",ORDERN,LRODT,LRSP))  Q:LRSP<1  D
 .. S LROT=0
 .. F  S LROT=$O(^LRO(69,LRODT,1,LRSP,2,LROT))  Q:LROT<1  D
 ... S TORDIEN=LROT_","_LRSP_","_LRODT
 ... S F60IEN=$$GET1^DIQ(69.03,TORDIEN,.01,"I")
 ... S F60DESC=$$GET1^DIQ(69.03,TORDIEN,.01)
 ... S OERRNUM=$$GET1^DIQ(69.03,TORDIEN,6)
 ... S OERRSTS=$$GET1^DIQ(100,+OERRNUM,5)
 ... W ?4,MSG,?14,F60IEN,?24,$E(F60DESC,1,28),?54,OERRNUM,?64,OERRSTS,!
 Q
 ;
 ;
OERRAFIX ; EP - Update all Orders' OERR Status Flag - Interactive version
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS("OERRAFIX")
 ;
 S HEADER(1)="OERR Order Status Update"
 S HEADER(2)="Cancelled Orders Only"
 D HEADERDT^BLRGMENU
 ;
 ;          1         2         3         4         5         6         7
 ;     567890123456789012345678901234567890123456789012345678901234567890
 W ?9,"This routine will UPDATE the OERR Order status for ALL Lab",!
 W ?4,"Orders that were cancelled during the Clinical Indication process",!
 W ?4,"prior to the installation of the LR*5.2*1035 patch.",!!
 I $D(^XTMP("BLR7OB1")) D
 . W ?9,"The LR*5.2*1035 Patch's Post Install Routine ran this on ",!
 . W ?19,$$FMTE^XLFDT($P($G(^XTMP("BLR7OB1",0)),U),"5DZ"),!!
 W ?9,"This should only need to be run once.",!!
 W ?9,"NOTE: this could take a long time to run.",!
 ;
 Q:$$WARNINGS^BLROTSCH("Are you sure you want to do this",9)="Q"
 ;
 D HEADERDT^BLRGMENU
 Q:$$WARNINGS^BLROTSCH("Second Chance: Are you still sure you want to do this",9)="Q"
 ;
 D HEADERDT^BLRGMENU
 Q:$$WARNINGS^BLROTSCH("LAST CHANCE: Do you want to do this",9)="Q"
 ;
 W !!,?4,"Very well."
 D PRESSKEY^BLRGMENU(9)
 ;
 D HEADERDT^BLRGMENU
 D OERRSTSC
 ;
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
 ;
 ; The following is called from the BLRPRE35 routine during Post Install processing OR from OERRAFIX above.
OERRSTSC ; EP - Change OERR Status for All OERR Orders with PENDING Status after associated Lab Order was cancelled during the Clinical Indication process.
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D TABMESG^BLRKIDSU("Modify OERR Status for Orders Cancelled During Clinical Indication.",5)
 ;
 D FIND^DIC(9.7,,"17I",,"LR*5.2*1033",,,,,"TARGET","ERRS") ; Need to determine when LR*5.2*1033 installed.
 I $D(ERRS) D  Q
 . D TABMESG^BLRKIDSU("Could not determine when LR*5.2*1033 was First Installed.",10)
 ;
 S LR1033ID=$G(TARGET("DILIST","ID",1,17))  ; Use LR*5.2*1033 first Install Date
 D BOKAY^BLRKIDS2("LR*5.2*1033 First Installed "_$$FMTE^XLFDT(LR1033ID,"5MZ")_".",10)
 ; 
 S (CNT,CNTORD)=0
 S LRODT=$$FMADD^XLFDT($P(LR1033ID,"."),-2)
 F  S LRODT=$O(^LRO(69,LRODT))  Q:LRODT<1  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,LRODT,1,LRSP))  Q:LRSP<1  D
 .. S CNTORD=CNTORD+1
 .. S (FOUND,LROT)=0
 .. F  S LROT=$O(^LRO(69,LRODT,1,LRSP,2,LROT))  Q:LROT<1  D
 ... S LROTIEN=LROT_","_LRSP_","_LRODT
 ... S CANCELR=$$GET1^DIQ(69.3991,1_","_LROTIEN,.01)  ; Get Cancel Reason
 ... Q:CANCELR'["Clinical Indication"       ; Skip if no "Clinical Indication" string
 ... ;
 ... S LROTOERR=$$GET1^DIQ(69.03,LROTIEN,6)
 ... Q:LROTOERR<1                           ; Skip if no OERR number
 ... Q:$$GET1^DIQ(100,LROTOERR,5)'["PEND"   ; Skip if OERR entry not PENDING
 ... ;
 ... S F60IEN=$$GET1^DIQ(69.03,LROTIEN,.01,"I")
 ... Q:F60IEN<1                             ; Skip if no File 60 IEN
 ... ;
 ... S TESTS(F60IEN)=""
 ... S FOUND=FOUND+1
 .. ;
 .. Q:FOUND<1      ; Skip if Order Not Cancelled or if OERR Status for tests not PENDING
 .. ;
 .. D NEW^BLR7OB1(LRODT,LRSP,"OC",,.TESTS,1)
 .. S CNT=CNT+1
 .. S ^XTMP("BLR7OB1",$J,"OERRSTSC",LRODT,LRSP)=""
 ;
 D TABMESG^BLRKIDSU(CNTORD_" Lab Orders analyzed.",4)
 D MES^XPDUTL
 D TABMESG^BLRKIDSU($S(CNT:CNT,1:"No")_" Lab Orders with OERR PENDING status.",9)
 ;
 Q:CNT<1
 ;
 S ^XTMP("BLR7OB1",0)=$$HTFM^XLFDT(+$H+90)_"^"_$$DT^XLFDT_"^Cancelled Orders OERR PENDING status Changed"
 ;
 D BOKAY^BLRPRE31(CNT_" Cancelled Orders OERR PENDING status changed to DISCONTINUED.",9)
 Q
 ;
 ;
 ; Bits and pieces cloned from LR7OB1, LR7OB0, LR7OB3, and LR7OB69
NEW(ODT,SN,CONTROL,NAT,TESTS,LRSTATI) ; Set-up order message - Cloned from LR7OB1
 Q:'$L($T(MSG^XQOR))
 Q:'$D(^LRO(69,$G(ODT),1,$G(SN),0))  N LRX0 S LRX0=^(0)
 ;
 I $$VER^LR7OU1>2.5,'$G(^ORD(100.99,1,"CONV")) N Y,DFN,LRDPF S Y=$G(^LR(+LRX0,0)),DFN=$P(Y,"^",3),LRDPF=$P(Y,"^",2)_$G(^DIC(+$P(Y,"^",2),0,"GL")) D
 . Q:'$D(^ORD(100.99,1,"PTCONV",DFN))
 . S $P(^LRO(69,ODT,1,SN,0),"^",11)=1  ; Keeps this order from being converted
 . D EN^LR7OV2(DFN_";"_$P(LRDPF,"^",2),1)
 Q:$P($G(^LR(+LRX0,0)),"^",2)'=2       ; Only allow messages for patients (file 2)
 N MSG,ORCHMSG,ORBBMSG,ORAPMSG,I,LRNIFN,LRTMPO
 K ^TMP("LRAP",$J),^TMP("LRCH",$J),^TMP("LRBB",$J)
 D ORD1^LR7OB1(ODT,SN,.TESTS)
 I '$D(LRTMPO("LRIFN")) D EN1^LR7OB0(ODT,SN,CONTROL,$G(NAT)),CALL^LR7OB1(CONTROL) K ^TMP("LRAP",$J),^TMP("LRCH",$J),^TMP("LRBB",$J) Q
 NEW TSTARRAY
 S LRNIFN=0 F  S LRNIFN=$O(LRTMPO("LRIFN",LRNIFN)) Q:LRNIFN<1  S X=LRTMPO("LRIFN",LRNIFN) D
 . I $P(X,"^",7)="P" Q  ;Test purged from CPRS
 . I $L($P(X,"^",14)) N ODT,SN D  Q
 .. S ODT=+$P(X,"^",14),SN=$P($P(X,"^",14),";",2)
 .. I $D(^LRO(69,+ODT,1,+SN,0)) S:CONTROL="RE" LRSTATI=2 D EN1^LR7OB0(ODT,SN,CONTROL,$G(NAT)),CALL^LR7OB1(CONTROL) K ^TMP("LRAP",$J),^TMP("LRCH",$J),^TMP("LRBB",$J)
 . ; D EN1^LR7OB0(ODT,SN,CONTROL,$G(NAT)),CALL(CONTROL) K ^TMP("LRAP",$J),^TMP("LRCH",$J),^TMP("LRBB",$J)
 . D EN1(ODT,SN,CONTROL,$G(NAT))
 . I $D(^TMP("LRCH",$J)) K TSTARRAY  M TSTARRAY=^TMP("LRCH",$J)
 . D ENTRYAUD^BLRUTIL("NEW^LR7OB1 8.5","TSTARRAY")    ; DEBUG
 . D CALL^LR7OB1(CONTROL) K ^TMP("LRAP",$J),^TMP("LRCH",$J),^TMP("LRBB",$J)
 Q
 ;
 ;
EN1(ODT,SN,CONTROL,NAT) ; EP - Build msg based on date and LRSN - Cloned from LR7OB0
 ;See doc under EN.
 ;SN=Specimen # in ^LRO(69,ODT,SN,
 N I,J,D0,DR,DA,DIC,DIE,CAT,ROOM,LOC,VAIN,VAERR,STDT,X,CTR,IFN,IFN1,IFN2,Z,Z1,LOC,X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,Y10,Y,COBR,COBX,DFN,LRDPF,LRDFN,LRFIRST,SEX,ORCMSG,OBRMSG,MSG,CHMSG,BBMSG,APMSG
 K ^TMP("LRX",$J)
 S LRFIRST=1,MSG="" D B369
 Q
 ;
 ;
B369 ; EP - Cloned from LR7OB3
 K ^TMP("LRX",$J)
 D 69(ODT,SN) Q:'$D(^TMP("LRX",$J,69))  G OUT:'$D(DFN) D:LRFIRST FIRST^LR7OB0 S LRFIRST=0
 D SNEAK^LR7OB3
 Q
 ;
 ;
OUT ;Exit here
 K ^TMP("LRX",$J)
 Q
 ;
 ;
69(ODT,SN) ; Cloned from LR7OB69.  See Documentation in that routine.
 N X,X0,XP1,X1,X4,Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8,Y9,Y10,Y11,Y12,IFN,TSTY,NOTE,GOTCOM K ^TMP("LRX",$J,69)
 Q:'$D(^LRO(69,+ODT,1,+SN,0))  S X0=^(0),XP1=$G(^(.1)),X1=$G(^(1)),X3=$G(^(3)),X4=$O(^(4,0))
 Q:'$D(^LR(+X0,0))  ;No matching entry in ^LR
 S:'$D(DFN) DFN=$P(^LR(+X0,0),"^",3) S:'$D(LRDFN) LRDFN=+X0 S:'$D(LRDPF) LRDPF=$P(^LR(+X0,0),"^",2)_$G(^DIC(+$P(^LR(+X0,0),"^",2),0,"GL"))
 S Y1=+XP1,Y2=$S($P(X1,"^"):$P(X1,"^"),1:$P(X0,"^",8)),Y3=$P(X0,"^",3),Y4=$P(X0,"^",4),Y5=$P(X0,"^",5),Y6=$P(X0,"^",6),Y7=$P(X0,"^",9),Y8=$P(X3,"^"),Y9=$P(X3,"^",2),Y11=$P(X0,"^",11),Y12=$P(X0,"^",2)
 S IFN=0 F  S IFN=$O(^LRO(69,ODT,1,SN,2,IFN)) Q:IFN<1  S X=$G(^(IFN,0)) I X D
 . I $G(LRNIFN),$D(LRTMPO("LRIFN",LRNIFN)) Q:+X'=+LRTMPO("LRIFN",LRNIFN)
 . S ^TMP("LRX",$J,69,IFN)=X,I=0
 . D GDG1^LRBEBA2(ODT,SN,IFN)
 . F  S I=$O(^LRO(69,ODT,1,SN,2,IFN,1,I)) Q:I<1  S X=^(I,0) D
 .. S ^TMP("LRX",$J,69,IFN,"N",I)=X
 . S I=0 F  S I=$O(^LRO(69,ODT,1,SN,2,IFN,1.1,I)) Q:I<1  S X=^(I,0) D
 .. S ^TMP("LRX",$J,69,IFN,"NC",I)=X
 S IFN=0 F  S IFN=$O(^LRO(69,ODT,1,SN,6,IFN)) Q:IFN<1  S X=^(IFN,0) D
 . Q:X["removed ==>"  Q:X["deleted by"
 . S ^TMP("LRX",$J,69,"N",IFN)=X
 S Y10=$O(^LRO(69,ODT,1,SN,4,0)),Y10=$S(Y10:$P(^(Y10,0),"^"),1:"")
 S ^TMP("LRX",$J,69)=Y1_"^"_Y2_"^"_Y3_"^"_Y4_"^"_Y5_"^"_Y6_"^"_Y7_"^"_Y8_"^"_Y9_"^"_Y10_"^"_Y11_"^"_Y12
 S IFN=0 F  S IFN=$O(^TMP("LRX",$J,69,IFN)) Q:IFN<1  S X=^TMP("LRX",$J,69,IFN) S X1=$P(X,"^",3),X2=$P(X,"^",4),X3=$P(X,"^",5) K TSTY D EN^LR7OU1(+X,$P(^LAB(60,+X,0),"^",5)) D 68^LR7OB68(IFN,X1,X2,X3,+X)
 Q
 ;
 ;
ROERRSTS ; EP - Report on pending OERR STatuS for orders deleted during the clinical indication process.
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:$$ROERRSTI()="Q"
 ;
 F  S LRODT=$O(^LRO(69,LRODT))  Q:LRODT<1!(QFLG="Q")  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,LRODT,1,LRSP))  Q:LRSP<1!(QFLG="Q")  D
 .. D ORDLVLDA
 .. S LROT=0
 .. F  S LROT=$O(^LRO(69,LRODT,1,LRSP,2,LROT))  Q:LROT<1!(QFLG="Q")  D ROERRSTL
 ;
 W:CNT !!
 W ?4,ORDERCNT," Lab Order Entry (#69) File entries analyzed."
 W !!,?9,$S(CNT:CNT,1:"No")," Order",$S(CNT=1:"",1:"s")," with PENDING OERR status."
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
ROERRSTI() ; EP - Initialization
 D SETBLRVS("ROERRSTS")
 S HEADER(1)="Orders Cancelled During Clinical Indication"
 S HEADER(2)="PENDING OERR Status"
 ;
 D FIND^DIC(9.7,,"17I",,"LR*5.2*1033",,,,,"TARGET","ERRS") ; Need to determine when LR*5.2*1033 installed.
 Q:$D(ERRS) $$BADSTF2Q^BLRUTIL7("LR*5.2*1033 Install Date NOT FOUND.")
 ;
 S LR1033ID=$G(TARGET("DILIST","ID",1,17))  ; Use LR*5.2*1033 first Install Date
 S HEADER(3)=$$CJ^XLFSTR("LR*5.2*1033 Installed:"_$$FMTE^XLFDT(LR1033ID,"5DZ"),IOM)
 ;
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HDRONE)
 D HEADERDT^BLRGMENU
 ;
 S HEADER(4)=" "
 S $E(HEADER(5),10)="External"
 S $E(HEADER(5),40)="Order"
 S $E(HEADER(5),71)="Test"
 S HEADER(6)="LRODT"
 S $E(HEADER(6),10)="LRODT"
 S $E(HEADER(6),20)="LRSP"
 S $E(HEADER(6),30)="ORDER #"
 S $E(HEADER(6),40)="OERR #"
 S $E(HEADER(6),52)="LROT"
 S $E(HEADER(6),60)="Test IEN"
 S $E(HEADER(6),71)="OERR #"
 ;
 S MAXLINES=IOS-4,LINES=MAXLINES+10
 S (CNT,ORDERCNT,PG)=0
 S QFLG="NO"
 S LRODT=$$FMADD^XLFDT($P(LR1033ID,"."),-2)
 Q "OK"
 ;
ORDLVLDA ; EP - Order Level Data
 S ORDERCNT=ORDERCNT+1
 S ORDERN=$$GET1^DIQ(69.01,LRSP_","_LRODT,9.5)
 S ORDOERR=$$GET1^DIQ(69.01,LRSP_","_LRODT,.11)
 Q
 ;
ROERRSTL ; EP - Line of Data
 Q:$$ROERRSTB()="Q"
 ;
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"
 ;
 W LRODT,?9,$$FMTE^XLFDT(LRODT,"2DZ"),?19,LRSP,?29,ORDERN,?39,ORDOERR,?51,LROT,?60,F60IEN,?69,LROTOERR,!
 S LINES=LINES+1
 S CNT=CNT+1
 Q
 ;
ROERRSTB() ; EP - "Break out" Data
 S CANCELR=$$GET1^DIQ(69.3991,1_","_LROT_","_LRSP_","_LRODT,.01)
 Q:CANCELR'["Clinical Indication" "Q"       ; Skip if no "Clinical Indication" string
 ;
 S LROTIEN=LROT_","_LRSP_","_LRODT
 S LROTOERR=$$GET1^DIQ(69.03,LROTIEN,6)     ; OERR Number
 Q:LROTOERR<1 "Q"                           ; Skip if no OERR Number
 ;
 S OERRSTS=$$GET1^DIQ(100,LROTOERR,5)       ; OERR Status
 Q:OERRSTS'["PEND" "Q"                      ; Skip if OERR entry not PENDING
 ;
 S F60IEN=$$GET1^DIQ(69.03,LROTIEN,.01,"I")
 Q:F60IEN<1 "Q"                             ; Skip if no File 60 IEN
 ;
 Q "OK"
 ;
 ; ============================= UTILITIES =============================
 ;
CHEKUSER() ; EP - Make sure User has the LRSUPER Key
 Q:$D(^XUSEC("LRSUPER",DUZ)) "OK"
 ;
 S HEADER(1)="OERR Order Status Update"
 S HEADER(2)="Lab Order OERR Status Utilities"
 D HEADERDT^BLRGMENU
 W !!,?9,"User ",$$GET1^DIQ(200,DUZ,.01)," [",DUZ,"] does *NOT* have the LRSUPER",!!
 W ?4,"Security Key.  Routine Ends."
 D PRESSKEY^BLRGMENU(9)
 Q "Q"
 ;
 ;
SETBLRVS(TWO) ; EP - Set BLRVERN variable(s)
 S BLRVERN=$P($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=TWO
 Q
