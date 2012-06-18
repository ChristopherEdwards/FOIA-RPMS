BMCFAHC ; IHS/PHXAO/TMJ - PRINT REFERRAL FORM ;  
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
START ;
 W:$D(IOF) @IOF
 W "**********  ARIZONA HEALTH CARE COST CONTAINMENT SYSTEM FORM PRINT  **********",!!
 W "This report will produce a hard copy computer generated AHCCCS form.",!!
GETREF ;get referral entry
 S BMCREF=""
 S DIC="^BMCREF(",DIC(0)="AEMQ",DIC("A")="Select Referral by Patient Name, date of referral or referral #: " D ^DIC K DA,DIC
 G:Y=-1 XIT
 S BMCREF=+Y
ZIS ;
 W !! S XBRC="COMP^BMCFAHC",XBRP="PRINT^BMCFAHC1",XBNS="BMC",XBRX="XIT^BMCFAHC"
 D ^XBDBQUE
 Q
XIT ;
 K BMCREF,BMCCHSR,BMCCMT
 Q
COMP ;
 S BMCFTYPE=2
 Q
