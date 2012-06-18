AGED10B ; VNGT/HS/BEE - EDIT PG 10 - ETHNICITY/RACE/LANGUAGE/MIGRANT/HOMELESS/INTERNET/HOUSEHOLD INFO (CONT) ; MAR 19, 2010 
 ;;7.1;PATIENT REGISTRATION;**7,8,9,10**;AUG 25, 2005;Build 7
 ;
LANG ;EP - EDIT PATIENT'S PRIMARY LANGUAGE
 ;
 N LIEN
LANG1 N CHK,DA,DIE,DR,DIROUT,DIRUT,DTOUT,DUOUT,IENS,OPRM,OPRMX,PLANG,PRM,PRMX,Y
 ;
 ;If no current entry selected, add new one
 I $G(LIEN)="" S LIEN=$$NEWLG(AGPATDFN)
 ;
 ;Pull current value
 S DA=LIEN,DA(1)=AGPATDFN,OPRMX=""
 S IENS=$$IENS^DILF(.DA)
 S OPRM=$$GET1^DIQ(9000001.86,IENS,".02","I")
 I OPRM]"" S OPRMX=$$GET1^DIQ(9999999.99,OPRM_",",".01","E")
 ;
 ;Edit the PRIMARY LANGUAGE field
 S DIE="^AUPNPAT("_DA(1)_",86,"
 S DR=".02Add the PRIMARY LANGUAGE spoken at home by the patient"
 D ^DIE
 ;
 ;Check for value
 S PRMX="",PRM=$$GET1^DIQ(9000001.86,IENS,".02","I")
 I PRM]"" S PRMX=$$GET1^DIQ(9999999.99,PRM_",",".01","E")
 ;
 ;Check Other Languages - Proficiency Handling
 S CHK=$$CHKENG(IENS)
 I $P(CHK,U,2)=0 D
 . I (PRMX'="ENGLISH")!((OPRMX'="ENGLISH")&(PRMX="ENGLISH")) D
 .. N PLANG,ERROR
 .. S PLANG("9000001.86",IENS,".06")="@"
 .. D FILE^DIE("","PLANG","ERROR")
 ;
 ;Erase Interpreter - If primary is blank or set to ENGLISH
 I PRMX=""!(PRMX="ENGLISH") D
 . N PLANG,ERROR
 . S PLANG("9000001.86",IENS,".03")="@"
 . D FILE^DIE("","PLANG","ERROR")
 ;
 ;Remove Preferred if no languages
 I PRMX="",$P(CHK,U)=0 D
 . N PLANG,ERROR
 . S PLANG(9000001.86,IENS,".04")="@"
 . D FILE^DIE("","PLANG","ERROR")
 ;
 ;Quit on "^"
 I $D(Y) G XLANG
 ;
 ;Check for value
 I PRM="",OPRM]"" K DA,DIE,DR,DIROUT,DIRUT,DTOUT,DUOUT,IENS,OPRM,PLANG,PRM,PRMX,Y G LANG1
 I PRM="",$$RQPRM^AGEDERR4(DUZ(2)) W "?? Required" K DA,DIE,DR,DIROUT,DIRUT,DTOUT,DUOUT,IENS,OPRM,PLANG,PRM,PRMX,Y G LANG1
 ;
 ;English Handling - If English need proficiency, If not English need Interpreter
 ;
 ;PRIMARY is not ENGLISH
 I PRMX'="ENGLISH" D  I $D(DIROUT)!$D(DTOUT)!$D(DUOUT)!$D(DIRUT) G XLANG
 . ;
 . ;Ask for Interpreter
 . D INTRP(LIEN)
 ;
 ;PRIMARY is ENGLISH
 I PRMX="ENGLISH" D  I $G(DTOUT)=1 G XLANG
 . ;
 . ;Ask for Proficiency
 . S DTOUT=$$PROF(LIEN)
 ;
 ;Other Languages Spoken
 D OLNG(LIEN)
 ;
 ;Check if Proficiency needs to be asked (ENGLISH was entered in Other Language Spoken)
 S CHK=$$CHKENG(IENS)
 I $P(CHK,U,2)=1 S DTOUT=$$PROF(LIEN) I $G(DTOUT)=1 G XLANG
 ;
 ;If Other Spoken Language isn't ENGLISH and Primary isn't ENGLISH, set Proficiency to NOT AT ALL
 I $P(CHK,U,2)=0,PRMX'="ENGLISH" D
 . N PLANG,ERROR
 . S PLANG("9000001.86",IENS,".06")="NA"
 . D FILE^DIE("","PLANG","ERROR")
 ;
 ;More than one language, ask preferred
 I $P(CHK,U)>0 D PREF(LIEN) G XLANG
 ;
 ;Only one language entered - fill PRIMARY into PREFERRED
 S PRM=$$GET1^DIQ(9000001.86,IENS,".02","I")
 S PLANG(9000001.86,IENS,".04")=$S(+PRM>0:+PRM,1:"@")  ;Preferred
 D FILE^DIE("","PLANG","ERROR")
 ;
