AGADFIX ; IHS/ASDS/EFG - FIX AGADLIST 9009065.05 ZERO NODE DD NUMBERS ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;one time utility to reset 2nd piece of zero node of field 5
 ;to 9009065.05P
 D DT^DICRW
 Q:'$D(^AGADLIST)
 W !,"Correcting the data structure in the Registration Mailing List File",!
 S AGIEN=0 F  S AGIEN=$O(^AGADLIST(AGIEN)) Q:'AGIEN  I $D(^AGADLIST(AGIEN,1,0)) S $P(^(0),"^",2)="9009065.05P" K ^AGADLIST(AGIEN,1,"B"),^("C")
 S DIK="^AGADLIST(" D IXALL^DIK
 K AGIEN
 Q
