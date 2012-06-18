DGV53PTE ;AISC/SAW-Convert EDR data from file 705 to file 391.51 ;7/16/93  16:07
 ;;5.3;Registration;;Aug 13, 1993
 ;;
 W !!,">>> Converting EDR data from file #705 to file #391.51..."
 S %X="^EDR(705,",%Y="^VAT(391.51," D %XY^%RCR S $P(^VAT(391.51,0),"^",1,2)="PIMS EDR EVENT^391.51D" K %X,%Y
 S DIU="^EDR(705,",DIU(0)="DST" D EN^DIU2 K DIU
 S DA(1)=+$O(^ORD(101,"B","DGPM MOVEMENT EVENTS",0)),VAFEDX=+$O(^ORD(101,"B","EDR CAPTURE EVENTS",0)),DA=+$O(^ORD(101,"AD",VAFEDX,DA(1),0))
 I DA(1),DA S DIK="^ORD(101,"_DA(1)_",10," D ^DIK
 I VAFEDX S DA=VAFEDX,DIK="^ORD(101," D ^DIK
 ;I '$D(^HL(770,0)) W !!,*7,"You have not yet initialized the DHCP HL7 package.  Be sure to re-run this part",!,"of the post-init (D ^DGV53PTE) after you initialize the DHCP HL7 package." G EXIT
771 S VAFEDDA=$O(^HL(771,"B","EDR-MAS",0)) I 'VAFEDDA K DD,DO S X="EDR-MAS",DIC="^HL(771,",DIC(0)="" D FILE^DICN G 771:Y<0 S (DA,VAFEDDA)=+Y,DIE=DIC,DR="2///I" D ^DIE
770 S DA=$O(^HL(770,"B","EDR-MAS",0)) I 'DA K DA,DD,DO,DR S X="EDR-MAS",DIC="^HL(770,",DIC(0)="" D FILE^DICN G 770:Y<0 S DA=+Y,DIE=DIC,DR="3///RCP;4///245;7///2.1;8////"_VAFEDDA_";14///P" D ^DIE
 S X=$O(^XMB(3.8,"B","EDR-RCP",0)) I X S $P(^HL(770,DA,0),"^",10)=X
EXIT W "completed."
 K DA,DIC,DIE,DIK,DR,VAFEDDA,VAFEDX,X,Y Q
