ABSPOSBM ; IHS/FCS/DRS - POS billing, part 3 ;      
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ; *****
 ; *****  Interface to ABSB, the ILC A/R package
 ; *****  This code is reached _ONLY_ by sites using ILC A/R,
 ; *****  and who choose to interface to it.
 ; *****
 Q
CHGLIST() ; EP - from ABSPOSBX
 ; Post all the charges in CHGLIST(IEN57)="" ; returns PCNDFN
 K ^BLL($J),^TMP($J,"VCPT")
 N VSTDFN,VCN
 N IEN57 S IEN57=$O(CHGLIST(0))
 S VSTDFN=$$VISITIEN^ABSPOS57
 I 'VSTDFN D IMPOSS^ABSPOSUE("DB","TI","Missing visit pointer","IEN57="_IEN57,"CHGLIST",$T(+0))
 S VCN=$P($G(^AUPNVSIT(VSTDFN,"VCN")),U)
 I VCN="" D IMPOSS^ABSPOSUE("DB","TI","Missing VCN","VSTDFN="_VSTDFN,"CHGLIST",$T(+0))
 S IEN57=0 F  S IEN57=$O(CHGLIST(IEN57)) Q:'IEN57  D
 . N VCPT
 . S VCPT=$$VCPT^ABSPOSBV
 . S ^BLL($J,VCN,VCPT)=""
 . S ^TMP($J,"VCPT",VCPT)=IEN57_U_$$RXI^ABSPOS57_U_$$RXR^ABSPOS57
 D LOG^ABSPOSL($T(+0)_" - Posting for VCN="_VCN_", VSTDFN="_VSTDFN)
 ;
 ; Make sure the visit has a V68.1 diagnosis code
 ;  (special for Sitka; available to others)
 ; 
 I '$P($G(^ABSP(9002313.99,1,"CREATING A/R")),U,1) D
 . D V681^ABSPOSB3
 ;
 ; Make sure the visit has a primary provider, setting him to
 ; be the prescriber if none is already defined.
 ;  (Special for Sitka; available to others)
 ;
 I '$P($G(^ABSP(9002313.99,1,"CREATING A/R")),U,2) D
 . D PROVIDER^ABSPOSB3()
 ;
 ; Make sure the visit has a clinic.  If not, give it the PHARMACY..
 ;
 I '$P($G(^ABSP(9002313.99,1,"CREATING A/R")),U,3) D
 . D CLINIC^ABSPOSB3
 ;
 ; Finally, create the actual bill
 ;
 N PCNDFN
 S PCNDFN=$$ABSBMAKE
 I '$G(PCNDFN) D
 . D LOG^ABSPOSL($T(+0)_" - ABSBMAKE failed to post charges!!")
 . D IMPOSS^ABSPOSUE("P,DB","TI",,,"call to ^ABSBMAKE",$T(+0))
 ;
 D DTBILLED ; And update the DATE BILLED multiple
 D COMMENTS ; about how much was paid and about reasons for rejects
 Q PCNDFN
COMMENTS ; remark about how much will be paid and give reasons for rejects
 N ARRPAID,ARRREJ ; 
 S IEN57=0 F  S IEN57=$O(CHGLIST(IEN57)) Q:'IEN57  D
 . N R S R=$$GET1^DIQ(9002313.57,IEN57_",","RESULT WITH REVERSAL")
 . I R="E PAYABLE" S ARRPAID(IEN57)=""
 . E  I R="E REJECTED" S ARRREJ(IEN57)=""
 I $D(ARRPAID) D PAYABLE^ABSPOSBF(PCNDFN,"Insurer will pay",.ARRPAID)
 I $D(ARRREJ) D REJECTS^ABSPOSBF(PCNDFN,"Rejected claims",.ARRREJ)
 Q
