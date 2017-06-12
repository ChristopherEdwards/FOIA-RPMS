BGOVAMI2 ; MSC/DKA - AMI Utilities 2 ;01-May-2014 14:44;DKA
 ;;1.1;BGO COMPONENTS;**13,14**;Mar 20, 2007
 ;01.23.14 - MSC/JS - move SET here to keep within 15k routine size limits
 ;01.28.14 - DEBUG EVENT CALL FOR NEW AMI RECORD ADDED
 ;O2.06.14 - Field .17 changed to store text
 ;05.01.14 - MSC/DKA Allow neither Fib Init nor Fib Not Init.
 ;
 ; Add/edit V AMI entry
SET(RET,INP) ;EP
 ; This is the exact opposite of the GET call.
 ; INP is an array of strings.
 ; The first string is the VFIEN^NumberOfLines^VisitIsLocked
 ; Each subsequent string is prefixed with a letter indicating the type of record:
 ; A   - Arrival
 ; AT  - Arrival Text (Comment)
 ; E   - EKG Done
 ; EF  - EKG Findings (Multiple)
 ; EFT - EKG Findings Text (Comment)
 ; ET  - EKG Done Text (Comment)
 ; F   - Fibrinolytic Therapy
 ; FT  - Fibrinolytic Therapy Text (Comment)
 ; O   - Onset Symptoms
 ; OT  - Onset Symptoms Text (Comment)
 ; P   - Protocol Standing Order
 ; PT  - Protocol Standing Order Text (Comment)
 ; S   - Symptom
 N DESCT,FDA,FNUM,NARR,NARRPTR,NOW,NUMNEW,SUBIEN,VCODE,VFIEN,VFNEW,VFSTR,VI,VIEN,REFUSED,VISDAT,DELF,VFCOMM
 N ADT,EDT,FDT,ODT,PDT,ATCOMM,EFTCOMM,ETCOMM,FTCOMM,OTCOMM,PTCOMM,FIBTXT,REFDT,DFN,RET2,FI
 S RET="",FNUM=$$FNUM
 S VFIEN=+INP(0)
 S VFNEW='VFIEN
 S VIEN=$P(INP(1),U,4)
 S VISDAT=$G(^AUPNVSIT(VIEN,0))
 S DFN=$P(VISDAT,U,5)
 I $G(DFN)="" S RET=$$ERR^BGOUTL(1062) Q
 S NOW=$$NOW^XLFDT ; Use the same value for Date/Time Entered fields
 S RET=$$CHKVISIT^BGOUTL(VIEN) Q:RET  ; Visit does not exist
 I VFNEW D VFNEW^BGOUTL2(.RET,FNUM,VFIEN,VIEN) S:RET>0 VFIEN=RET,RET=""
 I 'VFIEN S RET=$$ERR^BGOUTL(1070) Q  ; Unknown file entry (Best match for Unable to Add V File Entry)
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 F VI=1:1:$P(INP(0),U,2) D
 .S VFSTR=INP(VI)
 .S VCODE=$P(VFSTR,U)
 .I VCODE="A" D
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..S ADT=$P(VFSTR,U,2)
 ..I ADT>0,ADT'["." S ADT=(ADT-1)+.24
 ..S @FDA@(.01)=ADT ;ArrivalDateTime
 ..;S @FDA@(.01)=$P(VFSTR,U,2) ;ArrivalDateTime
 ..S @FDA@(1204)=$P(VFSTR,U,5) ;EncounterProvider
 .E  I VCODE="AT" D
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..S ATCOMM=$P(VFSTR,U,2) ; Comment (Date/Time Arrival)
 ..I ATCOMM="" S @FDA@(1)="@" ; Delete the comment, whether or not it already exists.
 ..E  D
 ...S @FDA@(1)=$NA(FDA(FNUM,VFIEN_",",1))
 ...S @FDA@(1,0)=$G(@FDA@(1,0))+1
 ...S @FDA@(1,@FDA@(1,0))=ATCOMM
 .E  I VCODE="E" D
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..I $P(VFSTR,U,2)]"" D
 ...S EDT=$P(VFSTR,U,2)
 ...I EDT>0,EDT'["." S EDT=(EDT-1)+.24
 ...S @FDA@(.07)=EDT ;EKGDone(Date/Time)
 ...;S @FDA@(.07)=$P(VFSTR,U,2) ;EKGDoneDateTime
 ...S @FDA@(.08)=NOW
 ...S @FDA@(.09)=DUZ
 ...S @FDA@(1201)=$P(VFSTR,U,3) ;EventDateTime
 ...S @FDA@(1202)=$P(VFSTR,U,4) ;OrderingProvider
 ...S @FDA@(1210)=$P(VFSTR,U,5) ;OutsideProviderName
 ...S @FDA@(1215)=$P(VFSTR,U,6) ;OrderingLocation
 ..I $P(VFSTR,U,2)="" D  ;                             1.22.14
 ...S @FDA@(.07)="@" ;EKGDone(Date/Time)
 ...S @FDA@(.08)="@" ;EKGDateTimeEntered
 ...S @FDA@(.09)="@" ;EKGEnteredBy
 ...S @FDA@(1201)="@" ;EventDateTime
 ...S @FDA@(1202)="@" ;OrderingProvider
 ...S @FDA@(1210)="@" ;OutsideProviderName
 ...S @FDA@(1215)="@" ;OrderingLocation
 ...S @FDA@(3)="@" ;EKG Comment [ET]
 .E  I VCODE="EF" D
 ..S SUBIEN=$P(VFSTR,U,2)
 ..I +SUBIEN&(SUBIEN["@") D DEL^BGOVAMI1(.RET2,VFIEN,SUBIEN,14) Q
 ..I SUBIEN="" S NUMNEW=$G(NUMNEW)+1,SUBIEN="+"_NUMNEW
 ..S SUBIEN=SUBIEN_","_VFIEN_","
 ..S FDA=$NA(FDA(FNUM_14,SUBIEN))
 ..S @FDA@(.01)=$P(VFSTR,U,3) ;EkgFindingsConceptId
 ..S (DESCT,@FDA@(.02))=$P(VFSTR,U,4) ;Description ID
 ..S (NARR,@FDA@(.03))=$P(VFSTR,U,5) ;Provider Text
 ..I DESCT]"" I NARR]"" S NARRPTR=$$NARR(DESCT,NARR)
 ..S @FDA@(.03)=$S($G(NARRPTR)>0:NARRPTR,1:"")
 ..S @FDA@(.04)=$P(VFSTR,U,6) ;ICD-9
 ..S @FDA@(.06)=$P(VFSTR,U,7) ;Interpreted By
 ..S @FDA@(.07)=$P(VFSTR,U,8) ;Event Date/Time
 ..S @FDA@(.08)=NOW ; Date/Time Entered
 ..S @FDA@(.09)=DUZ ; Entered By
 .E  I VCODE="EFT" D  ; Use same SUBIEN as previous "EF" record
 ..Q:+SUBIEN&(SUBIEN["@")
 ..S EFTCOMM=$P(VFSTR,U,3)
 ..I EFTCOMM="" S @FDA@(1)="@"
 ..E  D
 ...S @FDA@(1)=$NA(FDA(FNUM_14,SUBIEN,1))
 ...S @FDA@(1,0)=$G(@FDA@(1,0))+1
 ...S @FDA@(1,@FDA@(1,0))=EFTCOMM
 .E  I VCODE="ET" D
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..S ETCOMM=$P(VFSTR,U,2) ; EKG Comment
 ..I ETCOMM="" S @FDA@(3)="@"
 ..E  D
 ...S @FDA@(3)=$NA(FDA(FNUM,VFIEN_",",3))
 ...S @FDA@(3,0)=$G(@FDA@(3,0))+1
 ...S @FDA@(3,@FDA@(3,0))=ETCOMM
 .E  I VCODE="F" D
 ..; 2014-05-01 DKA If no date is sent, then clear both FibInit and FibNotInit fields,
 ..;                else if a reason is not sent, set FibInit and clear FibNotInit fields,
 ..;                otherwise set FibNotInit and clear FibInit fields.
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..;First check to see if neither FT Initiated nor FT Not Initiated (None button checked)
 ..I $P(VFSTR,U,2,3)=U F FI=.11:.01:.17 S @FDA@(FI)="@" ; Clear all the FibInit and FibNotInit fields
 ..E  I $P(VFSTR,U,4)="" D  ;  $P4 = Did Not Init Fib Reason  fld#.17
 ...; FT Initiated
 ...S FDT=$P(VFSTR,U,2)
 ...I FDT>0,FDT'["." S FDT=(FDT-1)+.24
 ...S @FDA@(.11)=FDT ;FibrinolyticTherapyInitiated
 ...;S @FDA@(.11)=$P(VFSTR,U,2) ;FibrinolyticTherapyInitiated
 ...S @FDA@(.12)=NOW,@FDA@(.13)=DUZ
 ...S @FDA@(.14)="@" ; Delete any previous value for FT DidNotInit
 ...S @FDA@(.15)="@" ; Delete any previous value for FT DidNotInitD/TEntered
 ...S @FDA@(.16)="@" ; Delete any previous value for FT DidNotInitEnteredBy
 ...S @FDA@(.17)="@" ; Delete any previous value for FT DidnotInitReason
 ...;IHS/MSC/MGH Try to remove any refusal reason if this is an edit
 ...D DELREF^BGOVAMI1(VFIEN)
 ..E  D
 ...; FT Not Initiated
 ...S (@FDA@(.14),REFDT)=$P(VFSTR,U,3) ;DidNotInit (Date)
 ...S @FDA@(.15)=NOW,@FDA@(.16)=DUZ
 ...;S (@FDA@(.17),REFUSED)=$P(VFSTR,U,4) ;DidnotInitReason
 ...S REFUSED=$P(VFSTR,U,4)
 ...S FIBTXT=$$GET1^DIQ(9999999.102,REFUSED,.01)
 ...S @FDA@(.17)=FIBTXT
 ...S @FDA@(.11)="@" ; Delete any previous value for FT Initiated
 ...S @FDA@(.12)="@" ; Delete any previous value for FT D/TEntered
 ...S @FDA@(.13)="@" ; Delete any previous value for FT EnteredBy
 .E  I VCODE="FT" D
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..S FTCOMM=$P(VFSTR,U,2) ; Fibrinolytic Therapy Comment
 ..I FTCOMM="" S @FDA@(4)="@" ; Delete the comment, whether or not it already exists.
 ..E  D
 ...S @FDA@(4)=$NA(FDA(FNUM,VFIEN_",",4))
 ...S @FDA@(4,0)=$G(@FDA@(4,0))+1
 ...S @FDA@(4,@FDA@(4,0))=FTCOMM
 .E  I VCODE="O" D
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..S ODT=$P(VFSTR,U,2)
 ..I ODT>0,ODT'["." S ODT=(ODT-1)+.24
 ..S @FDA@(.04)=ODT ;OnsetSymptoms
 ..;S @FDA@(.04)=$P(VFSTR,U,2) ;OnsetSymptoms
 ..S @FDA@(.05)=NOW
 ..S @FDA@(.06)=DUZ
 .E  I VCODE="OT" D
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..S @FDA@(2)=$NA(FDA(FNUM,VFIEN_",",2))
 ..S OTCOMM=$P(VFSTR,U,2) ; Onset Symptoms Text
 ..I OTCOMM="" S @FDA@(2)="@" ; Delete the comment, whether or not it already exists.
 ..E  D
 ...S @FDA@(2)=$NA(FDA(FNUM,VFIEN_",",2))
 ...S @FDA@(2,0)=$G(@FDA@(2,0))+1
 ...S @FDA@(2,@FDA@(2,0))=OTCOMM
 .E  I VCODE="P" D  ; Protocol Standing Orders (Sub-File)
 ..S SUBIEN=$P(VFSTR,U,2)
 ..I +SUBIEN&(SUBIEN["@") D DEL^BGOVAMI1(.RET2,VFIEN,SUBIEN,13) Q
 ..I SUBIEN="" S NUMNEW=$G(NUMNEW)+1,SUBIEN="+"_NUMNEW
 ..S SUBIEN=SUBIEN_","_VFIEN_","
 ..S FDA=$NA(FDA(FNUM_13,SUBIEN))
 ..S @FDA@(.01)=$P(VFSTR,U,3)
 ..S PDT=$P(VFSTR,U,4)
 ..I PDT>0,PDT'["." S PDT=(PDT-1)+.24
 ..S @FDA@(.02)=PDT ;ProtocolEventDateTime
 ..;S @FDA@(.02)=$P(VFSTR,U,4) ;ProtocolEventDateTime
 ..S @FDA@(.03)=NOW
 ..S @FDA@(.04)=DUZ
 .E  I VCODE="PT" D  ; Use same SUBIEN as previous "P" record
 ..Q:+SUBIEN&(SUBIEN["@")
 ..S PTCOMM=$P(VFSTR,U,3)
 ..I PTCOMM="" S @FDA@(1)="@"
 ..E  D
 ...S @FDA@(1)=$NA(FDA(FNUM_13,SUBIEN,1))
 ...S @FDA@(1,0)=$G(@FDA@(1,0))+1
 ...S @FDA@(1,@FDA@(1,0))=PTCOMM
 ...;S @FDA@(1,@FDA@(1,0))=$P(VFSTR,U,3)
 .E  I VCODE="S" D
 ..S SUBIEN=$P(VFSTR,U,2)
 ..I +SUBIEN&(SUBIEN["@") D DEL^BGOVAMI1(.RET2,VFIEN,SUBIEN,15) Q
 ..I SUBIEN="" S NUMNEW=$G(NUMNEW)+1,SUBIEN="+"_NUMNEW
 ..S SUBIEN=SUBIEN_","_VFIEN_","
 ..S FDA=$NA(FDA(FNUM_15,SUBIEN))
 ..S @FDA@(.01)=$P(VFSTR,U,3) ;Symptoms
 ..;S @FDA@(.019)=$P(VFSTR,U,4) ;Symptom Preferred Text
 S RET=$$UPDATE^BGOUTL(.FDA,"")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 ;add #9000022 PATIENT REFUSALS FOR SERVICE/NMI file entry:
 I $G(REFUSED)]"" N RET S RET=$$SETREF^BGOVAMI1(DFN,REFUSED,REFDT,VFNEW)
 Q
 ;
NARR(DESCT,NARR) ;Provider narrative is now provider text | descriptive SNOMED CT
 S NARRPTR=0
 S NARR=NARR_"|"_DESCT
 I $L(NARR) D  Q:RET
 .S RET=$$FNDNARR^BGOUTL2(NARR)
 .S:RET>0 NARRPTR=RET,RET=""
 Q NARRPTR
 ;
 ; Return V File #
 ; This method signature allows this to be called as a Remote Procedure.
FNUM(RET,INP) S RET=9000010.62
 Q RET