XLANG Q
 ;
NEWLG(AGPATDFN) ;EP - Create a new Language multiple entry and copy in previous responses
 ;
 N ALANG,DA,DEF,DIC,DLAYGO,IENS,INT,LIEN,OLIEN,PRE,PRM,PRO,X,Y
 ;
 ;Pull Current Info
 S DEF=$$CLANG(AGPATDFN,.OLNG)
 S OLIEN=$P(DEF,U)
 S INT=$P($P(DEF,U,3),":")  ;Interpreter
 S PRE=$P($P(DEF,U,4),":")  ;Preferred Language
 S PRM=$P($P(DEF,U,2),":")  ;Primary Language
 S PRO=$P($P(DEF,U,6),":")  ;English Proficiency
 ;
 ;Define new entry and save current information
 S DIC="^AUPNPAT("_AGPATDFN_",86,",DA(1)=AGPATDFN
 S DIC(0)="L"
 S X=DT
 S DLAYGO="9000001.86",DIC("P")=DLAYGO
 I '$D(^AUPNPAT(AGPATDFN,86,0)) S ^AUPNPAT(AGPATDFN,86,0)="^9000001.86D^^"
 K DO,DD D FILE^DICN
 S (LIEN,DA)=+Y,DA(1)=AGPATDFN
 S IENS=$$IENS^DILF(.DA)
 S ALANG(9000001.86,IENS,".02")=PRM  ;Primary
 S ALANG(9000001.86,IENS,".03")=INT  ;Interpreter
 S ALANG(9000001.86,IENS,".04")=PRE  ;Preferred
 S ALANG(9000001.86,IENS,".06")=PRO  ;English Proficiency
 D FILE^DIE("","ALANG","ERROR")
 I OLIEN]"" M ^AUPNPAT(AGPATDFN,86,DA,5)=^AUPNPAT(AGPATDFN,86,OLIEN,5)  ;Other Spoken
 Q LIEN
 ;
CHKENG(IENS) ;EP - Get Count of Other Languages Spoken and whether English is one of them
 N CNT,OLNG,ENG,IEN,LNG,ERROR
 D GETS^DIQ(9000001.86,IENS,".05*","E","OLNG","ERROR")
 S ENG=0,IEN="" F CNT=0:1 S IEN=$O(OLNG("9000001.8605",IEN)) Q:IEN=""  D
 . S LNG=$G(OLNG("9000001.8605",IEN,".01","E")) Q:LNG=""
 . I LNG="ENGLISH" S ENG=1
 Q CNT_"^"_ENG
 ;
