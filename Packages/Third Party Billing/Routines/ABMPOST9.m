ABMPOST9 ; IHS/ASDS/LSL - Post init of V2.4 Patch 9  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; There are -1's in the 19 Multiple of the 3P CLAIM DATA File
 ; This routine will look for and delete them.
 ;
 S DUZ2=DUZ(2)
 S (DA(1),DUZ(2))=0
 ;
 ; DIK won't work here because the value of DA is -1.
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 . F  S DA(1)=$O(^ABMDCLM(DUZ(2),DA(1))) Q:'+DA(1)  D
 . . I $D(^ABMDCLM(DUZ(2),DA(1),19,-1)) D
 . . . S ABMP2=$P($G(^ABMDCLM(DUZ(2),DA(1),19,-1,0)),U,2)
 . . . I +ABMP2 K ^ABMDCLM(DUZ(2),DA(1),19,"C",ABMP2,-1)
 . . . K ^ABMDCLM(DUZ(2),DA(1),"ASRC","M",-1,19)
 . . . K ^ABMDCLM(DUZ(2),DA(1),19,-1)
 ;
 S DUZ(2)=DUZ2
 K DUZ2,DA,DIK
 ;
ERROR ;   
 ; Add new error code to 3P ERROR CODE file
 K DA,DR,DIC,DLAYGO,X,DINUM
 S DIC="^ABMDERR("
 S DIC(0)="LX"
 S DLAYGO=9002274
 S DINUM=189
 S X="MEDICARE PART B PIN NUMBER UNSPECIFIED IN 3P INSURER FILE."
 S DIC("DR")=".02////Through INSURER TABLE MAINTENANCE, enter the provider and MEDICARE PART B pin number."
 S DIC("DR")=DIC("DR")_";.03////E"
 S DIC("DR")=DIC("DR")_";.05////0"
 D ^DIC
 Q:Y<0
 K DA,DIC,DR,DINUM,Y
 ;
 ; Add Required by insurer (Medicare and Railroad Retirement)
 S ^ABMDERR(189,11,0)="^9002274.411PA^^"
 F INS=1,2 D
 . S DIC(0)="LXE"
 . S DA(1)=189
 . S DIC="^ABMDERR("_DA(1)_",11,"
 . S DINUM=INS
 . S X=$P(^AUTNINS(INS,0),U)
 . D ^DIC
 . K DA,DIC,DINUM,X
 K INS
 ; 
 ; Add Required for export form (all current HCFA's)
 S ^ABMDERR(189,21,0)="^9002274.421P^^"
 F MOD=3,14,15,19,20 D
 . S DIC(0)="LXE"
 . S DA(1)=189
 . S DIC="^ABMDERR("_DA(1)_",21,"
 . S DINUM=MOD
 . S X=$P(^ABMDEXP(MOD,0),U)
 . D ^DIC
 . K DA,DIC,DINUM,X
 K MOD
 ;
 ; Add SITE multiple
 S ^ABMDERR(189,31,0)="^9002274.0431PA^^"
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 . S DIC(0)="LXE"
 . S DA(1)=189
 . S DIC="^ABMDERR("_DA(1)_",31,"
 . S DINUM=DUZ(2)
 . S X=$P($G(^DIC(4,DUZ(2),0)),U)
 . S DIC("DR")=".03////E"
 . D ^DIC
 . K DA,DIC,DINUM,X
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO
 Q
