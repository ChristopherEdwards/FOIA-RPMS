ABSPOSCB ; IHS/FCS/DRS - VMEDS(*) prep for ABSP(*) ;    [ 09/12/2002  10:07 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ; Called from ABSPOSCA from ABSPOSQG from ABSPOSQ2
 ;Setup ABSP() array which contains all pertinent data to create
 ;Claim Submission Records for the current Billing Item Record:
 ;
 ;Parameters:  DIALOUT   - Dial-out (9002313.55)
 ;            .ABSP      - Formatted array containing data required
 ;                         to create claim submission records
 ;----------------------------------------------------------------------
 ;
 Q
ABSP(DIALOUT,ABSP) ;EP
 I $D(RXILIST)<10 D IMPOSS^ABSPOSUE("P","TI","bad RXILIST",,,$T(+0))
 N PATIEN,VMEDS,NMEDS,INSURER,INSPINS,VSTIEN,INDEX
 D  ; set up some vars and make very sure some basic data exists
 . N RXI,R0,R1 S RXI=$O(RXILIST(""))
 . S R0=^ABSPT(RXI,0),R1=^(1)
 . S PATIEN=$P(R0,U,6)
 . S VSTIEN=$P(R0,U,7)
 . S INSURER=$P(R1,U,6)
 . S INSPINS=$P(R1,U,8),INSPINS=$P(^ABSPT(RXI,6),U,INSPINS)
 . I 'PATIEN D IMPOSS^ABSPOSUE("DB","TI","PATIEN",,,$T(+0))
 . I '$D(^DPT(PATIEN,0)) D IMPOSS^ABSPOSUE("DB","TI","^DPT(PATIEN)",,,$T(+0))
 . I 'VSTIEN D IMPOSS^ABSPOSUE("DB","TI","VSTIEN",,,$T(+0))
 . I '$D(^AUPNVSIT(VSTIEN,0)) D IMPOSS^ABSPOSUE("DB","TI","^AUPNVSIT(VSITIEN,0)",,,$T(+0))
 ;
E ;Set up VMEDS(*)=a bunch of pointers to important stuff
 ; Somewhat vestigial but for now, it survives.
 D GETVMED(.VMEDS)
 I '$D(VMEDS) Q 551
 I 'VMEDS(0) Q 553
 ;
 ;Get general info and set up ABSP array for Patient, Insurer, Site and
 ;NCPDP record format data
 D GETINFO^ABSPOSCC(DIALOUT,PATIEN,VSTIEN,INSPINS,INSURER)
 ;
 ;Determine number of mediations returned from GetInfo procedure
 S NMEDS=+$G(VMEDS(0))
 S ABSP("RX",0)=NMEDS
 Q:NMEDS=0 552
L ;Get medication and prescription data for each medication
 F INDEX=1:1:NMEDS D MEDINFO^ABSPOSCD(VMEDS(INDEX),INDEX,INSPINS)
 Q 0
 ;----------------------------------------------------------------------
 ;Setup VMEDS() array, which contains medication and prescription data
 ;for each medication in the billing items record:
 ;
 ;            .VMEDS     - Array of V Medication IEN #s (9000010.14)
 ;                         VMEDS(0) = <Total Number>
 ;                         VMEDS(N) = $P=1 --> <V Medication IEN>
 ;                                    $P=2 --> <RXIEN>
 ;                                    $P=3 --> <RXRFIEN>
 ;                                    $P=4 --> <VCPTIEN>
 ;                                    $P=5 --> pointer to 9002313.59
 ;----------------------------------------------------------------------
GETVMED(VMEDS) ;
 ;Manage local variables
 N NEXT,COUNT,RXIEN,RXRFIEN,VMEDIEN,VCPTIEN,ABSBRXI
 ;
 ;Loop:  RXILIST(*) -> VMED(*)
 ;
 S (NEXT,COUNT)=0
 F  D  Q:'NEXT
 .S NEXT=$O(RXILIST(NEXT)) Q:'NEXT
 .S ABSBRXI=NEXT
 .;D SETSLOT^ABSPOSL(ABSBRXI) ; point to prescription's logging
 .N R0,R1 S R0=^ABSPT(ABSBRXI,0),R1=^(1)
 .S VMEDIEN="" ; don't know, don't care
 .S RXIEN=$P(R1,U,11) I 'RXIEN D IMPOSS^ABSPOSUE("DB","TI","RXIEN",,"GETVMED",$T(+0))
 .S RXRFIEN=$P(R1,U,1) I RXRFIEN="" D IMPOSS^ABSPOSUE("DB","TI","RXRFIEN",,"GETVMED",$T(+0))
 .S VCPTIEN=$P(R1,U,3)
 .S COUNT=COUNT+1
 .S VMEDS(COUNT)=VMEDIEN_U_RXIEN_U_RXRFIEN_U_VCPTIEN_U_ABSBRXI
 .;D RELSLOT^ABSPOSL ; release slot for this prescription
 ;
 S VMEDS(0)=COUNT
 Q
