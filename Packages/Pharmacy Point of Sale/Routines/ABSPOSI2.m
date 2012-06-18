ABSPOSI2 ; IHS/FCS/DRS - support for the NDC/HCPCS/CPT field ;    [ 09/12/2002  10:10 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,40**;JUN 21, 2001
 Q
VALID ; this is what's called from the field's Data Validation field 
 I ^TMP("DDS",$J,$P(DDS,U),"F9002313.512",DDSDA,.02,"D")="" S DDSERROR=299 Q   ;IHS/OIT/CNI/RAN patch 40 avoid undefined in user screen when RX is blank
 N Z S Z=$$VALIDATE(X)
 ;S ^TMP($J,$T(+0),"VALIDATED")=Z
 I Z<0 D  Q
 . D IMPOSS^ABSPOSUE("P","TI","VALIDATE should have set DDSERROR","or Z is incorrectly <0","VALID",$T(+0))
 I X'=Z D
 . S (X,DDSEXT)=Z
 Q
 ; A onetime problem:  if you type an abbreviation, say PO
 ;  it expands to POSTAGE,  the pop-up page appears,
 ;  and when the pop-up is done, it goes back to PO.
 ; Field's post action PUT^DDSVAL(DIE,.DA,.03,X) works.
 ;  That's to make sure the expanded version gets stored.
 ;
VALIDATE(X)         ;  validate input and return transformed value 
 ; returns <0 and sets DDSERROR if error
 ; If successful, you could get:
 ;   1. NDC number ?10N or ?11N
 ;   2. NDC number with hyphens still in it
 ;   3. The word POSTAGE
 ;   4. "CPT "_CPTCODE   (requires uniqueness!!!)
 N RET K DDSERROR
 ;
 ; First, some pre-processing:
VAL0 ;
 I X?1"++3"10.11N2E D  ; Abbot Labs bar codes are "really funky"
 . S X=$E(X,4,$L(X)-2)
 I X?12N,$E(X)=0 S X=$E(X,2,12) ; chop leading zero off a 12-digit NDC?
 ;
 ; Now the If/Else list:  K RET if there was a problem
VAL1 I 0 ;
 E  I X?10N D  ; Lookup in AWP MED-TRANSACTION
 . S RET=$$NDC10^ABSPOS9(X)
 . I RET="" D  S DDSERROR=201
 . . D HLP^DDSUTL("We couldn't figure out the 10-digit NDC #"_X)
 . . D HLP^DDSUTL("Retype it in 5-4-1 or 4-4-2 or 5-3-2 format.")
 . E  D PRINTNAM(X)
 E  I X?11N D  ; Lookup in AWP MED-TRANSACTION
 . S RET=$$NDC11^ABSPOS9(X)
 . I RET="" D
 . . D HLP^DDSUTL("We couldn't find the 11-digit NDC #"_X)
 . . D HLP^DDSUTL("but we will process it anyhow.")
 . . S RET=X
 . E  D PRINTNAM(X)
 E  I $L(X,"-")=3 D
 . I X?4N1"-"4N1"-"2N S RET=X ; NDC formats with "-"
 . E  I X?5N1"-"3N1"-"2N S RET=X ; are always accepted
 . E  I X?5N1"-"4N1"-"1N S RET=X
 . E  I X?5N1"-"4N1"-"2N S RET=X
 . E  D  K RET S DDSERROR=205
 . . D HLP^DDSUTL("4-4-2, 5-3-2, 5-4-1, and 5-4-2 are the recognized formats.")
 E  I $E("POSTAGE",1,$L(X))=$$UPPER(X) D
 . S RET="POSTAGE"
 E  I $E("FIND",1,$L(X))=$$UPPER(X) D
 . ; not implemented - would do a lookup of CPT code
 E  D  ; supply items, CPT codes, HCPCS codes, etc.
 . ; maybe special codes in here?
 . I X?1"CPT ".E S X=$P(X,"CPT ",2)
 . S RET=$$CPT(X) I RET]"" S RET="CPT "_X Q
 . K RET S DDSERROR=299
 I $D(DDSERROR) D
 . D HLP^DDSUTL("Did not recognize "_X)
 . K RET
 Q $S($D(RET):RET,1:-1)
CPT(X) ; Lookup CPT code.  If found, return CPTIEN.
 Q $$LOOKUP("^ABSCPT(9002300,",X)
 ;
