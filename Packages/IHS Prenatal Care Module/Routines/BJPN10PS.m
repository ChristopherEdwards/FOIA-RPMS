BJPN10PS ;GDIT/HS/BEE-Prenatal Care Module 1.0 Post Install ; 08 May 2012  12:00 PM
 ;;1.0;PRENATAL CARE MODULE;;Dec 06, 2012;Build 61
 ;
 Q
 ;
PST ;
 ;
 NEW BI,TEXT,PIEN,DIC,X,Y,DIK,IEN
 ;
 ;Resolve file 80 descrepancies between sites
 S IEN=0 F  S IEN=$O(^BJPN(90680.02,IEN)) Q:'IEN  D
 . NEW MPIEN
 . S MPIEN=0 F  S MPIEN=$O(^BJPN(90680.02,IEN,1,MPIEN)) Q:'MPIEN  D
 .. NEW DA,IENS,XCD,BUPD,DIC,X,Y
 .. S DA(1)=IEN,DA=MPIEN,IENS=$$IENS^DILF(.DA)
 .. S XCD=$$GET1^DIQ(90680.21,IENS,.03,"E")
 .. Q:XCD=""
 .. ;
 .. ;ICD Code
 .. ;
 .. ;First look for passed in value
 .. S X=XCD,DIC="^ICD9(",DIC(0)="XM"
 .. D ^DIC
 .. ;
 .. ;If no match, look for + of value
 .. I +Y="-1" D
 ... S X=+XCD,DIC="^ICD9(",DIC(0)="XM"
 ... D ^DIC
 .. ;
 .. ;If no match look in "BA" index - Exact match
 .. I +Y="-1" D
 ... NEW IEN
 ... S IEN="" F  S IEN=$O(^ICD9("BA",XCD,IEN)) Q:'IEN  D  I Y>0 Q
 ... I $$GET1^DIQ(80,IEN_",",".01","I")'=XCD S Y="-1" Q
 ... S Y=IEN
 .. ;
 .. ;If no match look in "BA" index - + subscript, exact match
 .. I +Y="-1" D
 ... NEW IEN,CD
 ... S IEN="" F  S IEN=$O(^ICD9("BA",+XCD,IEN)) Q:'IEN  D  I Y>0 Q
 .... S CD=$$GET1^DIQ(80,IEN_",",".01","I")
 .... I CD=XCD S Y=IEN
 .... I $E(XCD,$L(XCD))=".",XCD=(CD_".") S Y=IEN Q
 .... I $E(CD,$L(CD))=".",CD=(XCD_".") S Y=IEN Q
 .. ;
 .. ;If no match look in "BA" index - + subscript, + match
 .. I +Y="-1" D
 ... NEW IEN,CD
 ... S IEN="" F  S IEN=$O(^ICD9("BA",+XCD,IEN)) Q:'IEN  D  I Y>0 Q
 .... S CD=$$GET1^DIQ(80,IEN_",",".01","I")
 .... I CD=+XCD S Y=IEN
 .... I $E(XCD,$L(XCD))=".",XCD=(CD_".") S Y=IEN Q
 .... I $E(CD,$L(CD))=".",CD=(XCD_".") S Y=IEN Q
 .. ;
 .. ;If no match look in "BA" index - subscript and " ", exact match
 .. I +Y="-1" D
 ... NEW IEN
 ... S IEN="" F  S IEN=$O(^ICD9("BA",XCD_" ",IEN)) Q:'IEN  D  I Y>0 Q
 .... S CD=$$GET1^DIQ(80,IEN_",",".01","I")
 .... I CD=XCD S Y=IEN
 .... I $E(XCD,$L(XCD))=".",XCD=(CD_".") S Y=IEN Q
 .... I $E(CD,$L(CD))=".",CD=(XCD_".") S Y=IEN Q
 .. ;
 .. ;If no match look in "BA" index -  + subscript and " ", exact match
 .. I +Y="-1" D
 ... NEW IEN
 ... S IEN="" F  S IEN=$O(^ICD9("BA",XCD_" ",IEN)) Q:'IEN  D  I Y>0 Q
 .... S CD=$$GET1^DIQ(80,IEN_",",".01","I")
 .... I CD=XCD S Y=IEN
 .... I $E(XCD,$L(XCD))=".",XCD=(CD_".") S Y=IEN Q
 .... I $E(CD,$L(CD))=".",CD=(XCD_".") S Y=IEN Q
 .. ;
 .. ;If no match look in "BA" index -  + subscript and " ", any match
 .. I +Y="-1" D
 ... NEW IEN
 ... S IEN="" F  S IEN=$O(^ICD9("BA",+XCD_" ",IEN)) Q:'IEN  D  I Y>0 Q
 .... S CD=$$GET1^DIQ(80,IEN_",",".01","I")
 .... I CD=+XCD S Y=IEN
 .... I $E(XCD,$L(XCD))=".",XCD=(CD_".") S Y=IEN Q
 .... I $E(CD,$L(CD))=".",CD=(XCD_".") S Y=IEN Q
 .. I +Y="-1" Q
 .. ;
 .. ;Hard set entry
 .. S $P(^BJPN(90680.02,IEN,1,MPIEN,0),U)=+Y
 . ;
 . ;Re-index that SNOMED Code ICD entry
 . K DA S DA(1)=IEN
 . K ^BJPN(90680.02,IEN,1,"B")
 . S DIK="^BJPN(90680.02,"_DA(1)_",1,",DIK(1)=".01" D ENALL^DIK
 ;
 ;Perform conversion (if reload)
 D CONV
 ;
 ;Re-index entries (in case of re-install)
 K ^AUPNVOB("AA"),^AUPNVOB("AC"),^AUPNVOB("AE"),^AUPNVOB("AF")
 S DIK="^AUPNVOB(",DIK(1)=".02" D ENALL^DIK
 ;
 ; UPDATE THE VUECENTRIC REGISTERED OBJECTS FILE
 W !,"Registering the Vucentric Objects..."
 F BI=1:1 S TEXT=$P($T(OBJ+BI),";",3,99) Q:($P(TEXT,";")="END")  D
 .W !,$P(TEXT,";")
 . ;
 . NEW DIC,X,Y,OBJUPD,ERROR,WP8,WP9,WP10
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
 ;Locate PIP entry
 S DIC(0)="MU",X="IHS.PN.EHR.PRENATALPROBLEMLIST",DIC="^CIAVOBJ(19930.2,"
 D ^DIC I +Y<0 G XPST
 S PIEN=+Y
 ;
 ;Enter USER values for Problem List Entry
 F BI=1:1 S TEXT=$P($T(PPUSE+BI),";",3,99) Q:($P(TEXT,";")="END")  D
 . ;
 . NEW DIC,X,Y,DA,OIEN
 . ;
 . ;Locate IEN for this entry
 . S DIC="^CIAVOBJ(19930.2,",X=$P(TEXT,";"),DIC(0)="OX"
 . D ^DIC I +Y<0 W !!,"<MISSING VUECENTRIC OBJECT: ",X,">" Q
 . S OIEN=+Y
 . ;
 . S DA(1)=PIEN,DIC="^CIAVOBJ(19930.2,"_DA(1)_",9,",DIC(0)="LOX",X=$P(TEXT,";")
 . D ^DIC
 ;
 ;Locate Pick List entry
 S DIC(0)="MU",X="IHS.PN.EHR.PRENATALPICKLIST",DIC="^CIAVOBJ(19930.2,"
 D ^DIC I +Y<0 G XPST
 S PIEN=+Y
 ;
 ;Enter USER values for Pick List Entry
 F BI=1:1 S TEXT=$P($T(PKUSE+BI),";",3,99) Q:($P(TEXT,";")="END")  D
 . ;
 . NEW DIC,X,Y,DA,OIEN
 . ;
 . ;Locate IEN for this entry
 . S DIC="^CIAVOBJ(19930.2,",X=$P(TEXT,";"),DIC(0)="OX"
 . D ^DIC I +Y<0 W !!,"<MISSING VUECENTRIC OBJECT: ",X,">" Q
 . S OIEN=+Y
 . ;
 . S DA(1)=PIEN,DIC="^CIAVOBJ(19930.2,"_DA(1)_",9,",DIC(0)="LOX",X=$P(TEXT,";")
 . D ^DIC
 ;
