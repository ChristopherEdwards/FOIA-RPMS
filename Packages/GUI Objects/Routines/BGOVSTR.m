BGOVSTR ; MSC/JS - Manage V STROKE ;30-Apr-2014 14;38;DKA
 ;;1.1;BGO COMPONENTS;**13,14**;Mar 20, 2007
 ;12.30.13 - MSC/JS add translation for Midnight, test in both pxiijs and pfrteen
 ;01.08.14 - MSC/DKA Send "@" to filer to delete comments when they are blank in the SET call.
 ;01.09.14 - MSC/JS delete fibrinolytic fields for fibrin therapy initiated or fibrin therapy refused.
 ;01.09.14 - MSC/DKA Remove calls to MIDGET() and MIDSET() because GUI got changed.
 ;                   Added code to change date only values to midnight (<Date-1>.24),
 ;                   and code to delete dates when they are blank.
 ;01.13.14 - MSC/JS moved GETVFIEN and NARR code to BGOVSTR1, reduce comments
 ;01.17.14 - MSC/JS - p13 update fixes added (IHS CCB items from Monday IHS call 1/13)
 ;01.24.14 - MSC/JS - moved SET code to BGOVSTR2 to keep routine size within 15k limit
 ;04.30.14 - MSC/DKA Corrected the order of the Scores (N) and their comments (MA,ML,LA,DY)
 ;
 ;Get STROKE by individual entry, visit, or patient
 ; INP = Patient IEN [1] ^ V File IEN [2] ^ Visit IEN [3]
