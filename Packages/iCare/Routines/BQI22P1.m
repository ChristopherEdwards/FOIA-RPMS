BQI22P1 ;VNGT/HS/ALA-Install Program v 2.2 Patch 1 ; 25 May 2011  7:31 AM
 ;;2.2;ICARE MANAGEMENT SYSTEM;**1**;Jul 28, 2011;Build 25
 ;
PRE ; Pre-install
 Q
 ;
POS ; Post-Install
 NEW DA,BQIUPD,ERROR
 S DA=1
 I $$PATCH^XPDUTL("BGP*11.0*4")=1!($$PATCH^XPDUTL("BGP*11.1*1")=1) D
 . S BQIUPD(90508,DA_",",.06)=1
 . S BQIUPD(90508,DA_",",12.03)=0
 . S BQIUPD(90508,DA_",",12.04)=0
 . S BQIUPD(90508,DA_",",12.07)=1
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
 D DX^BQI202PU
 ;
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 S ZTDESC="Hospital CQ Compile",ZTRTN="HOS^BQI22P1",ZTIO=""
 D ^%ZTLOAD
 K ZTDESC,ZTRTN,ZTIO,ZTDTH,ZTSK
 Q
 ;
HOS ; Hospital CQ - 90 days
 I $P(^BQI(90508,1,0),U,6)=1 D
 . K BGPIND
 . S BGPINDT=""
 . S BGPMUYF="90595.11"
 . S BGPRTYPE=4,BGP0RPTH="A"
 . S BGPMUT="H" ; BGPMU Hospital Measures
 . S BGPRTYPE=4,BGP0RPTH="A"
 . S BGPBEN=3
 . S X=0 F  S X=$O(^BGPMUIND(BGPMUYF,"AMS","H",X)) Q:X'=+X  S BGPIND(X)=""
 . S BQIGREF=$NA(^TMP("BQICQMH9",$J)) K @BQIGREF
 . ; 90 days
 . ; Current
 . S BGPBD=$$DATE^BQIUL1("T-90"),BGPED=DT
 . ; Previous
 . S BGPPBD=$$DATE^BQIUL1("T-181"),BGPPED=$$DATE^BQIUL1("T-91")
 . ; Baseline
 . S BGPBBD=BGPPBD,BGPBED=BGPPED
 . D BQI^BGPMUEHD(.BQIGREF)
 . K CDEN,CNUM,CEXC,PDEN,PNUM,PEXC,CSORT,PSORT,MTOT
 . S BN=""
 . F  S BN=$O(@BQIGREF@(BN)) Q:BN=""  D
 .. S I=""
 .. F  S I=$O(@BQIGREF@(BN,"C",I)) Q:I=""  D
 ... I $P($G(^BGPMUIND(90596.11,I,0)),U,4)[".ED." D  Q
 .... S MTOT=$P(@BQIGREF@(BN,"C",I),U,2)/60
 .... S CSORT(I,MTOT,BN)="",CSORT(I)=$G(CSORT(I))+1
 ... S CDEN(I)=$G(CDEN(I))+$P($G(@BQIGREF@(BN,"C",I)),U,1)
 ... S CNUM(I)=$G(CNUM(I))+$P($G(@BQIGREF@(BN,"C",I)),U,2)
 ... S CEXC(I)=$G(CEXC(I))+$P($G(@BQIGREF@(BN,"C",I)),U,3)
 .. S I=""
 .. F  S I=$O(@BQIGREF@(BN,"P",I)) Q:I=""  D
 ... I $P($G(^BGPMUIND(90596.11,I,0)),U,4)[".ED." D  Q
 .... S MTOT=$P(@BQIGREF@(BN,"P",I),U,2)/60
 .... S PSORT(I,MTOT,BN)="",PSORT(I)=$G(PSORT(I))+1
 .... S PDEN(I)=$G(PDEN(I))+$P($G(@BQIGREF@(BN,"P",I)),U,1)
 .... S PNUM(I)=$G(PNUM(I))+$P($G(@BQIGREF@(BN,"P",I)),U,2)
 .... S PEXC(I)=$G(PEXC(I))+$P($G(@BQIGREF@(BN,"P",I)),U,3)
 .. ; For DFN set up and store individual
 .. ;S PADH=$P($G(@BQIGREF@(DFN,"P",I)),U,4)
 . D STORH^BQITASK5(21)
 . K @BQIGREF,CSORT,PSORT
 ;
 ; Hospital CQ - 1 year
 I $P(^BQI(90508,1,0),U,6)=1 D
 . K BGPIND
 . S BGPINDT=""
 . S BGPMUYF="90595.11"
 . S BGPRTYPE=4,BGP0RPTH="A"
 . S BGPMUT="H" ; BGPMU Hospital Measures
 . S BGPRTYPE=4,BGP0RPTH="A"
 . S BGPBEN=3
 . S X=0 F  S X=$O(^BGPMUIND(BGPMUYF,"AMS","H",X)) Q:X'=+X  S BGPIND(X)=""
 . S BQIGREF=$NA(^TMP("BQICQMH1",$J)) K @BQIGREF
 . ; 1 year timeframe
 . ; Current
 . S BGPBD=$$DATE^BQIUL1("T-365"),BGPED=DT
 . ; Previous
 . S BGPPBD=$$DATE^BQIUL1("T-731"),BGPPED=$$DATE^BQIUL1("T-366")
 . ; Baseline
 . S BGPBBD=BGPPBD,BGPBED=BGPPED
 . D BQI^BGPMUEHD(.BQIGREF)
 . K CDEN,CNUM,CEXC,PDEN,PNUM,PEXC,CSORT,PSORT,MTOT
 . S BN=""
 . F  S BN=$O(@BQIGREF@(BN)) Q:BN=""  D
 .. S I=""
 .. F  S I=$O(@BQIGREF@(BN,"C",I)) Q:I=""  D
 ... I $P($G(^BGPMUIND(90596.11,I,0)),U,4)[".ED." D  Q
 .... S MTOT=$P(@BQIGREF@(BN,"C",I),U,2)/60
 .... S CSORT(I,MTOT,BN)="",CSORT(I)=$G(CSORT(I))+1
 ... S CDEN(I)=$G(CDEN(I))+$P($G(@BQIGREF@(BN,"C",I)),U,1)
 ... S CNUM(I)=$G(CNUM(I))+$P($G(@BQIGREF@(BN,"C",I)),U,2)
 ... S CEXC(I)=$G(CEXC(I))+$P($G(@BQIGREF@(BN,"C",I)),U,3)
 .. S I=""
 .. F  S I=$O(@BQIGREF@(BN,"P",I)) Q:I=""  D
 ... I $P($G(^BGPMUIND(90596.11,I,0)),U,4)[".ED." D  Q
 .... S MTOT=$P(@BQIGREF@(BN,"P",I),U,2)/60
 .... S PSORT(I,MTOT,BN)="",PSORT(I)=$G(PSORT(I))+1
 ... S PDEN(I)=$G(PDEN(I))+$P($G(@BQIGREF@(BN,"P",I)),U,1)
 ... S PNUM(I)=$G(PNUM(I))+$P($G(@BQIGREF@(BN,"P",I)),U,2)
 ... S PEXC(I)=$G(PEXC(I))+$P($G(@BQIGREF@(BN,"P",I)),U,3)
 ... ; For DFN set up and store individual
 ... ;S PADH=$P($G(@BQIGREF@(DFN,"P",I)),U,4)
 . D STORH^BQITASK5(11)
 . K @BQIGREF,CSORT,PSORT
 Q
