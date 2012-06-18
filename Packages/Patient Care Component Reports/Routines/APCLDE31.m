APCLDE31 ; IHS/CMI/LAB - list DEPRESSION screenings ; 
 ;;2.0;IHS PCC SUITE;**2,4**;MAY 14, 2009
 ;
 ;
PROC ;
 S APCLCNT=0
 S APCLH=$H,APCLJ=$J
 K ^XTMP("APCLDE3",APCLJ,APCLH)
 D XTMP^APCLOSUT("APCLDE3","DEPRESSION SCREENING REPORT")
 ;go through exam DEPRESSION, then through AUPNPREF for refusals
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:'$D(^DPT(DFN,0))
 .Q:$P(^DPT(DFN,0),U,19)  ;merged away
 .I APCLSEX'[$P(^DPT(DFN,0),U,2) Q  ;not right gender
 .I APCLDESP]"",$P($G(^APCPATR(DFN,0)),U,2)'=APCLDESP Q  ;not correct designated mh provider
 .I APCLSSP]"",$P($G(^APCPATR(DFN,0)),U,3)'=APCLSSP Q
 .I APCLCDP]"",$P($G(^APCPATR(DFN,0)),U,4)'=APCLCDP Q
 .S APCALSC="" I APCLEXPC S APCALSC=$$BHALCS(DFN,APCLBD,APCLED),APCPFI="BH"  ;include refusals
 .S APCPCALS="" S APCPCALS=$$PCCALCS(DFN,APCLBD,APCLED)  ;include refusals
 .I $P(APCPCALS,U,1)>$P(APCALSC,U,1) S APCALSC=APCPCALS,APCPFI="PCC"
 .S APCLEFS="" S APCLEFS=$$REFUSAL(DFN,9999999.15,$O(^AUTTEXAM("C",36,0)),APCLBD,APCLED)
 .I $P(APCLEFS,U,1)>$P(APCALSC,U,1) S APCALSC=APCLEFS,APCPFI="PCC"
 .I APCALSC="" Q  ;no screenings
 .S ^XTMP("APCLDE3",APCLJ,APCLH,"PTS",DFN)=APCALSC,$P(^XTMP("APCLDE3",APCLJ,APCLH,"PTS",DFN),U,20)=APCPFI
 .Q
 Q
