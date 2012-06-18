BDMDM8 ; IHS/CMI/LAB - PPD STUFF ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;IHS/TUCSON/LAB - patch 1 - 05/27/97 fixed cumulative TB STATUS calculation modified subroutine TBTXST and PPDCODE
 ;
 ;
START ;
PPD ;EP
 S BDMX=BDMPD_"^LAST SKIN PPD" S BDMER=$$START1^APCLDF(BDMX,BDMY)
 I '$D(BDM(1)) S ^TMP("BDM",$J,20)="No recorded PPD"
 I $D(BDM(1)) S Y=$P(BDM(1),U) D DD^%DT S ^TMP("BDM",$J,20)=$S($P(^AUPNVSK(+$P(BDM(1),U,4),0),U,5)]"":$P(^(0),U,5)_"mm;",1:"")_$S($P(BDM(1),U,2)'="P":"NEGATIVE - "_Y,1:"POSITIVE - "_Y)
TBTXST ;TB Treatment Status, 21 get last TB related health factor
 S %=$O(^ATXAX("B","DM AUDIT TB HEALTH FACTORS",0))
 I '% S ^TMP("BDM",$J,21)="TB Health Factor TAXONOMY MISSING!!" G PPDCODE ;IHS/TUCSON/LAB patch 1 - 05/27/97 - added this line
 I % D
 .S (X,Y)=0 F  S X=$O(^AUPNHF("AA",BDMPD,X)) Q:X'=+X!(Y)  I $D(^ATXAX(%,21,"B",X)) S Y=X
 .I Y S Y=$P(^AUTTHF(Y,0),U),^TMP("BDM",$J,21)=Y ;IHS/TUCSON/LAB - patch 1 - 05/27/97 modified this line
 ;I Y]"" S ^TMP("BDM",$J,21)=Y G TBCUML ;IHS/TUCSON/LAB - patch 1 - commented out this line and added line below
 I $D(^TMP("BDM",$J,21)) G TBCUML
 K BDM S BDMY="BDM(",BDMX=BDMPD_"^LAST HEALTH [DM AUDIT TB HEALTH FACTORS" S BDMER=$$START1^APCLDF(BDMX,BDMY)
 S ^TMP("BDM",$J,21)=$S($D(BDM(1)):$P(BDM(1),U,3),1:"TB Health Factor Not recorded")
TBCUML I BDMCUML D
 .I ^TMP("BDM",$J,21)["Not recorded" S BDMGOT1=1,BDMSUB=94 D CUML^BDMDM1 F BDMSUB=90:1:93 S BDMGOT1=0 D CUML^BDMDM1
 .I ^TMP("BDM",$J,21)["TB - TX COMPLETE" S BDMGOT1=1,BDMSUB=90 D CUML^BDMDM1 F BDMSUB=91:1:94 S BDMGOT1=0 D CUML^BDMDM1
 .I ^TMP("BDM",$J,21)["TB - TX INCOMPLETE" S BDMGOT1=1,BDMSUB=91 D CUML^BDMDM1 F BDMSUB=90,92,93,94 S BDMGOT1=0 D CUML^BDMDM1
 .I ^TMP("BDM",$J,21)["TB - TX UNKNOWN" S BDMGOT1=1,BDMSUB=93 D CUML^BDMDM1 F BDMSUB=90,91,92,94 S BDMGOT1=0 D CUML^BDMDM1
 .I ^TMP("BDM",$J,21)["TB - TX UNTREATED" S BDMGOT1=1,BDMSUB=92 D CUML^BDMDM1 F BDMSUB=90,91,93,94 S BDMGOT1=0 D CUML^BDMDM1
PPDCODE ;PPD STATUS CODE
 S BDMJ=""
 ;IHS/TUCSON/LAB - patch 1 - added the 2 lines below
 I $G(^TMP("BDM",$J,21))="TB - TX COMPLETE" S BDMJ=1 G PPDCUML
 I $G(^TMP("BDM",$J,21))["TB - " S BDMJ=2 G PPDCUML
 I ^TMP("BDM",$J,20)["POSITIVE" D  G PPDCUML
 .I $G(^TMP("BDM",$J,21))="TB - TX COMPLETE" S BDMJ=1
 .S BDMJ=2
 .Q
 I ^TMP("BDM",$J,20)["NEGATIVE" S BDMJ=5 D  G PPDCUML
 .I ^TMP("BDM",$J,37)["not recorded" S BDMJ=5 Q
 .S X=^TMP("BDM",$J,37),%DT="" D ^%DT S BDMI=Y,X=$P(^TMP("BDM",$J,20),"- ",2),%DT="" D ^%DT S BDMJ=$S(Y>BDMI:3,1:4)
 .Q
 S BDMJ=6
PPDCUML ;cumulative PPD
 S ^TMP("BDM",$J,36)=$P($T(@BDMJ),";;",2)_"  ("_BDMJ_")"
 Q:'BDMCUML
 S BDMI="70,71,72,73,74,75" F BDMX=1:1:6 S BDMSUB=$P(BDMI,",",BDMX),BDMGOT1=$S(BDMJ=BDMX:1,1:0) D CUML^BDMDM1
 Q
 ;
TBCODE(DFN) ;
 NEW BDMJ,BDMI
 S BDMJ=""
 ;return computed TB Status Code
 I ^TMP("BDM",$J,20)["POSITIVE" D  Q BDMJ
 .I $G(^TMP("BDM",$J,21))="TB - TX COMPLETE" S BDMJ=1
 .S BDMJ=2
 .Q
 I ^TMP("BDM",$J,20)["NEGATIVE" S BDMJ=4 D  Q BDMJ
 .I ^TMP("BDM",$J,37)["not recorded" S BDMJ=4 Q
 .S X=^TMP("BDM",$J,37),%DT="" D ^%DT S BDMI=Y,X=$P(^TMP("BDM",$J,20),"- ",2),%DT="" D ^%DT S X=$S(Y>BDMI:3,1:4)
 .Q
 S BDMJ=4
 Q BDMJ
 ;;
1 ;;PPD +, treatment complete
2 ;;PPD +, not treated or unknown treatment
3 ;;PPD -, up-to-date (placed after dm dx)
4 ;;PPD -, before DM dx
5 ;;PPD -, DM dx date unknown
6 ;;PPD Status unknown
