ORQRY01 ;SLC/JDL - Order query utility ;6/10/03 13:17
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**153,174**;Dec 17, 1997
 ;
DOCDT(DOCS) ;Date range for TIU
 N XDT,SDATE,EDATE
 S XDT=$O(DOCS("Reference",""))
 Q:'$L(XDT)
 S SDATE=$P(XDT,":"),EDATE=$P(XDT,":",2)
 S:SDATE=-1 SDATE=0
 I EDATE=-1 S EDATE=9999999+EDATE
 E  S EDATE=EDATE+1
 K DOCS("Reference",XDT)
 S DOCS("Reference",SDATE_":"_EDATE)=""
 Q
CLINPTS(ORY,CLIN,ORBDATE,OREDATE) ; RETURN LIST OF PTS W/CLINIC APPT W/IN DT RNG
 ;Copied from CLINPTS^ORQPTQ2 without maximum limitation
 S ORY="^TMP(""ORCLINPT"",$J)"
 K @ORY
 I +$G(CLIN)<1 S @ORY@(1)="^No clinic identified" Q 
 I $$ACTLOC^ORWU(CLIN)'=1 S @ORY@(1)="^Clinic is inactive or Occasion Of Service" Q
 N DFN,NAME,I,J,X,ORJ,ORSRV,ORNOWDT,CHKX,CHKIN,ORC,CLNAM
 S ORNOWDT=$$NOW^XLFDT
 S ORSRV=$G(^VA(200,DUZ,5)) I +ORSRV>0 S ORSRV=$P(ORSRV,U)
 S DFN=0,I=1
 I ORBDATE="" S ORBDATE=$$UP^XLFSTR($$GET^XPAR("USR^SRV.`"_+$G(ORSRV)_"^DIV^SYS^PKG","ORLP DEFAULT CLINIC START DATE",1,"E"))
 I OREDATE="" S OREDATE=$$UP^XLFSTR($$GET^XPAR("USR^SRV.`"_+$G(ORSRV)_"^DIV^SYS^PKG","ORLP DEFAULT CLINIC STOP DATE",1,"E"))
 ;CONVERT ORBDATE AND OREDATE INTO FILEMAN DATE/TIME
 D DT^DILF("T",ORBDATE,.ORBDATE,"","")
 D DT^DILF("T",OREDATE,.OREDATE,"","")
 I (ORBDATE=-1)!(OREDATE=-1) S @ORY@(1)="^Error in date range." Q 
 S OREDATE=$P(OREDATE,".")_.5  ;ADD 1/2 DAY TO END DATE
 ;access to SC global granted under DBIA #518:
 S ORJ=ORBDATE F  S ORJ=$O(^SC(+CLIN,"S",ORJ)) Q:ORJ<1!(ORJ>OREDATE)  D
 .I $L($G(^SC(+CLIN,"S",ORJ,1,0))) D
 ..S J=0 F  S J=$O(^SC(+CLIN,"S",ORJ,1,J)) Q:+J<1  D
 ...S ORC=$P(^SC(+CLIN,"S",ORJ,1,J,0),U,9)
 ...Q:ORC="C"  ; cancelled clinic availability
 ...;
 ...S DFN=+$G(^SC(+CLIN,"S",ORJ,1,J,0))
 ...S X=$G(^DPT(DFN,"S",ORJ,0)) I +X'=CLIN Q  ; appt cancelled/resched
 ...;
 ...; quit if appt cancelled or no show:
 ...I $P(X,U,2)'="NT",($P(X,U,2)["C")!($P(X,U,2)["N") Q
 ...;
 ...S @ORY@(I)=DFN_"^"_$P(^DPT(DFN,0),"^")_"^"_+CLIN_"^"_ORJ,I=I+1
 S:'$D(@ORY) @ORY@(1)="^No appointments."
 Q
