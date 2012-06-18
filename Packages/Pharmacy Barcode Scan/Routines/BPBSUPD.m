BPBSUPD ;IHS/CIA/PLS - Update Drug File from AWP data ;10-Aug-2005 21:57;SM
 ;;1.0;PHARMACY BARCODE SCAN;;August 10, 2005
 ;=================================================================
EN ;PEP - Called by the BPBS AWP SCAN BARCODE option
 N DONE,APSPOP,TXT1,TXT2
 I $$VERSION^XPDUTL("PSS")<1 D  Q
 .W !,"This option requires the Pharmacy Data Management Package!"
 D:'$D(PSOPAR) ^PSOLSET
 D INIT
 F  Q:$$LKUP(0)
 ;
 D FINAL^PSOLSET
 Q
 ;
LKUP(BC) ;EP
 N IEN,DATA,DRUG,DIC
 N X,FDA,PSSZ,PSSFLAG,AIEN,APRMPT,DA
 W !
 S PSSZ=1,PSSFLAG=0
 S IEN=$$GETIENA(50,"",-1,"","","QEALMNTV","",1)
 Q:IEN<1 1
 ;Q:'IEN 1
 I IEN D
 .S AIEN=$$GETNDC() Q:AIEN<0
 .I 'AIEN D
 ..S APRMPT="Would you like to manually update drug information"
 ..S APRMPT(1)="A match cannot be found."
 ..I $$DIRYN(.APRMPT,"Yes") D
 ...D EDITDRG(1,IEN)
 .E  D
 ..; STUFF FIELDS
 ..D DISPLAY(AIEN)
 ..Q:'$$DIRYN("Do you want to update the Drug File","Yes")
 ..D GETDATA(AIEN,.DATA),SETDATA(IEN,.DATA,.FDA)
 ..D STORE(IEN,.FDA)
 ..D EDITDRG(0,IEN)
 .S IEN=0
 Q 0
 ;
DISPLAY(IEN) ;EP
 W !,"You have selected to edit the settings for the following drug:"
 W !,?5,"Name : ",$$GET1^DIQ(9009037,IEN,201)
 W !,?5,"NDC  : ",$$GET1^DIQ(9009037,IEN,.01)   ;,?25,"Pattern: ",$$GET1^DIQ(9009037,IEN,203)
 W !,?5,"Manuf: ",$$GET1^DIQ(9009037,IEN,205)
 ;W !,?7,"AWP Effective Date: ",$$FMTE^XLFDT($$GET1^DIQ(9009037,IEN,.02,"I"),"5Z")
 W !,?5,"Dispense Units per Order: "_$$GET1^DIQ(9009037,IEN,103)
 W !
 Q
 ; Find Drug File entry by NDC
FINDDRG(NDC) ;EP
 N ERR
 Q $$FIND1^DIC(50,,,NDC,"ZNDC",,"ERR")
 ; Get data from AWP File
GETDATA(IEN,DATA) ;EP
 N DRUG,ERR
 S DATA(.01)=$$GET1^DIQ(9009037,IEN,.01)  ;NDC-UPC-HRI
 S DATA(.02)=$$GET1^DIQ(9009037,IEN,.02,"I")  ;EFFECTIVE DATE
 S DATA(.03)=$$GET1^DIQ(9009037,IEN,.03)  ;PER DISP UNIT
 S DATA(.04)=$$GET1^DIQ(9009037,IEN,.04)  ;PER ORDER UNIT
 S DATA(101)=$$GET1^DIQ(9009037,IEN,101)  ;PACKAGE SIZE
 S DATA(102)=$$GET1^DIQ(9009037,IEN,102)  ;PACKAGE QUANTITY
 S DATA(103)=$$GET1^DIQ(9009037,IEN,103)  ;DISP UNITS PER ORDER
 ;S DATA(104)=$$GET1^DIQ(9009037,IEN,104)  ;
 S DATA(201)=$$UP^XLFSTR($$TRIM^XLFSTR($$GET1^DIQ(9009037,IEN,201),"R"))  ;DRUG NAME
 S DATA(205)=$$GET1^DIQ(9009037,IEN,205)  ;MANUFACTURER
 S DATA(206)=$$GET1^DIQ(9009037,IEN,206)  ;GENERIC PRODUCT ID
 S DATA(403)=$$GET1^DIQ(9009037,IEN,403)  ;AAC PER DISPENSE UNIT
 S DATA(404)=$$GET1^DIQ(9009037,IEN,404)  ;AAC PER ORDER UNIT
 Q
 ; Set data into FDA Array