CLANG(AGPATDFN,OLNG) ;EP - Return the patients most recent language entry IEN and other Language Information
 ;
 N IEN,INT,INTX,LDT,LIEN,OIEN,PRE,PREX,PRM,PRMX,VAR,PRO,PROX
 ;
 S (LDT,LIEN,PRM,PRMX,INT,INTX,PRE,PREX,PRO,PROX,VAR)=""
 S LDT=$O(^AUPNPAT(AGPATDFN,86,"B",""),-1)
 I LDT]"" S LIEN=$O(^AUPNPAT(AGPATDFN,86,"B",LDT,""),-1)
 I LIEN]"" D
 . S IEN=LIEN_","_AGPATDFN_","
 . D GETS^DIQ(9000001.86,IEN,"**","IE","VAR")
 . S PRM=$G(VAR(9000001.86,IEN,".02","I"))
 . I PRM]"" S PRMX=$$GET1^DIQ(9999999.99,PRM_",",".01","E")
 . S INT=$G(VAR(9000001.86,IEN,".03","I"))
 . S INTX=$G(VAR(9000001.86,IEN,".03","E"))
 . S PRE=$G(VAR(9000001.86,IEN,".04","I"))
 . I PRE]"" S PREX=$$GET1^DIQ(9999999.99,PRE_",",".01","E")
 . S PRO=$G(VAR(9000001.86,IEN,".06","I"))
 . S PROX=$G(VAR(9000001.86,IEN,".06","E"))
 . S IEN="" F  S IEN=$O(VAR(9000001.8605,IEN)) Q:IEN=""  S OIEN=$G(VAR(9000001.8605,IEN,".01","I")) S:OIEN]"" OLNG(OIEN)=OIEN_":"_$$GET1^DIQ(9999999.99,OIEN_",",".01","E")
 ;
 ;Set up Other Language Spoken display field
 S OLNG=$O(OLNG(""))
 I $O(OLNG(OLNG))]"" S OLNG="MORE THAN ONE LANGUAGE"
 E  I OLNG]"" S OLNG=$P(OLNG(OLNG),":",2)
 ;
 Q LIEN_U_PRM_":"_PRMX_U_INT_":"_INTX_U_PRE_":"_PREX_U_OLNG_U_PRO_":"_PROX
 ;
INTRP(LIEN) ;EP - EDIT Interpreter required prompt
INTRP1 N DA,DIE,DR,IENS,INT,OINT,Y
 ;
 ;Pull current value
 S DA=LIEN,DA(1)=AGPATDFN
 S IENS=$$IENS^DILF(.DA)
 S OINT=$$GET1^DIQ(9000001.86,IENS,".03","I")
 ;
 ;Edit the INTERPRETER REQUIRED field
 S DIE="^AUPNPAT("_DA(1)_",86,"
 S DR=".03  Interpreter Required?: "
 D ^DIE I $D(Y) S DTOUT=1 Q
 ;
 ;Check for value
 S INT=$$GET1^DIQ(9000001.86,IENS,".03","I")
 I INT="",OINT]"" K DA,DIE,DR,IENS,INT,OINT G INTRP1
 I INT="",$$RQPRM^AGEDERR4(DUZ(2)) W "?? Required" K DA,DIE,DR,IENS,INT,OINT G INTRP1
 ;
 Q
 ;
OLNG(LIEN) ;EP - EDIT PATIENT'S OTHER LANGUAGE SPOKEN
 ;
 N DA,DR,DIE,DTOUT,Y
 ;
 S DA=LIEN,DA(1)=AGPATDFN,DA(2)=AGPATDFN
 S DIE="^AUPNPAT("_DA(1)_",86,"
 S DR=".05Other Language Spoken"
 S DR(2,9000001.8605)=".01Other Language Spoken"
 D ^DIE
 ;
 Q
 ;
PREF(LIEN) ;EP - EDIT Preferred Language
PREF1 N CHK,DA,DIE,DR,DIROUT,DIRUT,DTOUT,DUOUT,IENS,OPRE,PLANG,PRE,Y
 ;
 I $G(LIEN)'>0 S LIEN=$$NEWLG(AGPATDFN)
 ;
 ;Pull current value
 S DA=LIEN,DA(1)=AGPATDFN
 S IENS=$$IENS^DILF(.DA)
 S OPRE=$$GET1^DIQ(9000001.86,IENS,".04","I")
 ;
 ;Edit the PRIMARY LANGUAGE field
 S DIE="^AUPNPAT("_DA(1)_",86,"
 S DR=".04Indicate Preferred Language"
 D ^DIE I $D(Y) Q
 ;
 ;Check for value
 S PRE=$$GET1^DIQ(9000001.86,IENS,".04","I")
 I PRE="",OPRE]"" K DA,DIE,DR,DIROUT,DIRUT,DTOUT,DUOUT,IENS,OPRE,PLANG,PRE,Y G PREF1
 I PRE="",$$RQPRF^AGEDERR4(DUZ(2)) W "?? Required" K DA,DIE,DR,DIROUT,DIRUT,DTOUT,DUOUT,IENS,OPRE,PLANG,PRE,Y G PREF1
 ;
 Q
