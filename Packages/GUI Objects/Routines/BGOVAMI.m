BGOVAMI ; MSC/DKA - Manage V AMI ;06-Feb-2015 16:13;DU
 ;;1.1;BGO COMPONENTS;**13,14**;Mar 20, 2007
 ;12.26.13 - MSC/JS add translation for Midnight and blank 'E' input string check.
 ;01.08.14 - MSC/DKA Send "@" to filer to delete comments when they are blank in the SET call.
 ;01.08.14 - MSC/JS delete fibrinolytic fields for fibrin therapy initiated or fibrin therapy refused.
 ;01.10.14 - MSC/DKA Remove calls to MIDGET() and MIDSET() because GUI got changed.
 ;                 Added code to change date only values to midnight (<Date-1>.24),
 ;                 and code to delete dates when they are blank.
 ;01.17.14 - MSC/JS - p13 update fixes added (IHS CCB items from Monday IHS call 1/13)
 ;01.22.14 - MSC/JS EHR will send a blank 'E' for 'EKG DONE' box unchecked
 ;01.23.14 - MSC/JS - move SET to BGOVAMI2 to keep within 15k routine size limits
 ;03.19.14 - MCS/DKA - Added FIBRINOLYTIC THER D/T ENTERED to "F" string in GET().
 ;
 ; Get Chest Pain (AMI) by individual entry, visit, or patient
 ;   INP = Patient IEN [1] ^ V File IEN [2] ^ Visit IEN [3]
