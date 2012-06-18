ADGAD2 ; IHS/ADC/PDW/ENM - A&D WARD XFR ; [ 05/19/2000  10:26 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**5**;MAR 25, 1999
 ;
 ; Variables GL,FR,TO used by VA G&L routines.
 ;
 N WD,IFN,WARD,DFN,TS,PR,N,NAME,AGE,COM,HRCN,UTL,ID,DGDT,TY,CA,TYP,WDP
 N TSP
A ; -- main
 D SI,L2 Q
 ;
SI ; -- loop "CN" x-ref
 S WARD="" F  S WARD=$O(^DPT("CN",WARD)) Q:WARD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  D SI1
 Q
 ;
SI1 ; -- seriously ill
 Q:'$D(^DPT(DFN,"DAC"))  Q:$P(^("DAC"),U)=""
 S WD=$O(^DIC(42,"B",WARD,0)),IFN=^DPT("CN",WARD,DFN)
 S TS=$G(^DPT(DFN,.103)),PR=$G(^DPT(DFN,.104))
 S N=^DPT(DFN,0),NAME=$P(N,U),AGE=$$AGE
 S COM=$P($G(^AUPNPAT(DFN,11)),U,18),HRCN=$$HRCN^ADGF
 S UTL=PR_U_AGE_U_WD_U_TS_U_COM,DGTSI=DGTSI+1
 S:GL ^TMP("DGZADS",$J,"SI",NAME,HRCN,IFN)=UTL
 Q
 ;
L2 ; -- loop ward transfers
 S DGDT=FR F  S DGDT=$O(^DGPM("AMV2",DGDT)) Q:'DGDT!(DGDT>TO)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV2",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV2",DGDT,DFN,IFN)) Q:'IFN  D 1,2
 Q
 ;
1 S N=^DPT(DFN,0),NAME=$P(N,U),AGE=$$AGE,ID=9999999.9999999-DGDT
 S N=$G(^DGPM(+IFN,0)),TY=+$P(N,U,4),WD=+$P(N,U,6),CA=+$P(N,U,14)
 S N=$G(^DGPM(+$$MR,0)),TS=$S($P(N,U,9):$P(N,U,9),1:$$TSP),TSP=$$TSP
 S N=$G(^DGPM(+$$MP,0)),TYP=$S($P(N,U,2)=2:$P(N,U,4),1:0),WDP=$P(N,U,6)
 ; -- utility nodes
 Q:'GL
 ; -- absences
 I TY>11 S ^TMP("DGZADS",$J,"AB",NAME,DFN,IFN)=WDP_U_TY Q
 I TYP>11 S ^TMP("DGZADS",$J,"AB1",NAME,DFN,IFN)=TYP_U_WD Q
 ; -- ward transfers
 S ^TMP("DGZADS",$J,"WT",NAME,DFN,IFN)=WDP_U_WD Q
 ;
2 ; -- census counts   
 S DGT2=DGT2+1
 ; -- newborn
 I $D(^DIC(45.7,"B","NEWBORN",+TS)) D  Q
 . S DGLWD("NB",WDP)=DGLWD("NB",WDP)+$$LOS
 . S $P(DGWD("NB",WD),U,3)=$P(DGWD("NB",WD),U,3)+1
 . S $P(DGWD("NB",WDP),U,4)=$P(DGWD("NB",WDP),U,4)+1
 I $D(^DIC(45.7,"B","NEWBORN",+TSP)) D  Q
 . S DGLWD("NB",WDP)=DGLWD("NB",WDP)+$$LOS
 . S $P(DGWD(WD),U,3)=$P(DGWD(WD),U,3)+1
 . S $P(DGWD("NB",WDP),U,4)=$P(DGWD("NB",WDP),U,4)+1
 ; -- other
 S DGLWD(WDP)=DGLWD(WDP)+$$LOS
 S $P(DGWD(WD),U,3)=$P(DGWD(WD),U,3)+1
 S $P(DGWD(WDP),U,4)=$P(DGWD(WDP),U,4)+1 Q
 ;
AGE() ; -- age at admission
 ;N X,X1,X2 S X1=+^DGPM(+IFN,0),X2=$P(N,U,3) D ^%DTC Q:'X "" Q X\365.25
 N X,X1,X2 S X1=+$G(^DGPM(+$P(^DGPM(IFN,0),U,14),0)),X2=$P(N,U,3) D ^%DTC Q:'X "" Q X\365.25 ;IHS/ANMC/LJF/ENM 3/22/99
 ;
MR() ; -- movement, related, ien
 Q $O(^DGPM("APHY",IFN,0))
 ;
MP() ; -- movement, previous, ien
 Q $O(^($O(^DGPM("APMV",DFN,CA,ID)),0))
 ;
TSP() ; -- treating specialty, previous
 Q $O(^($O(^DGPM("ATS",DFN,CA,ID)),0))
 ;
LOS() ; -- ward los
 N X,X1,X2 S X1=+$G(^DGPM(+IFN,0)),X2=+$G(^DGPM(+$$MP,0)) D ^%DTC Q $S(X:X,1:1)
