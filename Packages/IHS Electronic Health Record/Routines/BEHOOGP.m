BEHOOGP ;IHS/MSC/MGH - Group Order API  ;27-Sep-2010 10:21;MGH
 ;;1.1;BEH COMPONENTS;**011003**;Sep 23,2004
 Q
 ;===================================================================
 ;Input
 ;   LST=array containing LST(n,"DFN")=PATIENT IEN
 ;                        LST(n,"PRV")=PROVIDER IEN
 ;                        LST(n,"CLN")=ICD9 code for clinical indication
 ;   ORDITM=IEN of the orderable item(ie. screening mammogram)
 ;   STDT=Start date/time in fileman format
 ;   LOC=IEN of ordering location from hosital location file (File 44)
 ;   DGRPRV = IEN of group provider (optional) (File 200)
 ;   ORDTXT = Array of text
 ;            Entered as ORDTXT(n,0)=TEXT
 ;Return array of entries in the format
 ;
 ;  OUTLST(1)="12^623^ORDER CREATED"
 ;            DFN^ORDER IEN^Additional Order TEXT
 ;  OUTLST(2)="24^0^Duplicate order: MAMMOGRAM BILAT 9/21/10 [PENDING]"
 ;            DFN^NOT CREATED^ERROR MESSAGE
 ;=====================================================================
GRPORD(OUTLST,LST,ORDITM,STDT,LOC,DGRPRV,ORDTXT) ;API  Entry point to make group order
 N ENTRY,DFN,PRV,PROV,DIALOG,CNT,INACT,OIOK,PKG,CI,IMGLO
 S OIOK=$$OICHK(ORDITM)
 I 'OIOK D ERR("Non-existent or inactive orderable item sent") Q
 I $G(STDT)="" D ERR("No date/time for order sent") Q
 ;Find order dialog
 S DIALOG=$$ODIALOG(ORDITM)
 I 'DIALOG D ERR("Order dialog could not be found.") Q
 S PKG=$$OPKG(DIALOG)
 I PKG="" D ERR("Package data for order dialog not available") Q
 I PKG="RA"&($D(ORDTXT)<10) D ERR("Missing reason for exam") Q
 I PKG="RA" D  I 'IMGLO D ERR("Imaging location not properly defined for this division") Q
 .S IMGLO=$$IMGLOC(ORDITM)
 S CNT=0
 S ENTRY=""  F  S ENTRY=$O(LST(ENTRY)) Q:ENTRY=""  D
 .S DFN=$G(LST(ENTRY,"DFN"))
 .S PROV=+$G(LST(ENTRY,"PRV"))
 .S:'PROV PROV=$$FINDPRV()
 .I 'PROV D RETERR("Unable to find provider for order") Q
 .I PKG="LR" D  I 'CI D RETERR("Unable to find clinical indication for order") Q
 ..S CI=$G(LST(ENTRY,"CLN"))
 .D CREATE
 Q