BHALCS(P,BDATE,EDATE) ;
 I '$G(P) Q ""
 I '$G(BDATE) Q ""
 I '$G(EDATE) Q ""
 ;loop through all of this patient's visits in date range
 NEW SDATE,X,V,D,R,M,E
 S R=""
 S SDATE=9999999-$$FMADD^XLFDT(EDATE,1),SDATE=SDATE_".9999"
 F  S SDATE=$O(^AMHREC("AE",P,SDATE)) Q:SDATE'=+SDATE!($P(SDATE,".")>(9999999-BDATE))!(R]"")  D
 .S V=0 F  S V=$O(^AMHREC("AE",P,SDATE,V)) Q:V'=+V!(R]"")  D
 ..Q:'$D(^AMHREC(V,0))
 ..;Q:'$$ALLOWVI^APCUTIL(DUZ,V)
 ..S APCLDATE=$P($P(^AMHREC(V,0),U),".")
 ..S X=$$AGE^AUPNPAT(DFN,APCLDATE)
 ..I $D(APCLAGET),X>$P(APCLAGET,"-",2) Q
 ..I $D(APCLAGET),X<$P(APCLAGET,"-",1) Q
 ..;clinic check
 ..I $D(APCLCLNT) S X=$P(^AMHREC(V,0),U,25) Q:X=""  Q:'$D(APCLCLNT(X))
 ..;PRIMARY PROVIDER CHECK
 ..S X=$$BHPPIN(V)
 ..I $D(APCLPROV),X="" Q  ;want only certain primary providers on visit
 ..I $D(APCLPROV),'$D(APCLPROV(X)) Q  ;want one provider and it's not this one
 ..I APCLPPUN,X'="" Q  ;want only unknown and this one has a primary provider
 ..;get measurements AUDC, AUDT, CRFTT
 ..S X=0 F  S X=$O(^AMHRMSR("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VAL^XBDIQ1(9002011.12,X,.01)
 ...I M="PHQ2"!(M="PHQ9") D
 ....S E=$P($G(^AMHRMSR(X,12)),U,4)
 ....I $D(APCLSPRV),E="" Q  ;want only certain SCR providers on visit
 ....I $D(APCLSPRV),'$D(APCLSPRV(E)) Q  ;want one provider and it's not this one
 ....I APCLSPUN,E'="" Q  ;want only unknown and this one has a SCR provider
 ....;check result
 ....S E=$P(^AMHRMSR(X,0),U,4)
 ....I M="PHQ2",E="",'$D(APCLREST(5)) Q
 ....I M="PHQ2",E<3,'$D(APCLREST(1)) Q
 ....I M="PHQ2",E>2,'$D(APCLREST(2)) Q
 ....I M="PHQ9",E="",'$D(APCLREST(5)) Q
 ....I M="PHQ9",E<5,'$D(APCLREST(1)) Q
 ....I M="PHQ9",E>4,'$D(APCLREST(2)) Q
 ....S R=$$BHRT(V,M,$P(^AMHRMSR(X,0),U,4),P,$$VALI^XBDIQ1(9002011.12,X,1204))
 ..I R]"" Q
 ..;get exam
 ..S E=$P($G(^AMHREC(V,14)),U,3)
 ..I E="" G BHHF
 ..S APCLRES=$$VAL^XBDIQ1(9002011,V,1403) S:APCLRES["REFUSED" APCLRES="REFUSED SCREENING" S:APCLRES["NEGATIVE" APCLRES="NEGATIVE"
 ..I APCLRES="NEGATIVE",'$D(APCLREST(1)) G BHHF
 ..I APCLRES="POSITIVE",'$D(APCLREST(2)) G BHHF
 ..I APCLRES["REFUSED",'$D(APCLREST(3)) G BHHF  ;do not want refusals
 ..I APCLRES["UNABLE",'$D(APCLREST(4)) G BHHF  ;do not want unables
 ..I APCLRES="",'$D(APCLREST(5)) G BHHF
 ..S E=$P($G(^AMHREC(V,14)),U,4)
 ..I $D(APCLSPRV),E="" G BHHF  ;want only certain SCR providers on visit
 ..I $D(APCLSPRV),'$D(APCLSPRV(E)) G BHHF  ;want one provider and it's not this one
 ..I APCLSPUN,E'="" G BHHF  ;want only unknown and this one has a SCR provider
 ..S R=$$BHRT(V,"DEPRESSION SCREENING",$$VAL^XBDIQ1(9002011,V,1403),P,$P($G(^AMHREC(V,14)),U,4),$P($G(^AMHREC(V,16)),U,1))
 ..I R]"" Q
BHHF ..;
 ..I $D(APCLREST(5)) S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VAL^XBDIQ1(9002011.01,X,.01)
 ...I M="14.1"!(M="V79.0") S R=$$BHRT(V,M,"",P,$$VALI^XBDIQ1(9002011.01,X,1204))
 ..I R]"" Q
 ..I $D(APCLREST(5)) S X=0 F  S X=$O(^AMHREDU("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VAL^XBDIQ1(9002011.05,X,.01)
 ...I M="DEP-SCR" S R=$$BHRT(V,M,"",P,$$VALI^XBDIQ1(9002011.05,X,.04),$P($G(^AMHREDU(V,11)),U,1))
 ..I R]"" Q
 Q R
BHRT(V,TYPE,RES,PAT,PROVSCRN,COMMENT) ;
 S PROVSCRN=$G(PROVSCRN)
 S COMMENT=$G(COMMENT)
 NEW T,D
 S (D,T)=$P($P(^AMHREC(V,0),U),".")
 S $P(T,U,2)=TYPE_";"_RES
 S $P(T,U,3)=$P(^DPT(PAT,0),U,2)
 S $P(T,U,4)=$$AGE^AUPNPAT(PAT,D)
 S $P(T,U,5)=$S($G(PROVSCRN)]"":$P(^VA(200,PROVSCRN,0),U),1:"UNKNOWN")
 S $P(T,U,6)=$$VAL^XBDIQ1(9002011,V,.25)
 S $P(T,U,7)=$$BHPPNAME(V)
 S $P(T,U,8)=$$VAL^XBDIQ1(9002011.55,PAT,.02)
 S $P(T,U,9)=$$VAL^XBDIQ1(9002011.55,PAT,.03)
 S $P(T,U,10)=$$VAL^XBDIQ1(9002011.55,PAT,.04)
 S $P(T,U,11)=$$VAL^XBDIQ1(9000001,PAT,.14)
 S $P(T,U,13)=V
 S $P(T,U,12)=COMMENT
 S $P(T,U,15)=PAT
 S $P(T,U,20)="BH"
 Q T
 ;
PCCALCS(P,BDATE,EDATE) ;EP - get alcohol screening from pcc
 I '$G(P) Q ""
 I '$G(BDATE) Q ""
 I '$G(EDATE) Q ""
 NEW T
 ;S T=$$LASTALC^APCAPI(P,BDATE,EDATE,"A")
 NEW R,V,APCLDATE,SDATE
 S R=""
 S SDATE=9999999-$$FMADD^XLFDT(EDATE,1),SDATE=SDATE_".9999"
 F  S SDATE=$O(^AUPNVSIT("AA",P,SDATE)) Q:SDATE'=+SDATE!($P(SDATE,".")>(9999999-BDATE))!(R]"")  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,SDATE,V)) Q:V'=+V!(R]"")  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..;Q:'$$ALLOWPCC^APCUTIL(DUZ,V)
 ..I 'APCLEXPC S C=$$CLINIC^APCLV(V,"C") I C=14!(C=43)!(C=48)!(C="C4")!(C="C9") Q
 ..I APCLEXPC,$D(^AHHREC("AVISIT",V)) Q  ;in BH module so already got it
 ..S APCLDATE=$P($P(^AUPNVSIT(V,0),U),".")
 ..S DFN=$P(^AUPNVSIT(V,0),U,5)
 ..Q:DFN=""
 ..;Q:'$$ALLOWP^APCUTIL(DUZ,DFN)
 ..S X=$$AGE^AUPNPAT(DFN,APCLDATE)
 ..I $D(APCLAGET),X>$P(APCLAGET,"-",2) Q
 ..I $D(APCLAGET),X<$P(APCLAGET,"-",1) Q
 ..;clinic check
 ..I $D(APCLCLNT) S X=$P(^AUPNVSIT(V,0),U,8) Q:X=""  Q:'$D(APCLCLNT(X))
 ..;PRIMARY PROVIDER CHECK
 ..S X=$$PRIMPROV^APCLV(V)
 ..I $D(APCLPROV),X="" Q  ;want only certain primary providers on visit
 ..I $D(APCLPROV),'$D(APCLPROV(X)) Q  ;want one provider and it's not this one
 ..I APCLPPUN,X'="" Q  ;want only unknown and this one has a primary provider
 ..S R=$$PCCSCR(V)
 Q R
PCCSCR(V) ;is there a screening?  return in R
 ;get measurements AUDC, AUDT, CRFTT
 NEW R,X,M,P,E
 S R=""
 S P=$P(^AUPNVSIT(V,0),U,5)
 S D=$P($P(^AUPNVSIT(V,0),U),".")
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNVMSR(X,2)),U,1)
 .S M=$$VAL^XBDIQ1(9000010.01,X,.01)
 .I M="PHQ2"!(M="PHQ9") D
 ..S E=$P($G(^AUPNVMSR(X,12)),U,4)
 ..I $D(APCLSPRV),E="" Q  ;want only certain SCR providers on visit
 ..I $D(APCLSPRV),'$D(APCLSPRV(E)) Q  ;want one provider and it's not this one
 ..I APCLSPUN,E'="" Q  ;want only unknown and this one has a SCR provider
 ..;check result
 ..S E=$P(^AUPNVMSR(X,0),U,4)
 ..I M="PHQ2",E="",'$D(APCLREST(5)) Q
 ..I M="PHQ2",E<3,'$D(APCLREST(1)) Q
 ..I M="PHQ2",E>2,'$D(APCLREST(2)) Q
 ..I M="PHQ9",E="",'$D(APCLREST(5)) Q
 ..I M="PHQ9",E<5,'$D(APCLREST(1)) Q
 ..I M="PHQ9",E>4,'$D(APCLREST(2)) Q
 ..S T=D_U_M_U_$$VAL^XBDIQ1(9000010.01,X,.04)_U_V_U_9000010.01_U_X
 ..S R=$$PCCV^APCLDE1(T,P)
 I R]"" Q R
 ;get exam
 S X=0 F  S X=$O(^AUPNVXAM("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9000010.13,X,.01)
 .I M="DEPRESSION SCREENING" D
 ..S E=$P($G(^AUPNVXAM(X,12)),U,4)
 ..I $D(APCLSPRV),E="" Q  ;want only certain SCR providers on visit
 ..I $D(APCLSPRV),'$D(APCLSPRV(E)) Q  ;want one provider and it's not this one
 ..I APCLSPUN,E'="" Q  ;want only unknown and this one has a SCR provider
 ..;check result
 ..S E=$P(^AUPNVXAM(X,0),U,4)
 ..I E="",'$D(APCLREST(5)) Q
 ..I E="N",'$D(APCLREST(1)) Q
 ..I E="PO",'$D(APCLREST(2)) Q
 ..S T=D_U_M_U_$$VAL^XBDIQ1(9000010.13,X,.04)_U_V_U_9000010.13_U_X
 ..S R=$$PCCV^APCLDE1(T,P)
 I R]"" Q R
 ;get pov
 I $D(APCLREST(5)) S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9000010.07,X,.01)
 .I M="V79.0" D
 ..S T=D_U_M_U_U_V_U_9000010.07_U_X
 ..S R=$$PCCV^APCLDE1(T,P)
 I R]"" Q R
 ;get education
 I $D(APCLREST(5)) S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9000010.16,X,.01)
 .I M="DEP-SCR" D
 ..S T=D_U_M_U_U_V_U_9000010.16_U_X
 ..S R=$$PCCV^APCLDE1(T,P)
 I R]"" Q R
 Q R
 ;
