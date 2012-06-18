ADGAD3 ; IHS/ADC/PDW/ENM - A&D DISCHARGES ; [ 05/19/2000  10:29 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**5**;MAR 25, 1999
 ;
 ; Variables GL, RD, FR, TO used by VA G&L routines.
 ;
 N DFN,IFN,DGDT,NAME,FAC,WD,COM,PR,TS,AGE,HRCN,CA,N,UTL,ID,Z
A ; -- main
 D L3 Q
 ;
L3 ; -- loop discharges 
 S DGDT=FR F  S DGDT=$O(^DGPM("AMV3",DGDT)) Q:'DGDT!(DGDT>TO)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV3",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV3",DGDT,DFN,IFN)) Q:'IFN  D 1,2,3
 Q
 ;
1 S ID=9999999.9999999-DGDT
 S N=$G(^DPT(+DFN,0)),NAME=$P(N,U),AGE=$$AGE
 S N=$G(^DGPM(+IFN,0)),FAC=$P(N,U,5),CA=$P(N,U,14)
 S N=$G(^DGPM(+$$MIP,0)),WD=$P(N,U,6)
 S N=$G(^DGPM(+$$MTSP,0)),TS=$P(N,U,9),PR=$P(N,U,8)
 S COM=$P($G(^AUPNPAT(DFN,11)),U,18),HRCN=$$HRCN^ADGF
 S UTL=PR_U_AGE_U_WD_U_TS_U_COM_U_FAC
 ; -- death, newborn or other
 I $D(^DPT(DFN,.35)),$P($P(^(.35),U),".")=RD D DEATH Q
 I $D(^DIC(45.7,"B","NEWBORN",TS)) D NWBRN Q
 D OTHER Q
 ;
2 ; -- ward
 ; -- newborn
 I $D(^DIC(45.7,"B","NEWBORN",TS)) D  Q
 . I $$ONE S $P(DGWD("NB",WD),U,6)=$P(DGWD("NB",WD),U,6)+1
 . S $P(DGWD("NB",WD),U,Z)=$P(DGWD("NB",WD),U,Z)+1
 . S DGLWD("NB",WD)=DGLWD("NB",WD)+$$LOS2
 ; -- all other
 I $$ONE S $P(DGWD(WD),U,6)=$P(DGWD(WD),U,6)+1
 S $P(DGWD(WD),U,Z)=$P(DGWD(WD),U,Z)+1
 S DGLWD(WD)=DGLWD(WD)+$$LOS2 Q
 ;
3 ; -- treating specialty
 ; -- peds
 I +AGE<DGADULT D  Q
 . S $P(DGTSP(TS),U,Z)=$P(DGTSP(TS),U,Z)+1
 . I $$ONE S $P(DGTSP(TS),U,6)=$P(DGTSP(TS),U,6)+1
 . S DGLTSP(TS)=DGLTSP(TS)+$$LOS6
 ; -- adults
 S $P(DGTSA(TS),U,Z)=$P(DGTSA(TS),U,Z)+1
 I $$ONE S $P(DGTSA(TS),U,6)=$P(DGTSA(TS),U,6)+1
 S DGLTSA(TS)=DGLTSA(TS)+$$LOS6 Q
 ;
DEATH ; -- deceased patients
 S:GL ^TMP("DGZADS",$J,"DT",NAME,HRCN,IFN)=UTL
 S DGT3D=DGT3D+1,Z=5 Q
 ;
NWBRN ; -- newborn patients
 S:GL ^TMP("DGZADS",$J,"DN",NAME,HRCN,IFN)=UTL
 S DGT3N=DGT3N+1,Z=2 Q
 ;
OTHER ; -- all other patients
 S:GL ^TMP("DGZADS",$J,"AD",NAME,HRCN,IFN)=UTL
 S DGT30=DGT30+1,Z=2 Q
 ;
MIP() ; --  movement, ifn, previous
 Q $O(^($O(^DGPM("APMV",DFN,CA,ID)),0))
 ;
MTSP() ; -- movement, ts, previous
 Q $O(^(+$O(^(+$O(^DGPM("ATS",DFN,CA,ID)),0)),0))
 ;
ONE() ; -- one day patients
 Q $S($P(^DGPM($P(^DGPM(IFN,0),U,14),0),".")=RD:1,1:0)
 ;
AGE() ; -- age at admission
 ;N X,X1,X2 S X1=DGDT,X2=$P(N,U,3) D ^%DTC Q:'X "" Q X\365.25
 N X,X1,X2 S X1=+$G(^DGPM(+$P(^DGPM(IFN,0),U,14),0)),X2=$P(N,U,3) D ^%DTC Q:'X "" Q X\365.25 ;IHS/ANMC/LJF/ENM 3/22/99
 ;
LOS2() ; -- ward los
 N X,X1,X2 S X1=+^DGPM(+IFN,0),X2=+^DGPM(+$$MIP,0) D ^%DTC Q $S(X:X,1:1)
 ;
LOS6() ; -- t.s. los
 N X,X1,X2 S X1=+^DGPM(+IFN,0),X2=+^DGPM(+$$MTSP,0) D ^%DTC Q $S(X:X,1:1)
