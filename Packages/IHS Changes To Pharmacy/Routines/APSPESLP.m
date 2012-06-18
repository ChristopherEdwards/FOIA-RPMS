APSPESLP ;IHS/BWF - Process entries from APSP REFILL REQUEST file ;22-Nov-2010 07:59;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008,1009**;Sep 23,2004
EN ; -- main entry point for APSP LM REFILL REQUEST
 D EN^VALM("APSP LM REFILL REQUEST")
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 N LINE,MSGID,IEN,SEG,HLDATA,APSPMSH,APSPPID,APSPORC,APSPRX0,APSPRXE,DRUG,PAT,PATLN,PATFN,LINEVAR,ITMDATE
 N PATNAME,STAT
 S VALMCNT=0
 S (IEN,LINE)=0 F  S IEN=$O(^APSPRREQ(IEN)) Q:'IEN  D
 .; do not display if the status is 'processed', there is an OERR order number, or the HL7 data is misisng
 .I $P(^APSPRREQ(IEN,0),U,2)!('$O(^APSPRREQ(IEN,5,0))) Q
 .S STAT=+$$GET1^DIQ(9009033.91,IEN,.03,"I") I "1235"[STAT Q
 .S MSGID=$$GET1^DIQ(9009033.91,IEN,.01,"E"),HLMSG=$$GHLDAT(IEN)
 .D SHLVARS
 .S PATNAME=$$PATNAME(APSPPID)
 .S DRUG=$P($P(APSPRXO,"|",2),U,2)
 .S ITMDATE=$$GET1^DIQ(9009033.91,IEN,.04,"I")
 .S ITMDATE=$$FMTE^XLFDT($P(ITMDATE,"."),"5Z")
 .; Set up record
 .S LINE=LINE+1,VALMCNT=VALMCNT+1
 .S LINEVAR=""
 .S LINEVAR=$$SETFLD^VALM1(LINE_".",LINEVAR,"ITEM")
 .S LINEVAR=$$SETFLD^VALM1(PATNAME,LINEVAR,"PATIENT")
 .S LINEVAR=$$SETFLD^VALM1(DRUG,LINEVAR,"DRUG")
 .S LINEVAR=$$SETFLD^VALM1(MSGID,LINEVAR,"MSGID")
 .S LINEVAR=$$SETFLD^VALM1(ITMDATE,LINEVAR,"DATE")
 .D SET^VALM10(LINE,LINEVAR,IEN)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D CLEAN^VALM10
 D FULL^VALM1
 Q
 ;
EXPND ; -- expand code
 Q
 ;
GHLDAT(IEN) ; Get HL7 message data from APSP REFILL REQUEST FILE
 N HLMSG
 S HLMSG=$$GET1^DIQ(9009033.91,IEN,5,"","HLDATA")
 Q HLMSG
 ;
SHLVARS ; Set up HL segment data
 N SEGTYP,VAR
 F SEGTYP="MSH","PID","ORC","RXO","RXE","RXR" S VAR="APSP"_SEGTYP,@VAR="",@VAR=$$GETSEG(.HLDATA,SEGTYP)
 Q
 ; Input:  DATA - HL7 data from APSP REFILL REQUEST file
 ;         TYPE - Message segment requested
GETSEG(DATA,TYPE) ;
 N X,RET,Q
 S RET="",(X,Q)=0 F  S X=$O(DATA(X)) Q:'X!(Q)  D
 .S DAT=$G(DATA(X)) I DAT="" S RET="" Q
 .I $P(DAT,"|")=TYPE S RET=DAT,Q=1 Q
 Q RET
 ;
CREATE ; Create new OE/RR order
 N ITEM,HLMSG,APSPMSH,APSPPID,APSPORC,APSPRXO,APSPRXE,IEN,IENS,ID,IDIEN,DAT,DFN,PROV,UNITS,NOUN
 N DUR,CONJ,VERB,SIGNOD,INSTNOD,SIG,DUPD,X,Z,ORDIALOG,NORIFN,ORVP,DIALOG,ORNP,STATUS,APSPRXO
 N APSPRXE,APSPRXR,APSPORC,APSPPID,DIEN,IDIEN,DUOUT,FIL2,FIL3,FIL,LIST,LOC,ROUTE,CNT,DIR,PHARM
 N CLININD,OPSIEN,SSRTEXT,DAW,MISLIST
 ; item selection
 I '$O(@VALMAR@(0)) D BACK Q
 S ITEM=$$SELITEM() I 'ITEM!(ITEM["^") D BACK Q
 S FIL=9009033.91,FIL2=9009033.912,FIL3=9009033.913
 ; set up hl7 variables
 S HLMSG=$$GHLDAT(ITEM) D SHLVARS
 ; get data from APSP REFILL REQUESTS FILE
 D PREPPTXT^APSPES2("PTXT",ITEM)
 I $D(PTXT) D
 .S $P(LINE,"-",80)="" W !,LINE,!,"Displaying order information"
 .D FULL^VALM1
 .S I=0 F  S I=$O(PTXT(I)) Q:'I  W !,PTXT(I)
 .W !,LINE
 S CHKPROC=$$DIRYN^APSPUTIL("Are you sure you wish to create this order?","YES",,.POP) I POP D BACK Q
 D GETS^DIQ(9009033.91,ITEM,"**","IE","DATA")
 S IEN=ITEM_","
 ; quit if status is 'PROCESSED' or 'PROCESSING'
 S STATUS=+$G(DATA(FIL,IEN,.03,"I")) I "235"[STATUS D BACK Q
 S LOC=$$GET1^DIQ(9009033.91,ITEM,1.6,"I")
 S PHARM=$$GET1^DIQ(9009033.91,ITEM,1.7,"I")
 ; Get the orderable item
 S DAT("ORDERABLE")=$G(DATA(FIL,IEN,1.1,"I"))
 I 'DAT("ORDERABLE") D FULL^VALM1 W !!,"No orderable item defined. Can not process." S DIR(0)="FO",DIR("A")="Press <Return> to continue" D ^DIR,BACK Q
 I '$D(DATA(FIL,IEN,1.5,"E")) W !!,"Days Supply not defined. Can not process." S DIR(0)="FO",DIR("A")="Press <Return> to continue" D ^DIR,BACK Q
 ; get the IEN and try to locate the drug from ^PSDRUG
 S ID=$$GET1^DIQ(101.43,DAT("ORDERABLE"),2,"E"),IDIEN=$P(ID,";"),DAT("DRUG")=$O(^PSDRUG("ASP",IDIEN,0))
 S DFN=$G(DATA(FIL,IEN,1.2,"I")),PROV=$G(DATA(FIL,IEN,1.3,"I"))
 S DAT("QTY")=+$G(DATA(FIL,IEN,1.4,"E")),DAT("SUPPLY")=$G(DATA(FIL,IEN,1.5,"E"))
 S INSTNOD=$O(^APSPRREQ(ITEM,2,0))
 I 'INSTNOD D FULL^VALM1 W !!,"No medication instructions, can not process entry." S DIR(0)="FO",DIR("A")="Press <Return> to continue" D ^DIR,BACK Q
 ; Get all possible doses
 S INST=0,CNT=1
 F  S INST=$O(^APSPRREQ(ITEM,2,INST)) Q:'INST  D
 .S IENS=INST_","_IEN
 .S (DAT("DOSE",CNT),DAT("INSTR",CNT),DAT("STRENGTH",CNT))=$G(DATA(FIL2,IENS,.01,"E")),DUPD=$G(DATA(FIL2,IENS,1,"E"))
 .S UNITS=$G(DATA(FIL2,IENS,2,"I"))
 .S NOUN=$G(DATA(FIL2,IENS,3,"E")),DUR=$G(DATA(FIL2,IENS,4,"E")),DAT("CONJ")=$G(DATA(FIL2,IENS,5,"I"))
 .S DAT("ROUTE",CNT)=$G(DATA(FIL2,IENS,6,"I")),DAT("SCHEDULE",CNT)=$G(DATA(FIL2,IENS,7,"E")),VERB=$G(DATA(FIL2,IENS,8,"E"))
 .S CNT=CNT+1
 ;
 S DAT("REFILLS")=0
 ; Get clinical indicator and build array for the data element. This field can be a multiple.
 ; TODO - parse apart clinical indicator to set both CLININD and CLININD2
 S CLININD=$P(APSPRXO,"|",21)
 S DONE=1
 ; Set up clinical indicator and REFREQ IEN into ORDIALOG
 F I=1:1  D  Q:DONE
 .I $P(CLININD,U,I)']"" Q
 .S ORDIALOG($$PTR^ORCD("OR GTX CLININD"),I)=$P(CLININD,U,I)
 S ORDIALOG($$PTR^ORCD("OR GTX SSRREQIEN"),1)=ITEM
 S DAW=$P($G(APSPRXO),"|",10)
 S ORDIALOG($$PTR^ORCD("OR GTX DAW"),1)=DAW
 D PREPPTXT^APSPES2("SSRTEXT",ITEM)
 S I=0 F  S I=$O(SSRTEXT(I)) Q:'I  D
 .S TXT=$G(SSRTEXT(I))
 .S NSSRTXT(I,0)=TXT
 S ORDIALOG($$PTR^ORCD("OR GTX SSREFREQ"),1)="NSSRTXT"
 S ORDIALOG($$PTR^ORCD("OR GTX PHARMACY"),1)=PHARM
 S SIGNOD=0
 I '$O(^APSPRREQ(ITEM,3,SIGNOD)) D FULL^VALM1 W !,"No signature, can not process entry." S DIR(0)="FO",DIR("A")="Press <Return> to continue" D ^DIR,BACK Q
 F  S SIGNOD=$O(^APSPRREQ(ITEM,3,SIGNOD)) Q:'SIGNOD  D
 .S IENS=SIGNOD_","_IEN
 .S DAT("SIG",SIGNOD,0)=$G(DATA(FIL3,IENS,.01,"E"))
 S DIALOG=$O(^ORD(101.41,"B","PSO OERR",0))
 I 'DIALOG D FULL^VALM1 W !,"Order dialog 'PSO OERR' could not be found." S DIR(0)="FO",DIR("A")="Press <Return> to continue" D ^DIR,BACK Q
 D DLGDEF^ORWDX(.LIST,"PSO OERR")
 S ORDIALOG=$O(^ORD(101.41,"B","PSO OERR",0))
 F X="ORDERABLE","INSTR","ROUTE","SCHEDULE","QTY","SIG","DOSE","DRUG","CONJ","SUPPLY","REFILLS" D
 .S Z=0 F  S Z=$O(LIST(Z)) Q:'Z  D
 ..I $P($G(LIST(Z)),U)=X D
 ...S DIEN=$P(LIST(Z),U,2)
 ...I X="SIG" S ORDIALOG(DIEN,1)="DAT(""SIG"")" Q
 ...I $O(DAT(X,0)) D  Q
 ....S SN=0 F  S SN=$O(DAT(X,SN)) Q:'SN  D
 .....S ORDIALOG(DIEN,SN)=$G(DAT(X,SN))
 ...S ORDIALOG(DIEN,1)=$G(DAT(X))
 S ORDIALOG($$PTR^ORCD("OR GTX ROUTING"),1)="E"
 S ORDIALOG($$PTR^ORCD("OR GTX URGENCY"),1)=$O(^ORD(101.42,"B","ROUTINE",0))
 S ORDIALOG($$PTR^ORCD("OR GTX LOCATION"),1)=LOC
 S ORDCHK=$$CHKORD(.ORDIALOG,.MISLIST)
 I 'ORDCHK D DISPMIS(.MISLIST) S DIR(0)="FO",DIR("A")="Press <Return> to continue" D ^DIR,BACK Q
 I '$$SCREEN^APSPMULT(+$G(DAT("DRUG")),,1) W !,"Not a valid refill drug" S DIR(0)="FO",DIR("A")="Press <Return> to continue" D ^DIR,BACK Q  ;IHS/MSC/JDS - 11/20/2010
 S ORVP=DFN_";DPT(",ORNP=PROV
 D SAVE^ORWD(.Y,DFN,PROV,$G(LOC),DIALOG,"N",.ORDIALOG)
 I $G(Y) S NORIFN=$P($P($P(Y(1),U),";"),"~",2)
 I '$G(NORIFN) D FULL^VALM1  W !,"Order not filed.",!,"Check data and try again." S DIR(0)="FO",DIR("A")="Press <Return> to continue" D ^DIR,BACK Q
 D EN^OCXOERR(DFN_U_+NORIFN_U_PROV_"^^^^^1")
 S FDA(9009033.91,ITEM_",",.02)=NORIFN
 S FDA(9009033.91,ITEM_",",.03)=1
 S FDA(9009033.91,ITEM_",",.07)=$$NOW^XLFDT()
 D FILE^DIE(,"FDA") K FDA
 D BACK
 Q
DISPHL7(PAT,QTY,PROV,DRUG,NOTE,STR,UNITS,ROUTE,NOUN,SCHARY,MEDUNITS,REFILLS,PHARM,SIG,ARY) ; Display HL7 data
 N LINE,K
 W !!
 S $P(LINE,"-",80)=""
 W LINE
 W !,"   Displaying incoming HL7 data:",!
 W !,"                   Patient: "_PAT
 W !,"                  Provider: "_PROV
 W !,"                Medication: "_DRUG
 W !,"                       SIG: "_SIG
 W !,"                      Note: "_NOTE
 W !,"                  Quantity: "_QTY
 W !,"                   Refills: "_REFILLS
 W !,"                  Pharmacy: "_PHARM
 W !!,"  Dosing information: (multiple line items indicates complex dosing)"
 W:$D(SCHARY) !,?3,"Units/Dose",?15,"Interval",?25,"Duration",?35,"Conjunction"
 F K=1:1 D  Q:'$D(SCHARY(K))
 .I $D(SCHARY(K)) W !,?5,$P(SCHARY(K),U),?15,$P(SCHARY(K),U,2),?25,$P(SCHARY(K),U,3),?35,$P(SCHARY(K),U,4)
 W !,LINE
 Q
 ;
 ;
CHKDEF(IEN,TEXT) ;
 N FOUND,X
 S FOUND=0
 S X=0 F  S X=$O(^APSPRREQ(ITEM,3,X)) Q:'X  D
 .I $G(^APSPRREQ(ITEM,3,X,0))=TEXT S FOUND=1
 Q FOUND
SELITEM() ;
 N MAX,PARAM,DPRMPT,ITEM,IEN
 S MAX=$O(^TMP("VALMAR",$J,VALMEVL,"IDX",""),-1)
 S PARAM="NO^1:"_MAX,DPRMPT="Select Entry"
 ; Prompt for item to edit
 S ITEM=$$DIR^APSPUTIL(PARAM,DPRMPT)
 I 'ITEM Q 0
 I '$D(^TMP("VALMAR",$J,VALMEVL,"IDX",ITEM)) Q 0
 S IEN=$O(^TMP("VALMAR",$J,VALMEVL,"IDX",ITEM,0))
 Q IEN
PATNAME(PIDSEG) ;
 N PAT,PATLN,PATFN,PATNAME
 S PAT=$P(PIDSEG,"|",6) I '$L(PAT) Q ""
 S PATLN=$P(PAT,U),PATFN=$P(PAT,U,2),PATNAME=PATLN_","_PATFN
 Q PATNAME
BACK ;
 ;L -^APSPRREQ(ITEM)
 K @VALMAR D INIT
 S VALMBCK="R"
 Q
 ;
 ; Builds array of control data
BLDARY(FLDARY) ;
 N QUIT,TEXT
 S QUIT=0
 F I=1:1 D  Q:QUIT
 .S TEXT=$T(FLDLST+I) I $P(TEXT,";;",2)="" S QUIT=1 Q
 .S FLDARY(I)=$T(FLDLST+I)
 Q
 ; Parameterized DIE call for top level field
PRMPT(FILE,IENS,FLD,DFT) ; PROMPT FIELD
 N DIE,DA,DR,Y,X
 S DIE("NO^")="OUTOK"
 S DIE=FILE,DA=IENS,DR=FLD_"//"_$S($L($G(DFT)):DFT,1:"") D ^DIE
 Q $D(Y)
 ;
 ;Parameterized DIE call for subfile
PRMPT2(FILE,TIEN,SIEN,FLD,NODE,DFT) ;
 N DIE,DA,DR,Y,X,DEL
 S DEL=0
 S DIE("NO^")="OUTOK"
 S DIE="^APSPRREQ("_ITEM_","_NODE_",",DA(1)=TIEN,DA=SIEN,DR=FLD_"//"_$S($D(DFT):DFT,1:"") D ^DIE
 I '$D(DA) S DEL=1
 Q $D(Y)_"|"_DEL
 ;
GETIEN(FILE,PRMT,DEF,POP) ;
 N DIC,APSPD,Y
 S POP=0
 I '$D(DEF) S DEF=" "
 S APSPD=$$GET1^DIQ(FILE,$$FIND1^DIC(FILE,,,DEF),.01)
 S DIC=FILE,DIC(0)="AE",DIC("A")=$G(PRMT),DIC("B")=APSPD
 D ^DIC
 S:Y'>0 POP=1
 Q +Y
 ; Display missing data elements to user.
 ; input - MLIST (from CHKORD), passed by reference
DISPMIS(MLIST) ;
 N ITEM,LINE
 S $P(LINE,"-",80)="" W !!,LINE
 W !,"The following items are not defined. This order can not be created."
 W !,"Please correct these items and try again."
 S ITEM="" F  S ITEM=$O(MLIST(ITEM)) Q:ITEM']""  D
 .W !,ITEM
 W !,LINE
 Q
 ; Input: OARY - ORDIALOG passed in by reference
 ;        MLIST - List of data elements that are missing from the order (pass by ref.), returned to calling module
CHKORD(OARY,MLIST) ;
 N STAT,I,DONE,CHKITEM,CHKIEN
 S STAT=1,DONE=0
 F I=1:1 D  Q:DONE
 .S CHKITEM=$P($T(REQFLDS+I),";;",2)
 .I '$L(CHKITEM) S DONE=1 Q
 .S CHKIEN=$O(^ORD(101.41,"B",CHKITEM,0))
 .I 'CHKIEN Q
 .; if the array item doesn't exist, place it in the 'missing' array and set stat to zero
 .I '$D(OARY(CHKIEN)) S MLIST(CHKITEM)=CHKIEN,STAT=0 Q
 .; if the array item exists, but there is no data populated, set the 'missing' array item and stat to zero
 .I $D(OARY(CHKIEN)),'$L($G(OARY(CHKIEN,1))) S MLIST(CHKITEM)=CHKIEN,STAT=0 Q
 Q STAT
REQFLDS ;
 ;;OR GTX ORDERABLE ITEM
 ;;OR GTX INSTRUCTIONS
 ;;OR GTX ROUTE
 ;;OR GTX SCHEDULE
 ;;OR GTX URGENCY
 ;;OR GTX ROUTING
 ;;OR GTX REFILLS
 ;;OR GTX DAYS SUPPLY
 ;;OR GTX PHARMACY
 ;;OR GTX DAW
 ;;OR GTX SSREFREQ
 ;;OR GTX SSRREQIEN
 ;;
 Q
