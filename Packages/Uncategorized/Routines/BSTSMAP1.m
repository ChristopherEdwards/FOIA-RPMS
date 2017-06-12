BSTSMAP1 ;GDIT/HS/BEE-Standard Terminology API Program - Mapping Logic ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**6,7,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
SAVEMAP(CONCDA,BSTSC,GL) ;Save ICD10 Condition Map Rules
 ;
 ;Called by UPDATE^BSTSDTS0
 ;
 Q:CONCDA=""
 Q:GL=""
 ;
 ;Clear out existing entries
 D
 . NEW MP
 . S MP=0 F  S MP=$O(^BSTS(9002318.4,CONCDA,14,MP)) Q:'MP  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=MP
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",14," D ^DIK
 ;
 ;Now save mappings
 I $D(@GL@("A10C"))>1 D
 . ;
 . NEW MG,MP,MC
 . S MG="" F  S MG=$O(@GL@("A10C",MG)) Q:MG=""  S MP="" F  S MP=$O(@GL@("A10C",MG,MP)) Q:MP=""  S MC="" F  S MC=$O(@GL@("A10C",MG,MP,MC)) Q:MC=""  D
 .. ;
 .. NEW DIC,X,Y,DA,IENS,DLAYGO,NODE,MICD,PC,CNDLST,COND,RULE
 .. S NODE=$G(@GL@("A10C",MG,MP,MC))
 .. S MICD=$P(NODE,U) Q:MICD=""  ;Get mapped ICD
 .. S CNDLST=$P(NODE,U,2)
 .. S DA(1)=CONCDA
 .. S DIC(0)="LX",DIC="^BSTS(9002318.4,"_DA(1)_",14,"
 .. S X=MC
 .. S DLAYGO=9002318.414 D ^DIC
 .. ;
 .. ;Quit on fail
 .. I +Y<0 Q
 .. ;
 .. ;Save remaining fields
 .. S (RULE,DA)=+Y,IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.414,IENS,".02")=MG
 .. S BSTSC(9002318.414,IENS,".03")=MP
 .. S BSTSC(9002318.414,IENS,".04")=MICD
 .. ;
 .. ;Save Conditions
 .. F PC=1:1:$L(CNDLST,";") S COND=$P(CNDLST,";",PC) D
 ... ;
 ... I PC>1,COND="" Q
 ... ;
 ... NEW VAR,OPER,VALUE,DA,IENS,DIC,DLAYGO,X,Y
 ... ;
 ... ;Handle Unconditionals
 ... S:COND="" COND="TRUE = 1"
 ... S VAR=$P(COND," ")  ;Condition
 ... S OPER=$P(COND," ",2)  ;Operator
 ... S VALUE=$P(COND," ",3,99)  ;Value
 ... ;
 ... ;Special variable handling
 ... I VAR="AAO",VALUE[" days" S VAR="AAOD",VALUE=$P(VALUE," ")
 ... I VAR="AAO",VALUE[" years" S VAR="AAOY",VALUE=$P(VALUE," ")
 ... S DA(2)=CONCDA,DA(1)=RULE
 ... S X=VAR,DIC(0)="LX",DIC="^BSTS(9002318.4,"_DA(2)_",14,"_DA(1)_",1,"
 ... S DLAYGO=9002318.4141
 ... K DO,DD D FILE^DICN
 ... I +Y<0 Q
 ... S DA=+Y,IENS=$$IENS^DILF(.DA)
 ... ;
 ... ;Save remaining fields
 ... S BSTSC(9002318.4141,IENS,.02)=OPER
 ... S BSTSC(9002318.4141,IENS,.03)=VALUE
 ... S BSTSC(9002318.4141,IENS,.04)=COND
 ;
 ;Capture the status
 I $D(@GL@("CSTS")) D
 . NEW CSTS,CIEN
 . S CIEN=$O(@GL@("CSTS","")) Q:CIEN=""
 . S CSTS=$P($G(@GL@("CSTS",CIEN)),U) S:CSTS="" CSTS="@"
 . S BSTSC(9002318.4,CONCDA_",",.14)=CSTS
 ;
 Q
 ;
PLIST(CONCID) ;Return conditional parameters used for that concepts conditional logic
 ;
 I $G(CONCID)="" Q ""
 ;
 NEW VAR,RETURN
 ;
 ;Compile list of parameters that are used
 S (RETURN,VAR)="" F  S VAR=$O(^BSTS(9002318.4,"J",36,CONCID,VAR)) Q:VAR=""  D
 . S RETURN=RETURN_$S(RETURN]"":"^",1:"")_VAR
 ;
 ;Return List
 Q RETURN
 ;
 ;Return AAOD
AAOD(VIEN) ;Return Age in Days
 ;
 ;Input: VIEN - The visit IEN
 ;
 Q:VIEN="" ""
 ;
 NEW AAOD,DOB,VDT,DFN,X1,X2,X,%Y
 ;
 S AAOD=""
 ;
 ;Visit Date
 S VDT=$$GET1^DIQ(9000010,VIEN_",",.01,"I") Q:VDT="" ""
 ;
 ;Date of Birth
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I") Q:DFN="" ""
 S DOB=$$GET1^DIQ(2,DFN,.03,"I") Q:DOB="" ""
 ;
 ;Get difference in dates in days
 S X2=DOB,X1=VDT D ^%DTC
 I +X>0 S AAOD=+X
 ;
 Q AAOD
 ;
 ;Return AAOY
AAOY(VIEN) ;Return Age in Years
 ;
 ;Input: VIEN - The visit IEN
 ;
 Q:VIEN="" ""
 ;
 NEW AAOY,DOB,VDT,DFN,X1,X2,X,%Y
 ;
 S AAOY=""
 ;
 ;Visit Date
 S VDT=$$GET1^DIQ(9000010,VIEN_",",.01,"I") Q:VDT="" ""
 ;
 ;Date of Birth
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I") Q:DFN="" ""
 ;
 ;Get the Age in Years
 S AAOY=$$GET1^DIQ(2,DFN,.033,"E")
 ;
 Q AAOY
 ;
AC(CONC) ;Return Acute/Chronic value for the concept
 ;
 I $G(CONC)="" Q ""
 ;
 NEW STS,CIEN
 ;
 ;Get the internal CIEN
 S CIEN=$O(^BSTS(9002318.4,"C",36,CONC,"")) Q:CIEN=""
 ;
 ;Pull the status from local cache
 S STS=$$GET1^DIQ(9002318.4,CIEN_",",.14,"I")
 S STS=$S(STS="A":"Acute",STS="C":"Chronic",1:"")
 Q STS
 ;
SEX(VIEN) ;Return patient sex
 ;
 ;Input: VIEN - The visit IEN
 ;
 I $G(VIEN)="" Q ""
 ;
 NEW DFN,SEX
 ;
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I") Q:DFN="" ""
 S SEX=$$GET1^DIQ(2,DFN,.02,"I")
 S SEX=$S(SEX="M":"Male",SEX="F":"Female",1:"")
 ;
 Q SEX
 ;
 ;Return Converted Parameter Value for Mapping
CVPARM(TYPE,PARM) ;Return the converted value
 ;
 I $G(PARM)="" Q ""
 I $G(TYPE)="" Q ""
 ;
 ;Look for a mapping translation in BSTS SNOMED MAPPING CONV
 S PARM=$O(^BSTS(9002318.6,"C",TYPE,PARM,""))
 ;
 ;Return the translated value
 Q PARM
 ;
TRI(VIEN) ;Return Trimester
 ;
 ;Input: VIEN - The visit IEN
 ;
 I $G(VIEN)="" Q ""
 ;
 NEW DFN,TRI
 ;
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I") Q:DFN="" ""
 ;
 ;Return the trimester in weeks
 S TRI=$$LASTMSR^BSTSMSR($G(DFN),"EGA",0,0)
 ;
 ;Convert to weeks
 I +TRI'>0 S TRI="" ;No trimester
 E  I +TRI<14 S TRI="First"
 E  I +TRI<28 S TRI="Second"
 E  S TRI="Third"
 ;
 Q TRI
 ;
BMI(VIEN) ;Return BMI
 ;
 ;Input: VIEN - The visit IEN
 ;
 I $G(VIEN)="" Q ""
 ;
 NEW DFN,BMI
 ;
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I") Q:DFN="" 0
 ;
 ;Return the latest BMI
 S BMI=$$LASTMSR^BSTSMSR($G(DFN),"BMI",0,0)
 ;
 ;Handle no BMI
 I +BMI'>0 S BMI=""
 ;
 Q BMI
 ;
AF(AF) ;Return Abnormal Findings
 ;
 I $G(AF)="" Q ""
 ;
 ;Handle invalid AF entries
 Q $S(AF="With":AF,AF="Without":AF,1:"")
 ;
HEAL(HEAL) ;Fracture Healing
 ;
 I $G(HEAL)="" Q ""
 ;
 ;Handle invalid HEAL entries
 Q $S(HEAL="Routine":HEAL,HEAL="Delayed":HEAL,HEAL="Nonunion":HEAL,HEAL="Malunion":HEAL,1:"")
 ;
LAT(PRB,FH) ;Return Laterality
 ;
 I $G(PRB)="",$G(FH)="" Q ""
 ;
 NEW LAT,ATR
 ;
 ;Pull laterality from the PROBLEM file or FAMILY HISTORY file
 S LAT=""
 I PRB]"" S LAT=$$GET1^DIQ(9000011,PRB_",",".22","I")
 I FH]"",LAT="" S LAT=$$GET1^DIQ(9000014,FH_",",".17","I")
 Q:$TR(LAT,"|")="" ""
 ;
 ;Quit if attribute not "Laterality"
 S ATR=$P(LAT,"|") Q:ATR="" ""
 S LAT=$P(LAT,"|",2) Q:LAT="" ""
 I ATR?1N.N,$O(^BSTS(9002318.6,"C","LAT",ATR,""))'="Laterality" Q ""
 I ATR'?1N.N,ATR'="Laterality" Q
 ;
 ;If SNOMED, convert and return
 I LAT?1N.N S LAT=$$CVPARM("LAT",LAT) Q $S(LAT="Right and left":"Bilateral",1:LAT)
 ;
 ;If text, convert Right and left -> Bilateral
 Q $S(LAT="Right and left":"Bilateral",1:LAT)
 ;