XPST Q
 ;
CONV ;Convert existing PIP/VOB entries to use new BJPN SNOMED TERMS entries
 ;
 ;Only convert if backup from pre-install is present
 Q:'$D(^XTMP("BJPNSMD"))
 ;
 NEW PIPIEN
 ;
 S PIPIEN=0 F  S PIPIEN=$O(^BJPNPL(PIPIEN)) Q:'PIPIEN  D
 . ;
 . NEW OIEN,OSMD,BJPNUP,ERROR,NIEN,DFN,IEN,FND
 . ;
 . S OIEN=$$GET1^DIQ(90680.01,PIPIEN_",",.03,"I") Q:OIEN=""
 . S OSMD=$P($G(^XTMP("BJPNSMD",90680.02,OIEN,0)),U,2) Q:OSMD=""
 . S DFN=$$GET1^DIQ(90680.01,PIPIEN_",",.02,"I") Q:DFN=""
 . ;
 . ;Now look for match in new file
 . S NIEN=$$FIND(OSMD)
 . ;
 . ;Look for deleted SNOMED terms - Remove if not in new set
 . I NIEN="" D DEL(DFN,PIPIEN,"E") Q
 . ;
 . ;Found entry - file in existing structure
 . S BJPNUP(90680.01,PIPIEN_",",.01)=NIEN
 . S BJPNUP(90680.01,PIPIEN_",",.03)=NIEN
 . D FILE^DIE("","BJPNUP","ERROR")
 . ;
 . ;Check for duplicates - old list had duplicates
 . S FND=0,IEN="" F  S IEN=$O(^BJPNPL("AC",DFN,NIEN,IEN)) Q:IEN=""  D
 .. ;
 .. ;Skip Deletes
 .. Q:($$GET1^DIQ(90680.01,IEN_",","2.01","I")]"")
 .. S FND=FND+1
 .. S FND(IEN)=""
 . ;
 . ;Delete any duplicates
 . I FND>1 D
 .. NEW IEN
 .. S IEN=$O(FND(""),-1) Q:IEN=""
 .. F  S IEN=$O(FND(IEN),-1) Q:IEN=""  D DEL(DFN,IEN,"D")
 ;
 ;Clear out backup entries
 K ^XTMP("BJPNSMD")
 Q
 ;
