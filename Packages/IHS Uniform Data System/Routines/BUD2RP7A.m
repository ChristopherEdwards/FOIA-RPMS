BUD2RP7A ; IHS/CMI/LAB - UDS REPORT PROCESSOR 01 Dec 2012 5:11 PM ;
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;;
PRGHLST ;EP - list of pregnant females
 ;is patient pregnant during the time period BUDBD and BUDED
 Q:BUDSEX'="F"
 S BUDP=$$PREG(DFN,$$FMADD^XLFDT(BUDED,-609),BUDED)
 I '$P(BUDP,U) Q  ;not pregnant
 S BUDHIV=$$HIV(DFN,BUDED)
 I '$P(BUDHIV,U) Q  ;no HIV
 S BUDRACEX=$$RACE^BUD2RPTC(DFN),BUDRACE=$P(BUDRACEX,U,2),BUDRACEP=$P(BUDRACEX,U,5)
 S BUDRACEE=$$RACE^BUD2RP7I(BUDRACE)
 S BUDR=""
 S BUDETHN=$P($$HISP^BUD2RPTC(DFN),U,1)
 I +BUDETHN=1 S BUDETHNN="Hispanic or Latino"
 I +BUDETHN=2 S BUDETHNN="Non-Hispanic/Latino"
 I +BUDETHN=3 S BUDETHNN="Unreported/Refused to Report"
 I BUDRACEP=8,(+BUDETHN=3) S BUDR=17 G SETSECTH  ;BOTH BLANK OR REFUSED
 I +BUDETHN=1 S BUDR=BUDRACEP G SETSECTH
 I +BUDETHN=2!(+BUDETHN=3) S BUDR=BUDRACEP+8
SETSECTH ;
 S $P(BUDSECTH(1),U,BUDR)=$P($G(BUDSECTH(1)),U,BUDR)+1
 S $P(BUDSECTH(1),U,18)=$P($G(BUDSECTH(1)),U,18)+1
 S ^XTMP("BUD2RP7",BUDJ,BUDH,"PRGH",BUDAGEP,$P(^DPT(DFN,0),U),BUDCOM,DFN)=$P(BUDP,"*",2)_"#"_$P(BUDHIV,"*",2)
 Q
 ;
PREG(P,BDATE,EDATE,NORXCHR) ;EP
 NEW BUDDX,B,CNT,BUDD,BUDG,BUDALL,BUDA,BUDDX,C,X,V,D,G,Z,T,%
 S B=0,CNT=0,BUDD="",BUDALL=""  ;if there is one before time frame set this to 1
 S NORXCHR=$G(NORXCHR)
 K BUDG
 S Y="BUDG("
 S X=P_"^ALL DX [BGP GPRA PREGNANCY DIAGNOSES;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 ;now reorder by date of diagnosis and eliminate all chr and rx if necessary
 ;unduplicate by date
 S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S BUDA($P(BUDG(X),U,1))=BUDG(X)
 K BUDG
 M BUDG=BUDA
 K BUDA
 S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  D
 .;get date
 .S D=$P(BUDG(X),U,1)
 .S C=$$CLINIC^APCLV($P(BUDG(X),U,5),"C")
 .I NORXCHR,C=39 Q
 .S C=$$PRIMPROV^APCLV($P(BUDG(X),U,5),"D")
 .I NORXCHR,C=53 Q  ;no chr as primary provider
 .S V=$P(BUDG(X),U,5)
 .S BUDDX(D)="",CNT=CNT+1,BUDALL=BUDALL_V_"|"_$P(BUDG(X),U,2)_U I CNT=2 S BUDD=D
 .I D>$$FMADD^XLFDT(EDATE,-365) S B=1
 .Q
 I CNT>1,B G MA
 I 'B Q 0  ;no visit during time period
PROB S T=$O(^ATXAX("B","BGP GPRA PREGNANCY DIAGNOSES",0))
 S (X,G)=0,Z="" F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE
 .Q:$P(^AUPNPROB(X,0),U,8)<BDATE
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S G=$P(^AUPNPROB(X,0),U,8),Z=X
 .Q
 I G=0,BUDD="" Q 0  ;no dxs and no problem list
 S BUDD=G,BUDALL=BUDALL_"Problem List: "_$$VAL^XBDIQ1(9000011,Z,.01)_" on "_$$DATE^BUD2UTL1(G)
MA ;now check for abortion or miscarriage
 ;abortion first
 K BUDG S Y="BUDG(" S X=P_"^LAST DX [BGP MISCARRIAGE/ABORTION DXS;DURING "_$$FMTE^XLFDT(BUDD)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BUDG(1)) Q 0  ;HAD MIS/AB
 S BUDG=$$LASTPRC^BUD2UTL1(P,"BGP ABORTION PROCEDURES",BDATE,EDATE)
 I BUDG Q 0
 S T=$O(^ATXAX("B","BGP MISCARRIAGE/ABORTION DXS",0))
 S (X,G)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .Q:$P(^AUPNPROB(X,0),U,8)<BUDD
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S G=1
 .Q
 I G Q 0
 ;now check CPTs for Abortion and Miscarriage
 S T=$O(^ATXAX("B","BGP CPT ABORTION",0))
 S %=$$CPT^BUD2DU(P,BUDD,EDATE,T,3)
 I %]"" Q 0
 S T=$O(^ATXAX("B","BGP CPT MISCARRIAGE",0))
 S %=$$CPT^BUD2DU(P,BUDD,EDATE,T,3)
 I %]"" Q 0
 S T=$O(^ATXAX("B","BGP CPT ABORTION",0))
 S %=$$TRAN^BUD2DU(P,BUDD,EDATE,T,3)
 I %]"" Q 0
 S T=$O(^ATXAX("B","BGP CPT MISCARRIAGE",0))
 S %=$$TRAN^BUD2DU(P,BUDD,EDATE,T,3)
 I %]"" Q 0
 Q 1_"*"_BUDALL
 ;