GET(RET,INP) ;EP
 N COUNT,PNAR,FN,FNS,FNUM,FX,DIDNOT,Z2,INDX,IENARR,VFARR,VFDATA,VFDEL,VFFLD,VFIEN,VFMSG,VFSTR,VIEN,DNIR,RETMID
 S RET=$$TMPGBL^BGOUTL,FNUM=$$FNUM,COUNT=0
 ; Get the V file IEN value(s)
 ; The number of values is returned in IENARR
 D GETVFIEN^BGOVAMI1(.IENARR,INP)
 I +$G(IENARR)=0 S @RET@(0)=$$ERR^BGOUTL(1035) Q  ; Indicate there's an unexplained error (Item not found)
 I IENARR<0 S @RET@(0)=IENARR Q
 F INDX=1:1:IENARR D
 .S FNUM=$$FNUM ; Reset this for each iteration
 .S VFIEN=IENARR(INDX)
 .K VFDATA,VFMSG
 .S VFDEL=0
 .D GETS^DIQ($$FNUM,VFIEN,"**","IE","VFDATA","VFMSG")
 .I $D(VFMSG("DIERR")) D
 ..S VFARR=0_U_$G(VFMSG("DIERR",1))_U_$G(VFMSG("DIERR",1,"TEXT",1))
 ..S VIEN=0 ; So $$ISLOCKED returns -1
 .E  D
 ..S FX=$O(VFDATA(FNUM,"")) ; Take the first subscript
 ..I VFDATA(FNUM,FX,5.01,"I") S VFDEL=1 Q  ; Ignore Deleted Records
 ..S @RET@(0)=$G(@RET@(0))+1 ; Increment the top-level counter for active records
 ..S VFARR=0,VFSTR="A"
 ..S $P(VFSTR,U,2)=VFDATA(FNUM,FX,.01,"I") ;ArrivalDateTime
 ..S $P(VFSTR,U,3)=VFDATA(FNUM,FX,.02,"I") ;PatientName
 ..S (VIEN,$P(VFSTR,U,4))=VFDATA(FNUM,FX,.03,"I") ;Visit
 ..;S $P(VFSTR,U,5)=VFDATA(FNUM,FX,1203,"I") ;clinic
 ..S $P(VFSTR,U,5)=VFDATA(FNUM,FX,1204,"I") ;EncounterProvider
 ..S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..; Add the comment lines from field 1 on separate "AT" records
 ..S FNS=0
 ..F  S FNS=$O(VFDATA(FNUM,FX,1,FNS)) Q:'FNS  D
 ...S VFSTR="AT"
 ...S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,1,FNS))
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..S VFSTR="E"
 ..S $P(VFSTR,U,2)=VFDATA(FNUM,FX,.07,"I") ;EKGDoneDateTime
 ..S $P(VFSTR,U,3)=VFDATA(FNUM,FX,1201,"I") ;EventDateTime
 ..S $P(VFSTR,U,4)=VFDATA(FNUM,FX,1202,"I") ;OrderingProvider
 ..S $P(VFSTR,U,5)=VFDATA(FNUM,FX,1210,"I") ;OutsideProviderName
 ..S $P(VFSTR,U,6)=VFDATA(FNUM,FX,1215,"I") ;OrderingLocation
 ..S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..; Add the comment lines from field 3 on separate "ET" records
 ..S FNS=0 F  S FNS=$O(VFDATA(FNUM,FX,3,FNS)) Q:'FNS  D
 ...S VFSTR="ET"
 ...S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,3,FNS))
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..S VFSTR="F"
 ..S $P(VFSTR,U,2)=VFDATA(FNUM,FX,.11,"I") ;FibrinolyticTherapyInitiated
 ..S $P(VFSTR,U,3)=VFDATA(FNUM,FX,.12,"I") ;FibrinolyticTherapyDateTimeEntered
 ..S $P(VFSTR,U,4)=VFDATA(FNUM,FX,.14,"I") ;DidNotInit
 ..S DIDNOT=VFDATA(FNUM,FX,.17,"I") ;DidnotInitReason
 ..I $L(DIDNOT)<4 S $P(VFSTR,U,5)=DIDNOT
 ..E  S Z2=$O(^AUTTREFR("B",DIDNOT,"")) S $P(VFSTR,U,5)=Z2
 ..S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..; Add the comment lines from field 4 on separate "FT" records
 ..S FNS=0 F  S FNS=$O(VFDATA(FNUM,FX,4,FNS)) Q:'FNS  D
 ...S VFSTR="FT"
 ...S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,4,FNS))
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..S VFSTR="O"
 ..S $P(VFSTR,U,2)=VFDATA(FNUM,FX,.04,"I") ;OnsetSymptoms
 ..S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..; Add the comment lines from field 2 on separate "OT" records
 ..S FNS=0
 ..F  S FNS=$O(VFDATA(FNUM,FX,2,FNS)) Q:'FNS  D
 ...S VFSTR="OT"
 ...S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,2,FNS))
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..;For the Protocol Standing Orders, create a separate set of P and PT records for each multiple
 ..S FNUM=$$FNUM_13
 ..S FX="" F  S FX=$O(VFDATA(FNUM,FX)) Q:FX=""  D
 ...S VFSTR="P"_U_$P(FX,",")
 ...S $P(VFSTR,U,3)=VFDATA(FNUM,FX,.01,"I") ;ProtocolStandingOrders
 ...S $P(VFSTR,U,4)=VFDATA(FNUM,FX,.02,"I") ;EventDateTime
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ...; Add the comment lines
 ...S FNS=0 F  S FNS=$O(VFDATA(FNUM,FX,1,FNS)) Q:'FNS  D
 ....S VFSTR="PT"_U_$P(FX,",")
 ....S $P(VFSTR,U,3)=$G(VFDATA(FNUM,FX,1,FNS))
 ....S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..;For the EKGFindings, create a separate set of EF and EFT records for each multiple
 ..S FNUM=$$FNUM_14
 ..S FX="" F  S FX=$O(VFDATA(FNUM,FX)) Q:FX=""  D
 ...S VFSTR="EF"_U_$P(FX,",")
 ...S $P(VFSTR,U,3)=VFDATA(FNUM,FX,.01,"I") ;EkgFindingsConceptId
 ...;S $P(VFSTR,U,4)=VFDATA(FNUM,FX,.02,"I") ;Description ID
 ...S PNAR=VFDATA(FNUM,FX,.03,"I")
 ...I +PNAR S $P(VFSTR,U,4)=$P($P($G(^AUTNPOV(PNAR,0)),U,1),"|",1) ;Provider text
 ...;S $P(VFSTR,U,6)=VFDATA(FNUM,FX,.04,"I") ;ICD9 Mapping
 ...;S $P(VFSTR,U,6)=VFDATA(FNUM,FX,.05,"I") ;ICD10 Mapping
 ...S $P(VFSTR,U,5)=VFDATA(FNUM,FX,.06,"I") ;Interpreted By
 ...S $P(VFSTR,U,6)=VFDATA(FNUM,FX,.07,"I") ;Event Date/Time
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ...; Add the comment lines
 ...S FNS=0 F  S FNS=$O(VFDATA(FNUM,FX,1,FNS)) Q:'FNS  D
 ....S VFSTR="EFT"_U_$P(FX,",")
 ....S $P(VFSTR,U,3)=$G(VFDATA(FNUM,FX,1,FNS))
 ....S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..;For the Symptoms, create a separate set of S records for each multiple
 ..S FNUM=$$FNUM_15
 ..S FX="" F  S FX=$O(VFDATA(FNUM,FX)) Q:FX=""  D
 ...S VFSTR="S"_U_$P(FX,",")
 ...S $P(VFSTR,U,3)=VFDATA(FNUM,FX,.01,"I") ;Symptoms
 ...S $P(VFSTR,U,4)=VFDATA(FNUM,FX,.019,"I") ;Symptom Preferred Text
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 .I 'VFDEL D
 ..S COUNT=COUNT+1
 ..M @RET@(COUNT)=VFARR
 ..S @RET@(COUNT)=VFIEN_U_VFARR_U_$$ISLOCKED^BEHOENCX(VIEN) ; Reset scalar value to include the Visit File IEN
 ..K VFARR
 Q
 ; Add/edit V AMI entry