SEV(PRB) ;Return Severity
 ;
 I $G(PRB)="" Q ""
 ;
 NEW SEV,I,FND
 ;
 ;Pull Severity from the PROBLEM file
 S (SEV,FND,I)=0 F  S I=$O(^AUPNPROB(PRB,13,I)) Q:'+I  D  Q:FND
 . NEW SNO
 . S SNO=$P($G(^AUPNPROB(PRB,13,I,0)),U,1)
 . I SNO'="",$$CVPARM^BSTSMAP1("SEV",SNO)'="Severity" S SEV=SNO,FND=1
 ;
 Q SEV
 ;
CMAP(CONC,PARMS) ;Return the conditional ICD10 mappings for a concept
 ;
 ;This function accepts a Concept ID and a string of parameters and based on mapping logic
 ;returns the mapped ICD10 code(s) for that concept
 ;
 ;Input:
 ; CONC - Concept ID
 ; PARMS - Parameter string. Ex. "EPI=255217005;VST=2087365;PRB=123456"
 ;
 ;Output: Returns a ";" string of ICD10 maps to that concept
 ;
 ;Mapping Overview
 ;Concepts with conditional mapping will have one or more map groups.  Each map group can have 0 or 1
 ;ICD10 codes associated with it. A concept can therefore have more than one ICD10 mapping, up to 1
 ;per map group. Within each map group there can be multiple priorities. Each priority
 ;can have one or more condition checks associated with it.  The ICD10 code assigned to the first
 ;priority that ALL the checks pass on will get assigned for that map group.
 ;
 I $G(CONC)="" Q ""  ;No Concept Id
 I $G(PARMS)="" Q ""  ;No mapping parameters passed in
 ;
 NEW PC,VAL,FND,ICD,VAR,CDARY,MGRP,VARRAY,FH,HEAL,VDT
 NEW EPI,VST,AF,SEV,PRB,OC,AAOD,AAOY,AC,BMI,SEX,LAT,TRI,TRUE
 ;
 ;Parse the passed in PARMS and set the variables
 S (EPI,VST,AF,SEV,PRB,OC,AAOD,AAOY,AC,BMI,SEX,LAT,TRI,FH,HEAL)="",TRUE=1  ;Preset possible variables
 F PC=1:1:$L(PARMS,";") S VAL=$P(PARMS,";",PC) I VAL]"" D
 . ;
 . ;Handle invalid parameters passed in
 . I VAL'["=" Q  ;No equal sign
 . I (",EPI,VST,AF,SEV,PRB,HEAL,OC,")'[(","_$P(VAL,"=")_",") Q  ;Incorrect first parameter
 . I $P(VAL,"=",2)="" Q  ;Null value, already set
 . ;
 . ;Set the parameter variable (adding quotes)
 . S VAL="S "_$P(VAL,"=")_"="_$C(34)_$P(VAL,"=",2)_$C(34)
 . X VAL
 ;
 ;Locate the variables used by this concept
 S (FND,ICD,VAR)="" F  S VAR=$O(^BSTS(9002318.4,"J",36,CONC,VAR)) Q:VAR=""  D
 . ;
 . ;Found a conditional map
 . S FND=1
 . ;
 . ;Record that variable is needed for the mapping
 . S VARRAY(VAR)=""
 ;
 ;Quit if no conditional mapping
 I FND="" Q ICD
 ;
 ;Determine the parameter values
 S VAR="" F  S VAR=$O(VARRAY(VAR)) Q:VAR=""  D
 . ;
 . ;Acute/Chronic
 . I VAR="AC" S AC=$$AC(CONC) Q
 . ;
 . ;Age at onset - Days
 . I VAR="AAOD" S AAOD=$$AAOD(VST) Q
 . ;
 . ;Age at onset - Years
 . I VAR="AAOY" S AAOY=$$AAOY(VST) Q
 . ;
 . ;Episodicity
 . I VAR="EPI" S EPI=$$CVPARM("EPI",EPI) Q
 . ;
 . ;Gender
 . I VAR="SEX" S SEX=$$SEX(VST) Q
 . ;
 . ;Laterality
 . I VAR="LAT" S LAT=$$LAT(PRB,FH) Q
 . ;
 . ;BMI
 . I VAR="BMI" S BMI=$$BMI(VST) Q
 . ;
 . ;Trimester
 . I VAR="TRI" S TRI=$$TRI(VST) Q
 . ;
 . ;Severity
 . I VAR="SEV" D  Q
 .. S:SEV="" SEV=$$SEV(PRB)
 .. S SEV=$$CVPARM("SEV",SEV)
 . ;
 . ;Abnormal Findings
 . I VAR="AF" S AF=$$AF(AF) Q
 . ;
 . ;Fracture Healing
 . I VAR="HEAL" S HEAL=$$HEAL(HEAL) Q
 ;
 ;Assemble the conditions
 D BCOND^BSTSMAP1(CONC,.CDARY)
 ;
 ;Visit Date
 S VDT=$$GET1^DIQ(9000010,$G(VST)_",",.01,"I") S:VDT="" VDT=DT
 ;
 ;Process each group
 S MGRP="" F  S MGRP=$O(CDARY(MGRP)) Q:MGRP=""  D
 . ;
 . NEW CNTR,GFND
 . ;
 . ;Loop by Counter/Priority - Quit if entry found for the group
 . S (GFND,CNTR)="" F  S CNTR=$O(CDARY(MGRP,CNTR)) Q:CNTR=""  D  Q:GFND
 .. ;
 .. NEW COD,FAIL
 .. ;
 .. ;Get the code
 .. S COD=$G(CDARY(MGRP,CNTR))
 .. ;
 .. NEW CNDCT
 .. ;
 .. ;Loop through each condition for the priority
 .. S (FAIL,CNDCT)="" F  S CNDCT=$O(CDARY(MGRP,CNTR,CNDCT)) Q:CNDCT=""  D  Q:FAIL
 ... ;
 ... NEW PASS,COND
 ... ;
 ... ;Get the condition and execute
 ... S PASS=0,COND=CDARY(MGRP,CNTR,CNDCT) X COND
 ... S:'PASS FAIL=1
 .. ;
 .. ;Quit priority if any check failed
 .. I FAIL Q
 .. ;
 .. ;Quit if COD is inactive
 .. I '$$VRSN^BSTSVICD(COD,VDT) Q
 .. ;
 .. ;Add code to the list and mark that one was found for the group
 .. S ICD=$G(ICD)_$S(ICD]"":";",1:"")_COD
 .. S GFND=1
 ;
 Q ICD
 ;