SETDATA(DRUG,DATA,FDA) ;EP
 N FN,SYN,NDC
 S SYN=$$HASSYN(DRUG,DATA(201))
 S FN=50,DRUG=DRUG_","
 S NDC=DATA(.01)
 ;S FDA(FN,DRUG,12)="" ; Order Unit
 ;S FDA(FN,DRUG,3)=""  ; DEA
 ;S FDA(FN,DRUG,14.5)=DATA(101)  ; WILL NOT BE USED
 S FDA(FN,DRUG,31)=$E(NDC,1,5)_"-"_$E(NDC,6,9)_"-"_$E(NDC,10,11)
 ;S FDA(FN,DRUG,15)=DATA(101)*DATA(102)
 S FDA(FN,DRUG,15)=DATA(103)
 S:DATA(.04)'="" FDA(FN,DRUG,9999999.31)=+DATA(.04)
 S:DATA(.03)'="" FDA(FN,DRUG,9999999.32)=+DATA(.03)
 S:DATA(.02) FDA(FN,DRUG,9999999.33)=DATA(.02)
 S:DATA(403)'="" FDA(FN,DRUG,16)=DATA(403)
 S:DATA(404)'="" FDA(FN,DRUG,13)=DATA(404)
 S:'SYN FDA(FN+.1,"?+1,"_DRUG,.01)=DATA(201)  ; Drug Name
 S FDA(FN+.1,$S(SYN:SYN,1:"?+1")_","_DRUG,1)=0    ; Trade Name
 S FDA(FN+.1,$S(SYN:SYN,1:"?+1")_","_DRUG,2)=DATA(.01)    ; NDC-UPC-HRI
 S:DATA(205)'="" FDA(FN+.1,$S(SYN:SYN,1:"?+1")_","_DRUG,405)=DATA(205)
 Q
 ;
 ; Commit updates to File 50.
STORE(DRUG,FDA,NEW) ;EP
 N MSG
 W !,?5,"Applying updates..."
 S NEW=$G(NEW,1)
 I NEW D
 .D UPDATE^DIE(,"FDA",,"MSG")
 E  D
 .D FILE^DIE("K","FDA","MSG")
 I $D(MSG) D
 .W !,"The following error occurred:"
 .W !,$G(MSG("DIERR",1,"TEXT",1))
 E  W !,?5,"Updates are complete..."
 K FDA
 Q
 ; Prompt for entry from file (Calls MIX^DIC1)
 ; APSFILE = File #
 ; APSPMPT = Prompt
 ; APSDFLD = Field whose value is to be used for default value
 ;           Set to -1 for no default value
 ; D = x-ref (C^D)
 ; APSSCRN = DIC("S") SCREEN LOGIC
 ; APSDIC0 = Parameters for DIC(0)
 ; APSLYFLD = List of forced identifier fields (DR) to override the defaulted fields.
GETIEN(APSFILE,APSPMPT,APSDFLD,D,APSSCRN,APSDIC0,APSLYFLD) ;EP
 N DIC,APSD,Y,DA
 S D=$G(D,"B")
 S:'$L(D) D="B"
 S DIC(0)=$G(APSDIC0,"AE")
 S APSDFLD=$G(APSDFLD,.01)
 S APSD=""
 S DIC("S")=$G(APSSCRN)
 S:APSDFLD>0 APSD=$$GET1^DIQ(APSFILE,$$FIND1^DIC(APSFILE,,," ",.D,DIC("S")),APSDFLD)
 S DIC=APSFILE
 S DIC("A")=$G(APSPMPT),DIC("B")=APSD
 I $L(D,U)>1,DIC(0)'["M" S DIC(0)=DIC(0)_"M"
 I DIC(0)["L" S DIC("DR")=$G(APSLYFLD)  ; Set force identifiers to inputted list
 D MIX^DIC1
 Q $S($D(DTOUT)!($D(DUOUT)):-1,+Y>0:+Y,1:0)
 ;
 ; Prompt for entry from file (calls ^DIC)
 ; APSFILE = File #
 ; APSPMPT = Prompt
 ; APSDFLD = Field whose value is to be used for default value
 ;           Set to -1 for no default value
 ; D = x-ref (C^D)
 ; APSSCRN = DIC("S") SCREEN LOGIC
 ; APSDIC0 = Parameters for DIC(0)
 ; APSLYFLD = List of forced identifier fields (DR) to override the defaulted fields.
 ; EVRYREC = If defined, will set DIC("T")
GETIENA(APSFILE,APSPMPT,APSDFLD,D,APSSCRN,APSDIC0,APSLYFLD,EVRYREC) ;EP
 N DIC,APSD,Y,DA,DUOUT,DTOUT
 S DIC(0)=$G(APSDIC0,"AE")
 S APSDFLD=$G(APSDFLD,.01)
 S APSD=""
 S:$L($G(APSSCRN)) DIC("S")=$G(APSSCRN)
 S:APSDFLD>0 APSD=$$GET1^DIQ(APSFILE,$$FIND1^DIC(APSFILE,,," ",.D,DIC("S")),APSDFLD)
 S DIC=APSFILE
 S:$G(EVRYREC) DIC("T")=""
 S DIC("A")=$G(APSPMPT),DIC("B")=APSD
 I DIC(0)["L" S DIC("DR")=$G(APSLYFLD)  ; Set force identifiers to inputted list
 D ^DIC
 Q $S($D(DTOUT)!($D(DUOUT)):-1,+Y>0:+Y,1:0)
 ;
GETNDC() ;EP
 N IEN,UPC,ERR,NDC,DIR,DTOUT,DUOUT,DIRUT,DIROUT,Y
 S DIR("A")="Scan or enter UPC/NDC Value"
 S DIR("A",1)="Format: NDC Value(5-4-2 format, no dashes)"
 S DIR("A",2)="        UPC Value(Full barcode number)"
 S DIR("?")="The value must be between 11 and 14 numbers and not contain a '-'."
 S DIR(0)="FO^11:14^K:X'?11N.N X"
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT)) -1
 S UPC=Y
 Q:UPC="" 0
 I $L(UPC)>11 D  ; A UPC code was scanned.
 .S NDC=$E(UPC,$L(UPC)-10,$L(UPC)-1)
 .I $E(NDC,1) S NDC=$E(NDC,1,5)_"0"_$E(NDC,6,10)
 .E  S NDC="0"_NDC
 E  D  ; A NDC was manually entered
 .S NDC=$E(UPC,1,11)
 S IEN=$$FIND1^DIC(9009037,,,NDC,,,"ERR")
 Q IEN
 ;
