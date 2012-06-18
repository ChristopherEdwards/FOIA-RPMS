AGGUL1 ;VNGT/HS/DLS - Miscellaneous AGG Utilities ; 08 Apr 2010  3:36 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
 Q
 ;
FMTE(Y) ;EP - Convert Fileman Date/Time to 'MMM DD,CCYY HH:MM:SS' format.
 ;Description
 ;  Receives Date (Y) in FileMan format and returns formatted date.
 ;
 ;Input
 ;  Y - FileMan date/time (i.e. 3051024.123456).
 ;  
 ;Output
 ;  Date/Time in External format (i.e. OCT 24,2005 12:34:56).
 ;  
 NEW DATM
 S DATM=$TR($$FMTE^DILIBF(Y,"5U"),"@"," ")
 I DATM["24:00" S DATM=$P(DATM," ",1,2)_" 00:00"
 Q DATM
 ;
DATE(DATE) ;EP - Convert standard date/time to a FileMan date/time
 ;Input
 ;  DATE - In a standard format
 ;Output
 ;  -1 is if it couldn't convert to a FileMan date
 ;  otherwise a standard FileMan date
 NEW %DT,X,Y
 I DATE[":" D
 . I DATE["/",$L(DATE," ")=3 S DATE=$P(DATE," ",1)_"@"_$P(DATE," ",2)_$P(DATE," ",3) Q
 . I $L(DATE," ")=3 S DATE=$P(DATE," ",1,2)_"@"_$P(DATE," ",3)
 . I $L(DATE," ")>3 S DATE=$P(DATE," ",1,3)_"@"_$P(DATE," ",4,99)
 S %DT="TS",X=DATE D ^%DT
 I Y=-1 S Y=""
 ;
 Q Y
 ;
FMTMDY(DATE) ;EP - Convert fileman date to MM/DD/YYYY format
 ;Input
 ;  DATE - In fileman format
 ;  
 ;Output
 ;  -1 if couldn't convert to MM/DD/YYYY format
 ;  Otherwise, date in MM/DD/YYYY format
 ;
 Q $TR($$FMTE^XLFDT(DATE,"5Z"),"@"," ")
 ;
TKO(STR,VAL) ;EP - Take off ending character
 ;
 ;Description
 ;  This will take off the ending character at the end of
 ;  a string
 ;Input
 ;  STR - String of data
 ;  VAL - Delimiter character
 ;Output
 ;  same STR without the ending character
 ;
 I $G(STR)="" Q ""
 I $G(VAL)="" Q ""
 ;
 NEW LV
 S LV=$L(VAL)
 I $E(STR,$L(STR)-(LV-1),$L(STR))=VAL S STR=$E(STR,1,$L(STR)-LV)
 ;
 Q STR
 ;
STRIP(STR,VAL) ;EP - Remove one or more trailing characters in a string.
 ;
 ;Description
 ;  Removes one or more trailing characters
 ;  at the end of a string.
 ;Input
 ;  STR - String of data
 ;  VAL - Delimiter character
 ;Output
 ;  Same STR without the trailing character(s).
 ;
 I $G(STR)="" Q STR
 I $G(VAL)="" Q STR
 ;
 F  Q:$E(STR,$L(STR))'=VAL  S STR=$E(STR,1,($L(STR)-1))
 Q STR
 ;
CTRL(X) ;EP - Strip out control characters
 I X'?.ANP F Y=1:1 I $E(X,Y)?.C Q:Y>$L(X)!(X="")  S X=$E(X,1,Y-1)_$E(X,Y+1,999),Y=Y-1
 Q X
 ;
TRIM(STR,VAL) ;EP - Remove one or more leading characters in a string.
 ;
 ;Description
 ;  Removes one or more leading characters from a string.
 ;Input
 ;  STR - String of data
 ;  VAL - Delimiter character
 ;Output
 ;  Same STR without the trailing character(s).
 ;
 I $G(STR)="" Q STR
 I $G(VAL)="" Q STR
 ;
 F  Q:$E(STR,1)'=VAL  S STR=$E(STR,2,($L(STR)))
 Q STR
 ;
PTR(FIL,FLD,VVAL,VPEC) ;EP - Find alternate value for a pointer
 ;
 ;  Input Parameters
 ;    FIL = FileMan File #
 ;    FLD = FileMan Field #
 ;    VVAL = Data Value
 ;    VPEC = Field from pointed to file, defaults to .01 if not defined
 ;
 NEW ARR1,VEDATA,VFILN,VEHDTA,VVALUE,VVVAL
 I $G(VPEC)="" S VPEC=.01
 ;
 I $G(VVAL)="" Q ""
 ;  Get the Pointer Global Reference
 D FIELD^DID(FIL,FLD,"","POINTER","VEPAR")
 S VEDATA=$G(VEPAR("POINTER")),VEHDTA="^"_VEDATA_"0)"
 S VFILN=$P($G(@VEHDTA),U,2)
 S VFILN=$$STRIP^XLFSTR(VFILN,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
 K VEPAR
 ;
 S VVVAL=$$GET1^DIQ(FIL,VVAL_",",FLD,"I") I VVVAL="" Q ""
 S VVALUE=$$GET1^DIQ(VFILN,VVVAL_",",VPEC,"E")
 ;B  D FIELD^DID(VFILN,VPEC,"N","GLOBAL SUBSCRIPT LOCATION","ARR")
 ;S ARR1=ARR("GLOBAL SUBSCRIPT LOCATION")
 ;
 ;I VVAL'="" S VEHDTA="^"_VEDATA_VVAL_","_$P(ARR1,";",1)_")"
 ;
 ;S PEC=$P(ARR1,";",2)
 ;I VVAL'="" S VVALUE=$P($G(@VEHDTA),U,PEC)
 Q VVALUE
 ;
STC(FIL,FLD,VAL) ; EP - Find a value for a set of codes code
 ;  Input Parameters
 ;    FIL = FileMan File Number
 ;    FLD = FileMan Field Number
 ;    VAL = Code Value
 ;
 NEW VEDATA,VEQFL,VEVL,VALUE
 S VEDATA=$P(^DD(FIL,FLD,0),U,3),VEQFL=0
 ;
 F I=1:1 S VEVL=$P(VEDATA,";",I) Q:VEVL=""  D  Q:VEQFL
 . S VALUE=$P(VEVL,":",2) I VAL=$P(VEVL,":",1) S VEQFL=1
 ;
 Q VALUE
 ;
TMPFL(MODE,UID,DFN) ;EP - Open to 'R'ead, Open to 'W'rite, 'C'lose or 'D'elete
 ; temporary file designed for use when converting report text to RPC
 ; data strings. Note that UID and DFN are components of the file name.
 ;
 ; Input
 ;    MODE(Required) - 'R'(Read),'W'(Write),'C'(Close),'D'(Delete)
 ;    UID(Req'd for modes D,R,W) - Job identifier
 ;    DFN(Req'd for modes D,R,W) - Patient IEN
 ; Output
 ;    POP - 0 for success, 1 for failure
 ;    
 N POP,HSPATH,HSFN
 S POP=1
 ;
 ; To close a file.
 I MODE="C" D CLOSE^%ZISH("AGGFILE")
 ;
 ; To Delete, Read-From, or Write-To a file.
 I "D/R/W"[MODE D
 .S HSPATH=$$DEFDIR^%ZISH("")
 .I HSPATH="" S HSPATH=$$PWD^%ZISH()
 .S HSFN=UID_"_"_$G(DFN)_".DAT"
 ;
 ; To delete a file
 I MODE="D" S POP=$$DEL^%ZISH(HSPATH,HSFN)
 ;
 ; To Read from or to Write to a file.
 I (MODE="R")!(MODE="W") D
 .D OPEN^%ZISH("AGGFILE",HSPATH,HSFN,MODE)
 Q POP
 ;
HRN(DFN) ;EP - Patient Health Record Number
 ;
 ;Description
 ;  Returns the patient's health record number
 ;Input
 ;  DFN - Patient internal entry number
 ;  DUZ(2) - Assumes DUZ(2) exists since it's defined by
 ;           signing on to the system as the user's default
 ;           facility
 ;Output
 ;  HRN - Health Record number for the user's default
 ;        facility
 ;
 I $G(DUZ(2))="" Q ""
 I $G(DFN)="" Q ""
 ;
 NEW HRN
 S HRN=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 I $P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,3)'="" S HRN="*"_HRN
 Q HRN
 ;
HRNL(DFN,LOC) ;PEP - Patient's Health Record Number
 ; Input
 ;   DFN - Patient's internal entry number
 ;   LOC - Facility internal entry number (so does not depend on DUZ(2)
 ;
 I $G(LOC)="" Q ""
 I $G(DFN)="" Q ""
 NEW HRN
 S HRN=$P($G(^AUPNPAT(DFN,41,LOC,0)),U,2)
 I $P($G(^AUPNPAT(DFN,41,LOC,0)),U,3)'="" S HRN="*"_HRN
 Q HRN
 ;
SENS(DFN) ;EP - Is patient sensitive flag
 ;Input
 ;  DFN - Patient internal entry number
 NEW FLAG
 S FLAG=+$P($G(^DGSL(38.1,+DFN,0)),"^",2)
 S FLAG=$S(FLAG=1:"YES",1:"NO")
 Q FLAG
 ;
CTY(DFN) ;EP - Combines city,state and zip
 NEW ADATA,RESULT,STN,AZIP,LZIP
 S ADATA=$G(^DPT(DFN,.11)) I ADATA="" Q ""
 S RESULT=$P(ADATA,U,4)
 I RESULT'="" S RESULT=RESULT_", "
 S STN=$P(ADATA,U,5)
 I STN'="" S RESULT=RESULT_$P(^DIC(5,STN,0),U,2)_" "
 S AZIP=$P(ADATA,U,6)
 S LZIP=$P(ADATA,U,12)
 S RESULT=RESULT_$S(LZIP'="":LZIP,1:AZIP)
 Q RESULT
 ;
CHS(DFN,PAIR) ;EP - CHS Eligibility
 NEW C0,RESULT
 S C0=0,RESULT=""
 S C0=$O(^AUPNPAT(DFN,34,C0)) I 'C0 Q RESULT  D
 . I $G(PAIR)=1 S RESULT=C0_$C(28)_$P($G(^AUPNELM(C0,0)),U,1) Q
 . S RESULT=$P($G(^AUPNELM(C0,0)),U,1)
 Q RESULT
 ;
ALT(DFN) ;EP - Alternate Resources
 NEW RESULT,AGINSN1,AGINS,AGCAT,ISACTIVE,AGGUAR,AGSEL,AOPCOINS
 NEW DATEINEF,FIXLIST,INSGEND,MEDCARE,NEWSEQR,PHREC,POLH,RAILROAD
 NEW REC,RELPOLHO,SPECSUB,TRUEPOLH,AGINSNN,PLANNAME,PLANPTR,MAX
 NEW GRPNUMB,COINS,ENTDAT,EFF,END
 D EP^AGINS
 D LOADCAT^AGCAT
 S ISACTIVE=0
 S N=0
 F  S N=$O(AGINS(N)) Q:N=""  D
 . S EFF=$P(AGINS(N),U,5),END=$P(AGINS(N),U,6)
 . I $$ISACTIVE^AGINSUPD(EFF,END) S ISACTIVE=1
 I 'ISACTIVE S RESULT="NO"
 I ISACTIVE S RESULT="YES"
 Q RESULT
 ;
MREC(DFN) ;EP - Status of Medical Record
 NEW RESULT,VAL
 S VAL=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,4)
 I VAL="" Q ""
 Q VAL_$C(28)_$P(^AUTTDIS(VAL,0),U,1)
 ;
AOB(DFN) ;EP - Assign of Benefits
 NEW RESULT,DATE
 S DATE=""
 S DATE=$O(^AUPNPAT(DFN,71,"B",DATE),-1)
 I 'DATE Q ""
 Q $$FMTE^AGGUL1(DATE)
 ;
ROI(DFN) ;EP - Release of Information
 NEW RESULT,DATE
 S DATE=""
 S DATE=$O(^AUPNPAT(DFN,36,"B",DATE),-1)
 I 'DATE Q ""
 Q $$FMTE^AGGUL1(DATE)
 ;
ADR(PATDFN,FORCE) ; EP - Update PREVIOUS MAIL ADDRESSES
 ; Copied and modified from AGUTILS
 S FORCE=$G(FORCE)
 ; Quit if they already have a historical address
 I FORCE="F" Q:$O(^AUPNPAT(PATDFN,83,0))
 NEW ADDREC,DIE,DIC,DR,DA
 S DA(1)=PATDFN
 S DIC="^AUPNPAT("_DA(1)_",83,"
 S DIC(0)="L"
 S X=""""_DT_""""
 D ^DIC
 I Y<0 Q
 S ADDREC=+Y
 ;
 ;get the current ADDRESS VALUES
 NEW AGSTR1,AGSTR2,AGSTR3,AGCITY,AGSTATE,AGZIP,AGHPHONE
 S AGSTR1=$$GET1^DIQ(2,PATDFN_",",.111)
 S AGSTR2=$$GET1^DIQ(2,PATDFN_",",.112)
 S AGSTR3=$$GET1^DIQ(2,PATDFN_",",.113)
 S AGCITY=$$GET1^DIQ(2,PATDFN_",",.114)
 S AGSTATE=$$GET1^DIQ(2,PATDFN_",",.115)
 I $G(AGSTATE)'="" I AGSTATE'=+AGSTATE S AGSTATE=$O(^DIC(5,"B",AGSTATE,""))
 S AGZIP=$S($$GET1^DIQ(2,PATDFN_",",.1112,"E")'="":$$GET1^DIQ(2,PATDFN_",",.1112,"E"),1:$$GET1^DIQ(2,PATDFN_",",.116))
 S AGHPHONE=$$GET1^DIQ(2,PATDFN_",",.131)
 ;
 K DIE,DIC,DR,DA,DIR
 S DA=ADDREC,DA(1)=PATDFN,IENS=$$IENS^DILF(.DA)
 S DIE="^AUPNPAT("_DA(1)_",83,"
 I FORCE="F" D
 . S AGGUPD(9000001.83,IENS,.02)="AGSTR1",AGGUPD(9000001.83,IENS,.03)="AGSTR2",AGGUPD(9000001.83,IENS,.04)="AGSTR3"
 . S AGGUPD(9000001.83,IENS,.05)="AGCITY",AGGUPD(9000001.83,IENS,.06)="AGSTATE",AGGUPD(9000001.83,IENS,.07)="AGZIP"
 . S AGGUPD(9000001.83,IENS,.08)="AGHPHONE"
 . ;S DR=".02////AGSTR1;.03////AGSTR2;.04////AGSTR3;.05////AGCITY;.06////AGSTATE;.07////AGZIP;.08////AGHPHONE"
 I FORCE'="F" D
 . S AGGUPD(9000001.83,IENS,.02)=AGSTR1,AGGUPD(9000001.83,IENS,.03)=AGSTR2,AGGUPD(9000001.83,IENS,.04)=AGSTR3
 . S AGGUPD(9000001.83,IENS,.05)=AGCITY,AGGUPD(9000001.83,IENS,.06)=AGSTATE,AGGUPD(9000001.83,IENS,.07)=AGZIP
 . S AGGUPD(9000001.83,IENS,.08)=AGHPHONE
 . ;S DR=".02///^S X=AGSTR1;.03///^S X=AGSTR2;.04///^S X=AGSTR3;.05///^S X=AGCITY;.06///^S X=AGSTATE;.07///^S X=AGZIP;.08///^S X=AGHPHONE"
 D FILE^DIE("","AGGUPD","ERROR")
 Q
 ;
EML(DFN) ; EP - Update PREVIOUS EMAIL ADDRESSES
 NEW ADDREC,DIE,DIC,DR,DA,AGEMAIL,AGGUPD,ERROR
 S DA(1)=DFN
 S DIC="^AUPNPAT("_DA(1)_",82,"
 S DIC(0)="L"
 S X=""""_DT_""""
 D ^DIC
 I Y<0 Q
 S ADDREC=+Y
 S AGEMAIL=$$GET1^DIQ(9000001,DFN_",",1802) I AGEMAIL="" Q
 S DA=ADDREC,DA(1)=DFN,IENS=$$IENS^DILF(.DA)
 S AGGUPD(9000001.82,IENS,.02)=AGEMAIL
 D FILE^DIE("","AGGUPD","ERROR")
 Q
 ;
TRIB(DFN) ; EP - Get list of other tribes
 NEW RESULT,DA,IENS
 S RESULT=""
 S DA(1)=DFN,DA=0
 F  S DA=$O(^AUPNPAT(DFN,43,DA)) Q:'DA  D
 . S IENS=$$IENS^DILF(.DA)
 . S RESULT=RESULT_$$GET1^DIQ(9000001.43,IENS,.01,"E")_";"
 S RESULT=$$TKO^AGGUL1(RESULT,";")
 I RESULT="" S RESULT="NONE LISTED"
 Q RESULT
