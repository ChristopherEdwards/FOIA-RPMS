BDGPOST5 ; IHS/ITSC/LJF - Add Patch History to Package file; [ 01/22/2004  3:54 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 Q
 ;
PATCHES ;EP mark package file entry with patch #s required by OE/RR etc.
 D BMES^XPDUTL("Adding older patches to patch history . . .")
 NEW PKG,VER,COUNT,PATCH,DA,DIC,X,Y
 S PKG=$O(^DIC(9.4,"C","DG",0)) Q:'PKG
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
 ;;124 SEQ #0;;IMAGING 3.0
 ;;57 SEQ #142;;OR*2.5*49
 ;;134 SEQ #170;;PSJ*5*20
 ;;249 SEQ #237;;OR*3*10/PSB*1*3/IMAGING 3.0
 ;;265 SEQ #238;;PSB*1*3/IMAGING 3.0
 ;;276 SEQ #239;;IMAGING 3.0
 ;;277 SEQ #241;;OR*3*10/IMAGING 3.0
 ;;389 SEQ #412;;SD*5.3*300 TPB
 ;;415 SEQ #428;;PSU*3*21
