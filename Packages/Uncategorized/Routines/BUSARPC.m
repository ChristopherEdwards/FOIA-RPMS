BUSARPC ;GDIT/HS/BEE-IHS USER SECURITY AUDIT Utility Program ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;;Nov 05, 2013;Build 65
 ;
 Q
 ;
BMX(BUSAP) ;PEP - Log audit entry from BMXNet
 ;
 NEW BUSABKR,BUSARPC,RPCIEN,BUSAIEN,BUSADVAL,BUSAOVAL,STS,MINP
 NEW TYPE,CAT,ACT,X,DESC,XDESC,DFNLOC,DFNEXE,VSTLOC,VSTEXE
 NEW MULT,BUSADVAL,DVAL,VVAL,DETEXE,NEWEXE,ORGEXE,SKIP,ADVEXE,MINPD,MINPL
 ;
 S SKIP=""
 ;
 ;Make sure logging switch is on
 I '+$$STATUS^BUSAOPT("B") S STS="0^BMX audit logging switch is off" G XBMX
 ;
 ;Define Application Variables
 S BUSABKR="B"                  ;Set Broker to BMX
 S BUSARPC=$G(BUSAP(2,"CAPI"))  ;Get the RPC
 I BUSARPC="" S STS="0^Missing RPC" G XBMX
 ;
 ;Find RPC IEN and skip if not defined
 S RPCIEN=$O(^XWB(8994,"B",BUSARPC,0)) I RPCIEN="" S STS="0^Invalid RPC" G XBMX
 ;
 ;See if RPC is set up to be audited
 S BUSAIEN=$O(^BUSA(9002319.03,"B",BUSARPC,"")) I BUSAIEN="" S STS="0^RPC not set to be tracked" G XBMX
 ;
 ;Check for inactive
 I $$GET1^DIQ(9002319.03,BUSAIEN_",",.07,"I") S STS="0^RPC call is inactive" G XBMX
 ;
 ;Pull definition
 S STS=$$DEF(BUSAIEN,.BUSAD) I 'STS G XBMX
 ;
 ;Assemble Summary Information
 ;
 ;Define Type as RPC
 S TYPE="R"
 ;
 ;Pull the CATEGORY
 S CAT=$G(BUSAD(.02)) I CAT="" S STS="0^Invalid definition category" G XBMX
 ;
 ;Pull the ACTION
 S ACT=$G(BUSAD(.03))
 ;
 ;Determine the Entry Description
 S X="",XDESC=$G(BUSAD(.06)) X:XDESC]"" XDESC
 S DESC=$G(X)
 ;
 ;Assemble Detail Information
 ;
 ;Retrieve DFN definition
 S DFNLOC=$G(BUSAD(1.01))
 S DFNEXE=$G(BUSAD(1.02))
 ;
 ;Retrieve VIEN definition
 S VSTLOC=$G(BUSAD(2.01))
 S VSTEXE=$G(BUSAD(2.02))
 ;
 ;Retrieve Multiple input info
 S MINP=0
 S MINPL=$G(BUSAD(2.03))
 S MINPD=$G(BUSAD(2.04))
 I MINPL]"",MINPD]"" S MINP=1
 ;
 ;Look for multiple results
 S MULT=0 I $P(DFNLOC,"^")="R"!($P(VSTLOC,"^")="R") S MULT=1
 I MINP,MULT S STS="0^DFN/VIEN cannot be pulled from both multiple inputs and results" G XBMX
 ;
 ;Stuff the DFN
 I $P(DFNLOC,U,2)]"" S STS=$$VAL^BUSAUTIL($P(DFNLOC,U),$P(DFNLOC,U,2),"B",BUSARPC,.DVAL) I 'STS G XBMX
 I MINP=1,MINPL="D" D MINP^BUSAUTIL(.DVAL,MINPD,MINPL,DFNEXE,.BUSADVAL) ;Multiple Input DFNs
 I MINP=0 D BFILE^BUSAUTIL(.DVAL,.BUSADVAL,1,DFNEXE,MULT,MINP) ;Single DFN or Result DFNs
 ;
 ;Stuff the VIEN (and possibly the DFN)
 I $P(VSTLOC,U,2)]"" S STS=$$VAL^BUSAUTIL($P(VSTLOC,U),$P(VSTLOC,U,2),"B",BUSARPC,.VVAL) I 'STS G XBMX
 I MINP=1,MINPL="V" D MINP^BUSAUTIL(.VVAL,MINPD,MINPL,VSTEXE,.BUSADVAL) ;Multiple Input VIENs
 I MINP=0 D BFILE^BUSAUTIL(.VVAL,.BUSADVAL,2,VSTEXE,MULT,MINP) ;Single VIEN or Result VIENs
 ;
 ;Stuff the detail description
 S DETEXE=$G(BUSAD(3))
 I DETEXE]"" D BFILE^BUSAUTIL("",.BUSADVAL,3,DETEXE,MULT,MINP)
 ;
 ;Stuff the new value
 S NEWEXE=$G(BUSAD(4))
 I NEWEXE]"" D BFILE^BUSAUTIL("",.BUSADVAL,4,NEWEXE,MULT,MINP)
 ;
 ;Stuff the original value
 S ORGEXE=$G(BUSAD(5))
 I ORGEXE]"" D BFILE^BUSAUTIL("",.BUSADVAL,5,ORGEXE,MULT,MINP)
 ;
 ;Advance definition executable
 S ADVEXE=$G(BUSAD(6))
 I ADVEXE]"" X ADVEXE
 ;
 ;Look for SKIP
 I +$G(SKIP) S STS="0^Skipped log entry" G XBMX
 ;
 ;Make API call
 S STS=$$LOG^BUSAAPI(TYPE,CAT,ACT,BUSARPC,DESC,"BUSADVAL")
 ;
