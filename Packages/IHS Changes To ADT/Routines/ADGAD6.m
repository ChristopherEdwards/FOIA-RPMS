ADGAD6 ; IHS/ADC/PDW/ENM - A&D TS XFR ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ; Variables FR, GL, TO used by VA G&L routines.
 ;
 N IFN,DFN,DGDT,NAME,CA,ID,TS,TSP,AGE,N
A ; -- main
 D L6,UTL Q
 ;
L6 ; -- loop ts
 S DGDT=FR F  S DGDT=$O(^DGPM("AMV6",DGDT)) Q:'DGDT!(DGDT>TO)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV6",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV6",DGDT,DFN,IFN)) Q:'IFN  Q:$$T=1  D 1
 Q
 ;
1 S NAME=$P($G(^DPT(DFN,0)),U),ID=9999999.9999999-DGDT
 S N=$G(^DGPM(IFN,0)),CA=$P(N,U,14),TS=$P(N,U,9),AGE=$$AGE
 ; -- a screen of some sort to check for a null ts should be here maw
 S TSP=$P($G(^DGPM(+$$M6P,0)),U,9)
 ; -- ts
 S:GL ^TMP("DGZADS",$J,"TS",NAME,DFN,IFN)=TSP_U_TS
 S DGT6=DGT6+1
 ; -- peds
 I +AGE<DGADULT D  Q
 . S DGLTSP(+TSP)=DGLTSP(+TSP)+$$LOS
 . S $P(DGTSP(+TS),U,3)=$P(DGTSP(+TS),U,3)+1
 . S $P(DGTSP(+TSP),U,4)=$P(DGTSP(+TSP),U,4)+1
 ; -- adult
 S DGLTSA(+TSP)=DGLTSA(TSP)+$$LOS
 S $P(DGTSA(+TS),U,3)=$P(DGTSA(+TS),U,3)+1
 S $P(DGTSA(+TSP),U,4)=$P(DGTSA(+TSP),U,4)+1 Q
 ;
UTL ; -- days total (adm,dis,trn,...)
 S ^TMP("DGZADS",$J,"ZZ")=DGT10_U_DGT30_U_DGT1N_U_DGT3N_U_DGT3D_U_DGTSI_U_DGT2_U_DGT6 Q
 ;
AGE() ; -- age at admission
 N X1,X2,X S X1=+^DGPM(CA,0),X2=+$P(^DPT(DFN,0),U,3) D ^%DTC Q X\365.25
 ;
MP() ; -- movement, previous
 Q $O(^(+$O(^DGPM("APMV",DFN,CA,ID)),0))
 ;
M6P() ; -- movement, ts, previous
 Q $O(^(+$O(^(+$O(^DGPM("ATS",DFN,CA,ID)),0)),0))
 ;
LOS() ; -- ts los
 N X,X1,X2 S X1=+$G(^DGPM(+IFN,0)),X2=+$G(^DGPM(+$$M6P,0)) D ^%DTC Q X
 ;
T() ; -- related movement transaction type
 Q $P($G(^DGPM(+$P($G(^DGPM(IFN,0)),U,24),0)),U,2)