PROF(LIEN) ;EP - EDIT ENGLISH PROFICIENCY prompt
PROF1 N CPRF,DA,DR,DIE,DTOUT,PRF,Y
 ;
 ;Pull current value
 S DA=LIEN,DA(1)=AGPATDFN
 S IENS=$$IENS^DILF(.DA)
 S CPRF=$$GET1^DIQ(9000001.86,IENS,".06","I")
 ;
 ;Edit the ENGLISH PROFICIENCY field
 S DIE="^AUPNPAT("_DA(1)_",86,"
 S DR=".06   How proficient is the patient in speaking ENGLISH?"
 D ^DIE I $D(DTOUT)!$D(Y) Q 1
 ;
 ;Check for value
 S PRF=$$GET1^DIQ(9000001.86,IENS,".06","I")
 I PRF="",CPRF]"" K CPRF,DA,DR,DIE,DTOUT,PRF,Y G PROF1
 I PRF="",$$RQPRM^AGEDERR4(DUZ(2)) K CPRF,DA,DR,DIE,DTOUT,PRF,Y W "??  Required" G PROF1
 ;
 Q 0
 ;
 ;GET ETHNICITY INFORMATION.
ETHNIC ;EP
EDETHNIC ;EP
 ;
 N DEF,DIR,DIROUT,DTOUT,DUOUT,DIRUT,ETHNIC,Y
 ;
 S DIR(0)="POr^10.2:EM"
 S DIR("A")="Ethnicity"
 ;
 ;Pull current value
 S DEF=$O(^DPT(AGPATDFN,.06,0))
 I DEF S DEF=$$GET1^DIQ(2.06,DEF_","_AGPATDFN_",",.01,"E")
 S:DEF]"" DIR("B")=DEF
 ;
 ;Prompt for Ethnicity
 S DIR("S")="I '$P($G(^(.02)),U)"
 D ^DIR
 I $D(DIROUT)!($D(DTOUT))!($D(DUOUT)) K DEF,DIR,DIROUT,DTOUT,DDUOUT,DIRUT,ETHNIC,Y G XETHNIC
 S ETHNIC=$G(Y)
 ;
 K DEF,DIR,DIROUT,DTOUT,DUOUT,DIRUT,Y
 ;
 ;Look for current entry - Re-ask if none and a delete or blank
 N DA,MOC
 S DA=$O(^DPT(AGPATDFN,.06,0)) I DA="",ETHNIC=-1,$$RQETH^AGEDERR4(DUZ(2)) W "??  Required" K DA,MOC,ETHNIC G ETHNIC
 ;
 ;Set up default Method of Collection
 S MOC=$$GET1^DIQ(10.3,"1,",".01","E")
 ;
 ;Delete current entry - Necessary as .01 field IEN gets used as the entry IEN
 I DA]"" D  I ETHNIC=-1 K DA,MOC,ETHNIC G ETHNIC
 . S MOC=$$GET1^DIQ(2.06,DA_","_AGPATDFN_",",".02","E")
 . N AGRACE
 . S DA(1)=AGPATDFN
 . S AGRACE(2.06,DA_","_DA(1)_",",".01")="@"
 . D FILE^DIE("","AGRACE","ERROR")
 ;
 ;Define new entry
 N DIC,X,Y
 S DA(1)=AGPATDFN
 S DIC="^DPT("_DA(1)_",.06,"
 S DIC(0)="L"
 S X=$P(ETHNIC,U,2)
 D ^DIC
 S:+Y>0 DA=+Y
 ;
 ;Make sure Eligibility is defined
 I DA=""!(ETHNIC=-1),$$RQETH^AGEDERR4(DUZ(2)) K DA,MOC,DIC,X,Y,ETHNIC G ETHNIC
 ;
 ;Prompt for Method of Collection
 D MOC(.DA,MOC)
 ;
XETHNIC ;
 Q
 ;
 ;Method of Collection