DTBILLED ; Update the DATE BILLED multiple
 N FDA,MSG,IEN57 S IEN57=$O(CHGLIST(0))
 N FN,IENS S FN=9002302.04,IENS="+1,"_PCNDFN_","
 S FDA(FN,IENS,.01)=DT ; DATE BILLED
 N IDLIST,AMT,IEN57 S IEN57=0
 F  S IEN57=$O(CHGLIST(IEN57)) Q:IEN57=""  D
 . ; if it has a claim ID, it was billed electronically
 . N X S X=$P(^ABSPTL(IEN57,0),U,4) Q:'X
 . S IDLIST($P(^ABSPC(X,0),U))=""
 . S AMT=AMT+$P(^ABSPTL(IEN57,5),U,5)
 . S FDA(FN,IENS,.02)=$$FMTIDS ; DESCRIPTION
 I $G(FDA(FN,IENS,.02))="" Q  ; none of them sent electronically
 S FDA(FN,IENS,.03)=AMT ; AMOUNT BILLED
 S FDA(FN,IENS,.04)=$$INSIEN^ABSPOS57
DTB8 D UPDATE^DIE(,"FDA",,"MSG")
 I $D(MSG) D  G DTB8:$$IMPOSS^ABSPOSUE("FM","TRI",$T(DTBILLED),,"DTB8",$T(+0))
 . D LOG^ABSPOSL("Failed to update DATE BILLED")
 . D LOGARRAY^ABSPOSL("FDA")
 . D LOGARRAY^ABSPOSL("MSG")
 Q