XBMX Q STS
 ;
CIA(XWBPTYPE,RTN,BUSAARY) ;PEP - Log audit entry from CIA Broker
 ;
 ;Make sure logging switch is on
 I '+$$STATUS^BUSAOPT("C") S STS="0^CIA Broker audit logging switch is off" G XCIA
 ;
 NEW BUSABKR,BUSARPC,RPCIEN,BUSAIEN,BUSADVAL,BUSAOVAL,STS,MINP
 NEW TYPE,CAT,ACT,X,DESC,XDESC,DFNLOC,DFNEXE,VSTLOC,VSTEXE
 NEW MULT,BUSADVAL,DVAL,VVAL,DETEXE,NEWEXE,ORGEXE,SKIP,ADVEXE,MINPD,MINPL
 ;
 ;Define Application Variables
 S BUSABKR="C"                  ;Set Broker to CIA
 S BUSARPC=$G(BUSAARY)  ;Get the RPC
 I BUSARPC="" S STS="0^Missing RPC" G XCIA
 S SKIP=""
 ;
 ;Find RPC IEN and skip if not defined
 S RPCIEN=$O(^XWB(8994,"B",BUSARPC,0)) I RPCIEN="" S STS="0^Invalid RPC" G XCIA
 ;
 ;See if RPC is set up to be audited
 S BUSAIEN=$O(^BUSA(9002319.03,"B",BUSARPC,"")) I BUSAIEN="" S STS="0^RPC not set to be tracked" G XCIA
 ;
 ;Check for inactive
 I $$GET1^DIQ(9002319.03,BUSAIEN_",",.07,"I") S STS="0^RPC call is inactive" G XCIA
 ;
 ;Pull definition
 S STS=$$DEF(BUSAIEN,.BUSAD) I 'STS G XCIA
 ;
 ;Assemble Summary Information
 ;
 ;Define Type as RPC
 S TYPE="R"
 ;
 ;Pull the CATEGORY
 S CAT=$G(BUSAD(.02)) I CAT="" S STS="0^Invalid definition category" G XCIA
 ;
 ;Pull the ACTION
 S ACT=$G(BUSAD(.03))
 ;
 ;Determine the Entry Description
 S X="",XDESC=$G(BUSAD(.06)),XDESC=$TR(XDESC,"~","^") X:XDESC]"" XDESC
 S DESC=$G(X)
 ;
 ;Assemble Detail Information
 ;
 ;Retrieve DFN definition
 S DFNLOC=$G(BUSAD(1.01))
 S DFNEXE=$G(BUSAD(1.02))
 ;
 ;Retrieve VIEN definition
 S VSTLOC=$G(BUSAD(2.01))
 S VSTEXE=$G(BUSAD(2.02))
 ;
 ;Retrieve Multiple input info
 S MINP=0
 S MINPL=$G(BUSAD(2.03))
 S MINPD=$G(BUSAD(2.04))
 I MINPL]"",MINPD]"" S MINP=1
 ;
 ;Look for multiple results
 S MULT=0 I $P(DFNLOC,"^")="R"!($P(VSTLOC,"^")="R") S MULT=1
 I MINP,MULT S STS="0^DFN/VIEN cannot be pulled from both multiple inputs and results" G XCIA
 ;
 ;Stuff the DFN
 I $P(DFNLOC,U,2)]"" S STS=$$VAL^BUSAUTIL($P(DFNLOC,U),$P(DFNLOC,U,2),"C",BUSARPC,.DVAL) I 'STS G XCIA
 I MINP=1,MINPL="D" D MINP^BUSAUTIL(.DVAL,MINPD,MINPL,DFNEXE,.BUSADVAL) ;Multiple Input DFNs
 I MINP=0 D CFILE^BUSAUTIL(.DVAL,.BUSADVAL,1,DFNEXE,MULT,MINP) ;Single DFN or Result DFNs
 ;
 ;Stuff the VIEN
 I $P(VSTLOC,U,2)]"" S STS=$$VAL^BUSAUTIL($P(VSTLOC,U),$P(VSTLOC,U,2),"C",BUSARPC,.VVAL) I 'STS G XCIA
 I MINP=1,MINPL="V" D MINP^BUSAUTIL(.VVAL,MINPD,MINPL,VSTEXE,.BUSADVAL) ;Multiple Input VIENs
 I MINP=0 D CFILE^BUSAUTIL(.VVAL,.BUSADVAL,2,VSTEXE,MULT,MINP) ;Single VIEN or Result VIENs
 ;
 ;Stuff the detail description
 S DETEXE=$G(BUSAD(3))
 I DETEXE]"" D CFILE^BUSAUTIL("",.BUSADVAL,3,DETEXE,MULT,MINP)
 ;
 ;Stuff the new value
 S NEWEXE=$G(BUSAD(4))
 I NEWEXE]"" D CFILE^BUSAUTIL("",.BUSADVAL,4,NEWEXE,MULT,MINP)
 ;
 ;Stuff the original value
 S ORGEXE=$G(BUSAD(5))
 I ORGEXE]"" D CFILE^BUSAUTIL("",.BUSADVAL,5,ORGEXE,MULT,MINP)
 ;
 ;Advance definition executable
 S ADVEXE=$G(BUSAD(6))
 I ADVEXE]"" X ADVEXE
 ;
 ;Look for SKIP
 I +$G(SKIP) S STS="0^Skipped log entry" G XCIA
 ;
 ;Create the log entry
 S STS=$$LOG^BUSAAPI(TYPE,CAT,ACT,BUSARPC,DESC,"BUSADVAL")
 ;