MOC(DA,DEF) N EXIT
 ;
 S EXIT=0
 F  D  Q:EXIT
 . ;
 . N AGRACE,DIR,DIROUT,DTOUT,DUOUT,DIRUT,MOC,X,Y
 . ;
 . S DIR(0)="POr^10.3:E"
 . S DIR("A")="Method of Collection"
 . ;
 . ;Pull current value
 . S:DEF]"" DIR("B")=DEF
 . ;
 . ;Prompt for Method of Collection
 . D ^DIR
 . I $D(DIROUT)!($D(DTOUT))!($D(DUOUT)) S EXIT=1 Q
 . ;
 . S MOC=$G(Y)
 . ;
 . ;Save current entry
 . S DA(1)=AGPATDFN
 . S AGRACE(2.06,DA_","_DA(1)_",",".02")=$S(MOC="-1":"@",1:$P(MOC,U))
 . D FILE^DIE("","AGRACE","ERROR")
 . ;
 . I MOC="-1",DEF]"" S DEF="" Q
 . I MOC="-1",$$RQETH^AGEDERR4(DUZ(2)) W "??  Required" Q
 . S EXIT=1
 ;
 Q
 ;
RACE ;EP - DISPLAY PATIENT'S RACE
EDRACE ;EP
 N AGRACE,DIE,DIR,DIROUT,DTOUT,DUOUT,DIRUT,DEF,ERROR,Y
 ;I $$RQRACE^AGEDERR4(DUZ(2)) S DIR(0)="Pr^10:M"
 S DIR(0)="POr^10:EM"
 S DIR("A")="Race"
 S DEF=$$GET1^DIQ(2,AGPATDFN_",",".06","E") S:DEF]"" DIR("B")=DEF
 S DIR("S")="I '$P($G(^(.02)),U)"
 D ^DIR
 I $D(DIROUT)!($D(DTOUT))!($D(DUOUT)) Q
 ;
 S AGRACE(2,AGPATDFN_",",".06")=$S(+Y=-1:"@",1:+Y)
 D FILE^DIE("","AGRACE","ERROR")
 ;
 ;Check if Race is required
 I $$GET1^DIQ(2,AGPATDFN_",",".06","I")="",$$RQRACE^AGEDERR4(DUZ(2)) W "??  Required" K AGRACE,DIE,DIR,DIROUT,DTOUT,DUOUT,DIRUT,DEF,ERROR,Y G EDRACE
 Q
NIH ;EP - DISPLAY NUMBER IN HOUSEHOLD
 K DIC,DR,DIE
 W !
 S DIE="^AUPNPAT("
 S DA=DFN
 S DR=.35
 D ^DIE
 K DIC,DR,DIE
 Q
THI ;EP - DISPLAY TOTAL HOUSEHOLD INCOME
 K DIC,DR,DIE,THI
 W !
 S DIE="^AUPNPAT("
 S DA=DFN
 S DR=".36Total Household Income"
 D ^DIE
 ;
 ;Check Income - If > 0 Ask Period, Otherwise remove Period
 S THI=$$GET1^DIQ(9000001,DFN_",",".36","E")
 I +THI'>0 D  Q
 . N ATHI
 . S ATHI(9000001,DFN_",","8701")=""
 . D FILE^DIE("","ATHI","ERROR")
 ;
 ;
THIP ;EP - EDIT/DISPLAY HOUSEHOLD INCOME PERIOD
 ;
 N CTHIP,DA,DR,DIE,DTOUT,THIP,Y
 ;
 ;Retrieve current value
 S CTHIP=$$GET1^DIQ(9000001,DFN_",",8701,"E")
 ;
 S DIE="^AUPNPAT("
 S DA=DFN
 S DR="8701Household Income Period"
 D ^DIE
 I $D(DTOUT)!$D(Y) Q
 ;
 S THIP=$$GET1^DIQ(9000001,DFN_",",8701,"E")
 I THIP="",CTHIP]"" K CTHIP,DA,DR,DIE,DTOUT,THIP,Y G THIP
 I THIP="" K CTHIP,DA,DR,DIE,DTOUT,THIP,Y W "??  Required" G THIP
 ;
 Q
