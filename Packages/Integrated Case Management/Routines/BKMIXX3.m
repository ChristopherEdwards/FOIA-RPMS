BKMIXX3 ;PRXM/HC/CJS - BKMI UTILITY PROGRAM; [ 1/19/2005  7:16 PM ] ; 21 Jul 2005  12:00 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;Miscellaneous BKM utilities
 ; Daou Incorporated v 1.0
 ; 4/12/05 - WOM
 Q
I(BKMVAR,BKMINC) ;EP - Returns BKMVAR+BKMINC while updating BKMVAR
 ; Programmers note: This function is meant to mimic the $I
 ;    function of CACHE 5. In order to fully mimic that function,
 ;    the first argument must be passed by reference.
 ;    No compatibility with the $I function is guaranteed unless
 ;    this the first argument is called by reference. In fact, null values
 ;    for the first argument are allowed if not passed by reference,
 ;    unlike $I.
 N BKMJUNK
 S BKMJUNK=$D(BKMINC)
 I $E(BKMJUNK,$L(BKMJUNK))'=1 S BKMINC=1
 I $G(BKMVAR)="" S BKMVAR=0
 S BKMVAR=BKMVAR+BKMINC
 Q BKMVAR
 ;
BASETMP(DFN) ; EP - Create ^TMP("BKMLKP",$J) entries
 ; Extrinsic function - Returns 1 (success = global created) or
 ;                              0 (failure = nothing created)
 ; Input:
 ;  DFN - IEN for File 2 (Patient)
 ; Output:
 ;  BKMIEN - IEN for File 90451 (HMS Registry)
 ;  ^TMP("BKMLKP",$J)=DFN
 ;  ^TMP("BKMLKP",$J,DFN)=PatientName^HRN^DOB(internal)^Sex(internal)^Age(calculated)^MaritalStatus(internal)^IEN(File 90451)
 ; Initialize
 N DA,PNT,HRN,DOB,SEX,AGE,MSTAT
 I '$D(DFN) Q 0
 I DFN="" Q 0
 ; Get IEN from File 90451 based on DFN
 S (DA,BKMIEN)=$O(^BKM(90451,"B",DFN,0))
 S PNT=$$GET1^DIQ(2,DFN,.01,"I")   ; Patient Name
 S HRN=$$HRN^BKMVA1(DFN)           ; HRN
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")   ; DOB
 S SEX=$$GET1^DIQ(2,DFN,.02,"I")   ; Sex
 S AGE=$$AGE^BKMIMRP1(DFN)         ; Age
 S MSTAT=$$GET1^DIQ(2,DFN,.05,"I") ; Marital Status
 K ^TMP("BKMLKP",$J)
 S ^TMP("BKMLKP",$J,DFN)=PNT_U_HRN_U_DOB_U_SEX_U_AGE_U_MSTAT_U_DA
 S ^TMP("BKMLKP",$J)=DFN
 Q 1
 ;
NOGO ;EP - NOT ALLOWED TO CHANGED OR ENTER DATA
 ;PRXM/HC/CJS 07/21/2005 -- Updated prompt
 ;W !!,*7,"Sorry, you are not authorized to enter/edit data at this point.",! H 2
 W !!,*7,"Sorry, you are not currently authorized to modify patient data.",!,"Please see your Security Administrator for access.",! H 4
 Q
 ;
PAUSE(PROMPT) ;EP - For screen displays pause and allow user to stop
 ; Returns a 1 if the user elected to stop
 I IOST'["C-" Q 0
 N DIR,DTOUT,DUOUT
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 S DIR(0)="E" D ^DIR
 Q $D(DTOUT)!$D(DUOUT)
 ;
HIVIEN() ; EP - Return IEN of HIV from File 90450
 ; Extrinsic function - returns IEN (File 90450 for HIV) or
 ;                              ""  (File 90450 for HIV not found)
 ; Input:  n/a
 ; Output: n/a
 ; Initialize
 N BKMHIV,DA
 S BKMHIV=$O(^BKM(90450,"B","HMS REGISTER",""))
 S DA=BKMHIV
 Q BKMHIV
 ;
VALID(BKMDUZ) ; EP - Determine if user is permitted in the HMS registry
 ; Extrinsic function - returns 1 (success - user in HMS registry) or
 ;                              0 (failure - user not in HMS registry)
 ; Input:
 ;  BKMDUZ - DUZ, IEN for File 200
 ; Output: n/a
 ; Initialize
 N BKMVLD,BKMHIV
 S BKMVLD=0
 S BKMHIV=$$HIVIEN^BKMIXX3()
 ; Determine if user's DUZ is in the HIV registry x-ref
 I BKMHIV'="",$G(BKMDUZ)'="",$D(^BKM(90450,BKMHIV,11,"B",$G(BKMDUZ))) S BKMVLD=1
 Q BKMVLD
 ;