HIV(P,EDATE) ;HIV DX OR PL?  return date of most recent
 NEW BDATE,BUDG,Y,X,E,T,G,C,S,D,BUDD,BUDA,GOT
 S GOT=""
 S Y="BUDG("
 K BUDG
 S BDATE=$P(^DPT(P,0),U,3)  ;dob
 S C=0,S=0,G=0  ;c is total count s is one during past 6 months, G is on problem list
 ;check problem list
 S T=$O(^ATXAX("B","BGP HIV/AIDS DXS",0))
 S X=0,G="" F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S G=$P(^AUPNPROB(X,0),U,8),C=$$VAL^XBDIQ1(9000011,X,.01)
 .Q
 I G D  Q Y
 .S Y="1*"
 .I G S Y=Y_"Problem List Diagnosis: "_C_" "_$$FMTE^XLFDT(G)_U
 S Y="BUDG("
 K BUDG
 S X=P_"^ALL DX [BGP HIV/AIDS DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 ;reorder and unduplicate by date
 K BUDD S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S D=$P(BUDG(X),U,1),BUDD(D)=BUDG(X)
 ;now count and check for 1 in past 6 months
 S Y=$$FMADD^XLFDT(EDATE,-180)
 S D=0 F  S D=$O(BUDD(D)) Q:D'=+D  S C=C+1 I D'<Y S S=1
 ;I 'S Q ""  ;no HIV dx in past 6 months
 I C>1 S GOT=1
 ;.S Y="1*"
 ;.;S X=0 F  S X=$O(BUDD(X)) Q:X'=+X  S Y=Y_$P(BUDD(X),U,5)_"|"_$P(BUDD(X),U,2)_U
 ;.K BUDG,BUDD
 ;.S X=P_"^LAST DX [BGP HIV/AIDS DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BUDG(")
 ;.S Y=Y_"@"_$P(BUDG(1),U,2)_"  "_$$FMTE^XLFDT($P(BUDG(1),U))
 ;K BUDD,BUDG
 I G!(GOT) D  Q Y
 .S Y="1*"
 .I G S Y=Y_"Problem List Diagnosis: "_C_" "_$$FMTE^XLFDT(G)_U
 .S X=0 F  S X=$O(BUDD(X)) Q:X<$$FMADD^XLFDT(EDATE,-365)  S Y=Y_$P(BUDD(X),U,5)_"|"_$P(BUDD(X),U,2)_U
 .S X=P_"^LAST DX [BGP HIV/AIDS DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BUDG(")
 .S Y=Y_"@"_$P(BUDG(1),U,2)_" "_$$FMTE^XLFDT($P(BUDG(1),U))
 Q ""
PRGRLST ;EP - list of pregnant females
 ;is patient pregnant during the time period BUDBD and BUDED
 Q:BUDSEX'="F"
 S BUDP=$$PREG(DFN,$$FMADD^XLFDT(BUDED,-609),BUDED)
 I '$P(BUDP,U) Q  ;not pregnant
 S BUDHISPN=$$HISP^BUD2RPTC(DFN)
 S BUDHISP=$P($$HISP^BUD2RPTC(DFN),U,1)  ;1=hispanic 2=non hispanic
 ;S BUDHISP1=BUDHISP+2  ;set piece
 ;
 S BUDR1=$$RACE^BUD2RPTC(DFN)
 S BUDR=$P(BUDR1,U,1)  ;LINE
 S ^XTMP("BUD2RP7",BUDJ,BUDH,"PRGR",$P(BUDR1,U,5),BUDHISP,BUDCOM,BUDAGEP,$P(^DPT(DFN,0),U),DFN)=$P(BUDP,"*",2)
 Q
 ;
PRGELST ;EP - list of pregnant females
 ;is patient pregnant during the time period BUDBD and BUDED
 Q:BUDSEX'="F"
 S BUDP=$$PREG(DFN,$$FMADD^XLFDT(BUDED,-609),BUDED)
 I '$P(BUDP,U) Q  ;not pregnant
 S BUDRACE=$$HISP^BUD2RPTC(DFN)
 I +BUDRACE=1 S BUDRACE="Hispanic or Latino"
 I +BUDRACE=2 S BUDRACE="All Others"
 S ^XTMP("BUD2RP7",BUDJ,BUDH,"PRGE",BUDRACE,BUDCOM,BUDAGEP,$P(^DPT(DFN,0),U),DFN)=$P(BUDP,"*",2)
 Q
 ;
