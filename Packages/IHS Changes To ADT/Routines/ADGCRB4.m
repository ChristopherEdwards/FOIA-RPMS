ADGCRB4 ; IHS/ADC/PDW/ENM - A SHEET line 7 ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- driver
 D H7,L7 Q
 ;
H7 ; -- sub heading 7
 I DGDS D  Q
 . W !,DGLIN1,!,"25 DX, Procedure & Comments",?41,"25a Medicaid #"
 W !,DGLIN1,!,"25 Admitting Diagnosis",?41,"25a Medicaid #" Q
 ;
L7 ; -- data line 7
 NEW X
 W ?56,$$MCD,!?3,$$DX,?45,"Medicare #",?55,$$MCR,!?3,$$COM1
 W ?45,"Railroad #",?55,$$RRN,!?3,$$COM2
 W ?42,"Other Insur #" S X=$$INS
 F I=1:2 Q:$P(X,U,I)=""  D
 . W ?55,$P(X,U,I) W:$P(X,U,I+1)]"" !?55,$P(X,U,I+1) W !
 Q
 ;
MCD() ; -- medicaid number & elig date
 N X,X1,Y Q:'$D(^AUPNMCD("B",DFN)) ""
 S X=$O(^AUPNMCD("B",DFN,0)) Q:'X ""
 I '$D(^AUPNMCD(X,0)) Q ""
 S Y="",X1=0 F  S X1=$O(^AUPNMCD(X,11,X1)) Q:'X1  S Y=X1
 I Y S Y=$P($G(^AUPNMCD(X,11,Y,0)),U,2) I Y S Y=$$DATE(Y)
 Q $P(^AUPNMCD(X,0),U,3)_" exp "_Y
 ;
MCR() ; -- medicare # & suffix
 N X,Y Q:'$D(^AUPNMCR(DFN,0)) ""
 S X=^AUPNMCR(DFN,0),Y=$P(X,U,4)
 I +Y,$D(^AUTTMCS(Y,0)) S Y=^(0)
 Q $P(X,U,3)_Y
 ;
RRN() ; -- railroad retirement # & prefix
 N X,Y Q:'$D(^AUPNRRE(DFN,0)) ""
 S X=^AUPNRRE(DFN,0),Y=$P(X,U,3)
 I +Y,$D(^AUTTRRP(Y,0)) S Y=^AUTTRRP(Y,0)
 Q Y_$P(X,U,4)
 ;
INS() ; -- private insurance
 NEW X,Y,N,DATE
 Q:'$D(^AUPNPRVT(DFN)) ""
 S DATE=$$SRVDT
 S Y="",X=0 F  S X=$O(^AUPNPRVT(DFN,11,X)) Q:'X  D
 . S N=^AUPNPRVT(DFN,11,X,0) Q:N=""
 . Q:$P(N,U,6)>DATE  ;elig not started
 . I $P(N,U,7)]"" Q:$P(N,U,7)<DATE  ;elig over
 . S Y=Y_$P($G(^AUTNINS(+N,0)),U)_U_$P(N,U,2)_U
 Q Y
 ;
COM1() ; -- comments line 1
 Q:DGDS $G(^ADGDS(DFN,"DS",+DGDS,1,1,0)) Q $E($G(^DGPM($$M6,"DX",1,0)),1,40)
 ;
COM2() ; -- comments line 2 
 Q:DGDS "Procedure: "_$P(DGN,U,2)
 Q $E($G(^DGPM($$M6,"DX",2,0)),1,40)
 ;
M6() ; -- treating specialty ifn
 Q +$O(^DGPM("APHY",DGFN,0))
 ;
DX() ; -- admitting diagnosis
 Q $S(DGDS:$P($G(^ADGDS(DFN,"DS",+DGDS,2)),U,7),1:$P(DGN,U,10))
 ;
DATE(X) ; -- converts fm date to number date (mm/dd/yy)
 Q $E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
 ;
SRVDT() ; -- finds service date
 Q $S(DGDS:+^ADGDS(DFN,"DS",DGDS,0),1:+^DGPM(DGFN,0))