FIND(TERM) ;Find term in new file
 I $G(TERM)="" Q ""
 ;
 NEW SHTERM,IEN,FOUND
 ;
 S SHTERM=$E(TERM,1,30),FOUND=""
 S IEN="" F  S IEN=$O(^BJPN(90680.02,"C",SHTERM,IEN)) Q:IEN=""  D  Q:FOUND
 . I TERM'=$$GET1^DIQ(90680.02,IEN_",",.02,"I") Q
 . S FOUND=IEN
 ;
 Q FOUND
 ;
DEL(DFN,PIPIEN,DCODE) ;Delete entries that have been removed
 ;
 ;If code has been removed delete altogether
 I DCODE="E" D
 . NEW DA,DIK,TM,IEN
 . ;
 . ;Remove Prenatal Problem entry 
 . S DA=PIPIEN,DIK="^BJPNPL(" D ^DIK
 . ;
 . ;Remove V file entries
 . S TM="" F  S TM=$O(^AUPNVOB("AE",DFN,PIPIEN,TM)) Q:TM=""  D
 .. S IEN="" F  S IEN=$O(^AUPNVOB("AE",DFN,PIPIEN,TM,IEN)) Q:IEN=""  D
 ... S DA=IEN,DIK="^AUPNVOB(" D ^DIK
 ;
 ;If code is a duplicate, mark as deleted (duplicate)
 I DCODE="D" D
 . NEW VIEN,TM,IEN
 . ;
 . ;Find last VIEN used
 . S (VIEN,TM)="" F  S TM=$O(^AUPNVOB("AE",DFN,PIPIEN,TM),-1) Q:TM=""  D  Q:VIEN
 .. S IEN="" F  S IEN=$O(^AUPNVOB("AE",DFN,PIPIEN,TM,IEN),-1) Q:IEN=""  D  Q:VIEN
 ... S VIEN=$$GET1^DIQ(9000010.43,IEN_",",.03,"I")
 . ;
 . ;Mark entry as deleted
 . I VIEN D DEL^BJPNPRUT("",VIEN,PIPIEN,DCODE,"")
 ;
 Q
 ;
 ;;File 19930.2 Field listing
 ;;PROGID;VRSN;SRC;SER;INI;REQ;PROP;MULT;DIS;ALLK;HIDD;SBYS;SERV;REG;NORG;DOTN;ALIA;TDES;DES;CLSID;HEIGHT;WIDTH
 ;;.01;1;2;3;8;9;10;11;12;13;14;15;16;17;18;19;22;23;98;99.5;4;5