CREATE ; Create new OE/RR order
 N ITEM,IEN,IENS,ID,IDIEN,DAT,LST,LST2,ORDCHK,NORIEN,Y
 N DUR,SIGNOD,SIG,INSTNOD,DUPD,X,Z,ORDIALOG,NORIFN,ORVP,ORNP,STATUS
 N DIEN,IDIEN,DUOUT,LIST,FID,OIL,DIR,OPSIEN,WP,MISLIST,ACT
 ; Get the orderable item
 D DLGDEF^ORWDX(.LIST,"RA OERR EXAM")
 S ORDIALOG=DIALOG
 S ORDIALOG($$PTR^ORCD("OR GTX ORDERABLE ITEM"),1)=ORDITM
 S ORDIALOG($$PTR^ORCD("OR GTX START DATE/TIME"),1)=STDT
 S ORDIALOG($$PTR^ORCD("OR GTX URGENCY"),1)=$O(^ORD(101.42,"B","ROUTINE",0))
 S ORDIALOG($$PTR^ORCD("OR GTX LOCATION"),1)=LOC
 S ORDIALOG($$PTR^ORCD("OR GTX PROVIDER"),1)=PROV
 S ACT="C"_PKG
 I $L($T(@ACT)) D @ACT
 ;Do order checks first
 S FID=PKG
 S OIL(1)=ORDITM
 D ACCEPT^ORWDXC(.LST2,DFN,FID,STDT,1,.OIL)
 I $G(LST2(1))'=""  D RETERR($P(LST2(1),U,4)) Q
 ;Put dialog together
 S ORDCHK=$$CHKORD(.ORDIALOG,.MISLIST)
 I 'ORDCHK D DISPMIS(.MISLIST) Q
 S ORVP=DFN_";DPT(",ORNP=PROV
 D SAVE^ORWD(.Y,DFN,PROV,$G(LOC),DIALOG,"N",.ORDIALOG)
 I $G(Y) S NORIEN=$P($P($P(Y(1),U),";"),"~",2)
 I '$G(NORIEN) D RETERR("Order not filed.") Q
 S CNT=CNT+1
 S OUTLST(CNT)=DFN_U_NORIEN_U_"ORDER CREATED"
 ;Check for signature action
 S SIG=$$GET^XPAR("ALL","BEHOOGP SIGN ORDERS",1,"I")
 I SIG=1 D SIGN(.ERRLST,DFN,PROV,LOC,NORIEN)
 Q
 ;
DISPMIS(MLIST) ;EP -
 N ITEM,LINE
 D RETERR("Items were missing from the order dialog.This order can not be created")
 Q
 ; Return patient primary provider if defined, otherwise the group provider passed in.
FINDPRV() ;EP-
 N PCP
 S PCP=$$GET1^DIQ(9000001,DFN,.14,"I")                                 ;pcp ien
 S:'PCP PCP=$G(DGRPRV)
 Q +PCP
 ; Add signature for either electronic or policy order
SIGN(ERRLST,DFN,ORNP,LOC,ORDER) ;EP -
 N ORVP,ORL,ERRCNT,RELSTS,ACTION,SIGSTS,ORIFN,ANERROR,NATR,ORWSIGN
 S RELSTS=1,ACTION=1,SIGSTS=1
 S ORVP=DFN_";DPT(",ORL(2)=LOC_";SC(",ORL=ORL(2),ERRCNT=0
 I '$D(^XUSEC("ORES",DUZ))&('$D(^XUSEC("ORELSE",DUZ))) Q
 I $D(^XUSEC("ORES",DUZ)) S NATR="E"
 I $D(^XUSEC("ORELSE",DUZ)) S NATR="I"
 S ORIFN=ORDER_";1"
 D EN^ORCSEND(ORIFN,"",SIGSTS,RELSTS,NATR,"",.ANERROR)
 I $L(ANERROR) D  Q                                                    ; don't print if an error occurred
 . S OUTLST(CNT)=OUTLST(CNT)_" "_ANERROR
 . K ORWSIGN(1)
 I RELSTS=0 K ORWSIGN(1) Q                                             ; don't print if unreleased
 S ORWSIGN(1)=ORDER
 D PRINTS^ORWD1(.ORWSIGN,LOC)
 Q
 ; Add error text to output array if error in input validation of parameters
ERR(ERRTXT) ;EP-
 S OUTLST(0)=ERRTXT
 Q
 ; Add error text to output array if error occurs during processing or validation of patient specific information
RETERR(ERRTXT) ;EP-
 S CNT=CNT+1
 S OUTLST(CNT)=DFN_U_0_U_ERRTXT
 Q
 ; Build Radiology order dialog responses
CRA ;EP-
 S ORDIALOG($$PTR^ORCD("OR GTX MODE OF TRANSPORT"),1)="A"
 S ORDIALOG($$PTR^ORCD("OR GTX IMAGING LOCATION"),1)=IMGLO
 S ORDIALOG($$PTR^ORCD("OR GTX PREGNANT"),1)="u"
 S ORDIALOG($$PTR^ORCD("OR GTX CATEGORY"),1)="O"
 S WP=$$PTR^ORCD("OR GTX WORD PROCESSING 1")
 M ORDIALOG("WP",WP,1)=ORDTXT
 S ORDIALOG(WP,1)="ORDIALOG(""WP"",WP,1)"
 Q
 ; Return imaging location associated with orderable item