REFUSAL(PAT,F,I,B,E) ;EP
 I '$G(PAT) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(B)="" Q ""
 I $G(E)="" Q ""
 NEW T,X,Y,%DT S X=B,%DT="P" D ^%DT S B=Y
 S X=E,%DT="P" D ^%DT S E=Y
 S (X,T)="" F  S X=$O(^AUPNPREF("AA",PAT,F,I,X)) Q:X'=+X!(T]"")  S Y=0 F  S Y=$O(^AUPNPREF("AA",PAT,F,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) D
 .S T=D
 .S $P(T,U,2)="REFUSED;"_$$VAL^XBDIQ1(9000022,Y,.07)
 .S $P(T,U,3)=$P(^DPT(PAT,0),U,2)
 .S $P(T,U,4)=$$AGE^AUPNPAT(PAT,D)
 .S $P(T,U,5)=$$VAL^XBDIQ1(9000022,Y,1204) I $P(T,U,5)="" S $P(T,U,5)="UNKNOWN"
 .S $P(T,U,6)="UNKNOWN"
 .S $P(T,U,7)="UNKNOWN"
 .S $P(T,U,8)=$$VAL^XBDIQ1(9002011.55,PAT,.02)
 .S $P(T,U,9)=$$VAL^XBDIQ1(9002011.55,PAT,.03)
 .S $P(T,U,10)=$$VAL^XBDIQ1(9002011.55,PAT,.04)
 .S $P(T,U,11)=$$VAL^XBDIQ1(9000001,PAT,.14)
 Q T