XCIA Q STS
 ;
XWB(BUSAP) ;PEP - Log audit entry from XWB Broker
 ;
 NEW BUSABKR,BUSARPC,RPCIEN,BUSAIEN,BUSADVAL,BUSAOVAL,STS,MINP
 NEW TYPE,CAT,ACT,X,DESC,XDESC,DFNLOC,DFNEXE,VSTLOC,VSTEXE
 NEW MULT,BUSADVAL,DVAL,VVAL,DETEXE,NEWEXE,ORGEXE,SKIP,ADVEXE,MINPD,MINPL
 ;
 S SKIP=""
 ;
 ;Make sure logging switch is on
 I '+$$STATUS^BUSAOPT("B") S STS="0^BMX audit logging switch is off" G XXWB
 ;
 ;Define Application Variables
 S BUSABKR="W"                  ;Set Broker to XWB Broker
 ;
 ;Get the RPC
 S BUSARPC=$G(BUSAP(2,"RPC")) S:BUSARPC="" BUSARPC=$G(BUSAP(2,"CAPI"))
 I BUSARPC="" S STS="0^Missing RPC" G XXWB
 ;
 ;Find RPC IEN and skip if not defined
 S RPCIEN=$O(^XWB(8994,"B",BUSARPC,0)) I RPCIEN="" S STS="0^Invalid RPC" G XXWB
 ;
 ;See if RPC is set up to be audited
 S BUSAIEN=$O(^BUSA(9002319.03,"B",BUSARPC,"")) I BUSAIEN="" S STS="0^RPC not set to be tracked" G XXWB
 ;
 ;Check for inactive
 I $$GET1^DIQ(9002319.03,BUSAIEN_",",.07,"I") S STS="0^RPC call is inactive" G XXWB
 ;
 ;Pull definition
 S STS=$$DEF(BUSAIEN,.BUSAD) I 'STS G XXWB
 ;
 ;Assemble Summary Information
 ;
 ;Define Type as RPC
 S TYPE="R"
 ;
 ;Pull the CATEGORY
 S CAT=$G(BUSAD(.02)) I CAT="" S STS="0^Invalid definition category" G XXWB
 ;
 ;Pull the ACTION
 S ACT=$G(BUSAD(.03))
 ;
 ;Determine the Entry Description
 S X="",XDESC=$G(BUSAD(.06)) X:XDESC]"" XDESC
 S DESC=$G(X)
 ;
 ;Assemble Detail Information
 ;
 ;Retrieve DFN definition
 S DFNLOC=$G(BUSAD(1.01))
 S DFNEXE=$G(BUSAD(1.02))
 ;
 ;Retrieve VIEN definition
 S VSTLOC=$G(BUSAD(2.01))
 S VSTEXE=$G(BUSAD(2.02))
 ;
 ;Retrieve Multiple input info
 S MINP=0
 S MINPL=$G(BUSAD(2.03))
 S MINPD=$G(BUSAD(2.04))
 I MINPL]"",MINPD]"" S MINP=1
 ;
 ;Look for multiple results
 S MULT=0 I $P(DFNLOC,"^")="R"!($P(VSTLOC,"^")="R") S MULT=1
 I MINP,MULT S STS="0^DFN/VIEN cannot be pulled from both multiple inputs and results" G XXWB
 ;
 ;Stuff the DFN
 I $P(DFNLOC,U,2)]"" S STS=$$VAL^BUSAUTIL($P(DFNLOC,U),$P(DFNLOC,U,2),"W",BUSARPC,.DVAL) I 'STS G XXWB
 I MINP=1,MINPL="D" D MINP^BUSAUTIL(.DVAL,MINPD,MINPL,DFNEXE,.BUSADVAL) ;Multiple Input DFNs
 I MINP=0 D WFILE^BUSAUTIL(.DVAL,.BUSADVAL,1,DFNEXE,MULT,MINP) ;Single DFN or Result DFNs
 ;
 ;Stuff the VIEN (and possibly the DFN)
 I $P(VSTLOC,U,2)]"" S STS=$$VAL^BUSAUTIL($P(VSTLOC,U),$P(VSTLOC,U,2),"W",BUSARPC,.VVAL) I 'STS G XXWB
 I MINP=1,MINPL="V" D MINP^BUSAUTIL(.VVAL,MINPD,MINPL,VSTEXE,.BUSADVAL) ;Multiple Input VIENs
 I MINP=0 D WFILE^BUSAUTIL(.VVAL,.BUSADVAL,2,VSTEXE,MULT,MINP) ;Single VIEN or Result VIENs
 ;
 ;Stuff the detail description
 S DETEXE=$G(BUSAD(3))
 I DETEXE]"" D WFILE^BUSAUTIL("",.BUSADVAL,3,DETEXE,MULT,MINP)
 ;
 ;Stuff the new value
 S NEWEXE=$G(BUSAD(4))
 I NEWEXE]"" D WFILE^BUSAUTIL("",.BUSADVAL,4,NEWEXE,MULT,MINP)
 ;
 ;Stuff the original value
 S ORGEXE=$G(BUSAD(5))
 I ORGEXE]"" D WFILE^BUSAUTIL("",.BUSADVAL,5,ORGEXE,MULT,MINP)
 ;
 ;Advance definition executable
 S ADVEXE=$G(BUSAD(6))
 I ADVEXE]"" X ADVEXE
 ;
 ;Look for SKIP
 I +$G(SKIP) S STS="0^Skipped log entry" G XXWB
 ;
 ;Make API call
 S STS=$$LOG^BUSAAPI(TYPE,CAT,ACT,BUSARPC,DESC,"BUSADVAL")
 ;
