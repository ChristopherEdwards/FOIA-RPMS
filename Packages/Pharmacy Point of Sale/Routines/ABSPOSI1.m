ABSPOSI1 ; IHS/FCS/DRS - support for the prescrip. field on the form ;    [ 09/12/2002  10:10 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,10**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;IHS/SD/lwj 03/10/04 patch 10
 ; Routine adjusted to call ABSPFUNC to retrieve
 ; the Prescription Refill NDC value.  At some
 ; point the call needs to be modified to call APSPFUNC.
 ; See ABSPFUNC for details on why call was done.
 ;----------------------------------------------------------------------
 Q
ENABASK D THEASKS(0) Q  ; enable the "Ask preauth?" etc. questions  
DISABASK D THEASKS(1) Q  ; disable those questions
THEASKS(N)         ; don't use this directly, the 0/1 meanings are backwards 
 ; from what you would think they mean (0 enables, 1 disables)
 N PAGE,BLOCK S PAGE=1,BLOCK=1
 N F F F=12,14,16,18,20 D
 . ;I N=0,F=18 Q  ; NOT IMPLEM'D - DON'T ENABLE
 . D UNED^DDSUTL(F,BLOCK,PAGE,N)
 Q
VALID ; VALID is the Data Validation action for the field.
 ; It may invoke prescription or visit lookup.
 ; It might reset X and DDSEXT. 
 ;D MSGWAIT("We are in VALID^"_$T(+0)_" with X="_$G(X)_", DDSEXT="_$G(DDSEXT))
 N Z S Z=$$VALIDATE(X)
 ;D MSGWAIT("VALIDATE^() returns and we have Z="_Z)
 S (X,DDSEXT)=Z
 ;D MSGWAIT("On the way out, we have set X="_$G(X)_" and DDSEXT="_$G(DDSEXT))
 Q
VALIDATE(X)         ;  validate input and return transformed value 
 ; Returns -1 if error and sets DDSERROR
 ;D MSGWAIT("We are in VALIDATE^"_$T(+0)_" with X="_$G(X))
 K DDSERROR
 N TYPE ; = "RX" or "VISIT"
 ;
VAL1 I 0 ; ELSE each possibility:
 E  I X?1N.N1"-"1N.N D  ; ANMC bar code labels
 . S TYPE="RX"
 . S X="`"_$P(X,"-",2)
 . S X=$$RXLOOKUP(X,"NOX")
 . I X<0 S DDSERROR=1
 E  I X?1N.N,$P($G(^ABSP(9002313.99,1,"INPUT")),U)=0 D  ; Sitka
 . S TYPE="RX"
 . S X="`"_+X
 . S X=$$RXLOOKUP(X,"NOX")
 . I X<0 S DDSERROR=2
 E  I X?1"`"1N.N D  ; internal RX number input ; 10/26/2000
 . S TYPE="RX",X=$$RXLOOKUP(X,"NOX") I X<0 S DDSERROR=6
VAL2 ;
 E  I X?1N.N0.1A!($$UPPER(X)?1"RX".P1N.N0.1A) D  ;external RX # input
 . S TYPE="RX"
 . I $$UPPER(X)?1"RX".E D
 . . S X=$P(X,"RX",2) F  Q:$E(X)?1N  S X=$E(X,2,$L(X))
 . S X=$$RXLOOKUP(X,"OX")
 . I X<0 S DDSERROR=5
 E  I X="" D  ; null (includes "@")
 . S X="DELETE"
 E  I $$UPPER(X)=$E("FIND",1,$L(X)) D
 . S TYPE="RX" ; might change to VISIT, below
 . ; RESET^DDS is the wrong thing to do here
 . ; try it without this, too  D FULLSCRE
 . W @IOF
 . S X=$$RXFIND^ABSPOSIF ; = RXI^RXR if presc,  = VISITIEN if visit
 . D REFRESH^DDSUTL
 . I X<0 S DDSERROR=3 Q
 . I $L(X,U)=1 S TYPE="VISIT"
 E  I X?0.1U1N.N1"."1N.N1U D  ; VCN number
 . S TYPE="VISIT" ; it might change to RX, below
 . S X=$O(^AUPNVSIT("VCN",X,0))
 . W @IOF
 . S X=$$RXFIND^ABSPOSIF(,,X) ; 
 . D REFRESH^DDSUTL
 . I 'X S DDSERROR=4,X=-1
 . I $L(X,U)=2 S TYPE="RX"
 E  I $L(X)'<3,$$UPPER(X)=$E("DELETE",1,$L(X)) D
 . S X="DELETE" ; and let EFFECTS do the dirty work later
 E  D  ; if it didn't hit any of the recognized cases:
 . S X=-1,DDSERROR=999
 ; And now deal with the results
 I X>0 D
 . I TYPE="RX" D  ; X=RXI or RXI^RXR
 . . S X="`"_X ; RXR part will be dealt with in EFFECTS
 . E  I TYPE="VISIT" D  ; X points to ^AUPNVSIT
 . . S X="V`"_X ; may be changed to VCN in EFFECTS
 E  I X?1"`"1N.N ; nothing needs to be done ; it's `RXI
 E  I X="DELETE" ; okay, nothing to do here ; EFFECTS takes care of it
 E  I X="@" ; okay, EFFECTS takes care of it
 E  I X=-1 D  ; DDSERROR should already be set.
 . D HELP^ABSPOSI1
 E  D IMPOSS^ABSPOSUE("P","TI","Unexpected case: X="_X,,"VAL2",$T(+0))
 Q X
FULLSCRE ; adapted from FULL^VALM1
 S IOTM=1,IOBM=IOSL W IOSC W @IOSTBM W IORC Q
RXLOOKUP(X,DIC0)         ; lookup by `IEN or prescrip # or patient name or whatever
 N DIC,Y,DUOUT,DTOUT S DIC="^PSRX(",DIC(0)=DIC0
 ;S ^TMP($T(+0),$J," 0 RXLOOKUP^DIC")=$H
 ;S ^TMP($T(+0),$J," 1 RXLOOKUP^DIC X^DIC0=")=$G(X)_U_$G(DIC0)
 D ^DIC
 N RET S RET=$S(Y>0:"`"_+Y,1:-1)
 I DIC0["A" D REFRESH^DDSUTL ; put screen back together
 ;S ^TMP($T(+0),$J," 2 RXLOOKUP^DIC RET=")=RET
 Q RET
HELP ;EP -
 N AR,N S N=0
 D HELP1("Scan the prescription label.")
 D HELP1("Or, you can enter ` followed by the internal number.")
 D HELP1("Or, type F or FIND to lookup by patient name.")
 D HELP1("Or, type the VCN number (non-prescription charges only).")
 I $$GET^DDSVAL(DIE,.DA,.02)]"" D HELP1("Answer with   @    to delete this line.")
 D HLP^DDSUTL(.AR)
 Q
HELP1(X) S N=N+1,AR(N)=X Q
MSGWAIT(X) ;EP - from ABSPOSI2,ABSPOSI8
 N AR S AR(1)=X
 ; ,AR(2)="$$EOP" 
 D HLP^DDSUTL(.AR)
 D HLP^DDSUTL("$$EOP")
 Q
EFFECTS N ERR ; side effects of putting a value in the prescription field
 N RX,NDC,PATNAME,DRUGNAME,FILLDATE
 N RXI,RXR,DRUG,PAT,AWPMED,VISIT,IEN59
 ; NDCDEF - not a field on the form, so this cheap fetch is okay
 N NDCDEF S NDCDEF=$P($G(^ABSP(9002313.51,DA(1),100)),U)
 I X?1"`"1N.N!(X?1"`"1N.N1"^"1N.N) D  ; It's a prescription:
 . ; Refill may or may not have been specified (FIND leads to 2nd piece)
 . I $L(X,U)>1 S RXR=$P(X,U,2),X=$P(X,U)
 . E  S RXR=$O(^PSRX($P(X,"`",2),1," "),-1)
 . S RX=X,RXI=$P(X,"`",2) ; display the `internal form
 . N R0 S R0=$G(^PSRX(RXI,0)) I R0="" D IMPOSS^ABSPOSUE("DB,P","TI","VALIDATE should have caught this",,"EFFECTS",$T(+0))
 . S PAT=$P(R0,U,2)
 . S PATNAME=$P(^DPT(PAT,0),U)
 . S DRUG=$P(R0,U,6) ; get pointer to drug file ; ABSP*1.0T7*11 ; removed "N DRUG", the NEW happened at the calling level and DRUG is needed below
 . I DRUG S DRUGNAME=$P($G(^PSDRUG(DRUG,0)),U) ; get drug name
 . E  S DRUGNAME="?missing from ^PSRX?"
 . I RXR D  ; refill
 . . S FILLDATE=$P(^PSRX(RXI,1,RXR,0),U) ;$O(^PSRX(X,1,"B",""),-1)
 . . ;IHS/SD/lwj 03/10/04 patch 10 nxt line rmkd out, new line added
 . . ;I NDCDEF S NDC=$P(^PSRX(RXI,1,RXR,0),U,13)
 . . I NDCDEF S NDC=$$NDCVAL^ABSPFUNC(RXI,RXR)  ;patch 10
 . . ;IHS/SD/lwj 03/10/04 patch 10 end change
 . . E  S NDC=""
 . . S VISIT=$P($G(^PSRX(RXI,1,RXR,999999911)),U)
 . E  D  ; first fill
 . . S FILLDATE=$P(^PSRX(RXI,2),U,2),RXR=0
 . . I NDCDEF S NDC=$P(^PSRX(RXI,2),U,7)
 . . E  S NDC=""
 . . S VISIT=$P($G(^PSRX(RXI,999999911)),U)
 . S FILLDATE=$$MMMDD(FILLDATE)
 . I VISIT D  ; got to follow the PCC link - we aren't at VISIT yet!
 . . S VISIT=$P($G(^AUPNVMED(VISIT,0)),U,3)
 E  I X?1"V`"1N.N D  ; a visit
 . S VISIT=$P(X,"`",2) N V0 S V0=^AUPNVSIT(VISIT,0)
 . S RX=$P($G(^AUPNVSIT(VISIT,"VCN")),U)
 . I RX="" S RX=X ; display the V`VSTDFN form if no VCN defined yet
 . S NDC="" ; no default for charge code
 . S PAT=$P(V0,U,5)
 . S PATNAME=$P(^DPT(PAT,0),U)
 . S DRUGNAME="" ; no charge item yet
 . S (RXI,RXR,AWPMED)="" ; no prescription
 . S FILLDATE=$$MMMDD($P($P(V0,U),"@"))
 E  I X="DELETE" D
 . S (RX,NDC,PATNAME,DRUGNAME,FILLDATE)=""
 ;S:RX="" RX=" " S:NDC="" NDC=" " S:PATNAME="" PATNAME=" "
 ;S:DRUGNAME="" DRUGNAME=" " S:FILLDATE="" FILLDATE=" "
 D PUT^DDSVAL(DIE,.DA,.02,RX)
 ; if you have a default NDC number, don't store unless field is empty.
 I $$GET^DDSVAL(DIE,.DA,.03)=""!1 D PUT^DDSVAL(DIE,.DA,.03,NDC)
 D PUT^DDSVAL(DIE,.DA,.04,PATNAME)
 D PUT^DDSVAL(DIE,.DA,.05,DRUGNAME)
 D PUT^DDSVAL(DIE,.DA,.06,FILLDATE)
 I X="DELETE" D  Q
 . ; delete all the other fields, too:
 . N F
 . F F=1.01:.01:1.07,2.01,5.01:.01:5.06,6.01:.01:6.03,7.01:.01:7.03 D
 . . D PUT^DDSVAL(DIE,.DA,F,"",,"I")
 . D ERASEALL^ABSPOSI8 ; the "I" multiple and page 8 details
 . S DDSBR="RX DISP" ; and go back to the RX field
 ; For others (not the DELETE case):
 D PUT^DDSVAL(DIE,.DA,1.01,$G(RXI),,"I")
 D PUT^DDSVAL(DIE,.DA,1.02,$G(RXR),,"I")
 D PUT^DDSVAL(DIE,.DA,1.03,$G(DRUG),,"I")
 D PUT^DDSVAL(DIE,.DA,1.04,$G(PAT),,"I")
 D PUT^DDSVAL(DIE,.DA,1.05,$G(AWPMED),,"I")
 D PUT^DDSVAL(DIE,.DA,1.06,$G(VISIT),,"I")
 D PUT^DDSVAL(DIE,.DA,1.07,$G(IEN59),,"I")
 ;D FILLDATE^ABSPOSIB ; called from Branching Logic
 Q
MMMDD(Y) ;EP
 X ^DD("DD") Q $P(Y,",")
UPPER(X) Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
