BUD1RP6X ; IHS/CMI/LAB - measure C ;
 ;;8.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 03, 2014;Build 36
 ;
CNTDTAP ;
 S (X,Y)="",C=0 F  S X=$O(BUDDTAP(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDDTAP(X) Q
 .S Y=X
 ;now count
 S BUDDTAP=0,X=0 F  S X=$O(BUDDTAP(X)) Q:X'=+X  S BUDDTAP=BUDDTAP+1
 Q
RESET ;RESET WORKING ARRAYS
 K BUDDT M BUDDT=BUDADT
 K BUDDIP M BUDDIP=BUDADIP
 K BUDTET M BUDTET=BUDATET
 K BUDPER M BUDPER=BUDAPER
 K BUDTD M BUDTD=BUDATD
 Q
RESETD ;RESET DUPES
 S (X,Y)="",C=0 F  S X=$O(BUDDT(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDDT(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BUDDIP(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDDIP(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BUDTET(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDTET(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BUDTD(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDTD(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BUDPER(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDPER(X) Q
 .S Y=X
 S BUDDT=0,X=0 F  S X=$O(BUDDT(X)) Q:X'=+X  S BUDDT=BUDDT+1
 S BUDTD=0,X=0 F  S X=$O(BUDTD(X)) Q:X'=+X  S BUDTD=BUDTD+1
 S BUDDIP=0,X=0 F  S X=$O(BUDDIP(X)) Q:X'=+X  S BUDDIP=BUDDIP+1
 S BUDTET=0,X=0 F  S X=$O(BUDTET(X)) Q:X'=+X  S BUDTET=BUDTET+1
 S BUDPER=0,X=0 F  S X=$O(BUDPER(X)) Q:X'=+X  S BUDPER=BUDPER+1
 Q
DTAP(P,BDATE,EDATE) ;EP
 K ^TMP($J,"CPT")
 NEW BUDC,BUDG,BUDX,BUDDTAP,BUDTD,BUDDT,BUDDIP,BUDTET,BUDPER
 ;first check for contraindication
 K BUDG S %=P_"^ALL DX 323.5;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 I '$D(BUDG(1)) G N
 S X=0,G="" F  S X=$O(BUDG(X)) Q:X'=+X!(G]"")  S Y=+$P(BUDG(X),U,4) D
 .S Z=$$VAL^XBDIQ1(9000010.07,Y,.09) I Z="E948.4"!(Z="E948.5")!(Z="E948.6") S G="1^Dtap Contraindication DX/Ecode: "_$P(BUDG(X),U,2)_"/"_Z_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 .S Z=$$VAL^XBDIQ1(9000010.07,Y,.18) I Z="E948.4"!(Z="E948.5")!(Z="E948.6") S G="1^Dtap Contraindication DX/Ecode: "_$P(BUDG(X),U,2)_"/"_Z_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 .S Z=$$VAL^XBDIQ1(9000010.07,Y,.19) I Z="E948.4"!(Z="E948.5")!(Z="E948.6") S G="1^Dtap Contraindication DX/Ecode: "_$P(BUDG(X),U,2)_"/"_Z_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 I G]"" Q G
N K BUDG S %=P_"^ALL DX 323.51;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 I '$D(BUDG(1)) G N1
 S X=0,G="" F  S X=$O(BUDG(X)) Q:X'=+X!(G]"")  S Y=+$P(BUDG(X),U,4) D
 .S Z=$$VAL^XBDIQ1(9000010.07,Y,.09) I Z="E948.4"!(Z="E948.5")!(Z="E948.6") S G="1^Dtap Contraindication DX/Ecode: "_$P(BUDG(X),U,2)_"/"_Z_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 .S Z=$$VAL^XBDIQ1(9000010.07,Y,.18) I Z="E948.4"!(Z="E948.5")!(Z="E948.6") S G="1^Dtap Contraindication DX/Ecode: "_$P(BUDG(X),U,2)_"/"_Z_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 .S Z=$$VAL^XBDIQ1(9000010.07,Y,.19) I Z="E948.4"!(Z="E948.5")!(Z="E948.6") S G="1^Dtap Contraindication DX/Ecode: "_$P(BUDG(X),U,2)_"/"_Z_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 I G]"" Q G
N1 K BUDG S %=P_"^ALL DX 323.52;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 S X=0,G="" F  S X=$O(BUDG(X)) Q:X'=+X!(G]"")  S Y=+$P(BUDG(X),U,4) D
 .S Z=$$VAL^XBDIQ1(9000010.07,Y,.09) I Z="E948.4"!(Z="E948.5")!(Z="E948.6") S G="1^Dtap Contraindication DX/Ecode: "_$P(BUDG(X),U,2)_"/"_Z_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 .S Z=$$VAL^XBDIQ1(9000010.07,Y,.18) I Z="E948.4"!(Z="E948.5")!(Z="E948.6") S G="1^Dtap Contraindication DX/Ecode: "_$P(BUDG(X),U,2)_"/"_Z_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 .S Z=$$VAL^XBDIQ1(9000010.07,Y,.19) I Z="E948.4"!(Z="E948.5")!(Z="E948.6") S G="1^Dtap Contraindication DX/Ecode: "_$P(BUDG(X),U,2)_"/"_Z_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 I G]"" Q G
 F BUDZ=1,20,22,50,102,106,107,110,120,130,132,28,35,112 S X=$$ANCONT^BUD1RP6C(P,BUDZ,EDATE) Q:X]""
 I X]"" Q "1^DTaP Contraindication IM package: "_$$DATE^BUD1UTL1($P(X,U))_" "_$P(X,U,2)
DTAPIM ;
 ;first gather up all cpt codes that relate in any way to dtap and store in ^TMP
 S ED=(9999999-EDATE)-1,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVCPT(X,0))
 ...S Y=$P(^AUPNVCPT(X,0),U)
 ...Q:Y=""
 ...S Y=$P($$CPT^ICPTCOD(Y),U,2)
 ...I Y=90700!(Y=90721)!(Y=90723)!(Y=90701)!(Y=90720)!(Y=90698)!(Y=90702)!(Y=90719)!(Y=90703) S ^TMP($J,"CPT",9999999-$P(ED,"."),Y)=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVTC(X,0))
 ...S Y=$P(^AUPNVTC(X,0),U,7)
 ...Q:Y=""
 ...S Y=$P($$CPT^ICPTCOD(Y),U,2)
 ...I Y=90700!(Y=90721)!(Y=90723)!(Y=90701)!(Y=90720)!(Y=90698)!(Y=90702)!(Y=90719)!(Y=90703) S ^TMP($J,"CPT",9999999-$P(ED,"."),Y)=""
 ;now gather up all DTAP immunizations, cpts 
 ;get all immunizations
 S C="1^20^22^50^102^106^107^110^120^130^132"
 D GETIMMS^BUD1RP6C(P,BDATE,EDATE,C,.BUDX)
 ;go through and set into DTAP if 10 days apart
 S X=0 F  S X=$O(BUDX(X)) Q:X'=+X  S BUDDTAP(X)=BUDX(X)
 D CNTDTAP  ;count to see if there are 4
 I BUDDTAP>3 S Y="1^DTap: total #: "_BUDDTAP,X=0 F  S X=$O(BUDDTAP(X)) Q:X'=+X  S Y=Y_"  "_BUDDTAP(X)
 I BUDDTAP>3 Q Y
 ;now get cpts for dtap or dtp
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90698!(Y=90700)!(Y=90701)!(Y=90720)!(Y=90721)!(Y=90723) S BUDDTAP(D)="DTaP CPT: "_Y_" on "_$$DATE^BUD1UTL1(D)
 D CNTDTAP  ;count to see if there are 4
 I BUDDTAP>3 S Y="1^DTaP: total #: "_BUDDTAP,X="" F  S X=$O(BUDDTAP(X)) Q:X'=+X  S Y=Y_"  "_BUDDTAP(X)
 I BUDDTAP>3 Q Y
 ;K BUDG S %=P_"^ALL DX V06.1;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 ;I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S BUDDTAP($P(BUDG(X),U))="DTaP DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 ;K BUDG S %=P_"^ALL DX V06.2;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 ;I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S BUDDTAP($P(BUDG(X),U))="DTaP DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 ;K BUDG S %=P_"^ALL DX V06.3;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 ;I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S BUDDTAP($P(BUDG(X),U))="DTaP DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 K BUDG S %=P_"^ALL PROCEDURE 99.39;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S BUDDTAP($P(BUDG(X),U))="DTaP Procedure: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 D CNTDTAP  ;count to see if there are 4
 I BUDDTAP>3 S Y="1^DTaP: total #: "_BUDDTAP,X="" F  S X=$O(BUDDTAP(X)) Q:X'=+X  S Y=Y_"  "_BUDDTAP(X)
 I BUDDTAP>3 Q Y
DT ;
 ;add in dt cpts
 K BUDDT,BUDADT
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90702 S BUDDT(D)="DT CPT: "_Y_" on "_$$DATE^BUD1UTL1(D),BUDADT(D)="DT CPT: "_Y_" on "_$$DATE^BUD1UTL1(D)
 ;are there 3 dt and 1 dtap by cvx and/or cpt?
 ;K BUDG S %=P_"^ALL DX V06.5;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 ;I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S BUDDT($P(BUDG(X),U))="DT DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U)),BUDADT($P(BUDG(X),U))="DT DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 S C="28"
 K BUDX D GETIMMS^BUD1RP6C(P,BDATE,EDATE,C,.BUDX)
 S X=0 F  S X=$O(BUDX(X)) Q:X'=+X  S BUDDT(X)=BUDX(X),BUDADT(X)=BUDX(X)
DT1 ;
 ;kill off any that are on the same day as the dtaps
 S (X,Y)="",C=0 F  S X=$O(BUDDT(X)) Q:X'=+X  I $D(BUDDTAP(X)) K BUDDT(X)
 S (X,Y)="",C=0 F  S X=$O(BUDDT(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDDT(X) Q
 .S Y=X
 K BUDALL
 S BUDDT=0,X=0 F  S X=$O(BUDDT(X)) Q:X'=+X  S BUDDT=BUDDT+1,BUDALL(X)=BUDDT(X)
 S BUDDTAP=0,X=0 F  S X=$O(BUDDTAP(X)) Q:X'=+X  S BUDDTAP=BUDDTAP+1,BUDALL(X)=BUDDTAP(X)
 S (X,Y)="",C=0 F  S X=$O(BUDALL(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDALL(X) Q
 .S Y=X
 S BUDALL=0 S X=0 F  S X=$O(BUDALL(X)) Q:X'=+X  S BUDALL=BUDALL+1
 I BUDALL>3 D  Q "1^"_Y
 .S Y=">=1 DTap & DT/TdS",X=0 F  S X=$O(BUDDTAP(X)) Q:X'=+X  S Y=Y_" "_BUDDTAP(X)
 .S X=0 F  S X=$O(BUDDT(X)) Q:X'=+X  S Y=Y_" "_BUDDT(X)
 ;
TETCVX ;
 K BUDTET,BUDATET
 S BUDTET=0
 ;EVIDENCE?
 S BUDEVTD=""
 K BUDG S %=P_"^LAST DX 037.;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 I $D(BUDG(1)) S BUDEVTD="1^Tetanus Evidence: "_$P(BUDG(1),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(1),U))
 I $$PLCODE^BUD1DU(P,"037.") S BUDEVTD="1^Tetanus Evidence: 037. on Problem List"
 S X=0 F  S X=$O(BUDDT(X)) Q:X'=+X  S BUDTET(X)=BUDDT(X)
 S X=0 F  S X=$O(BUDDTAP(X)) Q:X'=+X  S BUDTET(X)=BUDDTAP(X)
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90703!(Y=90702) S BUDTET(D)="Tetanus CPT: "_Y_" on "_$$DATE^BUD1UTL1(D),BUDATET(D)="TETANUS CPT: "_Y_" on "_$$DATE^BUD1UTL1(D)
 ;K BUDG S %=P_"^ALL DX V03.7;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 ;I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  D
 ;.S BUDTET($P(BUDG(X),U))="Tetanus DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U)),BUDATET($P(BUDG(X),U))="Tetanus DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 K BUDG S %=P_"^ALL PROCEDURE 99.38;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  D
 .S BUDTET($P(BUDG(X),U))="Tetanus Proc: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U)),BUDATET($P(BUDG(X),U))="Tetanus DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 K BUDX S C="35^112" D GETIMMS^BUD1RP6C(P,BDATE,EDATE,C,.BUDX)
 S X=0 F  S X=$O(BUDX(X)) Q:X'=+X  S BUDTET(X)=BUDX(X),BUDATET(X)=BUDX(X)
 S (X,Y)="",C=0 F  S X=$O(BUDTET(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDTET(X) Q
 .S Y=X
 S X=0 F  S X=$O(BUDTET(X)) Q:X'=+X  S BUDTET=BUDTET+1
DIP ;
 K BUDDIP,BUDADIP
 S BUDEVDIP=""
 K BUDG S %=P_"^LAST DX [BGP DIPHTHERIA EVIDENCE;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 I $D(BUDG(1)) S BUDEVDIP="1^Diphtheria Evidence "_$P(BUDG(1),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(1),U))
 I $$PLTAX^BUD1DU(P,"BGP DIPHTHERIA EVIDENCE") I X S BUDEVDIP="1^Diphtheria Evidence: "_$P(X,U,2)_" on Problem List"
 S X=0 F  S X=$O(BUDDT(X)) Q:X'=+X  S BUDDIP(X)=BUDDT(X)
 S X=0 F  S X=$O(BUDDTAP(X)) Q:X'=+X  S BUDDIP(X)=BUDDTAP(X)
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90719 S BUDDIP(D)="Diphtheria CPT: "_Y_" on "_$$DATE^BUD1UTL1(D),BUDADIP(D)="Diphtheria CPT: "_Y_" on "_$$DATE^BUD1UTL1(D)
 ;K BUDG S %=P_"^ALL DX V03.5;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 ;I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S BUDDIP($P(BUDG(X),U))="Diptheria DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U)),BUDADIP($P(BUDG(X),U))="Diptheria DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 K BUDG S %=P_"^ALL PROCEDURE 99.36;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S BUDDIP($P(BUDG(X),U))="Diphtheria Proc: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U)),BUDADIP($P(BUDG(X),U))="Diptheria Proc: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 S (X,Y)="",C=0 F  S X=$O(BUDDIP(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDDIP(X) Q
 .S Y=X
 S X=0,BUDDIP=0 F  S X=$O(BUDDIP(X)) Q:X'=+X  S BUDDIP=BUDDIP+1
 ;
PER ;
 K BUDPER,BUDAPER
 S BUDPEREV=""
 K BUDG S %=P_"^LAST DX [BGP PERTUSSIS EVIDENCE;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 I $D(BUDG(1)) S BUDPEREV="1^Pertussis Evidence "_$P(BUDG(1),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(1),U))
 I $$PLTAX^BUD1DU(P,"BGP PERTUSSIS EVIDENCE") I X S BUDPEREV="1^Pertussis Evidence: "_$P(X,U,2)_" on Problem List"
 S X=0 F  S X=$O(BUDDTAP(X)) Q:X'=+X  S BUDPER(X)=BUDDTAP(X)
 ;K BUDG S %=P_"^ALL DX V03.6;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 ;I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S BUDPER($P(BUDG(X),U))="Pertussis DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U)),BUDAPER($P(BUDG(X),U))="Pertussis DX: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 K BUDG S %=P_"^ALL PROCEDURE 99.37;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BUDG(")
 I $D(BUDG(1)) S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  D
 .S BUDPER($P(BUDG(X),U))="Pertussis Proc: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U)),BUDAPER($P(BUDG(X),U))="Pertussis Pertussis: "_$P(BUDG(X),U,2)_" on "_$$DATE^BUD1UTL1($P(BUDG(X),U))
 K BUDX S C="11" D GETIMMS^BUD1RP6C(P,BDATE,EDATE,C,.BUDX)
 S X=0 F  S X=$O(BUDX(X)) Q:X'=+X  S BUDPER(X)=BUDX(X),BUDAPER(X)=BUDX(X)
 S (X,Y)="",C=0 F  S X=$O(BUDPER(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDPER(X) Q
 .S Y=X
 S X=0,BUDPER=0 F  S X=$O(BUDPER(X)) Q:X'=+X  S BUDPER=BUDPER+1
CHK ;4 of each or evidence
 I BUDTET>3,BUDPER>3,BUDDIP>3 D  Q "1^"_Y
 .S Y="4 of each"
 .S X=0 F  S X=$O(BUDTET(X)) Q:X'=+X  S Y=Y_" "_BUDTET(X)
 .S X=0 F  S X=$O(BUDDIP(X)) Q:X'=+X  S Y=Y_" "_BUDDIP(X)
 .S X=0 F  S X=$O(BUDPER(X)) Q:X'=+X  S Y=Y_" "_BUDPER(X)
 I BUDPEREV,BUDTET>3,BUDDIP>3 D  Q "1^"_Y
 .S Y="evid per, 4 tet, 4 dip "
 .S Y=Y_BUDPEREV
 .S X=0 F  S X=$O(BUDTET(X)) Q:X'=+X  S Y=Y_" "_BUDTET(X)
 .S X=0 F  S X=$O(BUDDIP(X)) Q:X'=+X  S Y=Y_" "_BUDDIP(X)
 I BUDEVTD,BUDPER>3,BUDDIP>3 D  Q "1^"_Y
 .S Y="evid tetanus, 4 dip, 4 per "
 .S Y=Y_BUDEVTD
 .S X=0 F  S X=$O(BUDPER(X)) Q:X'=+X  S Y=Y_" "_BUDPER(X)
 .S X=0 F  S X=$O(BUDDIP(X)) Q:X'=+X  S Y=Y_" "_BUDDIP(X)
 I BUDEVDIP,BUDTET>3,BUDPER>3 D  Q "1^"_Y
 .S Y="evid Diptheria, 4 tet, 4 per "
 .S Y=Y_$P(BUDDIPEV,U,2)
 .S X=0 F  S X=$O(BUDTET(X)) Q:X'=+X  S Y=Y_" "_BUDTET(X)
 .S X=0 F  S X=$O(BUDPER(X)) Q:X'=+X  S Y=Y_" "_BUDPER(X)
 I BUDEVTD,BUDEVDIP,BUDPER>3 D  Q "1^"_Y
 .S Y="evid tet, evid dip, 4 per "
 .S Y=Y_$P(BUDEVTD,U,2)_" "_$P(BUDDIPEV,U,2)
 .S X=0 F  S X=$O(BUDPER(X)) Q:X'=+X  S Y=Y_" "_BUDPER(X)
 I BUDEVTD,BUDPEREV,BUDDIP>3 D  Q "1^"_Y
 .S Y="evid tet, evid PER, 4 dip "
 .S Y=Y_$P(BUDEVTD,U,2)_" "_$P(BUDPEREV,U,2)
 .S X=0 F  S X=$O(BUDDIP(X)) Q:X'=+X  S Y=Y_" "_BUDDIP(X)
 I BUDEVDIP,BUDPEREV,BUDTET>3 D  Q "1^"_Y
 .S Y="evid dip, evid per, 4 tet "
 .S Y=Y_$P(BUDDIPEV,U,2)_" "_$P(BUDPEREV,U,2)
 .S X=0 F  S X=$O(BUDTET(X)) Q:X'=+X  S Y=Y_" "_BUDTET(X)
 I BUDEVDIP,BUDPEREV,BUDEVTD D  Q "1^"_Y
 .S Y="evid dip, evid tet, evid per"
 .S Y=Y_$P(BUDDIPEV,U,2)_" "_$P(BUDEVTD,U,2)_" "_$P(BUDPEREV,U,2)
 .;S X=0 F  S X=$O(BUDTET(X)) Q:X'=+X  S Y=Y_" "_BUDTET(X)
 S Y="0^"
 I BUDDIP<4,'BUDEVDIP S Y=Y_(4-BUDDIP)_" DIP "
 I BUDTET<4,'BUDEVTD S Y=Y_(4-BUDTET)_" TET "
 I BUDPER<4,'BUDPEREV S Y=Y_(4-BUDPER)_" PER"
 Q Y