GET(RET,INP) ;EP
 N COUNT,FNUM,FN,FNS,FX,DIDNOT,Z2,INDX,IENARR,VFARR,VFDATA,VFFLD,VFMSG,VFSTR,VIEN,VFDEL,DNIR,ARRDT,EVTDT,RETMID
 S RET=$$TMPGBL^BGOUTL,FNUM=$$FNUM,COUNT=0
 ; Get the V file IEN value(s)
 ; The number of values returned in IENARR
 D GETVFIEN^BGOVSTR1(.IENARR,INP)
 I +$G(IENARR)=0 S @RET@(0)=$$ERR^BGOUTL(1035) Q  ; Indicate there's an unexplained error (Item not found)
 I IENARR<0 S @RET@(0)=IENARR Q
 F INDX=1:1:IENARR D
 .S FNUM=$$FNUM ; Reset for each iteration
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
 ..S ARRDT=VFDATA(FNUM,FX,.01,"I")
 ..S $P(VFSTR,U,2)=ARRDT ;ArrivalDateTime
 ..S $P(VFSTR,U,3)=VFDATA(FNUM,FX,.02,"I") ;PatientName
 ..S (VIEN,$P(VFSTR,U,4))=VFDATA(FNUM,FX,.03,"I") ;Visit
 ..S $P(VFSTR,U,5)=VFDATA(FNUM,FX,.04,"I") ;Handedness
 ..S $P(VFSTR,U,6)=VFDATA(FNUM,FX,1203,"I") ;Clinic
 ..S $P(VFSTR,U,7)=VFDATA(FNUM,FX,1204,"I") ;EncounterProvider
 ..S EVTDT=VFDATA(FNUM,FX,1201,"I")
 ..S $P(VFSTR,U,8)=EVTDT ;EventDateTime
 ..S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..; Add the comment lines from field 1 on separate "AT" records
 ..S FNS=0
 ..F  S FNS=$O(VFDATA(FNUM,FX,1,FNS)) Q:'FNS  D
 ...S VFSTR="AT"
 ...S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,1,FNS))
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..S VFSTR="F"
 ..S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,.11,"I")) ;FibrinolyticTherapyInitiated
 ..S $P(VFSTR,U,3)=VFDATA(FNUM,FX,.12,"I") ;FibDateEntered
 ..S $P(VFSTR,U,4)=VFDATA(FNUM,FX,.13,"I") ;FibEnteredBy
 ..S $P(VFSTR,U,5)=$G(VFDATA(FNUM,FX,.14,"I")) ;DidNotInit
 ..S $P(VFSTR,U,6)=VFDATA(FNUM,FX,.15,"I") ;DidnotInitDateTime
 ..S $P(VFSTR,U,7)=VFDATA(FNUM,FX,.16,"I") ;DidnotInitEnteredBy
 ..S DIDNOT=$G(VFDATA(FNUM,FX,.17,"I")) ;DidnotInitReason
 ..I $L(DIDNOT)<4 S $P(VFSTR,U,8)=DIDNOT
 ..E  S Z2=$O(^AUTTREFR("B",DIDNOT,"")) S $P(VFSTR,U,8)=Z2
 ..S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..; Add the comment lines from field 4 on separate "FT" records
 ..S FNS=0 F  S FNS=$O(VFDATA(FNUM,FX,4,FNS)) Q:'FNS  D
 ...S VFSTR="FT"
 ...S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,4,FNS))
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..;For NIH STROKE SCALE, create a separate set of N records for each multiple
 ..S FNUM=$$FNUM_15
 ..S FX="" F  S FX=$O(VFDATA(FNUM,FX)) Q:FX=""  D
 ...S VFSTR="N"_U_$P(FX,",")
 ...S $P(VFSTR,U,3)=$G(VFDATA(FNUM,FX,.01,"I")) ;NihStrokeScale
 ...S $P(VFSTR,U,4)=$G(VFDATA(FNUM,FX,.02,"I")) ;EventDateTime
 ...S $P(VFSTR,U,5)=$G(VFDATA(FNUM,FX,.03,"I")) ;EnteredBy
 ...S $P(VFSTR,U,6)=$G(VFDATA(FNUM,FX,.04,"I")) ;LOC
 ...S $P(VFSTR,U,7)=$G(VFDATA(FNUM,FX,.05,"I")) ;LOCquestions
 ...S $P(VFSTR,U,8)=$G(VFDATA(FNUM,FX,.06,"I")) ;LOCcommands
 ...S $P(VFSTR,U,9)=$G(VFDATA(FNUM,FX,.07,"I")) ;StrokeScale2BestGaze
 ...S $P(VFSTR,U,10)=$G(VFDATA(FNUM,FX,.08,"I")) ;Visual
 ...S $P(VFSTR,U,11)=$G(VFDATA(FNUM,FX,.09,"I")) ;StrokeScaleFacialPalsy
 ...S $P(VFSTR,U,12)=$G(VFDATA(FNUM,FX,.1,"I")) ;MotorArmLeft
 ...S $P(VFSTR,U,13)=$G(VFDATA(FNUM,FX,.11,"I")) ;MotorArmRight
 ...S $P(VFSTR,U,14)=$G(VFDATA(FNUM,FX,.12,"I")) ;MotorLegRight
 ...S $P(VFSTR,U,15)=$G(VFDATA(FNUM,FX,.13,"I")) ;MotorLegLeft
 ...S $P(VFSTR,U,16)=$G(VFDATA(FNUM,FX,.14,"I")) ;LimbAtaxia
 ...S $P(VFSTR,U,17)=$G(VFDATA(FNUM,FX,.15,"I")) ;Sensory
 ...S $P(VFSTR,U,18)=$G(VFDATA(FNUM,FX,.16,"I")) ;BestLanguage
 ...S $P(VFSTR,U,19)=$G(VFDATA(FNUM,FX,.17,"I")) ;Dysarthria
 ...S $P(VFSTR,U,20)=$G(VFDATA(FNUM,FX,.18,"I")) ;ExtinctionInattention
 ...S $P(VFSTR,U,21)=$G(VFDATA(FNUM,FX,.19,"I")) ;TotalStrokeScore
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ...;For NIH STROKE SCALE MOTOR ARM COMMENTS, create a separate MA record
 ...S VFSTR="MA"_U_$P(FX,",")
 ...S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,1.01,"I")) ;Motor Arm Left Comment
 ...S $P(VFSTR,U,3)=$G(VFDATA(FNUM,FX,1.02,"I")) ;Motor Arm Right Comment
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ...;For NIH STROKE SCALE MOTOR LEG COMMENTS, create a separate ML record
 ...S VFSTR="ML"_U_$P(FX,",")
 ...S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,2.01,"I")) ;Motor Leg Right Comment
 ...S $P(VFSTR,U,3)=$G(VFDATA(FNUM,FX,2.02,"I")) ;Motor Leg Left Comment
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ...;For NIH STROKE SCALE LIMB ATAXIA COMMENT, create a separate LA record
 ...S VFSTR="LA"_U_$P(FX,",")
 ...S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,3.01,"I")) ;Limb Ataxia Comment
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ...;For NIH STROKE SCALE DYSARTHRIA COMMENT, create a separate DY record
 ...S VFSTR="DY"_U_$P(FX,",")
 ...S $P(VFSTR,U,2)=$G(VFDATA(FNUM,FX,3.02,"I")) ;Dysarthria Comment
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..;For PROTOCOL STANDING ORDERS, create P and PT records for each multiple
 ..S FNUM=$$FNUM_13
 ..S FX="" F  S FX=$O(VFDATA(FNUM,FX)) Q:FX=""  D
 ...S VFSTR="P"_U_$P(FX,",")
 ...S $P(VFSTR,U,3)=$G(VFDATA(FNUM,FX,.01,"I")) ;ProtocolStandingOrders
 ...S $P(VFSTR,U,4)=$G(VFDATA(FNUM,FX,.02,"I")) ;EventDateTime
 ...S $P(VFSTR,U,5)=$G(VFDATA(FNUM,FX,.03,"I")) ;Date/Time Entered
 ...S $P(VFSTR,U,6)=$G(VFDATA(FNUM,FX,.04,"I")) ;Entered By
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ...; Add comment lines for "PT" record
 ...S FNS=0 F  S FNS=$O(VFDATA(FNUM,FX,1,FNS)) Q:'FNS  D
 ....S VFSTR="PT"_U_$P(FX,",")
 ....S $P(VFSTR,U,3)=$G(VFDATA(FNUM,FX,1,FNS))
 ....S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..;For STROKE SYMPTOMS, create S and ST records for each multiple
 ..S FNUM=$$FNUM_14
 ..S FX="" F  S FX=$O(VFDATA(FNUM,FX)) Q:FX=""  D
 ...S VFSTR="SS"_U_$P(FX,",")
 ...S $P(VFSTR,U,3)=$G(VFDATA(FNUM,FX,.01,"I")) ;ConceptID
 ...S $P(VFSTR,U,4)=$G(VFDATA(FNUM,FX,.019,"I")) ;SnomedPreferredTerm
 ...S $P(VFSTR,U,5)=$G(VFDATA(FNUM,FX,.02,"I")) ;DescriptionID
 ...S $P(VFSTR,U,6)=$P($G(VFDATA(FNUM,FX,.03,"E")),"|",1) ;ProviderText
 ...S $P(VFSTR,U,7)=$G(VFDATA(FNUM,FX,.04,"I")) ;DateTimeEntered
 ...S $P(VFSTR,U,8)=$G(VFDATA(FNUM,FX,.05,"I")) ;EnteredBy
 ...S $P(VFSTR,U,9)=$G(VFDATA(FNUM,FX,.06,"I")) ;Witnessed?
 ...S $P(VFSTR,U,10)=$G(VFDATA(FNUM,FX,.07,"I")) ;WitnessedBy
 ...S $P(VFSTR,U,11)=$G(VFDATA(FNUM,FX,.08,"I")) ;DateTimeWitnessed
 ...S $P(VFSTR,U,12)=$G(VFDATA(FNUM,FX,.09,"I")) ;BaselineStateLoinc
 ...S $P(VFSTR,U,13)=$G(VFDATA(FNUM,FX,.1,"I")) ;BaselineStateDateTime
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ...; Add the STROKE SYMPTOMS COMMENT lines on "ST" records
 ...S FNS=0 F  S FNS=$O(VFDATA(FNUM,FX,1,FNS)) Q:'FNS  D
 ....S VFSTR="ST"_U_$P(FX,",")
 ....S $P(VFSTR,U,3)=$G(VFDATA(FNUM,FX,1,FNS))
 ....S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 ..; For HANDEDNESS SNOMED CT, create a separate set of HS records for each multiple
 ..S FNUM=$$FNUM_2
 ..S FX="" F  S FX=$O(VFDATA(FNUM,FX)) Q:FX=""  D
 ...S VFSTR="HS"_U_$P(FX,",")
 ...S $P(VFSTR,U,3)=$G(VFDATA(FNUM,FX,.01,"I")) ; HandednessSnomedCode
 ...S $P(VFSTR,U,4)=$G(VFDATA(FNUM,FX,.019,"I")) ;HandednessPreferredTerm
 ...S VFARR=VFARR+1,VFARR(VFARR)=VFSTR
 .I 'VFDEL D
 ..S COUNT=COUNT+1
 ..M @RET@(COUNT)=VFARR
 ..S @RET@(COUNT)=VFIEN_U_VFARR_U_$$ISLOCKED^BEHOENCX(VIEN) ; Reset value to include the Visit File IEN
 ..K VFARR
 Q RET