XXWB Q STS
 ;
DEF(BUSAIEN,BUSAD) ;EP - Set up entry definition array
 ;
 NEW FLD
 F FLD=".01",".02",".03",".06",1.01,1.02,2.01,2.02,2.03,2.04,3,4,5,6 S BUSAD(FLD)=$TR($$GET1^DIQ(9002319.03,BUSAIEN_",",FLD,"I"),"~","^")
 Q $S($D(BUSAD)>1:1,1:"0^Invalid Definition")
 ;
RPC(DATA,INPUT) ;EP - BUSA LOG SECURITY AUDIT ENTRY
 ;
 ; Required variable:
 ;   DUZ - Pointer to NEW PERSON (#200) file
 ; 
 ;Input Parameters:
 ;
 ; INPUT
 ; 
 ; Piece ("|" delimiter)
 ;
 ; 1 - CAT (Required)    - The category of the event to log (S:System Event;
 ;                         P:Patient Related;D:Definition Change;O:Other Event)
 ; 2 - ACTION (Required for CAT="P") - The action for the event to log 
 ;                         (A:Additions;D:Deletions;Q:Queries;P:Print;
 ;                         E:Changes;C:Copy)
 ; 3 - CALL - (Required) - Free text entry describing the call which 
 ;                         originated the audit event (Maximum length
 ;                         200 characters)
 ;                         Examples could be an RPC value or calling
 ;                         routine
 ; 4 - DESC - (Required) - Free text entry describing the call action
 ;                         (Maximum length 250 characters)
 ;                         Examples could be 'Patient demographic update',
 ;                         'Copied iCare panel to clipboard' or 'POV Entry'
 ; 5 - DETAIL (Required for CAT="P") - Delimited list of patient/visit records
 ;                         to log. Required for patient related events. 
 ;                         Optional for other event types
 ;
 ; Format: DETAIL = DFN1_$C(29)_VIEN1_$C(29)_EVENT DESCRIPTION1_$C(29)_NEW VALUE1 ...
 ;                  ... _$C(29)_ORIGINAL VALUE1_$C(28)_DFN2_$C(29)_VIEN2_$C(29) ...
 ;                  ... _EVENT DESCRIPTION2_$C(29)_NEW VALUE2_$C(29)_ORIGINAL VALUE2 ...
 ;                  ... $C(28)_DFN3 ...
 ;
 ; Where:
 ; DFN# - (Optional for non-patient related calls) - Pointer to VA PATIENT file (#2)
 ; VIEN# - (Optional for non-visit related calls) - Pointer to VISIT file (#9000010)
 ; EVENT DESCRIPTION# -(Optional) - Additional detail to log for this entry
 ; NEW VALUE# - (Optional) - New value after call completion, if applicable
 ; ORIGINAL VALUE# - (Optional) - Original value prior to call execution, if applicable
 ;
 NEW CAT,ACTION,CALL,DESC,DETAIL,DCNT,I,DET,BUSAII,UID,RES,ENTRY
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BUSARPC",UID))
 K @DATA
 ;
 S BUSAII=0
 ;
 ;Create header
 S @DATA@(0)="I00001RESULT^T00250ERROR_MESSAGE"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BUSARPC D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Check for DUZ
 I $G(DUZ)="" S RES="0^DUZ is not defined" G XBRPC
 ;
 ;Move input to local variables
 S INPUT=$G(INPUT,"")
 S CAT=$P(INPUT,"|")
 S ACTION=$P(INPUT,"|",2)
 S CALL=$P(INPUT,"|",3)
 S DESC=$P(INPUT,"|",4)
 S DETAIL=$P(INPUT,"|",5)
 ;
 ;Format DETAIL
 S DCNT=0
 F I=1:1:$L(DETAIL,$C(28)) S ENTRY=$P(DETAIL,$C(28),I) I $TR(ENTRY,$C(29))]"" D
 . NEW DFN,VIEN,EDESC,NVAL,OVAL
 . S DFN=$P(ENTRY,$C(29))
 . S VIEN=$P(ENTRY,$C(29),2)
 . S EDESC=$P(ENTRY,$C(29),3)
 . S NVAL=$P(ENTRY,$C(29),4)
 . S OVAL=$P(ENTRY,$C(29),5)
 . S DCNT=DCNT+1
 . S DET(DCNT)=DFN_U_VIEN_U_EDESC_U_NVAL_U_OVAL
 ;
 ;Perform the call
 S RES=$$LOG^BUSAAPI("R",CAT,ACTION,CALL,DESC,"DET")
 ;
XBRPC S BUSAII=BUSAII+1,@DATA@(BUSAII)=RES_$C(30)
 S BUSAII=BUSAII+1,@DATA@(BUSAII)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BUSAII),$D(DATA) S BUSAII=BUSAII+1,@DATA@(BUSAII)=$C(31)
 Q
