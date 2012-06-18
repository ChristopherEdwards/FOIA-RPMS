ADGPTLC ; IHS/ADC/PDW/ENM - CALCULATE PATIENT LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 K ^TMP("DGZPTL",$J)
 ; -- main
 N DFN,NAME,WD,BED,RM,IFN,AD,DX,TS,PR,N,RMBD,RB,COM,X,Y
 D AWD:'DGWST,OWD:DGWST
 I $D(^ADGDS("CN"))!$D(^SRF("AIHS1","OB")) D ^ADGPTLC1
 G:DGO=3 ^ADGPTLP1
 G ^ADGPTLP
 ;
AWD ; -- all wards
 I DGO'=3 D
 . S WD=0 F  S WD=$O(^DG(405.4,"W",WD)) Q:'WD  D:'$$OOSW(WD)
 .. S RB=0 F  S RB=$O(^DG(405.4,"W",WD,RB)) Q:'RB  D:'$$OOSB(RB)
 ... S WARD=$P($G(^DIC(42,+WD,0)),U),RMBD=$P($G(^DG(405.4,+RB,0)),U)
 ... S ^TMP("DGZPTL",$J,"BED",WD,RB)=WARD_"-"_RMBD
 S WARD="" F  S WARD=$O(^DPT("CN",WARD)) Q:WARD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  D 1
 Q
 ;
OWD ; -- one ward
 Q:$$OOSW(DGWST)  I DGO'=3 D
 . S RB=0 F  S RB=$O(^DG(405.4,"W",DGWST,RB)) Q:'RB  D:'$$OOSB(RB)
 .. S WARD=$P($G(^DIC(42,+DGWST,0)),U),RMBD=$P($G(^DG(405.4,+RB,0)),U)
 .. S ^TMP("DGZPTL",$J,"BED",DGWST,RB)=WARD_"-"_RMBD
 S WARD=$P(^DIC(42,DGWST,0),U)
 S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  D 1
 Q
 ;
1 S IFN=^DPT("CN",WARD,DFN),NAME=$P(^DPT(DFN,0),U),WD=$G(^DPT(DFN,.1))
 S BED=$G(^DPT(DFN,.101)),TS=$G(^(.103)),PR=$G(^(.104))
 S RM=WD_"-"_BED,COM=$P($G(^AUPNPAT(DFN,11)),U,18)
 S N=$G(^DGPM(IFN,0)),AD=+N,DX=$S(DGO=2:TS,1:$P(N,U,10))
 ;--alpha list
 I DGO=3 D  Q
 . S ^TMP("DGZPTL",$J,"A",NAME,DFN)=RM_U_AD_U_TS_U_PR_U_COM
 ;--no room-bed
 I $P(RM,"-",2)="" D  Q
 . S ^TMP("DGZPTL",$J,"WD",RM,DFN)=DFN_U_NAME_U_AD_U_DX_U_PR_U_COM
 ;--with room-bed
 S ^TMP("DGZPTL",$J,"WD",RM)=DFN_U_NAME_U_AD_U_DX_U_PR_U_COM
 Q
 ;
Q ;--cleanup
 K DFN,NAME,WD,BED,RM,IFN,AD,DX,TS,PR,N,RMBD,RB,COM Q
 ;
OOSB(Y) ; -- bed out of service
 Q:'$D(^DG(405.4,Y,"I","AINV")) 0
 N X S X=$G(^DG(405.4,Y,"I",+$O(^($O(^("AINV",0)),0)),0)) Q:'X 0
 Q $S($P(X,U,4)=DT:0,$P(X,U,4)&($P(X,U,4)<DT):0,X=DT:0,X<DT:1,1:0)
 ;
OOSW(Y) ; -- ward out of service
 Q:'$D(^DIC(42,Y,"OOS","AINV")) 0
 N X S X=$G(^DIC(42,Y,"OOS",+$O(^($O(^("AINV",0)),0)),0)) Q:'X 0
 Q $S($P(X,U,4)=DT:0,$P(X,U,4)&($P(X,U,4)<DT):0,X=DT:0,X<DT:1,1:0)