FMTIDS() ; format IDLIST(claim ID's) into a concise string
 ; LEN agrees with ^DD(9002302.04,1) maximum length
 N X,RET,LEN,FIRST S (FIRST,RET,X)=$O(IDLIST("")),LEN=50
 F  S X=$O(IDLIST(X)) Q:X=""  D
 . I $P(X,"-",1,2)=$P(FIRST,"-",1,2) S RET=RET_","_$P(X,"-",3)
 . E  S RET=RET_";"_X,FIRST=X
 I $L(RET)>LEN S RET=$E(RET,1,LEN-3)_"..."
 E  I $L(RET)+4'>LEN S RET="POS "_RET
 Q RET
ABSBMAKE() ;
 ; We have ^BLL, ^TMP as above; also VCN,VSTDFN and lots of other stuff
 ; Return PCNDFN
 N ARTYPNUM D ARTYPNUM ; set the right ARTYPNUM for these charges
 I $D(^AUPNVSIT(VSTDFN,"PINS")) S ^TMP($J,"SAVE PINS")=^AUPNVSIT(VSTDFN,"PINS")
 E  K ^TMP($J,"SAVE PINS")
 I $D(^AUPNVSIT(VSTDFN,"PCN")) S ^TMP($J,"SAVE PCN")=^AUPNVSIT(VSTDFN,"PCN")
 E  K ^TMP($J,"SAVE PCN")
 N PINS D PINS
 D  ; fix old style CAID,2352 -> CAID,2352,0
 . ; affects only those created under old and being posted under new
 . N I F I=1:1:$L(PINS,U) D
 . . N X S X=$P(PINS,U,I)
 . . I $L(X,",")=2 S $P(X,",",3)=0,$P(PINS,U,I)=X
 S ^AUPNVSIT(VSTDFN,"PINS")=PINS
 S $P(^AUPNVSIT(VSTDFN,"PCN"),U)=ARTYPNUM
 N PCN,BAL,PCNDFN
 D
 . N BLLTYP S BLLTYP="OP"
 . N FIXINDEX S FIXINDEX=0
 . I '$O(^AUPNVSIT("VCN",VCN,"")) D
 . . D LOG^ABSPOSL("DELETED VISIT FOR "_VCN_" INTERNAL NUMBER "_VSTDFN)
 . . D LOG^ABSPOSL("We're going to post charges to it anyway.")
 . . S ^AUPNVSIT("VCN",VCN,VSTDFN)=""
 . . S FIXINDEX=1
 . ;D LOG^ABSPOSB3("with ^AUPNVSIT("_VSTDFN_",""PINS"")="_$G(^AUPNVSIT(VSTDFN,"PINS")))
 . ; Use the "null file" for ^ABSBMAKE output
AM6 . I '$$NULLOPEN D  G AM6:$$IMPOSS^ABSPOSUE("DEV","IRT","$$NULLOPEN",,"AM6",$T(+0))
 . D COMBINS ; - - - - - - - UPDATE COMBINED INSURANCE - - - - - - -
 . D ^ABSBMAKE ; - - - - - - - - -  CREATE THE BILL - - - - - - - -
 . D NULLCLOS
 . I FIXINDEX D
 . . K ^AUPNVSIT("VCN",VCN,VSTDFN)
 . S PCN=$P(^ABSBITMS(9002302,PCNDFN,0),U)
 . S BAL=$P(^ABSBITMS(9002302,PCNDFN,3),U)
 ; restore the old PINS and PCN TYPE to the visit
 I $D(^TMP($J,"SAVE PINS")) S ^AUPNVSIT(VSTDFN,"PINS")=^TMP($J,"SAVE PINS") K ^TMP($J,"SAVE PINS")
 E  K ^AUPNVSIT(VSTDFN,"PINS")
 I $D(^TMP($J,"SAVE PCN")) S ^AUPNVSIT(VSTDFN,"PCN")=^TMP($J,"SAVE PCN")
 E  K ^AUPNVSIT(VSTDFN,"PCN")
 I '$G(PCNDFN) D  Q ""
 . D LOG^ABSPOSL("* * * * * ERROR:  did not create A/R for VN="_VCN_",VSTDFN="_VSTDFN)
 . D LOG^ABSPOSL("This is the ^BLL($J) contents:")
 . N TMP M TMP=^BLL($J)
 . D LOGARRAY^ABSPOSL("TMP")
 . D LOG^ABSPOSL("This is the ^TMP($J,""VCPT"") contents:")
 . K TMP M TMP=^TMP($J,"VCPT")
 . D LOGARRAY^ABSPOSL("TMP")
 N PAT D
 . N N D FIRSTN
 . S PAT=$P(^ABSPTL(N,0),U,6)
 . S PAT=$P(^DPT(PAT,0),U)
 N X S X=PAT_"  VCN "_VCN_"  PCN "_PCN
 S X=X_"  $"_$J(BAL,0,2)
 S X=X_" posted"
 D LOG^ABSPOSL(X) ;,$G(ECHO)) 
 N VCPT S VCPT=0 F  S VCPT=$O(^BLL($J,VCN,VCPT)) Q:'VCPT  D
 . N N,RXI,RXR
 . S N=^TMP($J,"VCPT",VCPT),RXI=$P(N,U,2),RXR=$P(N,U,3),N=$P(N,U)
 . N N57 S N57=N ; maybe, in case fileman blows away N
 . D LINEITEM ; log file detail of the charge
 . D MARKVCPT ; note RXI, RXR on the VCPT
 . D UPDATE57 ; record in .57 file that this entry has been billed
 . D UPDATE02 ; 9002313.02 claim points to PCN
 . I $$GET1^DIQ(9002313.57,N57_",","RESULT WITH REVERSAL")?1"E ".E D
 . . D OFFNCPDP^ABSBPBRX(PCNDFN) ; electronic claim? do not print form.
 Q PCNDFN
COMBINS ; have to update the combined insurance file?  Yes. 
 ; because DO ^ABSBMAKE refers back to combined insurance.
 ; (This is new.  Sitka didn't need it because back then,
 ;  ILC and Point of Sale used the same ^ABSBCOMB.)
 N PATDFN S PATDFN=$P(^AUPNVSIT(VSTDFN,0),U,5)
 I $D(^ABSBCOMB) D  ; FSI/ILC A/R Version 2
 . D EN^VTLCOMB(PATDFN)
 E  D  ; FSI/ILC A/R Version 1
 . N D1,ELGBEG,ELGEND,GRPDFN,GRPNAM,GRPNUM,INSDFN,INSNAM
 . N POLDFN,POLNAM,POLNUM,POLREC,REC,REL,X
 . D ^ABSBCOMB(PATDFN)
 Q
