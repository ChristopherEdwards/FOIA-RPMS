APCLAL31 ; IHS/CMI/LAB - list ALCOHOL screenings ; 
 ;;2.0;IHS PCC SUITE;**2,4**;MAY 14, 2009
 ;
 ;
PROC ;
 S APCRCNT=0
 S APCRH=$H,APCRJ=$J
 K ^XTMP("APCLAL3",APCRJ,APCRH)
 D XTMP^AMHUTIL("APCLAL3","ALCOHOL SCREENING REPORT")
 ;go through exam ALCOHOL, then through AUPNPREF for refusals
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:'$D(^DPT(DFN,0))
 .Q:$P(^DPT(DFN,0),U,19)  ;merged away
 .;Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 .I APCRSEX'[$P(^DPT(DFN,0),U,2) Q  ;not right gender
 .I APCRDESP]"",$P($G(^AMHPATR(DFN,0)),U,2)'=APCRDESP Q  ;not correct designated mh provider
 .I APCRSSP]"",$P($G(^AMHPATR(DFN,0)),U,3)'=APCRSSP Q
 .I APCRCDP]"",$P($G(^AMHPATR(DFN,0)),U,4)'=APCRCDP Q
 .S APCALSC="" I APCLEXBH S APCALSC=$$BHALCS(DFN,APCRBD,APCRED),APCPFI="BH"  ;include refusals
 .S APCPCALS="" I APCREXPC S APCPCALS=$$PCCALCS(DFN,APCRBD,APCRED)  ;include refusals
 .I $P(APCPCALS,U,1)>$P(APCALSC,U,1) S APCALSC=APCPCALS,APCPFI="PCC"
 .S APCREFS="" I APCREXPC S APCREFS=$$REFUSAL(DFN,9999999.15,$O(^AUTTEXAM("C",35,0)),APCRBD,APCRED)
 .I $P(APCREFS,U,1)>$P(APCALSC,U,1) S APCALSC=APCREFS,APCPFI="PCC"
 .I APCALSC="" Q  ;no screenings
 .S ^XTMP("APCLAL3",APCRJ,APCRH,"PTS",DFN)=APCALSC,$P(^XTMP("APCLAL3",APCRJ,APCRH,"PTS",DFN),U,20)=APCPFI
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
 ..;Q:'$$ALLOWVI^AMHUTIL(DUZ,V)
 ..S APCRDATE=$P($P(^AMHREC(V,0),U),".")
 ..S X=$$AGE^AUPNPAT(DFN,APCRDATE)
 ..I $D(APCRAGET),X>$P(APCRAGET,"-",2) Q
 ..I $D(APCRAGET),X<$P(APCRAGET,"-",1) Q
 ..;clinic check
 ..I $D(APCRCLNT) S X=$P(^AMHREC(V,0),U,25) Q:X=""  Q:'$D(APCRCLNT(X))
 ..;PRIMARY PROVIDER CHECK
 ..S X=$$BHPPIN(V)
 ..I $D(APCRPROV),X="" Q  ;want only certain primary providers on visit
 ..I $D(APCRPROV),'$D(APCRPROV(X)) Q  ;want one provider and it's not this one
 ..I APCRPPUN,X'="" Q  ;want only unknown and this one has a primary provider
 ..;get measurements AUDC, AUDT, CRFTT
 ..S X=0 F  S X=$O(^AMHRMSR("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VAL^XBDIQ1(9002011.12,X,.01)
 ...I M="AUDC"!(M="AUDT")!(M="CRFT") D
 ....S E=$P($G(^AMHRMSR(X,12)),U,4)
 ....I $D(APCRSPRV),E="" Q  ;want only certain SCR providers on visit
 ....I $D(APCRSPRV),'$D(APCRSPRV(E)) Q  ;want one provider and it's not this one
 ....I APCRSPUN,E'="" Q  ;want only unknown and this one has a SCR provider
 ....;check result
 ....S E=$P(^AMHRMSR(X,0),U,4)
 ....I M="AUDT",E="",'$D(APCRREST(5)) Q
 ....I M="AUDT",E<8,'$D(APCRREST(1)) Q
 ....I M="AUDT",E>7,'$D(APCRREST(2)) Q
 ....I M="CRFT",E="",'$D(APCRREST(5)) Q
 ....I M="CRFT",E<2,'$D(APCRREST(1)) Q
 ....I M="CRFT",E>1,'$D(APCRREST(2)) Q
 ....I M="AUDC",E="",'$D(APCRREST(5)) Q
 ....I M="AUDC",E<4,$$SEX^AUPNPAT(P)="M",'$D(APCRREST(1)) Q
 ....I M="AUDC",E<3,$$SEX^AUPNPAT(P)="F",'$D(APCRREST(1)) Q
 ....I M="AUDC",E>3,$$SEX^AUPNPAT(P)="M",'$D(APCRREST(2)) Q
 ....I M="AUDC",E>2,$$SEX^AUPNPAT(P)="F",'$D(APCRREST(2)) Q
 ....S R=$$BHRT(V,M,$P(^AMHRMSR(X,0),U,4),P,$$VALI^XBDIQ1(9002011.12,X,1204))
 ..I R]"" Q
 ..;get exam
 ..S E=$P($G(^AMHREC(V,14)),U,3)
 ..I E="" G BHHF
 ..S APCRRES=$$VAL^XBDIQ1(9002011,V,1403) S:APCRRES["REFUSED" APCRRES="REFUSED SCREENING" S:APCRRES["NEGATIVE" APCRRES="NEGATIVE"
 ..I APCRRES="NEGATIVE",'$D(APCRREST(1)) G BHHF
 ..I APCRRES="POSITIVE",'$D(APCRREST(2)) G BHHF
 ..I APCRRES["REFUSED",'$D(APCRREST(3)) G BHHF  ;do not want refusals
 ..I APCRRES["UNABLE",'$D(APCRREST(4)) G BHHF  ;do not want unables
 ..I APCRRES="",'$D(APCRREST(5)) G BHHF
 ..S E=$P($G(^AMHREC(V,14)),U,4)
 ..I $D(APCRSPRV),E="" G BHHF  ;want only certain SCR providers on visit
 ..I $D(APCRSPRV),'$D(APCRSPRV(E)) G BHHF  ;want one provider and it's not this one
 ..I APCRSPUN,E'="" G BHHF  ;want only unknown and this one has a SCR provider
 ..S R=$$BHRT(V,"ALCOHOL SCREENING",$$VAL^XBDIQ1(9002011,V,1403),P,$P($G(^AMHREC(V,14)),U,4),$P($G(^AMHREC(V,16)),U,1))
 ..I R]"" Q
BHHF ..;
 ..S X=0 F  S X=$O(^AMHRHF("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VALI^XBDIQ1(9002011.08,X,.01)
 ...I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U)="ALCOHOL/DRUG" D
 ....;check screening provider
 ....S E=$P($G(^AMHRHF(V,12)),U,4)
 ....I $D(APCRSPRV),E="" Q  ;want only certain SCR providers on visit
 ....I $D(APCRSPRV),'$D(APCRSPRV(E)) Q  ;want one provider and it's not this one
 ....I APCRSPUN,E'="" Q  ;want only unknown and this one has a SCR provider
 ....;check result
 ....I $$VAL^XBDIQ1(9002011.08,X,.01)="CAGE 0/4",'$D(APCRREST(1)) Q
 ....I $$VAL^XBDIQ1(9002011.08,X,.01)'="CAGE 0/4",'$D(APCRREST(2)) Q
 ....S R=$$BHRT(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1))
 ..I R]"" Q
 ..I $D(APCRREST(5)) S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VAL^XBDIQ1(9002011.01,X,.01)
 ...I M="29.1"!(M="V79.1") S R=$$BHRT(V,M,"",P,$$VALI^XBDIQ1(9002011.01,X,1204))
 ..I R]"" Q
 ..I $D(APCRREST(5)) S X=0 F  S X=$O(^AMHREDU("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VAL^XBDIQ1(9002011.05,X,.01)
 ...I M="CD-SCR"!(M="AOD-SCR") S R=$$BHRT(V,M,"",P,$$VALI^XBDIQ1(9002011.05,X,.04),$P($G(^AMHREDU(V,11)),U,1))
 ..I R]"" Q
 ..I $D(APCRREST(5)) S X=0 F  S X=$O(^AMHRPROC("AD",V,X)) Q:X'=+X!(R]"")  D
 ...S M=$$VALI^XBDIQ1(9002011.04,X,.01)
 ...Q:'$$ICD^ATXCHK(M,$O(^ATXAX("B","BGP ALCOHOL SCREENING CPTS",0)),1)
 ...S R=$$BHRT(V,"CPT: "_$$VAL^XBDIQ1(9002011.04,X,.01),"",P,"")
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
 ;S T=$$LASTALC^APCLAPI(P,BDATE,EDATE,"A")
 NEW R,V,APCRDATE,SDATE
 S R=""
 S SDATE=9999999-$$FMADD^XLFDT(EDATE,1),SDATE=SDATE_".9999"
 F  S SDATE=$O(^AUPNVSIT("AA",P,SDATE)) Q:SDATE'=+SDATE!($P(SDATE,".")>(9999999-BDATE))!(R]"")  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,SDATE,V)) Q:V'=+V!(R]"")  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..;Q:'$$ALLOWPCC^APCUTIL(DUZ,V)
 ..I 'APCLEXBH S C=$$CLINIC^APCLV(V,"C") I C=14!(C=43)!(C=48)!(C="C4")!(C="C9") Q
 ..I APCLEXBH,$D(^AHHREC("AVISIT",V)) Q  ;in BH module so already got it
 ..;Q:'$$ALLOWPCC^AMHUTIL(DUZ,V)
 ..S APCRDATE=$P($P(^AUPNVSIT(V,0),U),".")
 ..S DFN=$P(^AUPNVSIT(V,0),U,5)
 ..Q:DFN=""
 ..;Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 ..S X=$$AGE^AUPNPAT(DFN,APCRDATE)
 ..I $D(APCRAGET),X>$P(APCRAGET,"-",2) Q
 ..I $D(APCRAGET),X<$P(APCRAGET,"-",1) Q
 ..;clinic check
 ..I $D(APCRCLNT) S X=$P(^AUPNVSIT(V,0),U,8) Q:X=""  Q:'$D(APCRCLNT(X))
 ..;PRIMARY PROVIDER CHECK
 ..S X=$$PRIMPROV^APCLV(V)
 ..I $D(APCRPROV),X="" Q  ;want only certain primary providers on visit
 ..I $D(APCRPROV),'$D(APCRPROV(X)) Q  ;want one provider and it's not this one
 ..I APCRPPUN,X'="" Q  ;want only unknown and this one has a primary provider
 ..S R=$$PCCSCR(V)
 Q R
PCCSCR(V) ;is there a screening?  return in R
 ;get measurements AUDC, AUDT, CRFTT
 NEW R,X,M,P,E
 S R=""
 S P=$P(^AUPNVSIT(V,0),U,5)
 S D=$P($P(^AUPNVSIT(V,0),U),".")
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNVMSR(X,2)),U,1)  ;entered in error
 .S M=$$VAL^XBDIQ1(9000010.01,X,.01)
 .I M="AUDC"!(M="AUDT")!(M="CRFT") D
 ..S E=$P($G(^AUPNVMSR(X,12)),U,4)
 ..I $D(APCRSPRV),E="" Q  ;want only certain SCR providers on visit
 ..I $D(APCRSPRV),'$D(APCRSPRV(E)) Q  ;want one provider and it's not this one
 ..I APCRSPUN,E'="" Q  ;want only unknown and this one has a SCR provider
 ..;check result
 ..S E=$P(^AUPNVMSR(X,0),U,4)
 ..I M="AUDT",E="",'$D(APCRREST(5)) Q
 ..I M="AUDT",E<8,'$D(APCRREST(1)) Q
 ..I M="AUDT",E>7,'$D(APCRREST(2)) Q
 ..I M="CRFT",E="",'$D(APCRREST(5)) Q
 ..I M="CRFT",E<2,'$D(APCRREST(1)) Q
 ..I M="CRFT",E>1,'$D(APCRREST(2)) Q
 ..I M="AUDC",E="",'$D(APCRREST(5)) Q
 ..I M="AUDC",E<4,$$SEX^AUPNPAT(P)="M",'$D(APCRREST(1)) Q
 ..I M="AUDC",E<3,$$SEX^AUPNPAT(P)="F",'$D(APCRREST(1)) Q
 ..I M="AUDC",E>3,$$SEX^AUPNPAT(P)="M",'$D(APCRREST(2)) Q
 ..I M="AUDC",E>2,$$SEX^AUPNPAT(P)="F",'$D(APCRREST(2)) Q
 ..S T=D_U_M_U_$$VAL^XBDIQ1(9000010.01,X,.04)_U_V_U_9000010.01_U_X
 ..S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 ;get exam
 S X=0 F  S X=$O(^AUPNVXAM("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9000010.13,X,.01)
 .I M="ALCOHOL SCREENING" D
 ..S E=$P($G(^AUPNVXAM(X,12)),U,4)
 ..I $D(APCRSPRV),E="" Q  ;want only certain SCR providers on visit
 ..I $D(APCRSPRV),'$D(APCRSPRV(E)) Q  ;want one provider and it's not this one
 ..I APCRSPUN,E'="" Q  ;want only unknown and this one has a SCR provider
 ..;check result
 ..S E=$P(^AUPNVXAM(X,0),U,4)
 ..I E="",'$D(APCRREST(5)) Q
 ..I E="N",'$D(APCRREST(1)) Q
 ..I E="PO",'$D(APCRREST(2)) Q
 ..S T=D_U_M_U_$$VAL^XBDIQ1(9000010.13,X,.04)_U_V_U_9000010.13_U_X
 ..S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 ;get health factor
 S X=0 F  S X=$O(^AUPNVHF("AD",V,X)) Q:X'=+X  D
 .S M=$$VALI^XBDIQ1(9000010.23,X,.01)
 .I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U)="ALCOHOL/DRUG" D
 ..S E=$P($G(^AUPNVHF(X,12)),U,4)
 ..I $D(APCRSPRV),E="" Q  ;want only certain SCR providers on visit
 ..I $D(APCRSPRV),'$D(APCRSPRV(E)) Q  ;want one provider and it's not this one
 ..I APCRSPUN,E'="" Q  ;want only unknown and this one has a SCR provider
 ..;check result
 ..I $$VAL^XBDIQ1(9000010.23,X,.01)="CAGE 0/1",'$D(APCRREST(1)) Q
 ..I $$VAL^XBDIQ1(9000010.23,X,.01)'="CAGE 0/1",'$D(APCRREST(2)) Q
 ..S T=D_U_$$VAL^XBDIQ1(9000010.23,X,.01)_U_U_V_U_9000010.23_U_X
 ..S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 ;get pov
 I $D(APCRREST(5)) S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9000010.07,X,.01)
 .I M="V79.1" D
 ..S T=D_U_M_U_U_V_U_9000010.07_U_X
 ..S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 ;get education
 I $D(APCRREST(5)) S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9000010.16,X,.01)
 .I M="CD-SCR"!(M="AOD-SCR") D
 ..S T=D_U_M_U_U_V_U_9000010.16_U_X
 ..S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 ;get CPTs
 I $D(APCRREST(5)) S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 .S M=$$VALI^XBDIQ1(9000010.18,X,.01)
 .Q:'$$ICD^ATXCHK(M,$O(^ATXAX("B","BGP ALCOHOL SCREENING CPTS",0)),1)
 .S T=D_U_M_U_U_V_U_9000010.18_U_X
 .S R=$$PCCV^APCLAL1(T,P)
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