EFFECTS ;
 ; Force an update of pricing when you enter page 7, by wiping out
 ;  any unit price that might already be stored there.
 I $$GET^DDSVAL(9002313.51,DA(1),1.03),$$GET^DDSVAL(DIE,.DA,5.02)]"" D
 . D PUT^DDSVAL(DIE,.DA,5.02,"")
 ;
 ; Input of a CPT code has many implications:
 I X?1"CPT "1E.E D
 . ;D MSGWAIT("In EFFECTS^"_$T(+0)_" with X="_X)
 . N CPTCODE S CPTCODE=$P(X,"CPT ",2)
 . N CPTIEN S CPTIEN=$$LOOKUP("^ABSCPT(9002300,",CPTCODE)
 . ;D MSGWAIT("$$LOOKUP yields CPTIEN="_CPTIEN)
 . N C0 S C0=^ABSCPT(9002300,CPTIEN,0)
 . N CPTDESC S CPTDESC=$P(C0,U,2)
 . I CPTDESC="" S CPTDESC=$P(C0,U,3)
 . N PRICE S PRICE=$P(C0,U,5)
 . N VISITIEN S VISITIEN=$$GET^DDSVAL(DIE,.DA,1.06,"I")
 . N VCN S VCN=$P($G(^AUPNVSIT(VISITIEN,"VCN")),U)
 . I VCN="" S VCN="V`"_VISITIEN
 . D PUT^DDSVAL(DIE,.DA,.02,VCN)
 . D PUT^DDSVAL(DIE,.DA,.05,CPTDESC)
 . D PUT^DDSVAL(DIE,.DA,.06,$$MMMDD($P(^AUPNVSIT(VISITIEN,0),U)))
 . D PUT^DDSVAL(DIE,.DA,1.01,"") ;RXI
 . D PUT^DDSVAL(DIE,.DA,1.02,"") ;RXR
 . D PUT^DDSVAL(DIE,.DA,1.05,"") ;AWPMED
 . D PUT^DDSVAL(DIE,.DA,1.08,CPTIEN,,"I")
 . D PUT^DDSVAL(DIE,.DA,5.01,1)
 . D PUT^DDSVAL(DIE,.DA,5.02,PRICE)
 . D PUT^DDSVAL(DIE,.DA,5.04,0) ; no dispense fee?
 . D PUT^DDSVAL(DIE,.DA,5.06,"ABSCPT",,"I") ; source of price
 . ;IHS/OIT/SCR 11/20/08
 . D PUT^DDSVAL(DIE,.DA,5.07,0) ; no incentive amount
 . D RECALC1^ABSPOSI7
 Q
MMMDD(Y) Q $$MMMDD^ABSPOSI1(Y)
MSGWAIT(X)         D MSGWAIT^ABSPOSI1(X) Q
LOOKUP(DICX,X)          ; general lookup, given file root DIC ; 
 ; returns IEN if success, false if failure
 N DIC,DTIME,DLAYGO,DINUM,Y,DTOUT,DUOUT
 S DIC=DICX,DIC(0)="MNSX"
 S DIC("S")="I Y<100000" ; disallow input of drugs as CPT codes
 D ^DIC
 Q $S(Y>0:+Y,1:"")
STOREAWP ; not implemented - we don't have a readily-available AWP pointer
 Q
PRINTNAM(X)        ; print name as found in AWP MED-TRANSACTION file
 ; Print it in the help area, as the name from the drug file is
 ; usually more complete and informative
 N NAME S NAME=$$NAME^ABSPOS9(X)
 D HLP^DDSUTL(X_" is "_NAME)
 Q
HELP ;
 N AR,N S N=0
 D HELP1("Enter the NDC number")
 D HELP1("or a CPT or HCPCS code")
 D HLP^DDSUTL(.AR)
 Q
HELP1(X) S N=N+1,AR(N)=X Q
ASKPRE() Q $$GET^DDSVAL(9002313.51,DA(1),1.02)
ASKINS() Q $$GET^DDSVAL(9002313.51,DA(1),1.01) ; actually,should check for exact value
ASKPRI() Q $$GET^DDSVAL(9002313.51,DA(1),1.03)
ASKDATE() Q $$GET^DDSVAL(9002313.51,DA(1),1.04)
BRANCH ;
 I $$ASKPRE!$$ASKINS!$$ASKPRI!$$ASKDATE S DDSSTACK=3
 QUIT
 ; DUPLICATE LABEL:
 ;MSGWAIT(X)         N AR S AR(1)=X
 ; ,AR(2)="$$EOP" 
 ;D HLP^DDSUTL(.AR)
 ;D HLP^DDSUTL("$$EOP")
 ;Q
UPPER(X) Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
