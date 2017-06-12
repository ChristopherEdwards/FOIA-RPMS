BJPN2P08 ;GDIT/HS/BEE-Prenatal Care Module 2.0 Patch 8 Post Install ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**8**;Feb 24, 2015;Build 25
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT
 ;
 ;Check for BJPN*2.0*7
 I '$$INSTALLD("BJPN*2.0*7") D BMES^XPDUTL("Version 2.0 Patch 7 of BJPN is required!") S XPDQUIT=2 Q
 ;
 ;Check for EHRp21
 I '$$INSTALLD("BGO*1.1*21") D BMES^XPDUTL("Version 1.1 Patch 20 of EHR is required!") S XPDQUIT=2 Q
 ;
 ;Check for BJPCp17
 I '$$INSTALLD("BJPC*2.0*17") D BMES^XPDUTL("Version 2.0 Patch 17 of BJPC is required!") S XPDQUIT=2 Q
 ;
 Q
 ;
PST ;EP - Prenatal 2.0 Patch 8 Post Installation Code
 ;
 ;Tie BJPNRPC to BSTSRPC
 ;
 ;Set BSTSRPC into BJPNRPC
 NEW IEN,DA,X,DIC,BI,TEXT,PIEN,Y
 ;
 K DO,DD
 S DA(1)=$$FIND1^DIC(19,"","B","BJPNRPC","","","ERROR"),DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMNZ"
 I $G(^DIC(19,DA(1),10,0))="" S ^DIC(19,DA(1),10,0)="^19.01IP^^"
 S X="BSTSRPC"
 D ^DIC I +Y<1 K DO,DD D FILE^DICN
 ;
 ; UPDATE THE VUECENTRIC REGISTERED OBJECTS FILE
 W !,"Registering the Vucentric Objects..."
 ;
 NEW BI,TEXT
 ;
 F BI=1:1 S TEXT=$P($T(OBJ+BI),";",3,99) Q:($P(TEXT,";")="END")  D
 .W !,$P(TEXT,";")
 . ;
 . NEW DIC,X,Y,OBJUPD,ERROR,WP8,WP9,WP10,OIEN
 . ;
 . ;PROGID (#.01)
 . S DIC="^CIAVOBJ(19930.2,",DIC(0)="LOX",X=$P(TEXT,";")
 . D ^DIC I +Y<0 Q
 . S OIEN=+Y
 . ;
 . ;NAME (#1)
 . S OBJUPD(19930.2,OIEN_",",1)=$P(TEXT,";",2)
 . ;
 . ;VERSION (#2)
 . S OBJUPD(19930.2,OIEN_",",2)=$P(TEXT,";",3)
 . ;
 . ;SOURCE (#3)
 . S OBJUPD(19930.2,OIEN_",",3)=$P(TEXT,";",4)
 . ;
 . ;SERIALIZABLE (#8)
 . S WP8(1)=$P(TEXT,";",5)
 . D WP^DIE(19930.2,OIEN_",",8,"","WP8")
 . ;
 . ;INITIALIZATION (#9)
 . S WP9(1)=$P(TEXT,";",6)
 . D WP^DIE(19930.2,OIEN_",",9,"","WP9")
 . ;
 . ;REQUIRED (#10)
 . S WP10(1)=$P(TEXT,";",7)
 . D WP^DIE(19930.2,OIEN_",",10,"","WP10")
 . ;
 . ;PROPEDIT (#11)
 . S OBJUPD(19930.2,OIEN_",",11)=$P(TEXT,";",8)
 . ;
 . ;MULTIPLE (#12)
 . S OBJUPD(19930.2,OIEN_",",12)=$P(TEXT,";",9)
 . ;
 . ;DISABLED (#13)
 . S OBJUPD(19930.2,OIEN_",",13)=$P(TEXT,";",10)
 . ;
 . ;ALLKEYS (#14)
 . S OBJUPD(19930.2,OIEN_",",14)=$P(TEXT,";",11)
 . ;
 . ;HIDDEN (#15)
 . S OBJUPD(19930.2,OIEN_",",15)=$P(TEXT,";",12)
 . ;
 . ;SIDEBYSIDE (#16)
 . S OBJUPD(19930.2,OIEN_",",16)=$P(TEXT,";",13)
 . ;
 . ;SERVICE (#17)
 . S OBJUPD(19930.2,OIEN_",",17)=$P(TEXT,";",14)
 . ;
 . ;REGRESS (#18)
 . S OBJUPD(19930.2,OIEN_",",18)=$P(TEXT,";",15)
 . ;
 . ;NOREGISTER (#19)
 . S OBJUPD(19930.2,OIEN_",",19)=$P(TEXT,";",16)
 . ;
 . ;DOTNET (#22)
 . S OBJUPD(19930.2,OIEN_",",22)=$P(TEXT,";",17)
 . ;
 . ;ALIAS (#23)
 . S OBJUPD(19930.2,OIEN_",",23)=$P(TEXT,";",18)
 . ;
 . ;TECHNICAL DESCRIPTION (#98)
 . S OBJUPD(19930.2,OIEN_",",98)=$P(TEXT,";",19)
 . ;
 . ;DESCRIPTION (#99)
 . S OBJUPD(19930.2,OIEN_",",99)=$P(TEXT,";",20)
 . ;
 . ;CLSID (#.5)
 . S OBJUPD(19930.2,OIEN_",",.5)=$P(TEXT,";",21)
 . ;
 . ;HEIGHT (#4)
 . S OBJUPD(19930.2,OIEN_",",4)=$P(TEXT,";",22)
 . ;
 . ;WIDTH (#5)
 . S OBJUPD(19930.2,OIEN_",",5)=$P(TEXT,";",23)
 . ;
 . ;Update entry
 .D FILE^DIE("","OBJUPD","ERROR")
 ;
XPST Q
 ;
 ;;File 19930.2 Field listing
 ;;PROGID;NAME;VRSN;SRC;SER;INI;REQ;PROP;MULT;DIS;ALLK;HIDD;SBYS;SERV;REG;NORG;DOTN;ALIA;TDES;DES;CLSID;HEIGHT;WIDTH
 ;;.01;1;2;3;8;9;10;11;12;13;14;15;16;17;18;19;22;23;98;99.5;4;5
OBJ ;;
 ;;FILE:BEHPOVCVG.DLL;BEHPovCvg;1.0.6102.15169;BEHPovCvg.dll;;;;0;1;0;0;1;0;0;0;;0;;;;;;
 ;;IHS.PN.EHR.PRENATALPROBLEMLIST.PIPCOMPONENT;Pregnancy Issues and Problems List;2.0.8.5;IHS.PN.EHR.PrenatalProblemList.dll;;;IHS.PN.EHR.PrenatalProblemList.chm;0;1;0;0;0;0;0;0;;1;;;;{B5416178-ECD8-4515-A700-2980BCAA6CAA};300;640
 ;;FILE:INDIANHEALTHSERVICE.SNOMEDCTSEARCH.DLL;SNOMED CT Search;1.0.7.2;IndianHealthService.SNOMEDCTSearch.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;END;
 ;;
 ;
INSTALLD(BJPNSTAL) ;EP - Determine if patch BJPNSTAL was installed, where
 ;BJPNSTAL is the name of the INSTALL.  E.g "BJPN*2.0*8".
 ;
 NEW DIC,X,Y,D
 S X=$P(BJPNSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(BJPNSTAL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BJPNSTAL,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