BKMIEN(BKMDFN) ; EP - Determine IEN for Patient in File 90451 based on DFN
 ; Extrinsic function - returns IEN (File 90451 IEN for DFN) or
 ;                              ""  (No File 90451 entry for DFN)
 ; Input:
 ;  BKMDFN - IEN for Patient File 2
 ; Output: n/a
 ; Initialize
 N BKMIEN
 S BKMIEN=$S($G(BKMDFN)'="":$O(^BKM(90451,"B",$G(BKMDFN),"")),1:"")
 Q BKMIEN
 ;
BKMREG(BKMIEN) ; EP - Determine IEN for HIV registry in File 90451.01 based on File 90451 IEN
 ; Extrinsic function - returns IEN (File 90451.01 IEN for HIV) or
 ;                              ""  (No File 90451.01 entry for HIV)
 ; Input:
 ;  BKMIEN - IEN for File 90451
 ; Output: n/a
 ; Initialize
 N BKMHIV,BKMREG
 S BKMREG=""
 S BKMHIV=$$HIVIEN^BKMIXX3()
 I BKMHIV'="",$G(BKMIEN)'="" S BKMREG=$O(^BKM(90451,$G(BKMIEN),1,"B",BKMHIV,""))
 Q BKMREG
 ;
BKMPRIV(BKMDUZ) ; EP - Determine user's rights in HMS
 ; Extrinsic function - returns 1 (ability to add/edit) or
 ;                              0 (not permitted to add/edit)
 ; Input:
 ;  BKMDUZ - DUZ, IEN for File 200
 ; Output: n/a
 ; Initialize
 N BKMHIV,BKMPRV,BKMPRIV
 S BKMPRIV=""
 S BKMHIV=$$HIVIEN^BKMIXX3()
 I BKMHIV'="",$G(BKMDUZ)'="" D
 . S BKMPRV=$O(^BKM(90450,BKMHIV,11,"B",$G(BKMDUZ),0))
 . I BKMPRV'="" S BKMPRIV=$P(^BKM(90450,BKMHIV,11,BKMPRV,0),"^",2)
 S BKMPRIV=$S(BKMPRIV="":0,BKMPRIV="R":0,1:1)
 Q BKMPRIV
 ;
HDR ; EP - Display header for menus
 N PKG,VERSION,DA,IENS,SITE,USER
 S PKG=$$FIND1^DIC(9.4,,"X","BKM","C")
 S VERSION=$$GET1^DIQ(9.4,PKG,13,"I"),VERSION="HMS Version "_VERSION
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 S USER="Current User: "_$$GET1^DIQ(200,$G(DUZ),.01,"I")
 W @IOF,!!?IOM-$L(VERSION)\2,VERSION
 W !?IOM-$L(SITE)\2,SITE
 W !?IOM-$L(USER)\2,USER
 Q
 ;
DIAG(DEF,RECVAL,MIX) ;EP - HMS Diagnosis Category
 ; Prompt user for HMS Diagnosis Category
 ; A tiered approach was requested by IHS.
 ; At risk -> Exposed Source Known -> Specific Source
 ; User may enter final value and bypass prompts
 ; e.g. EI may be entered at the HMS DIAGNOSIS CATEGORY prompt
 ; DEF = the current HMS Diagnosis Category in 90451
 ; RECVAL = recommended value
 ; MIX = mixed case flag (used by input template BKMV PATIENT RECORD
 ; 
 N DIR,Y
 S DEF=$G(DEF),MIX=$G(MIX)
DI1 S DIR(0)="F"
 K DIR("A")
 S DIR("A")=$S(MIX:"  HMS Diagnosis Category",1:"HMS DIAGNOSIS CATEGORY")
 S DIR("A",1)=" "
 S DIR("A",2)="     Select one of the following:"
 S DIR("A",3)=" "
 S DIR("A",4)="          R         AT RISK"
 S DIR("A",5)="          H         HIV"
 S DIR("A",6)="          A         AIDS"
 S DIR("A",7)=" "
 K DIR("B")
 I DEF]"" D
 . I DEF="A"!(DEF="H") S DIR("B")=$S(DEF="A":"AIDS",1:"HIV") Q
 . S DIR("B")="AT RISK"
 . ;I DEF="A"!(DEF="H") S DIR("B")=DEF Q
 . ;S DIR("B")="R"
 ;If there is no Diagnosis Category on file and there is a recommended value display it
 I DEF="",RECVAL]"" S DIR("A",9)="  Recommended Diagnosis Value = <"_$S(RECVAL="A":"AIDS",1:"HIV")_">"
 S DIR("?")="Enter a code from the list."
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q -1
 ; Convert response from lower to upper case
 S Y=$$UP^XLFSTR(Y)
 ; If 1st character of response is an 'A' distinguish between AIDS, AT RISK and Invalid entry
 I $E(Y)="A",$E("AIDS",1,$L(Y))'=Y S Y=$S($E("AT RISK-",1,$L(Y))=Y:"R",1:"Invalid")
 S Y=$E(Y)
 I '$F("^R^H^A^",U_Y_U) W !!?2,"Enter a code from the list.",!! G DI1
 W " ",$S(Y="R":"AT RISK",Y="H":"HIV",1:"AIDS")
 I Y'="R" Q $$DICONV(Y)