FMTNDC(NDC) ;EP
 ;Q:NDC["-" NDC
 I $E(NDC,1) S NDC=$E(NDC,1,5)_"-0"_$E(NDC,6,8)_"-"_$E(NDC,9,10)
 E  S NDC="0"_$E(NDC,1,4)_"-"_$E(NDC,5,8)_"-"_$E(NDC,9,10)
 Q NDC
 ; DIR call for Y/N response
DIRYN(APSPMT,APSDFL,APSHLP,APSPOP) ;EP
 N Y
 S Y=$$DIR("YO",.APSPMT,.APSDFL,.APSHLP,.APSPOP)
 Q Y
 ;
 ; Parameterized DIR call
DIR(APSDTP,APSPMT,APSDFL,APSHLP,APSPOP,APSSCRN) ;EP
 N DIR,DTOUT,DUOUT,Y
 S DIR(0)=APSDTP
 S:$L($G(APSDFL)) DIR("B")=$G(APSDFL)
 I '$G(APSPMT) M DIR("A")=APSPMT
 I '$G(APSHLP) M DIR("?")=APSHLP
 S DIR("S")=$G(APSSCRN,"")
 I $G(APSKDIRB) K DIR("B")
 D ^DIR
 S:$D(DUOUT)!$D(DTOUT) APSPOP=1
 Q Y
 ; Pause for user input
DIRZ(APSPMT) ;EP
 N X
 S X=$$DIR("E",.APSPMT,,,.APSPOP)
 Q
 ; Return AWP Drug Name
GAWPDNM(DRGIEN) ;EP
 Q $$GET1^DIQ(9009037,DRGIEN,201)
 ; Return Synonym IEN
HASSYN(DRGIEN,SYN) ;EP
 N RES,LP
 S RES=0
 I DRGIEN,$L(SYN) D
 .S LP=0 F  S LP=$O(^PSDRUG(DRGIEN,1,LP)) Q:'LP  D  Q:RES
 ..I $P(^PSDRUG(DRGIEN,1,LP,0),U)=SYN S RES=LP
 Q RES
 ; Edit Drug File entry
EDITDRG(MANUAL,DRUG) ;EP
 S MANUAL=$G(MANUAL,1)
 D PSSMAN^BPBSUPD1(MANUAL,DRUG)
 Q
 ; Setup
INIT ;EP
 S TXT1="Unable to locate drug for NDC"
 S TXT2="Please manually enter the NDC number in 5-4-2 format(NO DASHES)."
 S TXT3="Do you wish to manually enter drug information"
 Q
 ;
T1 ;EP
 N PRMPT
 S PRMPT="Would you like to manually update the Drug File"
 S PRMPT(1)="A match cannot be found!"
 W $$DIRYN(.PRMPT,"Yes")
 Q
