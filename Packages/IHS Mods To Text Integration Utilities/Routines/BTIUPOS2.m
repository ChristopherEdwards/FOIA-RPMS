BTIUPOS2 ; IHS/ITSC/LJF - More IHS post initialization actions ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
 Q
PROTCL ;EP;  fix entries in protocols previously sent
 NEW DIE,DA,DR,X,Y
 S DIE="^ORD(101,"
 ; fix screen for Make Addendum protocol
 S DA=$O(^ORD(101,"B","TIU ACTION MAKE ADDENDUM",0)) Q:'DA
 S DR="24///I $D(^XUSEC(""TIUZCLIN2"",+$G(DUZ)))" D ^DIE
 Q
 ;
PATCHES ;EP mark package file entry with patch #s required by OE/RR
 D BMES^XPDUTL("Adding older patches to patch history . . .")
 NEW PKG,VER,COUNT,PATCH,DA,DIC,X,Y
 S PKG=$O(^DIC(9.4,"C","TIU",0)) Q:'PKG
 S VER=$O(^DIC(9.4,PKG,22,"B","1.0",0)) I 'VER D ADD(PKG) Q:VER<1
 F COUNT=1:1 S PATCH=$P($T(PATCH+COUNT),";;",2) Q:PATCH=""  D
 . I $D(^DIC(9.4,PKG,22,VER,"PAH","B",PATCH)) Q   ;already in file
 . S DIC="^DIC(9.4,"_PKG_",22,"_VER_",""PAH"","
 . S DA(2)=PKG,DA(1)=VER,DIC(0)="L"
 . S DIC("P")=$P(^DD(9.49,1105,0),U,2)
 . S X=PATCH,DIC("DR")=".02///"_DT_";.03///`"_DUZ
 . D ^DIC
 Q
 ;
ADD(IEN) ; add version to Package file
 NEW DIC,X,Y,DA
 S DIC="^DIC(9.4,"_IEN_",22,",DIC(0)="L",X="1.0"
 S DIC("P")=$P(^DD(9.4,22,0),U,2)
 S DIC("DR")="2///"_DT_";3///`"_DUZ,DA(1)=IEN
 D ^DIC S VER=+Y
 Q
 ;
PATCH ;;
 ;;1 SEQ #4;;IMAGING 3.0
 ;;3 SEQ #5;; Other TIU patches
 ;;4 SEQ #8;;GMRC*3*4
 ;;7 SEQ #9;;OR*3*10
 ;;15 SEQ #10;;OR*3*2/OR*3*10
 ;;19 SEQ #19;;GMRC*3*4/OR*3*10
 ;;28 SEQ #22;;OR*3*10
 ;;31 SEQ #34;;GMRC*3*4
 ;;47 SEQ #60;;OR*3*10/IMAGING 3.0
 ;;76 SEQ #70;;OR*3*10
 ;;63 SEQ #76;;IMAGING 3.0
 ;;80 SEQ #82;;OR*3*10
 ;;102 SEQ #86;;OR*3*10
 ;;89 SEQ #90;;OR*3*10
 ;;108 SEQ #99;;OR*3*85
 ;;100 SEQ #103;;OR*3*109
 ;;105 SEQ #106;;OR*3*85
 ;;119 SEQ #109;;OR*3*109
 ;;125 SEQ #113;;OR*3*109
 ;;127 SEQ #118;;OR*3*116
 ;;122 SEQ #119;;OR*3*116
 ;;109 SEQ #123;;Clinical Procedures
 ;;124 SEQ #124;;OR*3*148/OR*3*141
 ;;138 SEQ #125;;OR*3*148
 ;;150 SEQ #142;;OR*3*153
 ;;135 SEQ #144;;TIU*1.0*170
