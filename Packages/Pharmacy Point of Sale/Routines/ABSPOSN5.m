ABSPOSN5 ; IHS/FCS/DRS - NCPDP Forms for ILC A/R ;  [ 09/12/2002  10:16 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
EN(TITLE,PFLAG) ;EP
 ;
 N X,Y,SITE,AINS,D0,PAT,TOTPCN,FLG,PCN,PCNBAL,VCN,SUBPCN,RESP,DIR,DATE
 S Y=DT D DD^%DT S DATE=Y
 S SITE=$P($G(^ABSSETUP(9002314,1,0)),U,1)
 S SITE=$P($G(^DIC(4,SITE,0)),U,1)
 U IO
 D HDR
 D RPT
 W @IOF
 ;K ^TMP("ABSPOSN5",$J)
 Q
 ;----------------------------------------------------------------
RPT ;
 K ^TMP("ABSPOSN5",$J)
 N AINS,D0
 S (D0,FLG("X"))=0
 F  S D0=$O(^ABSBITMS(9002302,PFLAG,1,D0)) Q:'D0  DO
 . S AINS=$P($G(^ABSBITMS(9002302,D0,0)),U,3)
 . I AINS="" S AINS="SELF PAY"
 . S PAT=$P($G(^ABSBITMS(9002302,D0,0)),U,2)
 . Q:'PAT
 . S PAT=$P($G(^DPT(PAT,0)),U,1)
 . S ^TMP("ABSPOSN5",$J,AINS,PAT,D0)=""
 S AINS=""
 S TOTPCN=0
 F  S AINS=$O(^TMP("ABSPOSN5",$J,AINS)) Q:AINS=""  D  Q:FLG("X")
 . W !,$E(AINS,1,80)
 . S PAT="",SUBPCN=0
 . F  S PAT=$O(^TMP("ABSPOSN5",$J,AINS,PAT)) Q:PAT=""  D  Q:FLG("X")
 . . S D0=0
 . . F  S D0=$O(^TMP("ABSPOSN5",$J,AINS,PAT,D0)) Q:'D0  D  Q:FLG("X")
 . . . S PCN=$P($G(^ABSBITMS(9002302,D0,0)),U,1)
 . . . S PCNBAL=$P($G(^ABSBITMS(9002302,D0,3)),U,1)
 . . . Q:PCNBAL=0
 . . . S VCN=$P($G(^ABSBITMS(9002302,D0,"VCN")),U,1)
 . . . S SUBPCN=SUBPCN+PCNBAL
 . . . W !,?8,$E(PAT,1,30),?44,$E(VCN,1,12),?57,$E(PCN,1,12),?70,$J(PCNBAL,10,2)
 . . . I ($Y+6)>IOSL,$E(IOST)="P" D HDR
 . . . I ($Y+6)>IOSL,$E(IOST)="C" W *7 S DIR(0)="E" D ^DIR S RESP=Y D HDR I RESP=0 S FLG("X")=1 Q
 . W !,?70,"----------",!,"SUBTOTAL",?70,$J(SUBPCN,10,2),!
 . S TOTPCN=TOTPCN+SUBPCN
 Q:FLG("X")=1
 W !!,?70,"----------",!,"TOTAL",?70,$J(TOTPCN,10,2),!
 I $E(IOST)="C" W *7 S DIR(0)="E" D ^DIR  Q:'Y
 Q
 ;----------------------------------------------------------------------
HDR W @IOF
 W !,$E(TITLE,1,39),?40,$E(SITE,1,24),?68,$E(DATE,1,12)
 W !!,"INSURER/PATIENT",?44,"VCN",?57,"PCN",?70,"BALANCE"
 W !,$TR($J("",80)," ","-")
 Q
