BTIUUPD2 ; IHS/MSC/MGH - IHS post initialization actions ;09-Aug-2007 09:30;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1005**;NOV 04, 2004
 ; This routine will add patch numbers to the package file for
 ; patches that were installed with the basic TIU install
 ;
PATCHES ;EP mark package file entry with patch #s required by OE/RR
 D BMES^XPDUTL("Adding older patches to patch history . . .")
 NEW PKG,VER,COUNT,PATCH,DA,DIC,X,Y
 S PKG=$O(^DIC(9.4,"C","TIU",0)) Q:'PKG
 S VER=$O(^DIC(9.4,PKG,22,"B","1.0",0)) Q:VER=""!(VER<1)
 F COUNT=1:1 S PATCH=$P($T(PATCH+COUNT),";;",2) Q:PATCH=""  D
 . I $D(^DIC(9.4,PKG,22,VER,"PAH","B",PATCH)) Q   ;already in file
 . S DIC="^DIC(9.4,"_PKG_",22,"_VER_",""PAH"","
 . S DA(2)=PKG,DA(1)=VER,DIC(0)="L"
 . S DIC("P")=$P(^DD(9.49,1105,0),U,2)
 . S X=PATCH,DIC("DR")=".02///"_DT_";.03///`"_DUZ
 . D ^DIC
 Q
PATCH ;;
 ;;6 SEQ #1;;Update EHR
 ;;2 SEQ #2;;Update EHR
 ;;123 SEQ #117;;Update EHR
 ;;5 SEQ #3;;Update EHR
 ;;8 SEQ #6;;Update EHR
 ;;11 SEQ #7;;Update EHR
 ;;9 SEQ #11;;Update EHR
 ;;12 SEQ #13;;Update EHR
 ;;10 SEQ #14;;Update EHR
 ;;18 SEQ #15;;Update EHR
 ;;13 SEQ #16;;Update EHR
 ;;24 SEQ #17;;Update EHR
 ;;14 SEQ #18;;Update EHR
 ;;23 SEQ #20;;Update EHR
 ;;25 SEQ #21;;Update EHR
 ;;33 SEQ #23;;Update EHR
 ;;37 SEQ #24;;Update EHR
 ;;29 SEQ #25;;Update EHR
 ;;30 SEQ #26;;Update EHR
 ;;26 SEQ #27;;Update EHR
 ;;32 SEQ #28;;Update EHR
 ;;17 SEQ #29;;Update EHR
 ;;35 SEQ #30;;Update EHR
 ;;36 SEQ #31;;Update EHR
 ;;44 SEQ #32;;Update EHR
 ;;22 SEQ #33;;Update EHR
 ;;27 SEQ #35;;Update EHR
 ;;41 SEQ #36;;Update EHR
 ;;40 SEQ #37;;Update EHR
 ;;34 SEQ #38;;Update EHR
 ;;42 SEQ #39;;Update EHR
 ;;46 SEQ #40;;Update EHR
 ;;20 SEQ #41;;Update EHR
 ;;49 SEQ #42;;Update EHR
 ;;54 SEQ #43;;Update EHR
 ;;21 SEQ #44;;Update EHR
 ;;56 SEQ #45;;Update EHR
 ;;55 SEQ #46;;Update EHR
 ;;48 SEQ #47;;Update EHR
 ;;50 SEQ #48;;Update EHR
 ;;51 SEQ #49;;Update EHR
 ;;43 SEQ #50;;Update EHR
 ;;59 SEQ #51;;Update EHR
 ;;45 SEQ #52;;Update EHR
 ;;38 SEQ #53;;Update EHR
 ;;70 SEQ #54;;Update EHR
 ;;69 SEQ #55;;Update EHR
 ;;65 SEQ #56;;Update EHR
 ;;72 SEQ #57;;Update EHR
 ;;57 SEQ #58;;Update EHR
 ;;66 SEQ #59;;Update EHR
 ;;39 SEQ #61;;Update EHR
 ;;52 SEQ #62;;Update EHR
 ;;67 SEQ #63;;Update EHR
 ;;77 SEQ #64;;Update EHR
 ;;71 SEQ #65;;Update EHR
 ;;75 SEQ #66;;Update EHR
 ;;64 SEQ #67;;Update EHR
 ;;62 SEQ #68;;Update EHR
 ;;74 SEQ #69;;Update EHR
 ;;53 SEQ #71;;Update EHR
 ;;84 SEQ #72;;Update EHR
 ;;83 SEQ #73;;Update EHR
 ;;73 SEQ #74;;Update EHR
 ;;68 SEQ #75;;Update EHR
 ;;86 SEQ #77;;Update EHR
 ;;87 SEQ #78;;Update EHR
 ;;92 SEQ #79;;Update EHR
 ;;79 SEQ #80;;Update EHR
 ;;94 SEQ #81;;Update EHR
 ;;90 SEQ #83;;Update EHR
 ;;91 SEQ #84;;Update EHR
 ;;101 SEQ #85;;Update EHR
 ;;99 SEQ #87;;Update EHR
 ;;93 SEQ #88;;Update EHR
 ;;81 SEQ #89;;Update EHR
 ;;98 SEQ #91;;Update EHR
 ;;82 SEQ #92;;Update EHR
 ;;103 SEQ #93;;Update EHR
 ;;104 SEQ #94;;Update EHR
 ;;88 SEQ #95;;Update EHR
 ;;78 SEQ #96;;Update EHR
 ;;107 SEQ #97;;Update EHR
 ;;58 SEQ #98;;Update EHR
 ;;61 SEQ #100;;Update EHR
 ;;111 SEQ #102;;Update EHR
 ;;96 SEQ #104;;Update EHR
 ;;114 SEQ #105;;Update EHR
 ;;110 SEQ #107;;Update EHR
 ;;121 SEQ #108;;Update EHR
 ;;118 SEQ #110;;Update EHR
 ;;116 SEQ #111;;Update EHR
 ;;117 SEQ #112;;Update EHR
 ;;120 SEQ #114;;Update EHR
 ;;115 SEQ #115;;Update EHR
 ;;123 SEQ #117;;Update EHR
 ;;127 SEQ #118;;Update EHR
 ;;126 SEQ #120;;Update EHR
 ;;129 SEQ #121;;Update EHR
 ;;132 SEQ #122;;Update EHR
 ;;130 SEQ #126;;Update EHR
 ;;131 SEQ #127;;Update EHR
 ;;140 SEQ #128;;Update EHR
 ;;136 SEQ #129;;Update EHR
 ;;146 SEQ #130;;Update EHR
 ;;139 SEQ #132;;Update EHR
 ;;145 SEQ #133;;Update EHR
 ;;142 SEQ #134;;Update EHR
 ;;143 SEQ #135;;Update EHR
 ;;148 SEQ #136;;Update EHR
 ;;156 SEQ #137;;Update EHR
 ;;154 SEQ #138;;Update EHR
 ;;149 SEQ #139;;Update EHR
 ;;155 SEQ #140;;Update EHR
 ;;152 SEQ #141;;Update EHR
 ;;151 SEQ #143;;Update EHR
 ;;144 SEQ #145;;Update EHR
 ;;160 SEQ #146;;Update EHR
 ;;164 SEQ #147;;Update EHR
 ;;158 SEQ #148;;Update EHR
 ;;153 SEQ #149;;Update EHR
 ;;137 SEQ #150;;Update EHR
 ;;134 SEQ #151;;Update EHR
