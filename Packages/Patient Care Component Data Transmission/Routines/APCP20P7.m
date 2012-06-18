APCP20P7 ; IHS/TUCSON/LAB - Routine to create bulletin ; [ 12/16/03  3:16 PM ]
 ;;2.0;IHS PCC DATA EXTRACTION;**7**;APR 03, 1998
 ;;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
PRE ;EP - pre init
 ;delete all entries from rec file
 S APCPX=0 F  S APCPX=$O(^APCPREC(APCPX)) Q:APCPX'=+APCPX  S DA=APCPX,DIK="^APCPREC(" D ^DIK
 ;data will be reloaded with kids install
 Q
POST ;EP
OPT ;add 2 new options (supplement, report)
 D LAB ;build lab taxonomy
 NEW X
 S X=$$ADD^XPDMENU("APCPMENU","APCP RE-EXPORT DATE RANGE","EDR")
 I 'X W "Attempt to new re-export option failed.." H 3
 S X=$$DELETE^XPDMENU("APCPMENU","APCP RE-EXPORT MENU")
 S X=$$DELETE^XPDMENU("APCP REPORTS MENU","APCP RPT CHA RECORDS")
 ;reset all visits with 7 or more diagnoses for reexport by setting APCIS
 Q  ;do not resend per Donnie
 ;loop thru APCPLOG, if has .24 then loop thru 21 mult
 W !,"checking some visits...hold on"
 S APCPDT=$O(^AUPNVSIT("APCIS",0))
 S APCPLOG=0 F  S APCPLOG=$O(^APCPLOG(APCPLOG)) Q:APCPLOG'=+APCPLOG  D
 .Q:$P(^APCPLOG(APCPLOG,0),U,24)=""
 .S APCPV=0 F  S APCPV=$O(^APCPLOG(APCPLOG,21,APCPV)) Q:APCPV'=+APCPV  D
 ..Q:'$D(^AUPNVSIT(APCPV,0))
 ..Q:$P(^AUPNVSIT(APCPV,0),U,11)
 ..S C=0,P=0 F  S P=$O(^AUPNVPOV("AD",APCPV,P)) Q:P'=+P  S C=C+1
 ..I C>6 D
 ...S X=$P(^AUPNVSIT(APCPV,0),U,2) Q:$D(^AUPNVSIT("APCIS",X,APCPV))  ;already in xref
 ...S X=$P(^AUPNVSIT(APCPV,0),U,13) Q:$D(^AUPNVSIT("APCIS",X,APCPV))  ;already in xref
 ...S ^AUPNVSIT("APCIS",APCPDT,APCPV)="" W "."
 ..Q
 .Q
 Q
LAB ;
 S APCPX="APCP PAP SMEAR TESTS" D PAPLAB1
 S APCPX="APCP PSA TESTS TAX" D PSALAB1
 Q
PAPLAB1 ;
 W !,"Creating ",APCPX," Taxonomy..."
 S APCPDA=$O(^ATXLAB("B",APCPX,0))
 Q:APCPDA  ;taxonomy already exisits
 S X=APCPX,DIC="^ATXLAB(",DIC(0)="L",DIADD=1,DLAYGO=9002228 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",APCPX," TAX" Q
 S APCPTX=+Y,$P(^ATXLAB(APCPTX,0),U,2)=APCPX,$P(^(0),U,5)=DUZ,$P(^(0),U,6)=DT,$P(^(0),U,8)="B",$P(^(0),U,9)=60,^ATXLAB(APCPTX,21,0)="^9002228.02101PA^0^0"
 S APCPX=$O(^LAB(60,"B","PAP SMEAR",0))
 I APCPX S ^ATXLAB(APCPTX,21,1,0)=APCPX,^ATXLAB(APCPTX,21,"B",APCPX,1)="",$P(^ATXLAB(APCPTX,21,0),U,3)=APCPX,$P(^ATXLAB(APCPTX,21,0),U,4)=1
 S DA=APCPTX,DIK="^ATXAX(" D IX1^DIK
 Q
 ;
PSALAB1 ;
 W !,"Creating ",APCPX," Taxonomy..."
 S APCPDA=$O(^ATXLAB("B",APCPX,0))
 Q:APCPDA  ;taxonomy already exisits
 S X=APCPX,DIC="^ATXLAB(",DIC(0)="L",DIADD=1,DLAYGO=9002228 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",APCPX," TAX" Q
 S APCPTX=+Y,$P(^ATXLAB(APCPTX,0),U,2)=APCPX,$P(^(0),U,5)=DUZ,$P(^(0),U,6)=DT,$P(^(0),U,8)="B",$P(^(0),U,9)=60,^ATXLAB(APCPTX,21,0)="^9002228.02101PA^0^0"
 S APCPX=$O(^LAB(60,"B","PSA",0))
 I APCPX S ^ATXLAB(APCPTX,21,1,0)=APCPX,^ATXLAB(APCPTX,21,"B",APCPX,1)="",$P(^ATXLAB(APCPTX,21,0),U,3)=APCPX,$P(^ATXLAB(APCPTX,21,0),U,4)=1
 S DA=APCPTX,DIK="^ATXAX(" D IX1^DIK
 Q
 ;
