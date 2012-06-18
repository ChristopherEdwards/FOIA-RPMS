APCPPOST ; IHS/TUCSON/LAB - OHPRD-TUCSON/LAB POST-INIT ROUTINE FOR VERSION 1.4 OF APCP AUGUST 14, 1992 ; [ 04/03/98  08:39 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;;APR 03, 1998
 D ^XBKVAR
 S:'$D(DUZ(0)) DUZ(0)="@"
 W !!,"You will now be asked to update the PCC DATA TRANS  Site file by responding with the",!,"IHS Data Center Systems to which you have been instructed to send transactions."
 W !,"The new one added with this version is the STATISTICAL DATABASE SYSTEM.",!
 W !,"You will also be asked to update the other fields in the Site File.  See",!,"the User's Manual for assistance.",!
 I '$D(^APCPSITE(1,0)) S DIC(0)="AEMQL",DIC="^APCPSITE(" D ^DIC I Y=-1 W !!,"ERROR!! " G XIT
 D ^APCPESIT
 W !!,"Done with Site file updating!",!
XIT ;
 K APCPTX,APCPVDFN,APCPLOG,APCPDA
 Q
 ;
