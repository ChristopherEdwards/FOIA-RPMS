BGP6D3C ; IHS/CMI/LAB - New routine created in Serenji at 8/28/2015 2:31:05 PM ; 
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
FIRSTPDX(P,BDATE,EDATE) ;EP
 NEW BGPG,G,Y,X,T,E,BGPR
 K BGPG
 S Y="BGPG("
 S BDATE=$G(BDATE)
 I BDATE="" S BDATE=$P(^DPT(P,0),U,3)
 S BGPR=""
 S X=P_"^FIRST DX [BGP PREGNANCY DIAGNOSES 2;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 I $D(BGPG(1)) S BGPR=$P(BGPG(1),U)
 K BGPG
 S BGPG=$$FIRSTPRC^BGP6UTL1(P,"BGP PREGNANCY ICD PROCEDURES",BDATE,EDATE)
 I BGPG]"",$P(BGPG,U,3)<BGPR S BGPR=$P(BGPG,U,3)
 S X=$$FIRSTCPT^BGP6UTL1(P,"BGP PREGNANCY CPT CODES",BDATE,EDATE)
 I X,$P(X,U,1)<BGPR S BGPR=$P(X,U,1)
 Q BGPR