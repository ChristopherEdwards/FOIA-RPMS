AGGWVAL ;VNGT/HS/ALA-AGG Window Validation Program ; 07 Apr 2010  7:05 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
VAL(DATA,VFILE,PARMS) ;EP -- AGG WINDOW DATA VALIDATION
 ;
 ;Input
 ;  VFILE - The vfile number or name
 ;  PARMS - The parameters being checked for validation
 ;
 NEW UID,II,BQ,LIST,BN,PDATA,NAME,VALUE,HDR,CODN,VALID,VALFLD,BI,VFLD,TYPE,X,RESULT
 NEW VFIEN,MSG,HNDLR,IEN,CODE,REVAL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGWVAL",UID))
 K @DATA
 S II=0,MSG=""
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGWVAL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S VFILE=$G(VFILE,"") I VFILE="" S BMXSEC="RPC Failed: No Window selected" Q
 S VFIEN=$O(^AGG(9009068.3,"B",VFILE,""))
 S FILE=$P(^AGG(9009068.3,VFIEN,0),U,2)
 ;
 S @DATA@(II)="I00010RESULT^T00100MSG^T00001HANDLER^I00010IEN^T00008CODE^T00100REVALIDATE"_$C(30)
 ; Get list of parameters
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 I PARMS="" S II=II+1,@DATA@(II)="1^"_$G(MSG)_U_$G(HNDLR)_U_$G(IEN)_U_$G(CODE)_U_$G(REVAL)_$C(30) G DONE
 ; Parse parameters
 F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . I NAME["{"!(NAME["}") S NAME=$$STRIP^XLFSTR(NAME,"{}")
 . S @NAME=VALUE
 . ; If value is DFN, it exists at the PCC Visit level not individual
 . ; V File level.
 . I VFILE'=9000010&(NAME="DFN"!(NAME="APCDDATE")) Q
 . S CODN=$O(^AGG(9009068.3,VFIEN,10,"AC",NAME,""))
 . I CODN="" S BMXSEC="RPC Failed: Parameter does not exist for this Window" Q
 . I $G(VALID)="" S VALID=$P($G(^AGG(9009068.3,VFIEN,10,CODN,2)),U,2)
 . I $G(VALFLD)="" S VALFLD=$P($G(^AGG(9009068.3,VFIEN,10,CODN,2)),U,1)
 ;
 ; Check that values exist for all fields needed for the validation
 F BI=1:1:$L(VALFLD,";") S VFLD=$P(VALFLD,";",BI) D
 . I VFLD["*" S VFLD=$$STRIP^XLFSTR(VFLD,"*") Q
 . I VFLD["{"!(VFLD["}") S VFLD=$$STRIP^XLFSTR(VFLD,"{}") Q
 . I $G(@VFLD)="" S BMXSEC="RPC Failed: Missing validation value for "_VFLD
 I $G(BMXSEC)'="" Q
 ;
 S VALID=$TR(VALID,"~","^"),RESULT=0
 ; Execute the validation tag
 D @VALID
 S II=II+1,@DATA@(II)=RESULT_U_$G(MSG)_U_$G(HNDLR)_U_$G(IEN)_U_$G(CODE)_U_$G(REVAL)_$C(30)
 ; Clean up validation variables
 F BI=1:1:$L(VALFLD,";") D
 . S VFLD=$P(VALFLD,";",BI),VFLD=$$STRIP^XLFSTR(VFLD,"*"),VFLD=$$STRIP^XLFSTR(VFLD,"+"),VFLD=$$STRIP^XLFSTR(VFLD,"{}")
 . K @VFLD
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SSN(ASSN,DFN) ;EP - SSN
 ;I $G(ASSN)="",$G(NOSSN)="",$$ISREQ^AGGUL2(2,"SSN") S RESULT=-1,MSG="Enter a SSN or a Reason for No SSN" Q
 ;
 NEW DGY,AGGL,VERIFY
 S VERIFY=0,RESULT=1
 I +$G(DFN)=0,$G(ASSN)="" S RESULT=1 Q
 I $G(ASSN)'="",$L(ASSN)<9 S RESULT=-1,MSG="SSN should be 9 characters" Q
 I +$G(DFN)'=0,$P(^AUPNPAT(DFN,0),U,23)]"" D
 . I $D(^AUTTSSN($P(^AUPNPAT(DFN,0),U,23),0)) D
 .. I "V"[$P(^AUTTSSN($P(^AUPNPAT(DFN,0),U,23),0),U) S VERIFY=1
 I VERIFY S RESULT=-1,MSG="The SSN has been verified by the SSA and cannot be edited." Q
 I $G(ASSN)'="" D  Q
 . S DGY=$O(^DPT("SSN",ASSN,0)) I DGY="" S RESULT=1 Q
 . I DGY>0,DGY'=DFN,$D(^DPT(DGY,0)) S RESULT=-1,MSG="SSN already used by another patient." Q
 I $E(ASSN,1,1)=9 S RESULT=-1,MSG="The SSN must not begin with 9" Q
 I $E(ASSN,1,3)="000",$E(ASSN,1,5)'="00000" S RESULT=-1,MSG="First three digits cannot be zeros." Q
 ;
 S RESULT=1
 Q
 ;
NOSSN(NOSSN,ASSN,DFN) ;EP
 I $G(ASSN)="",$G(NOSSN)="",$$ISREQ^AGGUL2(2,"SSN") S RESULT=-1,MSG="Enter a SSN or a Reason for No SSN" Q
 I $G(ASSN)="",$G(NOSSN)'="" S RESULT=1 Q
 I $G(ASSN)'="",$G(NOSSN)'="" S RESULT=-1,MSG="Enter a SSN or a Reason for No SSN. You cannot enter both." Q
 Q
 ;
HRN(HRN,DFN) ;EP - HRN
 NEW EDFN,LC
 S EDFN=$O(^AUPNPAT("D",HRN,""))
 I EDFN="" S RESULT=1 Q
 I EDFN=DFN S RESULT=1 Q
 S LC=0
 S LC=$O(^AUPNPAT("D",HRN,EDFN,LC))
 ; If the location of the patient with the existing same HRN is not the same location
 I LC'=DUZ(2) S RESULT=1 Q
 S RESULT=-1,MSG="HRN "_HRN_" is already assigned to patient "_$S($P($G(^DPT(EDFN,0)),U)'="":$P($G(^DPT(EDFN,0)),U),1:"UNDEFINED RECORD")
 Q
 ;
IBQ(X,DFN,TBQ,AGGPTCLB) ;EP - Indian Blood Quantum
 N RTN,CLBEN
 ;
 ;Skip check if classification/beneficiary is not Indian/Alaskan Native
 S CLBEN=$O(^AUTTBEN("B","INDIAN/ALASKA NATIVE",""))  ;Get Classification IEN
 I AGGPTCLB]"",AGGPTCLB'=CLBEN S RESULT=1,MSG="" Q
 ;
 D
 . I $L(TBQ)>11!($L(TBQ)<1) K TBQ Q
 . I "NF"[$E(TBQ) S TBQ=$S($E(TBQ)="F":"FULL",1:"NONE") Q
 . I $E(TBQ)'?1N&(($E(TBQ,1,3)'="UNK")&($E(TBQ,1,3)'="UNS")) K TBQ Q
 . I $E(TBQ)="U" S TBQ=$S($E(TBQ,3)="K":"UNKNOWN",1:"UNSPECIFIED") Q
 . I TBQ'?1.4N1"/"1.5N K TBQ Q
 . I $P(TBQ,"/",1)>$P(TBQ,"/",2)!(+$P(TBQ,"/",2)=0) K TBQ Q
 . S:$P(TBQ,"/",1)=$P(TBQ,"/",2) TBQ="FULL" Q
 ;
 D
 . I $L(X)>11!($L(X)<1) K X Q
 . I "NF"[$E(X) S X=$S($E(X)="F":"FULL",1:"NONE") Q
 . I $E(X)'?1N&(($E(X,1,3)'="UNK")&($E(X,1,3)'="UNS")) K X Q
 . I $E(X)="U" S X=$S($E(X,3)="K":"UNKNOWN",1:"UNSPECIFIED") Q
 . I X'?1.4N1"/"1.5N K X Q
 . I $P(X,"/",1)>$P(X,"/",2)!(+$P(X,"/",2)=0) K X Q
 . S:$P(X,"/",1)=$P(X,"/",2) X="FULL" Q
 ;
 S RESULT=1
 ;
 ;Set up fields to revalidate
 S REVAL="AGGPTELG;AGGPTCLB;AGGPTTRI;AGGPTTRQ"
 ;
 I $G(X)="" S RESULT=-1,MSG="Entry not valid" Q
 I $G(TBQ)="" Q
 ;
 ;Basic Quantum checks
 I RESULT=1,"UNKNOWN,NONE,UNSPECIFIED"[X,"UNKOWN,NONE,UNSPECIFIED"'[TBQ D
 . S MSG="Quantums are Inconsistent",RESULT=-1,CODE="AGGPTBLQ"
 ;
 I RESULT=1,TBQ="FULL",X'="FULL" D
 . S MSG="Quantums are Inconsistent",RESULT=-1,CODE="AGGPTBLQ"
 ;
 ;Check to see if main tribal quantum is greater than blood quantum
 I RESULT=1,$P($G(^AGFAC(DUZ(2),0)),U,2)="Y" S RTN=$$QUANT^AGGUL2(X,TBQ,0) I $P(RTN,U)=-1 S MSG="The Tribal Quantum cannot be greater than the Indian Blood Quantum",RESULT=-1
 Q
 ;
TBQ(X,DFN,IBQ,AGGPTCLB) ;EP - Tribal Blood Quantum
 D TBQ^AGGWVAL1(X,DFN,IBQ,AGGPTCLB)
 Q
 ;
OTQ(X) ;EP - Other Tribe Quantum
 D
 . I $L(X)>11!($L(X)<1) K X Q
 . I "NF"[$E(X) S X=$S($E(X)="F":"FULL",1:"NONE") Q
 . I $E(X)'?1N&(($E(X,1,3)'="UNK")&($E(X,1,3)'="UNS")) K X Q
 . I $E(X)="U" S X=$S($E(X,3)="K":"UNKNOWN",1:"UNSPECIFIED") Q
 . I X'?1.4N1"/"1.5N K X Q
 . I $P(X,"/",1)>$P(X,"/",2)!(+$P(X,"/",2)=0) K X Q
 . S:$P(X,"/",1)=$P(X,"/",2) X="FULL" Q
 ;
 I $G(X)="" S RESULT=-1,MSG="Entry not valid" Q
 S RESULT=1
 Q
 ;
DELIP(CHOICE,RECORD) ;EP - Delete insurance policy
 N IN3PB
 S IN3PB=$$USED^AGUTILS(CHOICE,"",8,RECORD)
 I $L(IN3PB) D  Q
 .S RESULT=-1,MSG="WARNING: This member has outstanding claims and/or bills!!!"
 .S MSG=MSG_" Deleting this member may cause data integrity problems"
 .S MSG=MSG_" in the Third Party Billing package!!"
 NEW DA,IENS,REL
 S DA(1)=CHOICE,DA=RECORD,IENS=$$IENS^DILF(.DA)
 S REL=$$GET1^DIQ(9000006.11,IENS,.05,"E")
 I REL="SELF" D  Q
 . S RESULT=-1,MSG="THIS IS THE POLICY HOLDER. IF YOU DELETE THE POLICY HOLDER"
 . S MSG=MSG_" THE PRIVATE INSURANCE ELIGIBILITIES OF ALL MEMBERS OF THIS"
 . S MSG=MSG_" POLICY WILL BE DELETED INCLUDING THE POLICY HOLDER"
 . S MSG=MSG_" DO YOU REALLY WANT TO DO THIS?"
 S RESULT=1
 Q
 ;
IMP(VALUE,AUPNDOB) ;EP - Imprecise date validation
 S RESULT=1,AUPNDOB=$G(AUPNDOB,"")
 I VALUE="B",AUPNDOB'="" S VALUE=AUPNDOB
 S VALUE=$$DATE^AGGUL1(VALUE)
 I VALUE="" S RESULT=-1,MSG="Invalid date" Q
 Q
 ;
DRDTS(BDT,EDT) ;EP - Daily Reports Date Validation
 S RESULT=1
 I BDT="",EDT="" Q
 I '$D(DT) D DT^DICRW
 ; beginning date Check
 I BDT]"" D  Q:(EDT="")!(RESULT=-1)
 . S BDT=$P($$DATE^AGGUL1(BDT),".")
 . I BDT="" S RESULT=-1,MSG="Must supply Beginning Date." Q
 . I BDT>DT S RESULT=-1,MSG="Do not use future dates." Q
 ; Ending date check
 I EDT]"" D  Q:(BDT="")!(RESULT=-1)
 . S EDT=$P($$DATE^AGGUL1(EDT),".")
 . I EDT="" S RESULT=-1,MSG="Must supply Ending Date." Q
 . I EDT>DT S RESULT=-1,MSG="Do not use future dates." Q
 ; compare beginning and edning dates
 I BDT>EDT S RESULT=-1,MSG="INVALID ENTRY - The END is before the BEGINNING." Q
 Q
 ;
VET(DFN,AGGPTVET) ;EP - Veteran validation
 NEW X,X1,X2,AGGPTDOB
 S RESULT=1
 I AGGPTVET="N" Q
 S AGGPTDOB=$P(^DPT(DFN,0),U,3)
 S X1=DT,X2=AGGPTDOB
 S X=$E(X1,1,3)-$E(X2,1,3)-($E(X1,4,7)<$E(X2,4,7))
 I X<17 S RESULT=-1,MSG="Applicant is TOO YOUNG to be a veteran...ONLY "_X_" YEARS OLD!!"
 Q
 ;
MP(INSPTR,DFN) ; EP - for repeating insurers
 I $D(^AUPNPRVT("I",INSPTR,DFN)) S MSG="WARNING: If you proceed you will be ADDING an Insurer that the Patient already has an Eligibility Record for!"
 Q
 ;
NAM(NAME) ; EP - Name validation
 NEW DG20NAME,X,ERROR
 S RESULT=1
 I NAME="" Q
 I NAME[", " S RESULT=-1,MSG="No space after the comma" Q
 S (DG20NAME,X)=NAME
 S (X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,35,,,.ERROR)
 S AE="",QFL=0
 F  S AE=$O(ERROR(AE)) Q:AE=""  D  Q:QFL
 . I AE=1 S RESULT=-1,MSG="Name does not contain a comma",QFL=1 Q
 . S RESULT=-1,MSG="Name is not in correct format",QFL=1
 Q
 ;
MAI(NAME) ; EP - Maiden name validation
 NEW DG20NAME,X,AE ;,ERROR
 S RESULT=1
 I NAME="" Q
 S (DG20NAME,X)=NAME
 S (X,DG20NAME)=$$FORMAT^DPTNAME(.DG20NAME,3,35,,2,.ERROR,1)
 S AE="",QFL=0
 F  S AE=$O(ERROR(AE)) Q:AE=""  D  Q:QFL
 . I AE=1 S RESULT=-1,MSG="Name does not contain a comma",QFL=1 Q
 . S RESULT=-1,MSG="Name is not in correct format",QFL=1
 Q
 ;
DOB(DOB) ; EP - Date of Birth Validation
 S RESULT=1
 I $G(DOB)="" Q
 S DOB=$$DATE^AGGUL1(DOB)
 I DOB<1701231 S RESULT=-1,MSG="Date must be later than 12/31/1870" Q
 I DOB>DT S RESULT=-1,MSG="Future dates not valid" Q
 Q
 ;
DOD(DOD,DFN) ; EP - Date of Death validation
 S RESULT=1
 I $G(DOD)="" Q
 S DOD=$$DATE^AGGUL1(DOD)
 S DOB=$$GET1^DIQ(2,DFN_",",.03,"I") I DOB="" Q
 I DOD>DT S RESULT=-1,MSG="Future dates not valid" Q
 I DOD\1<DOB S RESULT=-1,MSG="Date cannot be before Date of Birth ("_$$FMTE^AGGUL1(DOB)_")" Q
 Q
 ;
ELG(AGB,AGTP,AGQT,AGQI,AGEL) ; EP - Eligibility check
 D EN^AGGELCHK(AGB,AGTP,AGQT,AGQI,AGEL)
 S REVAL=""
 Q
 ;
ELGS(AGB,AGTP,AGQT,AGQI,AGEL) ; EP - Eligibility check from Eligibility Status field
 S RESULT="",MSG="",CODE="",REVAL=""
 D EN^AGGELCHK(AGB,AGTP,AGQT,AGQI,AGEL)
 ;
 ;Determine whether to flag Eligibility Status field with an error
 ;Errors for other fields will be caught in revalidation
 I $G(RESULT)=-1,($G(CODE)="AGGPTCLB"!($G(CODE)="AGGPTTRI")) S RESULT=1,MSG="",CODE=""
 ;
 ;Set up fields to revalidate
 S REVAL="AGGPTCLB;AGGPTBLQ;AGGPTTRI;AGGPTTRQ"
 Q
 ;
ELGC(AGB,AGTP,AGQT,AGQI,AGEL) ; EP - Eligibility check from Classification field
 S RESULT="",MSG="",CODE="",REVAL=""
 D EN^AGGELCHK(AGB,AGTP,AGQT,AGQI,AGEL)
 ;
 ;Determine whether to flag Classification field with an error
 ;Errors for other fields will be caught in revalidation
 I $G(RESULT)=-1,($G(CODE)="AGGPTELG"!($G(CODE)="AGGPTTRI")) S RESULT=1,MSG="",CODE=""
 ;
 ;Set up fields to revalidate
 S REVAL="AGGPTELG;AGGPTBLQ;AGGPTTRI;AGGPTTRQ"
 Q
 ;
ELGT(AGB,AGTP,AGQT,AGQI,AGEL) ; EP - Eligibility check from Tribe of Membership field
 S RESULT="",MSG="",CODE="",REVAL=""
 D EN^AGGELCHK(AGB,AGTP,AGQT,AGQI,AGEL)
 ;
 ;Determine whether to flag Tribe of Membership field with an error
 ;Errors for other fields will be caught in revalidation
 I $G(RESULT)=-1,($G(CODE)="AGGPTCLB"!($G(CODE)="AGGPTELG")) S RESULT=1,MSG="",CODE=""
 ;
 ;Set up fields to revalidate
 S REVAL="AGGPTELG;AGGPTCLB;AGGPTBLQ;AGGPTTRQ"
 Q
 ;
FM(AGGFTNME,AGGMTNME,DFN) ; EP = Family Member check
 NEW AGE
 S RESULT=1
 S AGE=$$AGE^AGGAGE(DFN)
 I AGE'<18 Q
 ;
 I $G(AGGFTNME)'="" D NAM(AGGFTNME) I RESULT'=1 Q
 I $G(AGGMTNME)'="" D NAM(AGGMTNME) I RESULT'=1 Q
 S REVAL="AGGFTEMN;AGGMTEMN;AGGFTNME;AGGMTNME"
 I $G(AGGFTNME)="",$G(AGGMTNME)="" S RESULT=-1,MSG="Minor must have either Father's name or Mother's name entered." Q
 Q
 ;
FEMP(AGGFTEMN,AGGMTEMN,AGGFTNME,AGGMTNME,DFN) ; EP = Father's Employer check
 D FEMP^AGGWVAL1(AGGFTEMN,AGGMTEMN,AGGFTNME,AGGMTNME,DFN)
 Q
 ;
MEMP(AGGMTEMN,AGGMTNME,AGGFTNME,AGGFTEMN,DFN) ; EP = Mother's Employer check
 D MEMP^AGGWVAL1(AGGMTEMN,AGGMTNME,AGGFTNME,AGGFTEMN,DFN)
 Q
 ;
ROI(AGGPTROI) ; EP - Release of Information
 N RES
 S RESULT=1,MSG=""
 S RES=$$ROI^AGGALTRG(AGGPTROI) I $P(RES,U)=-1 S RESULT=-1,MSG=$P(RES,U,2)
 Q
 ;
AOB(AOB) ;EP - Assignment of Benefits
 S RESULT=1,MSG=""
 S REVAL="AGGPTROI"
 I $$RQAOB^AGEDERR4(DUZ(2)),AOB="" S RESULT=-1,MSG="Assignment of Benefits is Required"
 Q
 ;
ZIP(ZIP) ;EP - Zip Code Validation
 I $G(ZIP)="" S RESULT=1 Q
 S ZIP=$$STRIP^XLFSTR(ZIP,"-")
 I $L(ZIP)<5!($L(ZIP)>9) S RESULT=-1,MSG="Enter 5 or 9 digit zip code." Q
 I ZIP'?5N,(ZIP'?9N) S RESULT=-1,MSG="Enter numbers for zip code." Q
 S RESULT=1
 Q
 ;
DTEMS(STRT,END) ; EP - Elig dates validation for Medicaid and Private Insurance
 D DTEMS^AGGARVAL(STRT,END)
 Q
 ;
DTEME(END,STRT) ; EP
 D DTEME^AGGARVAL(END,STRT)
 Q
 ;
DTMS(TRANSTYP,STRT,END) ; EP
 I TRANSTYP="A" S RESULT=1 Q
 D DTEMS^AGGARVAL(STRT,END)
 Q
 ;
DTME(TRANSTYP,END,STRT) ; EP
 I TRANSTYP="A" S RESULT=1 Q
 D DTEME^AGGARVAL(END,STRT)
 Q
 ;
HNUM(HNUM) ; EP
 S RESULT=1
 I $G(HNUM)="" Q
 I HNUM'?.N S RESULT=-1,MSG="Enter a number between 0 and 99" Q
 I HNUM<0!(HNUM>99) S RESULT=-1,MSG="Enter a number between 0 and 99"
 Q
 ;
CERT(DCER) ; EP - Death Certificate
 S RESULT=1
 I $G(DCER)="" Q
 I $L(DCER)>8!($L(DCER)<6)!'(DCER?6.8N) S RESULT=-1,MSG="Death Certificate must be between 6 and 8 numbers only." Q
 Q