IMGLOC(ORDITM) ;EP-
 N RAD,RADIEN,RADTYP,ABB,X,ILOC,STOP,ORY
 S STOP=0,ILOC=""
 S RAD=$$GET1^DIQ(101.43,ORDITM,2,"I")
 I 'RAD Q ""
 S RADIEN=$P(RAD,";",1)
 I 'RADIEN Q ""
 S RADTYP=$$GET1^DIQ(71,RADIEN,12,"I")
 I 'RADTYP Q ""
 S ABB=$P($G(^RA(79.2,RADTYP,0)),U,3)
 I ABB="" Q ""
 D EN4^RAO7PC1(ABB,"ORY")
 S X="" F  S X=$O(ORY(X)) Q:X=""!(STOP=1)  D
 .I $P($G(ORY(1)),U,3)=DUZ(2) S ILOC=$P($G(ORY(1)),U,1),STOP=1
 Q ILOC
 ;
 ; Input: OARY - ORDIALOG passed in by reference
 ;        MLIST - List of data elements that are missing from the order (pass by ref.), returned to calling module
OICHK(ORDITM) ;EP-
 ;Check and get data on the orderable item
 N DATE
 I 'ORDITM Q ""
 S DATE=$$GET1^DIQ(101.43,ORDITM,.1,"I")
 I 'DATE Q 1
 I STDT<DATE Q ""
 Q DATE
 ; Return Order Dialog associated with the Orderable Item
ODIALOG(ORDITM) ;EP-
 N DSPGP,DIALOG
 S DSPGP=$$GET1^DIQ(101.43,ORDITM,5,"I")
 I 'DSPGP Q ""
 S DIALOG=$$GET1^DIQ(100.98,DSPGP,4,"I")
 I 'DIALOG  S DIALOG=$O(^ORD(100.98,"AD",DSPGP,""))
 Q DIALOG
 ; Return package associated with an Order Dialog
OPKG(DIALOG) ;EP-
 N PACK,AB
 S PACK=$$GET1^DIQ(101.41,DIALOG,7,"I")
 I 'PACK Q ""
 S AB=$$GET1^DIQ(9.4,PACK,1,"E")
 Q AB
 ; Validate input array
CHKORD(OARY,MLIST) ;EP-
 N STAT,I,DONE,CHKITEM,CHKIEN
 S STAT=1,DONE=0
 F I=1:1 D  Q:DONE
 .S CHKITEM=$P($T(REQFLDS+I),";;",2)
 .I '$L(CHKITEM) S DONE=1 Q
 .S CHKIEN=$O(^ORD(101.41,"B",CHKITEM,0))
 .I 'CHKIEN Q
 .                                                                     ; if the array item doesn't exist, place it in the 'missing' array and set stat to zero
 .I '$D(OARY(CHKIEN)) S MLIST(CHKITEM)=CHKIEN,STAT=0 Q
 .                                                                     ; if the array item exists, but there is no data populated, set the 'missing' array item and stat to zero
 .I $D(OARY(CHKIEN)),'$L($G(OARY(CHKIEN,1))) S MLIST(CHKITEM)=CHKIEN,STAT=0 Q
 Q STAT
 ; Require elements for Radiology dialog
REQFLDS ;
 ;;OR GTX ORDERABLE ITEM
 ;;OR GTX WORD PROCESSING 1
 ;;OR GTX CATEGORY
 ;;OR GTX LOCATION
 ;;OR GTX URGENCY
 ;;OR GTX PREGNANT
 ;;OR GTX START DATE/TIME
 ;;OR GTX MODE OF TRANSPORT
 ;;OR GTX IMAGING LOCATION
 ;;OR GTX PROVIDER
 ;;
 Q