BCOND(CONC,CDARY) ;Build the condition array
 ;
 ;Returns a list of conditions for an array and the CODE for each
 ;CDARY(MGRP,CNTR)=ICD10 code
 ;CDARY(MGRP,CNTR,#)=Executable M code for the condition
 ;                   Condition will return PASS=0 (Fail) or PASS=1 (Success) if all conditions pass
 ;                   then the ICD10 for that priority/counter will be assigned for that map group
 ;
 ;Where:
 ;MGRP - The map group
 ;CNTR - The priority/counter within the group
 ;# - The condition entry or entries for that priority/counter
 ;
 NEW CIEN,MGRP
 ;
 ;Get the internal CIEN
 S CIEN=$O(^BSTS(9002318.4,"C",36,CONC,"")) Q:CIEN=""
 ;
 ;Loop through each map group
 S MGRP=0 F  S MGRP=$O(^BSTS(9002318.4,CIEN,14,"C",MGRP)) Q:'MGRP  D
 . ;
 . NEW MPRI
 . ;
 . ;Loop through by priority
 . S MPRI="" F  S MPRI=$O(^BSTS(9002318.4,CIEN,14,"C",MGRP,MPRI)) Q:MPRI=""  D
 .. ;
 .. NEW CNTR
 .. ;
 .. ;Loop through by counter - counter needed because priority may not be unique
 .. S CNTR="" F  S CNTR=$O(^BSTS(9002318.4,CIEN,14,"C",MGRP,MPRI,CNTR)) Q:CNTR=""  D
 ... ;
 ... NEW CIEN1
 ... ;
 ... ;Loop through by CIEN1 (IEN of the ICD CONDITIONAL MAPPING multiple)
 ... S CIEN1="" F  S CIEN1=$O(^BSTS(9002318.4,CIEN,14,"C",MGRP,MPRI,CNTR,CIEN1)) Q:CIEN1=""  D
 .... ;
 .... ;Capture the ICD10 code assigned to that priority/counter
 .... NEW CIEN2,COD,DA,IENS
 .... S DA(1)=CIEN,DA=CIEN1,IENS=$$IENS^DILF(.DA)
 .... S COD=$$GET1^DIQ(9002318.414,IENS,".04","E") Q:COD=""  ;Code
 .... S CDARY(MGRP,CNTR)=COD
 .... ;
 .... ;Loop through by Condition (priority/counters could have >1 condition - AND logic applies)
 .... S CIEN2=0 F  S CIEN2=$O(^BSTS(9002318.4,CIEN,14,CIEN1,1,CIEN2)) Q:'CIEN2  D
 ..... ;
 ..... NEW VAR,OP,VAL,DA,IENS,COND
 ..... ;
 ..... ;Parse the condition
 ..... S DA(2)=CIEN,DA(1)=CIEN1,DA=CIEN2,IENS=$$IENS^DILF(.DA)
 ..... S VAR=$$GET1^DIQ(9002318.4141,IENS,".01","E") ;Variable
 ..... S OP=$$GET1^DIQ(9002318.4141,IENS,".02","E") ;Condition
 ..... S VAL=$$GET1^DIQ(9002318.4141,IENS,".03","E") ;Value
 ..... S:VAL]"" VAL=$C(34)_VAL_$C(34) ;Add quotes to value
 ..... ;
 ..... ;Assemble the condition
 ..... ;Need special logic to handle if the patient value is null (so if check is AAO<29 and no visit
 ..... ;passed in AAO value would be null. In this case do not pass the check (even though ""<29). If
 ..... ;the condition is looking for a null though (Ex. AC="") allow it.
 ..... S COND="S PASS=0 I ("_VAR_"]"""")!("_VAR_"=""""&("_VAL_"="""")),"_VAR_OP_VAL_" S PASS=1"
 ..... ;
 ..... ;Set up the array
 ..... S CDARY(MGRP,CNTR,CIEN2)=COND
 ;
 Q
