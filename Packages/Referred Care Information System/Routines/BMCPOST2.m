BMCPOST2 ; IHS/PHXAO/TMJ - ADD MAIL GROUP TO BULLENTIN ENTRY ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 W !!,?5,"***I Will now add the appropriate Mail Group Entry to each Mail Bulletin***",!!
 D ADDCHS,ADDIHS,ADDOTHER,ADDINHOU
 W !!,?5,"**Mail Groups entries to Bulletin File are now Complete**",!!
 D END
 Q
 ;
ADDCHS ;ADD BMC CHS ALERT Mail Group
 ;
 S BMCBULL="BMC CHS ALERT" D
 .  S BMCBIEN=$O(^XMB(3.6,"B",BMCBULL,0))
 .  I 'BMCBIEN W !,BMCBULL," bulletin not found.....I was unable to add  BMC CHS ALERT mail group to this Bulletin." Q
 . I $D(^XMB(3.6,BMCBIEN,2,"B","BMC CHS ALERT")) W !,"Mail Group Entry already Exists in Mail Group field of the Bulletin File",!! Q
 .  S DIC="^XMB(3.6,"_BMCBIEN_",2,"
 .  S DIC(0)="L"
 .  S DIC("P")=$P(^DD(3.6,4,0),U,2)
 .  S DA(1)=BMCBIEN
 .  S X=$O(^XMB(3.8,"B","BMC CHS ALERT",0))
 .  I 'X W !,"Can't find the BMC CHS ALERT Mail Group." Q
 .  K DD,DO
 .  D FILE^DICN K DIC
 .  I +Y<0 W !?5,"Multiple entry was unsuccessful:  ",X K X Q
 .  W !?5,X_" Mail Group added to the "_BMCBULL_" Bulletin."
 .  K X,Y,DA
 .  Q
 K BMCBIEN,BMCBULL
 W !!
 Q
 ;
 ;
ADDIHS ;
 ;
 S BMCBULL="BMC IHS ALERT" D
 .  S BMCBIEN=$O(^XMB(3.6,"B",BMCBULL,0))
 .  I 'BMCBIEN W !,BMCBULL," bulletin not found.....I was unable to add  BMC IHS ALERT mail group to this Bulletin." Q
 . I $D(^XMB(3.6,BMCBIEN,2,"B","BMC IHS ALERT")) W !,"Mail Group Entry already Exists in Mail Group field of the Bulletin File",!! Q
 .  S DIC="^XMB(3.6,"_BMCBIEN_",2,"
 .  S DIC(0)="L"
 .  S DIC("P")=$P(^DD(3.6,4,0),U,2)
 .  S DA(1)=BMCBIEN
 .  S X=$O(^XMB(3.8,"B","BMC IHS ALERT",0))
 .  I 'X W !,"Can't find BMC IHS ALERT Mail Group." Q
 .  K DD,DO
 .  D FILE^DICN K DIC
 .  I +Y<0 W !?5,"Multiple entry was unsuccessful:  ",X K X Q
 .  W !?5,X_" Mail Group added to the "_BMCBULL_" Bulletin."
 .  K X,Y,DA
 .  Q
 K BMCBIEN,BMCBULL
 W !!
 Q
 ;
ADDOTHER ;
 ;
 S BMCBULL="BMC OTHER ALERT" D
 .  S BMCBIEN=$O(^XMB(3.6,"B",BMCBULL,0))
 .  I 'BMCBIEN W !,BMCBULL," bulletin not found.....I was unable to add  BMC OTHER ALERT mail group to this Bulletin." Q
 . I $D(^XMB(3.6,BMCBIEN,2,"B","BMC OTHER ALERT")) W !,"Mail Group Entry already Exists in Mail Group field of the Bulletin File",!! Q
 .  S DIC="^XMB(3.6,"_BMCBIEN_",2,"
 .  S DIC(0)="L"
 .  S DIC("P")=$P(^DD(3.6,4,0),U,2)
 .  S DA(1)=BMCBIEN
 .  S X=$O(^XMB(3.8,"B","BMC OTHER ALERT",0))
 .  I 'X W !,"Can't find the BMC OTHER ALERT Mail Group." Q
 .  K DD,DO
 .  D FILE^DICN K DIC
 .  I +Y<0 W !?5,"Multiple entry was unsuccessful:  ",X K X Q
 .  W !?5,X_" Mail Group added to the "_BMCBULL_" Bulletin."
 .  K X,Y,DA
 .  Q
 K BMCBIEN,BMCBULL
 W !!
 Q
 ;
ADDINHOU ;
 ;
 S BMCBULL="BMC INHOUSE ALERT" D
 .  S BMCBIEN=$O(^XMB(3.6,"B",BMCBULL,0))
 .  I 'BMCBIEN W !,BMCBULL," bulletin not found.....I was unable to add  BMC INHOUSE ALERT mail group to this Bulletin." Q
 . I $D(^XMB(3.6,BMCBIEN,2,"B","BMC INHOUSE ALERT")) W !,"Mail Group Entry already Exists in Mail Group field of the Bulletin File",!! Q
 .  S DIC="^XMB(3.6,"_BMCBIEN_",2,"
 .  S DIC(0)="L"
 .  S DIC("P")=$P(^DD(3.6,4,0),U,2)
 .  S DA(1)=BMCBIEN
 .  S X=$O(^XMB(3.8,"B","BMC INHOUSE ALERT",0))
 .  I 'X W !,"Can't find the BMC INHOUSE ALERT Mail Group." Q
 .  K DD,DO
 .  D FILE^DICN K DIC
 .  I +Y<0 W !?5,"Multiple entry was unsuccessful:  ",X K X Q
 .  W !?5,X_" Mail Group added to the "_BMCBULL_" Bulletin."
 .  K X,Y,DA
 .  Q
 K BMCBIEN,BMCBULL
 W !!
 Q
END ;
 K BMCBIEN,BMCBULL
