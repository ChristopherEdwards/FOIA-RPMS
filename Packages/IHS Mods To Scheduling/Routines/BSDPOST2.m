BSDPOST2 ; IHS/ITSC/LJF - Add Patch History to Package file; [ 01/22/2004  3:54 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 Q
 ;
PATCHES ;EP mark package file entry with patch #s required by OE/RR etc.
 D BMES^XPDUTL("Adding older patches to patch history . . .")
 NEW PKG,VER,COUNT,PATCH,DA,DIC,X,Y
 S PKG=$O(^DIC(9.4,"C","SD",0)) Q:'PKG
 S VER=$O(^DIC(9.4,PKG,22,"B","5.3",0)) Q:'VER
 F COUNT=1:1 S PATCH=$P($T(PATCH+COUNT),";;",2) Q:PATCH=""  D
 . I $D(^DIC(9.4,PKG,22,VER,"PAH","B",PATCH)) Q   ;skip if already in file
 . S DIC="^DIC(9.4,"_PKG_",22,"_VER_",""PAH"","
 . S DA(2)=PKG,DA(1)=VER,DIC(0)="L"
 . S DIC("P")=$P(^DD(9.49,1105,0),U,2)
 . S X=PATCH,DIC("DR")=".02///"_DT_";.03///`"_DUZ
 . D ^DIC
 Q
 ;
PATCH ;;
 ;;131 SEQ #127;;GMRA*4*9
 ;;263 SEQ #243;;SD*5.3*300
 ;;254 SEQ #247;;PSU*3*21
