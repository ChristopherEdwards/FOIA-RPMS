APCLPOST ; IHS/OHPRD/TMJ - IHS-TUCSON/GIS/THL ; [ 02/11/97  7:18 AM ]
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
EN ;
 D ^XBKVAR
 W !!,"Beginning Post init: " D ^%T
 D ^APCLONIT
 D ^APCLL
 D PROC,PROC,DMTX,DMTX1,KILL,EXIT
 Q
PROC ;
 D WAIT^DICD W "   ... setting templates into sort file"
 S %(1)=""
 F I=0:0 S %(1)=$O(^APCLSRT("B",%(1))) Q:%(1)=""  D SET
 K ^APCLSRT("B")
 S DIK="^APCLSRT(" D IXALL^DIK
 K %,APCLTMP,APCLTMPN
 Q
KILL ;
 K DA,DIADD,DLAYGO,DA,DR,DI,A,B,S,D,X,Y,Z,DIC,DIE,D1,DDC,DDH,DIG,DIH,DIU,DIV,DIW,DQ
 Q
EXIT ;
 W $C(7),$C(7),!!?5,"ASSOCIATED PRINT TEMPLATE POINTERS HAVE BEEN RESET."
 W !?5,"INITIALIZATION OF THE PCC MANAGEMENT REPORTS SYSTEM IS COMPLETE."
 K APCLX,APCLY,DA,DIE,DIU,DR,DIV,X,Y,%,DIC,DLAYGO,DIH,DIG,DO,D0,D1,DI,I,DQ,DIW,APCLTX,ATXFLG,ATXX
 Q
SET F %(2)=0:0 S %(2)=$O(^APCLSRT("B",%(1),%(2))) Q:'%(2)  D SET1
 Q
SET1 ;
 K ^APCLSRT(%(2),2,"B")
 F %(3)=0:0 S %(3)=$O(^APCLSRT(%(2),2,%(3))) Q:'%(3)  S APCLTMP=$P(^APCLSRT(%(2),2,%(3),0),U,2) I APCLTMP]"" D SET2
 Q
SET2 ;
 F APCLTMPN=0:0 S APCLTMPN=$O(^DIPT("B",APCLTMP,APCLTMPN)) Q:'APCLTMPN  S $P(^APCLSRT(%(2),2,%(3),0),U)=APCLTMPN
 Q
 ;
 ;
 ;
DMTX ;add 14 Taxonomies/Bulletins if don't exit
 I '$D(^ATXAX(0)) W !!,"You do not have the Taxonomy System installed....I can not",!,"update the appropriate entries in the taxonomy file for",!,"the Diabetes Program QA Audit System or APCL Taxonomies." H 5 Q
 W !,"Installing Appropriate APCL and DM namespaced..Taxonomies/Bulletins - if not already installed.........Takes a while!",!! D ^APCLTX
 W !!,"Taxonomy Install Successfully Completed",!!
 Q
DMTX1 ;
 ;fix ada,hf,education topics dm audit taxonomies
 D ^APCLPOS5
 Q