DI2 ; At-Risk Level
 ; PRX/HMS/DLS 3/30/2006 Changed DIR(0) from 'F'ree text to 'S'et of Codes.
 S DIR(0)="Fr"
 K DIR("A")
 S DIR("A")=$S(MIX:"  At Risk Diagnosis Category",1:"AT RISK DIAGNOSIS CATEGORY")
 S DIR("A",1)=" "
 S DIR("A",2)="     Select one of the following:"
 S DIR("A",3)=" "
 S DIR("A",4)="          KN         AT RISK- KNOWN SOURCE"
 S DIR("A",5)="          UNK        AT RISK- UNKNOWN SOURCE"
 S DIR("A",6)=" "
 K DIR("B")
 I DEF]"" D
 . I DEF="A"!(DEF="H") Q
 . I DEF="EU" S DIR("B")="AT RISK- UNKNOWN SOURCE" Q
 . S DIR("B")="AT RISK- KNOWN SOURCE"
 . ;I DEF="EU" S DIR("B")="UNK" Q
 . ;S DIR("B")="KN"
 S DIR("?")="Enter a code from the list."
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q -1
 S Y=$$UP^XLFSTR(Y)
 I $L(Y)>9,$E("AT RISK- KNOWN SOURCE",1,$L(Y))=Y S Y="KN"
 I $L(Y)>9,$E("AT RISK- UNKNOWN SOURCE",1,$L(Y))=Y S Y="UNK"
 S Y=$S((Y="K")!(Y="KN"):"KN",(Y="U")!(Y="UN")!(Y="UNK"):"UNK",1:"")
 I '$F("^KN^UNK^",U_Y_U) W !!?2,"Enter a code from the list.",!! G DI2
 W " ",$S(Y="KN":"AT RISK- KNOWN SOURCE",1:"AT RISK- UNKNOWN SOURCE")
 I Y="UNK" Q "EU"
DI3 ; At Risk - Known Level
 S DIR(0)="Fr"
 K DIR("A")
 S DIR("A")=$S(MIX:"  At Risk- Known Source Diagnosis Category",1:"AT RISK- KNOWN SOURCE DIAGNOSIS CATEGORY")
 S DIR("A",1)=" "
 S DIR("A",2)="     Select one of the following:"
 S DIR("A",3)=" "
 S DIR("A",4)="          IN         AT RISK- INFANT EXPOSED"
 S DIR("A",5)="          OCC        AT RISK- OCCUPATIONAL EXPOSURE"
 S DIR("A",6)="          NON        AT RISK- NON OCCUPATIONAL EXPOSURE"
 S DIR("A",7)=" "
 K DIR("B")
 I DEF]"" D
 . I DEF="A"!(DEF="H")!(DEF="EU") Q
 . S DIR("B")=$S(DEF="EI":"AT RISK- INFANT EXPOSED",DEF="EO":"AT RISK- OCCUPATIONAL EXPOSURE",DEF="EN":"AT RISK- NON OCCUPATIONAL EXPOSURE",1:"")
 S DIR("?")="Enter a code from the list to identify the type of exposure."
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q -1
 S Y=$$UP^XLFSTR(Y)
 I $L(Y)>9,$E("AT RISK- INFANT EXPOSED",1,$L(Y))=Y S Y="IN"
 I $L(Y)>9,$E("AT RISK- OCCUPATIONAL EXPOSURE",1,$L(Y))=Y S Y="OCC"
 I $L(Y)>9,$E("AT RISK- NON OCCUPATIONAL EXPOSURE",1,$L(Y))=Y S Y="NON"
 S Y=$S((Y="I")!(Y="IN"):"IN",(Y="O")!(Y="OC")!(Y="OCC"):"OCC",(Y="N")!(Y="NO")!(Y="NON"):"NON",1:"")
 I '$F("^IN^OCC^NON^",U_Y_U) W !!?2,"Enter a code from the list.",!! G DI3
 W " ",$S(Y="IN":"AT RISK- INFANT EXPOSED",Y="OCC":"AT RISK- OCCUPATIONAL EXPOSURE",1:"AT RISK- NON OCCUPATIONAL EXPOSURE")
 Q $$DICONV(Y)
 ;
DICONV(VAL) ;Convert external to internal value of HMS Diagnosis Category
 Q $S(Y="NON":"EN",Y="OCC":"EO",Y="IN":"EI",Y="UNK":"EU",Y="KN":"EK",1:Y)
