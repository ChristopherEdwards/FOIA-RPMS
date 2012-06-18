ABSPOSQB ; IHS/FCS/DRS - POS background, Part 1 ;   [ 08/20/2002  9:01 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**1,3,23**;JUN 21, 2001
 ;
 ;IHS/DSD/lwj 10/09/01 on behalf of David Slauenwhite - change 
 ; consist of one line be altered in the "C" subroutine.
 ; David reported:
 ;   I think that what happens is that CLEAR59^ABSPOSIZ always 
 ;   cleans out the 9002313.59 transaction-in-progress entry so 
 ;   that C+3 always gets null for both these fields.  The
 ;   GETDIV^ABSPOSQC computes them anew, and then C+7:C+8
 ;   stores the computed values in the correct locations so that in 
 ;   D+3, GETPHARM^ABSPOSQC will find the correct pharmacy.
 ;
 ;IHS/SD/lwj 08/20/01  NCPDP 5.1 changes
 ; New field added to point to the new DUR/PPS values file.  The
 ; pointer will reside in the Outpatient Pharmacy V6.0 file following
 ; the release of Patch 4.  For now, we are just setting up the code
 ; in anticipation of the field.  (PCS will require the DUR/PPS
 ; claim segment as part of their format.)
 ; Since the logic is similar to the Override field -I will add this
 ; new field retrieval to the same place in the code.
 ;
 ;IHS/SD/RLT - 06/21/07 - 10/18/07 - Patch 23
 ; Get DIAGNOSIS CODE POINTER from prescription file
 Q
CLAIMINF() ;EP - from ABSPOSQA
 ; Send in ABSBRXI, ABSBRXR, ABSBNDC, IEN59
 ; Fill in as much other information as possible,
 ; Every 9002313.59 field must be accounted for in here!
 ;  Even if only to say "not filled in", or to explicitly delete field. 
 ;
 N FN S FN=9002313.59
 N FDA,IEN,MSG
 N IEN59COM S IEN59COM=IEN59_","
 ;
 ; Now fill in missing information.
 ; Set up FDA(FN,IEN59_",",FIELD)=internal value
 ;
 ; ***
 ; ***  Fields in the ^(0) node
 ; ***
 ; .01 ENTRY#  already done
 ; .13 TYPE    already done  ; use $$TYPE^ABSPOSQ to infer it from IEN59 in here
 ; 1   STATUS  already done
 ; 2   PCN     not yet
 ; 3   CLAIM   not yet 
 ; 4   RESPONSE  not yet
 ;
 ; 12  VISIT        -  set up ABSBVISI
 ;
A S ABSBVISI=$P(^ABSPT(IEN59,0),U,7)
 I 'ABSBVISI D  ; need to lookup visit
 . I $$TYPE^ABSPOSQ=3 D  ; if supply item, we found visit from ^PSRX
 . . D IMPOSS^ABSPOSUE("DB,P","TI","Supply item must have visit by now.",IEN59,"A",$T(+0))
 . D VISIT^ABSPOSQC
 . S FDA(FN,IEN59COM,12)=ABSBVISI
 I 'ABSBVISI Q 12 ; result code 12 - visit lookup failed
 ;
 ; Make sure there's a VCN number assigned to this visit
 ;
A1 I $$MAKEVCN^ABSPOSQ D SETVCN^ABSPOSQD
 ;
 ; 5   PATIENT      -  set up ABSBPATI
 ;
B S ABSBPATI=$P(^ABSPT(IEN59,0),U,6)
 I 'ABSBPATI D
 . S ABSBPATI=$P(^AUPNVSIT(ABSBVISI,0),U,5)
 . S FDA(FN,IEN59COM,5)=ABSBPATI
 ;
 ; 7   LAST UPDATE  not here
 ; 14  POSITION IN CLAIM  not here
 ; 13  USER    already done
 ; 15  START TIME  already done
 ; 16  COMMS LOG    not yet
 ;
 ; ***
 ; ***  Fields in the ^(1) node
 ; ***
 ; 9   ABSBRXR  already done
 ; 10  ABSBNDC 
 S FDA(FN,IEN59COM,10)=ABSBNDC ; usually already there
 ;
 ; 8   VCPT  - at the very end, in a separate billing job,
 ;     in the billing programs, ABSPOSB* 
 ;
 ; 11  ABSBDIV           -  ABSBPDIV, pointer to ^PS(59,ABSBPDIV,*)
 ; 1.05 ABSBDIV SOURCE   -  ABSBSDIV, source = 1
 ;
C S ABSBPDIV=$P(^ABSPT(IEN59,1),U,4)
 I ABSBPDIV D
 . N X S X=^ABSPT(IEN59,1)
 . ;IHS/DSD/lwj 10/09/01 nxt line changed to line below
 . ;S ABSBSDIV=$P(X,U,4),ABSBPDIV=$P(X,U,5)  ;IHS/DSD/lwj 10/09/01
 . S ABSBPDIV=$P(X,U,4),ABSBSDIV=$P(X,U,5)   ;IHS/DSD/lwj 10/09/01
 ; end of 10/09/01 changes
 I 'ABSBPDIV D
 . D GETDIV^ABSPOSQC ; needs ABSBRXI,ABSBRXR
 . I $$TYPE^ABSPOSQ=1!($$TYPE^ABSPOSQ=2) D  ; prescription or postage
 . . S FDA(FN,IEN59COM,11)=ABSBPDIV
 . . S FDA(FN,IEN59COM,1.05)=ABSBSDIV
 ;
 ; 1.07 PHARMACY  (depends on ABSBSDIV,ABSBPDIV)
 ;
D S ABSPHARM=$P(^ABSPT(IEN59,1),U,7)
 I 'ABSPHARM D
 . D GETPHARM^ABSPOSQC
 . S FDA(FN,IEN59COM,1.07)=ABSPHARM
 ;
 ; 1.06 INSURER - see ^(6) and ^(7), below
 ; 1.08 PINS PIECE - see ^(6) and ^(7), below
 ;
 ; 1.09 PREAUTHORIZATION NUMBER
 ;  May someday need to do an extra lookup here.
 ;  Thinking of Puyallup, where an extensive preauthorization number
 ;  database scheme has been set up in the past.
 ;  (And more typically, may be handled by the NCPDP OVERRIDE
 ;
 ; 1.11 ABSBRXI  already done
 ;
 ; 1.12 RESUBMIT AFTER REVERSAL
 ;   How's that work again?  It was set by the caller, right?
 ;
 ; 1.13 NCPDP OVERRIDES
 I $$TYPE^ABSPOSQ=1!($$TYPE^ABSPOSQ=2) D
 . N ABSPRXI,ABSPRXR
 . S ABSPRXI=$$RXI^ABSPOSQ
 . S ABSPRXR=$$RXR^ABSPOSQ
 . ;N X S X=$$GETIEN^ABSPOSO($$RXI^ABSPOSQ,$$RXR^ABSPOSQ)
 . N X S X=$$GETIEN^ABSPOSO(ABSPRXI,ABSPRXR)
 . I X S FDA(FN,IEN59COM,1.13)=X
 . ;
 . ;IHS/SD/lwj 8/20/02 NCPDP 5.1 changes - add the retrieval of the
 . ; DUR/PPS pointer from the prescription file
 . ;N DUR S DUR=$$GETDUR^ABSPOSO($$RXI^ABSPOSQ,$$RXR^ABSPOSQ)
 . N DUR S DUR=$$GETDUR^ABSPOSO(ABSPRXI,ABSPRXR)
 . I DUR S FDA(FN,IEN59COM,1.14)=DUR
 . ;
 . ;IHS/SD/RLT - 06/21/07 - 10/18/07 - Patch 23
 . ; Get DIAGNOSIS CODE POINTER
 . ;N DIAG S DIAG=$$GETDIAG^ABSPOSO($$RXI^ABSPOSQ,$$RXR^ABSPOSQ)
 . N DIAG S DIAG=$$GETDIAG^ABSPOSO(ABSPRXI,ABSPRXR)
 . I DIAG S FDA(FN,IEN59COM,1.17)=DIAG
 ;
 ; ***
 ; ***   Fields in the ^(2) node - RESULT CODE, RESULT TEXT - not here
 ; ***   In the ^(3) node - CANCELLATION REQUESTED - not here
 ; ***   In the ^(4) node - REVERSAL CLAIM, REVERSAL RESPONSE - not here
 ; ***
 ;
 ; ***
 ; ***   INSURANCE data  
 ; ***   Fields 1.06 INSURER and 1.08 PINS PIECE
 ; ***   And the ^(6) and ^(7) nodes
 ; ***
 S INSURER=$P(^ABSPT(IEN59,1),U,6)
I I INSURER D  ; whoever set up this entry included insurance data
 . ; nothing more to do right now
 E  D  ; insurance data not set up; establish defaults here and now
 . N INSARRAY
 . I $$TYPE^ABSPOSQ=2 D  ; postage: try to take same insur. as prescrip
 . . N N57 S N57=$$N57LAST^ABSPOSQ() Q:'N57  ; last transaction
 . . N TMP M TMP=^ABSPTL(N57) Q:'$D(TMP(6))
 . . S INSARRAY(0)=$L(TMP(6),U)
 . . N I F I=1:1:$L(TMP(6),U) D
 . . . S INSARRAY(I)=$P(TMP(7),U,I)_U_$P(TMP(6),U,I)
 . I '$D(INSARRAY) D INSURER^ABSPOS25(.INSARRAY)
 . ; INSARRAY(0)=count^other junk...
 . ; INSARRAY(n)=insurer^pins
 . N I F I=1:1:$P(INSARRAY(0),U) D
 . . I I>3 Q
 . . S FDA(FN,IEN59COM,I+700)=$P(INSARRAY(I),U)
 . . S FDA(FN,IEN59COM,I+600)=$P(INSARRAY(I),U,2)
 . . I I=1 D
 . . . S (INSURER,FDA(FN,IEN59COM,1.06))=$P(INSARRAY(I),U)
 . . . S FDA(FN,IEN59COM,1.08)=1
 ;
 ; ***
 ; ***   PRICING data - in the ^(5) node
 ; ***
 ; 
P N PRICING S PRICING=$G(^ABSPT(IEN59,5))
 I $P(PRICING,U,5)]"" D
 . ; do nothing; pricing is already determined
 E  D  ; need to figure out pricing
 . I $$TYPE^ABSPOSQ=2 D
 . . D IMPOSS^ABSPOSUE("DB,P","TI","Pricing of postage must already be in place by now.",IEN59,"P:2",$T(+0))
 . E  I $$TYPE^ABSPOSQ=3 D
 . . D IMPOSS^ABSPOSUE("DB,P","TI","Pricing of supplies must already be in place by now.",IEN59,"P:3",$T(+0))
 . E  I $$TYPE^ABSPOSQ=1 D  ; Drug pricing:
 . . N DRGDFN,DRGNAME,PROVDFN,PROV,PRICALC
 . . N ABSBRXI,ABSBRXR,ABSBNDC,ABSBDRGI
 . . S ABSBRXI=$$RXI^ABSPOSQ,ABSBRXR=$$RXR^ABSPOSQ,ABSBNDC=$$NDC^ABSPOSQ
 . . S ABSBDRGI=$$DRGDFN^ABSPOSQ ; INSURER was set above
 . . D EN^ABSPOSQP ; and PRICING is set for you
 . N I F I=1:1:5 S FDA(FN,IEN59COM,I+500)=$P(PRICING,U,I)
 ;
 ; The 9002313.59 entry has all the data it should have at this point.
 ; Store whatever data were just determined in this routine.
 ;
FILE1 I $D(FDA) D
 . D FILE^DIE("","FDA","MSG")
 I $D(MSG) D  G FILE99
 . D LOG^ABSPOSL("Error in D FILE^DIE at tag FILE1^"_$T(+0))
 . D LOGMSG ; failure - log returned diagnostics
 ;
FILE99 D LOG59 ; log a copy of what's in the IEN59 now
 Q $S($D(MSG):1000,1:0) ; >0 if error, =0 if no error
 ;
LOGMSG D LOG^ABSPOSL("Error returned by FILE^DIE")
 D LOGARRAY("MSG") Q  ; log the MSG array
LOGARRAY(Q) ;EP - ABSPOSQD
 I $D(@Q)#10 D LOG^ABSPOSL(Q_"="_@Q)
 F  S Q=$Q(@Q) Q:Q=""  D LOG^ABSPOSL(Q_"="_@Q)
 Q
LOG59 ; log the IEN59 entry
 N A M A=^ABSPT(IEN59)
 D LOG^ABSPOSL("Contents of ^ABSPT("_IEN59_") :")
 D LOGARRAY("A")
 Q
LOG59A ;EP - from REVERS59^ABSPOS6D
 N SAVESLOT S SAVESLOT=$$GETSLOT^ABSPOSL
 D SETSLOT^ABSPOSL(IEN59)
 D LOG59
 D RELSLOT^ABSPOSL
 D SETSLOT^ABSPOSL(SAVESLOT)
 Q
