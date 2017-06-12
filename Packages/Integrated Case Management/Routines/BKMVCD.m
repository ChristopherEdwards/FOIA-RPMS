BKMVCD ;PRXM/HC/BHS - HMS ; 16-AUG-2005
 ;;2.2;HIV MANAGEMENT SYSTEM;;Apr 01, 2015;Build 40
 ;
 Q
 ;
ADDPAT(BKMPAT) ; EP - Add pat to iCare register
 N DIC,X,Y
 S X=$G(BKMPAT)
 S DIC(0)="L"
 S DIC="^BKM(90451,"
 D FILE^DICN
 Q +$P(Y,U,1)
 ;
ADDREG(BKMIEN,BKMHIV) ; EP - Add new pat to the HMS register.
 N DA,DIC,X,Y
 S X=$G(BKMHIV)
 S DIC(0)="L"
 S DIC="^BKM(90451,"_BKMIEN_",1,"
 S DA(1)=BKMIEN
 D FILE^DICN
 Q +$P(Y,U,1)