SET(RET,INP) ;EP
 ; This is the exact opposite of the GET call.
 ; INP is an array of strings.
 ; The first string is the VFIEN^NumberOfLines^VisitIsLocked, check BGOVAMI2 for input string descriptions
 S RET=""
 D SET^BGOVAMI2(.RET,.INP)
 Q
 ; Delete a Chest Pain (AMI) entry
 ;  INP = V File IEN ^  DELETE REASON ^ OTHER
 ; Logically Delete a Chest Pain (AMI) entry
 ; Flag the entry as Entered in Error
 ; Specify the Reason and Comment (if Reason is Other)
DEL(RET,INP) ;EP
 N COMMENT,FDA,REASON,VFIEN
 S VFIEN=$P(INP,U)
 S REASON=$P(INP,U,2)
 S COMMENT=$P(INP,U,3)
 I VFIEN="" S RET=$$ERR^BGOUTL(1008) Q  ; Missing input data
 I '$D(^AUPNVAMI(VFIEN)) S RET=$$ERR^BGOUTL(1035) Q  ; Item not found
 S FDA=$NA(FDA($$FNUM,VFIEN_","))
 S @FDA@(5.01)=1
 S @FDA@(5.02)=DUZ
 S @FDA@(5.03)=$$NOW^XLFDT()
 S @FDA@(5.04)=REASON
 S @FDA@(5.05)=COMMENT
 S RET=$$UPDATE^BGOUTL(.FDA,,VFIEN)
 S:RET="" RET=1
 ;Check/Delete entry in PATIENT REFUSALS FOR SERVICE/NMI file #9000022
 N REFREA
 S REFREA=$$GET1^DIQ(9000010.62,VFIEN,.17)
 I $G(REFREA)]"" D
 .N RET S RET=$$DELREF^BGOVAMI1(VFIEN)
 Q
 ; Return V File #
 ; This method signature allows this to be called as a Remote Procedure.
FNUM(RET,INP) S RET=9000010.62
 Q RET
