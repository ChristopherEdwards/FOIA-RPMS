ABSPOSFB ; IHS/FCS/DRS - VMEDS(*) prep for ABSP(*) ;   [ 09/12/2002  10:08 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;
 ; Copied from routine ABSPOSCB on 03/20/2001.
 ; This version is for printing NCPDP forms.
 ; Goal: merge the two versions back into the same one someday.
 ; Complication with that, however:  this operates off 9002313.57
 ; but the other one works with 9002313.59
 ;----------------------------------------------------------------------
 ;
 Q
ABSP() ;EP - from ABSPOSFA - with TRANSACT(ien57)=""
 ; Returns 0 if success, nonzero if error
 ;
 ; We know that all of the transactions in the list
 ; have the same insurer, patient, visit.
 N PATIEN,VMEDS,NMEDS,INSURER,INSPINS,VSTIEN,INDEX,DIALOUT
 D  ; set up some vars and make very sure some basic data exists
 . N R0,R1,IEN57 S IEN57=$O(TRANSACT(""))
 . S R0=^ABSPTL(IEN57,0),R1=^(1)
 . S PATIEN=$P(R0,U,6)
 . S VSTIEN=$P(R0,U,7)
 . S INSURER=$P(R1,U,6)
 . S INSPINS=$P(R1,U,8),INSPINS=$P($G(^ABSPTL(IEN57,6)),U,INSPINS)
 . I 'PATIEN D CRASH
 . I '$D(^DPT(PATIEN,0)) D CRASH
 . I 'VSTIEN D CRASH
 . I '$D(^AUPNVSIT(VSTIEN,0)) D CRASH
 ;
E ;Set up VMEDS(*)=^RXI^RXR^^IEN57
 D GETVMED(.VMEDS)
 I '$D(VMEDS) Q 651
 I 'VMEDS(0) Q 652
 ;
 ;Get general info and set up ABSP array for Patient, Insurer, Site and
 ;NCPDP record format data
 ;
 S DIALOUT=0
 D GETINFO^ABSPOSFC(DIALOUT,PATIEN,VSTIEN,INSPINS,INSURER)
 ;
 ;Determine number of mediations returned from GetInfo procedure
 S NMEDS=+$G(VMEDS(0))
 S ABSP("RX",0)=NMEDS
 Q:NMEDS=0 653
L ;Get medication and prescription data for each medication
 F INDEX=1:1:NMEDS D MEDINFO^ABSPOSFD(VMEDS(INDEX),INDEX,INSPINS)
 Q 0
 ;----------------------------------------------------------------------
 ;Setup VMEDS() array, which contains medication and prescription data
 ;for each medication in the billing items record:
 ;
 ;            .VMEDS     - Array of V Medication IEN #s (9000010.14)
 ;                         VMEDS(0) = <Total Number>
 ;                         VMEDS(N) = $P=1 --> null
 ;                                    $P=2 --> <RXIEN>
 ;                                    $P=3 --> <RXRFIEN>
 ;                                    $P=4 --> null
 ;                                    $P=5 --> pointer to 9002313.57
 ;----------------------------------------------------------------------
GETVMED(VMEDS) ;
 ;Manage local variables
 N NEXT,COUNT,RXIEN,RXRFIEN,IEN57
 ;
 ;Loop:  TRANSACT(ien57)->VMED(*)
 ;
 S (NEXT,COUNT)=0
 F  D  Q:'NEXT
 .S NEXT=$O(TRANSACT(NEXT)) Q:'NEXT
 .S IEN57=NEXT
 .N R0,R1 S R0=^ABSPTL(IEN57,0),R1=^(1)
 .S VMEDIEN="" ; don't know, don't care
 .S RXIEN=$P(R1,U,11) I 'RXIEN D CRASH
 .S RXRFIEN=$P(R1,U,1) I RXRFIEN="" D CRASH
 .S COUNT=COUNT+1
 .S VMEDS(COUNT)=U_RXIEN_U_RXRFIEN_U_U_IEN57
 S VMEDS(0)=COUNT
 Q
CRASH N % Q %