SET(RET,INP) ;EP
 ;Add/edit V STROKE entry
 ;The first string is the VFIEN^NumberOfLines^VisitIsLocked, check BGOVSTR2 for input string descriptions
 S RET=""
 D SET^BGOVSTR2(.RET,.INP)
 Q
 ; Logically Delete a STROKE entry
 ; INP = V File IEN ^  DELETE REASON ^ OTHER
 ; Flag the entry as Entered in Error
 ; Specify the Reason and Comment (if Reason is Other)
 ; Update V Measurement file LKW and NSST entries EIE
DEL(RET,INP) ;EP
 N COMMENT,FDA,REASON,VFIEN
 S VFIEN=$P(INP,U)
 S REASON=$P(INP,U,2)
 S COMMENT=$P(INP,U,3)
 I VFIEN="" S RET=$$ERR^BGOUTL(1008) Q
 I '$D(^AUPNVSTR(VFIEN)) S RET=$$ERR^BGOUTL(1035) Q
 S FDA=$NA(FDA($$FNUM,VFIEN_","))
 S @FDA@(5.01)=1
 S @FDA@(5.02)=DUZ
 S @FDA@(5.03)=$$NOW^XLFDT()
 S @FDA@(5.04)=REASON
 S @FDA@(5.05)=COMMENT
 S RET=$$UPDATE^BGOUTL(.FDA,,VFIEN)
 S:RET="" RET=1
 N REFREA
 S REFREA=$$GET1^DIQ(9000010.63,VFIEN,.17)
 I $G(REFREA)]"" D
 .N RET S RET=$$DELREF^BGOVSTR1(VFIEN)
 D EIEVM^BGOVSTR1(.RET2,VFIEN)
 Q
 ; Return V File #
FNUM(RET,INP) S RET=9000010.63
 Q RET
