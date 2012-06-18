ABSPOSIF ; IHS/FCS/DRS - handle FIND command ;   [ 09/12/2002  10:11 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ; "FIND" - when typed at Prescription field, here's what happens
 Q
TEST N RETVAL S RETVAL=$$RXFIND()
 W ! D ZWRITE^ABSPOS("RETVAL")
 Q
RXFIND(PAT,TYPE,VISITIN) ;EP - from ABSPOSI1
 ;lookup prescription - return RXI^RXR
 ; If you don't send the patient or the visitIEN, a lookup is done. 
 ; TYPE = 1 looking for a prescription - return RXI^RXR
 ; TYPE = 2 looking for a visit - return VISITIEN
 ; TYPE = 3 (default)  don't know which; ask.
 ;     Which one is returned?  $L(returned value,U)=1 or 2 tells you
 ; Returns False if no selection made.
 ;
 ; We lookup the patient first, then the visit, and
 ; then the prescription based on the visit
 ;
 N PATNAME,SEL,VISITIEN,TTYPE
 N DDS ; they have ScreenMan hooks in ^DIR - they are poison to this
 ;       ABSPOSIF program!  NEW safely disables them for now.
 ; all NEWs above this line ^^^   because there are GOTOs below
RXFINDA I $D(VISITIN) S VISITIEN=VISITIN,PAT=$P(^AUPNVSIT(VISITIEN,0),U,5)
 E  S VISITIEN=0
 I '$G(PAT) S PAT=$$PATFIND I 'PAT G RXFINDX
 I '$D(TYPE) S TYPE=3
 S PATNAME=$P(^DPT(PAT,0),U)
 ;
 I 'VISITIEN D
 . W !,"...Searching for visits and prescriptions for "_PATNAME_" ...",!
RXFINDC S SEL=$$VISIFIND(PAT,TYPE,VISITIEN) I 'SEL K PAT G RXFINDA
 ; Side effect - we still have ^TMP($J,"LIST",SEL,"X")=count of prescs
 S VISITIEN=^TMP($J,"LIST",SEL,"I")
 ;
 ; Are you looking for a visit or for a prescription?
 I TYPE=1 G RXFINDK
 I TYPE=2 Q VISITIEN ; looking for a visit - you've got it - done
 ; But if there are no prescriptions with this visit, and they saw
 ; the list, then just take the visit and don't ask.
 I '$G(VISITIN),'^TMP($J,"LIST",SEL,"X") Q VISITIEN
 S TTYPE=$$TTYPE
 I 'TTYPE K PAT G RXFINDA
 I TTYPE=1 G RXFINDK
 I TTYPE=2 Q VISITIEN
 D IMPOSS^ABSPOSUE("P","TI","Bad TTYPE="_TTYPE,,"RXFINDC",$T(+0))
 ;
RXFINDK ; If there was only one prescription with the visit, that's the one
 ; we take - the drug name and date was shown, we know that's the one
 ;
 I ^TMP($J,"LIST",SEL,"X")=1 D  Q X
 . N RXI S RXI=$O(^TMP($J,"LIST",SEL,"X",""))
 . N RXR S RXR=$O(^TMP($J,"LIST",SEL,"X",RXI,""))
 . S X=RXI_U_RXR
 ;
 I ^TMP($J,"LIST",SEL,"X")=0 D  G RXFINDC
 . W !,"This visit has no prescriptions!   Try again..." H 2 W !
 ;
 S SEL=$$WHICHRX(SEL) I 'SEL G RXFINDC
 Q ^TMP($J,"LIST",SEL,"I") ; RXI^RXR
RXFINDX ; removed call ; ABSP*1.0T7*8 ; D REFRESH^DDSUTL
 Q -1
TTYPE() ; so what are you looking for?
 N PROMPT,DEFAULT,OPT,DISPLAY,CHOICES,TIMEOUT,ANS
 S PROMPT="What kind of charge is this for? "
 S DEFAULT="P",OPT=1,DISPLAY="V"
 S CHOICES="P:Prescription;N:Non-prescription item"
 S TIMEOUT=$S($G(DTOUT):DTOUT,1:300)
 S ANS=$$SET^ABSPOSU3(PROMPT,DEFAULT,OPT,DISPLAY,CHOICES,TIMEOUT)
 Q $S(ANS="P":1,ANS="N":2,1:"")
WHICHRX(SEL)          ; given ^TMP($J,"LIST" and  SEL from visit selection,
 ; present another list to select which prescription
 N TMP M TMP=^TMP($J,"LIST",SEL,"X") ; TMP=count, TMP(RXI,RXR)=""
 N VISIDESC S VISIDESC=^TMP($J,"LIST",SEL,"E")
 K ^TMP($J,"LIST") S ^TMP($J,"LIST",0)=0
 N TYPE S TYPE="S"
 N LISTROOT S LISTROOT="^TMP("_$J_",""LIST"","
 N X S X="1|Prescrip.:10,Drug:30,Fill Date:11,Quantity:10"
 S ^TMP($J,"LIST","Column Headers")=X
 N TITLE S TITLE="Select a prescription for "_PATNAME_" from this visit"
 N PROMPT S PROMPT(1)=VISIDESC
 N OPT S OPT=1
 N ANSROOT S ANSROOT="^TMP($J,""ANS""," K ^TMP($J,"ANS")
 N RXI,RXR S RXI=0 F  S RXI=$O(TMP(RXI)) Q:'RXI  D
 . S RXR="" F  S RXR=$O(TMP(RXI,RXR)) Q:RXR=""  D
 . . N N S (N,^TMP($J,"LIST",0))=^TMP($J,"LIST",0)+1
 . . N Z S Z=$G(^PSRX(RXI,0))
 . . N DRUGIEN S DRUGIEN=$P(Z,U,6)
 . . N DRUGNAME I DRUGIEN S DRUGNAME=$P($G(^PSDRUG(DRUGIEN,0)),U)
 . . E  S DRUGIEN="?"
 . . N DATE,QTY
 . . I RXR D
 . . . N Z S Z=$G(^PSRX(RXI,1,RXR,0))
 . . . S DATE=$P(Z,U)
 . . . S QTY=$P(Z,U,4)
 . . E  D
 . . . S DATE=$P($G(^PSRX(RXI,2)),U,2)
 . . . S QTY=$P(Z,U,7)
 . . N Y S Y=DATE X ^DD("DD") S DATE=Y
 . . S QTY=$$FMTQTY(QTY)
 . . N X S X=$$LJBF("`"_RXI,10)_" "_$$LJBF(DRUGNAME,30)
 . . S X=X_" "_$$LJBF(DATE,11)_" "_$$LJBF($$FMTQTY(QTY),10)
 . . S ^TMP($J,"LIST",N,"E")=X
 . . S ^TMP($J,"LIST",N,"I")=RXI_U_RXR
 S X=$$LIST^ABSPOSU4(TYPE,LISTROOT,ANSROOT,TITLE,.PROMPT,OPT)
 I "^^"[X Q ""
 I X<0 Q ""
 Q X
FMTQTY(QTY)        ; decimal, 3 places, but no excess trailing zeroes
 I QTY#1=0 Q QTY_"    "
 S QTY=$J(QTY,0,3)
 I QTY?.E1"."1N1"00" S $E(QTY,$L(QTY)-1,$L(QTY))="  "
 E  I QTY?.E1"."2N1"0" S $E(QTY,$L(QTY))=" "
 Q QTY
VISIFIND(PAT,RXTYPE,VISITIEN)      ; given patient IEN, present a list of visits
 ; if RXTYPE=1, then pick only visits which have prescriptions
 ; returns index of one selected, and ^TMP($J,"LIST",***) left over
 ; returns false if none selected
 ; VISITIEN'=0 means "this is the visit I want, fake it out as if it
 ;   had been selected from the list."
 ;W "In VISIFIND with " ZW PAT,RXTYPE H 1
 I $G(PAT) S PATNAME=$P(^DPT(PAT,0),U)
 N TYPE S TYPE="S" ; single item selection
 N LISTROOT S LISTROOT="^TMP("_$J_",""LIST""," K ^TMP($J,"LIST")
 N X S X="1|Visit:12,Date:14,Clinic:15,Prescriptions:25"
 S ^TMP($J,"LIST","Column Headers")=X
 N ANSROOT S ANSROOT="^TMP("_$J_",""ANS""," K ^TMP($J,"ANS")
 D VISLIST(VISITIEN)
 N TITLE S TITLE="Select a visit"
 I $G(PAT) S TITLE=TITLE_" for "_PATNAME
 N PROMPT S PROMPT="Item number (^ to exit)"
 N OPT S OPT=1
 N X
 I VISITIEN S X=1 ; we specified it, we pretend we selected it
 E  I '^TMP($J,"LIST",0) D  S X=""
 . W PATNAME," has no visits on file.",!
 E  S X=$$LIST^ABSPOSU4(TYPE,LISTROOT,ANSROOT,TITLE,PROMPT,OPT)
 I "^^"[X Q ""
 I X<0 Q ""
 Q X
VISLIST(VISITIEN) ; set up LISTROOT ; given PAT ; if $$, it returns the count
 ; variations?  haven't thought it through - for now, must have PAT
 N ROOT S ROOT=$E(LISTROOT,1,$L(LISTROOT)-1)_")"
 S @ROOT@(0)=0
 N TIME9 S TIME9=""
 F  S TIME9=$O(^AUPNVSIT("AA",PAT,TIME9)) Q:'TIME9  D  ; in reverse
 . N VSTIEN S VSTIEN=0
 . F  S VSTIEN=$O(^AUPNVSIT("AA",PAT,TIME9,VSTIEN)) Q:VSTIEN=""  D
 . . I $G(VISITIEN) Q:VISITIEN'=VSTIEN  ; when we want only this one
 . . N VCN,DATE,CLINIC,DELETED,PRESC,RXI,RXR,Z,Y,X,N,RXINFO
 . . S VCN=$P($G(^AUPNVSIT(VSTIEN,"VCN")),U)
 . . I VCN="" S VCN="`"_VSTIEN
 . . S Z=^AUPNVSIT(VSTIEN,0)
 . . I $P(Z,U,11) S VCN="D!"_VCN ; deleted visit!
 . . S Y=$P(Z,U) X ^DD("DD") S DATE=$P(Y,"@")_"@"_$P($P(Y,"@",2),":")
 . . S CLINIC=$P(Z,U,8) I CLINIC S CLINIC=$P($G(^DIC(40.7,CLINIC,0)),U)
 . . ;
 . . S N=@ROOT@(0)+1 ; don't store in @ROOT@(0) until you keep it
 . . ;
 . . D VISRX(VSTIEN,$E(ROOT,1,$L(ROOT)-1)_","_N_",""X"")")
 . . ;
 . . I @ROOT@(N,"X")=1 D  ; exactly one prescription - print drug name
 . . . S RXI=$O(@ROOT@(N,"X",""))
 . . . S RXINFO=$P($G(^PSRX(RXI,0)),U,6)
 . . . I RXINFO S RXINFO=$P($G(^PSDRUG(RXINFO,0)),U)
 . . . I RXINFO="" S RXINFO="missing data"
 . . E  I @ROOT@(N,"X") D  ; more than 1 prescriptions
 . . . S RXINFO=@ROOT@(N,"X")_" prescriptions"
 . . E  D  ; 0 prescriptions
 . . . S RXINFO="none"
 . . I RXINFO="none",RXTYPE=1 Q  ; stop, we only want prescriptions
 . . S X=$$LJBF(VCN,12)
 . . S X=X_" "_$$LJBF(DATE,15)
 . . S X=X_" "_$$LJBF(CLINIC,15)
 . . S X=X_" "_$$LJBF(RXINFO,25)
 . . S @ROOT@(N,"E")=X
 . . S @ROOT@(N,"I")=VSTIEN
 . . S @ROOT@(0)=N
 Q:$Q @ROOT@(0) Q
VISRX(VISIT,ROOT)  ; build @ROOT=count of prescriptions for this visit
 ; @ROOT@(RXI,RXR)="" for each prescription
 ; Jump there via V MEDICATION
 I '$D(@ROOT) S @ROOT=0
 N VMED S VMED=0
 F  S VMED=$O(^AUPNVMED("AD",VISIT,VMED)) Q:VMED=""  D VMEDRX(VMED,ROOT)
 Q
VMEDRX(VMEDIEN,ROOT)         ; called from VISRX
 N RXI,RXR
 S RXI=0 F  S RXI=$O(^PSRX("APCC",VMEDIEN,RXI)) Q:'RXI  D
 . I $D(^(RXI))=1 S @ROOT@(RXI,0)="",@ROOT=@ROOT+1
 . E  S RXR=0 F  S RXR=$O(^PSRX("APCC",VMEDIEN,RXI,RXR)) Q:'RXR  D
 . . S @ROOT@(RXI,RXR)=""
 . . S @ROOT=@ROOT+1
 Q
PATFIND()          ; return patient IEN, or false if none selected
 N DIC,Y,DUOUT,DTOUT,X,DLAYGO,DINUM,RETVAL
 S DIC=2,DIC(0)="AEMNQZ"
 ;
 ; Removed this screen.  If memory serves, this "C" index is not
 ; reliable.  Besides, we need flexibility to find patients and visits
 ; which don't have prescription file entries, since we'll be entering
 ; non-prescription items, too.
 ; ,DIC("S")="I $D(^PSRX(""C"",Y))"
 ;
 D ^DIC ; lookup patient
 Q $S(Y<0:"",1:+Y)
LJBF(X,N)          Q $E(X_$J("",N-$L(X)),1,N)