LINEITEM         ;
 N DRGDFN,NDC,DRGNAME,CHARGE,X,QTY
 S DRGDFN=$P(^PSRX(RXI,0),U,6)
 S NDC=$P(^ABSPTL(N57,1),U,2) ; fixed 03/26/2001
 S DRGNAME=$P($G(^PSDRUG(DRGDFN,0)),U)
 S CHARGE=$P(^ABSVCPT(9002301,VCPT,0),U,5)
 S QTY=$P(^ABSPTL(N57,5),U)
 I QTY#1 S QTY=$J(QTY,8,3)
 E  S QTY=$J(QTY,4)
 S X=QTY_" "_$$ANFF^ABSPECFM(DRGNAME,25)_"  "
 S X=X_$$ANFF^ABSPECFM($$FORMTNDC^ABSPOS9(NDC),13)
 S X=X_" "_$J(CHARGE,8,2)
 S X=X_"  ("_VCPT_")"
 D LOG^ABSPOSL(X)
 Q
MARKVCPT         ; 
 N DIE,DA,DR,DIDEL,DTOUT
 S DIE=9002301,DA=VCPT,DR="56////"_RXI_";56.3////"_RXR_";56.4////"_N57
 D ^DIE
 Q
UPDATE57     ; record in POS data that this VCPT has been billed
 N DIE,DA,DR,DIDEL,DTOUT
 S DIE=9002313.57,DA=N57,DR="2////"_PCNDFN D ^DIE
 Q
 Q
UPDATE02 ;
 N DIE,DA,DR,DIDEL,DTOUT
 S DIE=9002313.02,DA=$P(^ABSPTL(N57,0),U,4)
 Q:'DA
 S DR=".03////"_PCNDFN_";1.02///"_PCN_";1.03///"_VCN
 D ^DIE
 Q
ARTYPNUM ; determine the AR TYPE number for the current VCN
 N OK,PHARM
ART2 S OK=1
 D FIRSTN
 S PHARM=$P(^ABSPTL(N,1),U,7) ; point to .56
 S ARTYPNUM=$P(^ABSP(9002313.56,PHARM,0),U,4)
 I 'ARTYPNUM S ARTYPNUM=$P(^ABSP(9002313.99,1,"RX A/R TYPE"),U)
 I 'ARTYPNUM S OK=0
 I OK I '$D(^ABSBTYP(ARTYPNUM)) S OK=0 ; be overly cautious about this
 I 'OK G ART2:$$IMPOSS^ABSPOSUE("DB","RTI","A/R TYPE missing from setup file",,"ARTYPNUM",$T(+0))
 Q
PINS ; set PINS = the right PINS node for this VCN
 D FIRSTN
 S PINS=^ABSPTL(N,6)
 Q
FIRSTN ; S N=first 9002313.57 for the first VCPT for this VCN
 ; used by ARTYPNUM and PINS
 N VCPT S VCPT=$O(^BLL($J,VCN,0))
 I 'VCPT D  Q  ; get first VCPT
 . D IMPOSS^ABSPOSUE("P","TI","Incomplete ^BLL array",,"FIRSTN",$T(+0))
 S N=$P(^TMP($J,"VCPT",VCPT),U) ; point to the 9002313.57 record
 Q
NULLOPEN() ; open null file, because ^ABSBMAKE echoes to screen
 S X=$$GET1^DIQ(9002313.99,"1,",1490)
 N DIR,FILE,SLASH,SLASHCH
 S SLASH=$S(X["/":"/",X["\":"\",1:"")
 I SLASH]"" D
 . N N S N=$L(X,SLASH)
 . S DIR=$P(X,SLASH,1,N-1)_SLASH
 . S FILE=$P(X,SLASH,N)
 E  D
 . I X="" S DIR="",FILE=$T(+0)_".tmp"
 . E  S DIR="",FILE=X
 D OPEN^%ZISH($$NULLHNDL,DIR,FILE,"W")
 Q '$G(POP) ; 1 success, 0 failure
NULLCLOS D CLOSE^%ZISH($$NULLHNDL) Q
NULLHNDL() Q 54