OBJ ;;
 ;;FILE:INFRAGISTICS2.EXCEL.V10.3.DLL;Excel.v10.3;10.3.20103.1000;Infragistics2.Excel.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:INFRAGISTICS2.SHARED.V10.3.DLL;Shared.v10.3;10.3.20103.1000;Infragistics2.Shared.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:INFRAGISTICS2.WIN.MISC.V10.3.DLL;Misc.v10.3;10.3.20103.1000;Infragistics2.Win.Misc.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINGRID.EXCELEXPORT.V10.3.DLL;ExcelExport.v10.3;10.3.20103.1000;Infragistics2.Win.UltraWinGrid.ExcelExport.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINGRID.V10.3.DLL;UltraWinGrid.v10.3;10.3.20103.1000;Infragistics2.Win.UltraWinGrid.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINPRINTPREVIEWDIALOG.V10.3.DLL;UltraWinPrintPreviewDialog.v10.3;10.3.20103.1000;Infragistics2.Win.UltraWinPrintPreviewDialog.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINSTATUSBAR.V10.3.DLL;UltraWinStatusBar.v10.3;10.3.20103.1000;Infragistics2.Win.UltraWinStatusBar.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINTOOLBARS.V10.3.DLL;UltraWinToolbars.v10.3;10.3.20103.1000;Infragistics2.Win.UltraWinToolbars.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:INFRAGISTICS2.WIN.V10.3.DLL;Win.v10.3;10.3.20103.1000;Infragistics2.Win.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINLISTBAR.V10.3.DLL;UltraWinListBar.v10.3;10.3.20103.1000;Infragistics2.Win.UltraWinListBar.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINLISTVIEW.V10.3.DLL;UltraWinListView.v10.3;10.3.20103.1000;Infragistics2.Win.UltraWinListView.v10.3.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;FILE:RICHTEXTBOXPRINTCONTROL.DLL;Rich Text Box Print Control;1.0.0.0;RichTextBoxPrintControl.dll;;;;0;0;0;0;1;0;0;0;;0;;;;;;
 ;;IHS.PN.EHR.PRENATALPICKLIST.PRENATALPICKLISTCOMPONENT;Prenatal Pick List;1.0.0.13;IHS.PN.EHR.PrenatalPickList.dll;;;IHS.PN.EHR.PrenatalPickList.chm;0;1;0;0;0;0;0;0;;1;;;;{0A2C8481-DB1A-4D80-A8E0-CEBF70E6F705};300;600
 ;;IHS.PN.EHR.PRENATALPROBLEMLIST.PIPCOMPONENT;Pregnancy Issues and Problems List;1.0.0.13;IHS.PN.EHR.PrenatalProblemList.dll;;;IHS.PN.EHR.PrenatalProblemList.chm;0;1;0;0;0;0;0;0;;1;;;;{B5416178-ECD8-4515-A700-2980BCAA6CAA};300;640
 ;;END;
 ;;
PPUSE ;;
 ;;FILE:INFRAGISTICS2.EXCEL.V10.3.DLL
 ;;FILE:INFRAGISTICS2.SHARED.V10.3.DLL
 ;;FILE:INFRAGISTICS2.WIN.MISC.V10.3.DLL
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINGRID.EXCELEXPORT.V10.3.DLL
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINGRID.V10.3.DLL
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINPRINTPREVIEWDIALOG.V10.3.DLL
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINSTATUSBAR.V10.3.DLL
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINTOOLBARS.V10.3.DLL
 ;;FILE:INFRAGISTICS2.WIN.V10.3.DLL
 ;;FILE:RICHTEXTBOXPRINTCONTROL.DLL
 ;;END;
 ;;
PKUSE ;;
 ;;FILE:INFRAGISTICS2.SHARED.V10.3.DLL
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINLISTBAR.V10.3.DLL
 ;;FILE:INFRAGISTICS2.WIN.ULTRAWINLISTVIEW.V10.3.DLL
 ;;FILE:INFRAGISTICS2.WIN.V10.3.DLL
 ;;END;
 ;;