PCCV(S,PAT) ;
 NEW T
 S T=""
 S $P(T,U)=$P(S,U)
 S $P(T,U,2)=$P(S,U,2)_";"_$P(S,U,3)
 S $P(T,U,3)=$P(^DPT(PAT,0),U,2)
 S $P(T,U,4)=$$AGE^AUPNPAT(PAT,$P(S,U))
 S $P(T,U,5)=$$SCRNPCC(S)
 S $P(T,U,6)=$$VAL^XBDIQ1(9000010,$P(S,U,4),.08)
 S $P(T,U,7)=$$PRIMPROV^APCLV($P(S,U,4),"N")
 S $P(T,U,8)=$$VAL^XBDIQ1(9002011.55,PAT,.02)
 S $P(T,U,9)=$$VAL^XBDIQ1(9002011.55,PAT,.03)
 S $P(T,U,10)=$$VAL^XBDIQ1(9002011.55,PAT,.04)
 S $P(T,U,11)=$$VAL^XBDIQ1(9000001,PAT,.14)
 S $P(T,U,14)=$P(S,U,4)
 S $P(T,U,15)=PAT
 S $P(T,U,20)="PCC"
 Q T
SCRNPCC(T) ;get screening provider based on v file
 NEW S,F
 S F=1202
 I $P(T,U,5)=9000010.16!($P(T,U,5)=9000010.23) S F=".05"
 S S=$$VAL^XBDIQ1($P(T,U,5),$P(T,U,6),F)
 I S]"" Q S
 Q "UNKNOWN"
BHPPIN(R) ;
 NEW %,%1
 S %=0,%1="" F  S %=$O(^AMHRPROV("AD",R,%)) Q:%'=+%  I $P(^AMHRPROV(%,0),U,4)="P" S %1=$P(^AMHRPROV(%,0),U)
 Q %1
BHPPNAME(R) ;EP primary provider internal # from 200
 NEW %,%1
 S %=0,%1="" F  S %=$O(^AMHRPROV("AD",R,%)) Q:%'=+%  I $P(^AMHRPROV(%,0),U,4)="P" S %1=$P(^AMHRPROV(%,0),U),%1=$P($G(^VA(200,%1,0)),U)
 I %1]"" Q %1
 Q "UNKNOWN"
SPRV(E) ;
 I $P($G(^AUPNVXAM(E,12)),U,4) Q $$VAL^XBDIQ1(9000010.13,E,1204)
 Q "UNKNOWN"
PRVREF(R) ;
 I $P($G(^AUPNPREF(R,12)),U,4)]"" Q $$VAL^XBDIQ1(9000022,R,1204)
 Q "UNKNOWN"
PPV(V) ;
 NEW %
 S %=$$PRIMPROV^APCLV(V,"N")
 I %]"" Q %
 Q "UNKNOWN"
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:IO'=IO(0)
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 W !
 S DIR("A")="End of Report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
