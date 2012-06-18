BADEHL3 ;IHS/MSC/MGH/VAC - Dentrix HL7 inbound interface  ;01-Oct-2010 10:20;EDR
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 ;; Modified - IHS/MSC/AMF - 11/23/10 - More descriptive alert messages
 ;; Modified - IHS/MSC/AMF 10/2010 fix for hospital location FT1-16,2
 ; Return array of message data
 ; Input: MIEN - IEN to HLO MESSAGES and HLO MESSAGE BODY files
 ; Output: DATA
 ;         HLMSTATE
PARSE(DATA,MIEN,HLMSTATE) ;EP
 N SEG,CNT
 Q:'$$STARTMSG^HLOPRS(.HLMSTATE,MIEN)
 M DATA("HDR")=HLMSTATE("HDR")
 S CNT=0
 F  Q:'$$NEXTSEG^HLOPRS(.HLMSTATE,.SEG)  D
 .S CNT=CNT+1
 .M DATA(CNT)=SEG
 Q
 ; Process incoming DFT message
PROC ;EP
 ;todo- check APP ACK TYPE
 N DATA,ARY,SEGPID,SEGPV1,SEGFT1,ERR,RET,DFN,NAME,NOPV1,APTIME,LOC,OUT,PNAME,POV,PROV,PROVFN,PROVLN,PROVMN,SCODE
 N DRG,DCODE,DCODEQ,PVDIEN,DSPNUM,BADIN,APCDALVR,APCDTNOV,APCDVSIT,SEGIEN,SEGRXD,SURGDES,TCODE,TYPE,VTYPE
 N APCDPAT,APCDTNOU,APCDTOS,APCDTSUR,APCDTFEE,APCDTCDT,APCDTPRV,APCDTEPR,APCDTPNT,APCDTEXK,APCDTSC,APCDTOPR,PARLOC
 N HLNAME,HFNAME,LNAME,NAME,DOB,HLDOB,BADERR,BADEWARN,X,Y,IEN,ASUFAC,ASUFAC2,CCODE,CODEIEN,DESC,VTIME,EXKEY,HOSLOC,MOD
 N PRVNPI,NOOPSITE
 S BADERR=""
 S (APCDTOPR,APCDTPNT)=""
 Q:'$G(HLMSGIEN)
 D PARSE(.DATA,HLMSGIEN,.HLMSTATE)
PID ;Get the PID segment and find the correct patient
 S SEGIEN=$$FSEGIEN(.DATA,"PID")
 I 'SEGIEN D ACK(HLMSGIEN,"","Missing PID segment.") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 M SEGPID=DATA(SEGIEN)
 S DFN=$$GET^HLOPRS(.SEGPID,2)
 I DFN="" D ACK(HLMSGIEN,DFN,"Missing DFN in PID:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 ; Get the ASUFAC number
 N ASUFAC,HFCN,FAC
 S X=$$GET^HLOPRS(.SEGPID,3)
 I X="" D ACK(HLMSGIEN,DFN,"Missing ASUFAC in PID:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S ASUFAC=$E(X,1,6)
 S IEN=$$HRCNF^BADEUTIL(X)
 ; Added new capture of ASUFAC IHS/MSC/VAC 8/2010
 I IEN="" D ACK(HLMSGIEN,DFN,"Missing HRCN in PID:")  Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 ; Check if patient has been merged
 S DFN=$$MRGTODFN^BADEUTIL(DFN)
 I '$D(^DPT(DFN))  D ACK(HLMSGIEN,DFN,"Patient DFN: "_DFN_" not in RPMS.") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S (APCDPAT,BADIN("PAT"))=DFN
 ; Match on birth dates and last names
 S HLNAME=$$GET^HLOPRS(.SEGPID,5,1)
 S HFNAME=$$GET^HLOPRS(.SEGPID,5,2)
 S HLDOB=$$GET^HLOPRS(.SEGPID,7)
 I $L(HLDOB)>8 S HLDOB=$E(HLDOB,1,8)
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S DOB=$$HLDATE^HLFNC(DOB,"DT")
 S NAME=$$GET1^DIQ(2,DFN,.01),LNAME=$P(NAME,",",1)
 ; I LNAME'=HLNAME S BADERR=" Last names for "_DFN_" do not match in message"
 ; I DOB'=HLDOB S BADERR=" Birth dates for "_DFN_" do not match in message"
 ; I BADERR'="" D ACK(BADERR) Q
PV1 ;Get the PV1 segment and get enough data to create the visit
 S NOPV1=0
 S SEGIEN=$$FSEGIEN(.DATA,"PV1")
 I 'SEGIEN S NOPV1=1
 E  M SEGRXD=DATA(SEGIEN)
FT1 ;Get the FT1 segment
 S SEGIEN=$$FSEGIEN(.DATA,"FT1")
 I 'SEGIEN D ACK(HLMSGIEN,DFN,"Missing FT1 segment:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 M SEGFT1=DATA(SEGIEN)
 ;Get the date/time of visit
 S X=$$GET^HLOPRS(.SEGFT1,4)
 I X="" D ACK(HLMSGIEN,DFN,"Missing visit date in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 ; If no time on this visit, check the parameter to see if a default time exists
 I $L(X)=8 D
 .S VTIME=$$GET^XPAR("ALL","BADE EDR DEFAULT TIME")
 .S:VTIME="" VTIME=1138 ;IHS/MSC/AMF 10/2010 Change in default visit time
 .S X=X_VTIME
 S Y=$$FMDATE^HLFNC(X)
 I $P(Y,".")>$$DT^XLFDT S BADERR=" " D ACK(HLMSGIEN,DFN,"Future visit date not allowed:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S BADIN("VISIT DATE")=Y
 D DD^%DT S APCDTCDT=Y   ;External format
 ;This field determines if its new (0), update (2) or delete (1)
 S DESC=$$GET^HLOPRS(.SEGFT1,9)
 S APCDTEXK=$$GET^HLOPRS(.SEGFT1,2)  ;Special code
 I APCDTEXK="" D ACK(HLMSGIEN,DFN,"Missing Dentrix ID in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 ;First, check to see if this code is already in the V dental file
 S EXKEY="" S EXKEY=$O(^AUPNVDEN("AXK",APCDTEXK,EXKEY))
 I EXKEY'="" D
 .I DESC=0 S BADERR=" Unique id "_APCDTEXK_" already exists " Q
 .;If transaction description is to delete, must find existing entry
 .I DESC=1 D DEL^BADEHL4 Q
 .;If transcaction description is to update, must find existing entry
 .I DESC=2 D UPD^BADEHL4  Q
 I EXKEY="" D
 .I DESC=1 S BADERR="Can't delete Dentrix ID "_APCDTEXK_" doesn't exist:" Q  ;IHS/MSC/AMF 10/2010 eliminate jump out of loop
 .I DESC=2 S BADERR="Can't update Dentrix ID "_APCDTEXK_" doesn't exist:" Q  ;IHS/MSC/AMF 10/2010 eliminate jump out of loop
 .I DESC=0 D NEW
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
NEW ;Create a new dental procedure
 N DUSER
 S APCDTNOV=1
 S TYPE=$$GET^HLOPRS(.SEGFT1,6)
 S TCODE=$$GET^HLOPRS(.SEGFT1,7)
 I TCODE="" D ACK(HLMSGIEN,DFN,"Missing ADA code in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 I $E(TCODE,1,1)="D" S SCODE=$E(TCODE,2,$L(TCODE))
 E  S SCODE=TCODE
 S CODEIEN="" S CODEIEN=$O(^AUTTADA("B",SCODE,CODEIEN))
 I CODEIEN="" D ACK(HLMSGIEN,DFN,"ADA code "_TCODE_" not in RPMS:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S NOOPSITE=$$GET1^DIQ(9999999.31,CODEIEN,.09,"I")="n"
 ;Charge amount
 S APCDTFEE=$$GET^HLOPRS(.SEGFT1,11)
 ; ----- IHS/MSC/AMF 10/2010 fix for FT1-16,2
 ;Find the location and clinic location
 S ASUFAC2=$$GET^HLOPRS(.SEGFT1,16,1)
 S HOSLOC=$$GET^HLOPRS(.SEGFT1,16,2)
 I $L(ASUFAC2) I HOSLOC="" S ASUFAC=ASUFAC2
 ;
 S BADEWARN=""
 S HOSLOC2=0 I $L(HOSLOC) S HOSLOC2=1
 I +HOSLOC2=1  D
 .S PARLOC=+$O(^SC("B",HOSLOC,"")) I 'PARLOC S BADEWARN="Warning: Clinic "_HOSLOC_" is not valid ",HOSLOC="" Q
 .S LOC=+$P($G(^SC(PARLOC,0)),U,4) I LOC="" S BADEWARN="Warning: Location not found for Clinic "_HOSLOC,HOSLOC=""
 I +HOSLOC2=0 D
 .S LOC=$O(^AUTTLOC("C",ASUFAC,"")) I '$L(LOC) S BADERR="No location associated with ASUFAC "_ASUFAC Q
 .S PARLOC=+$$GET^XPAR("DIV.`"_LOC_"^SYS","BADE EDR DEFAULT CLINIC") I 'PARLOC S BADERR=" There is no default clinic for this location "_ASUFAC Q
 .S LOCA=+$P($G(^SC(PARLOC,0)),U,4) I LOCA'=LOC S BADERR="Location, this ASUFAC, and the DEFAULT CLINIC is incorrect "_ASUFAC Q
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 I $L(BADEWARN) D ACK(HLMSGIEN,DFN,BADEWARN) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 ; ----- end IHS/MSC/AMF 10/2010 fix for FT1-16,2
 ;
 I LOC>0 D
 .S DUZ(2)=LOC  ;SAC Exemption requested
 .S DUSER=$$DUSER^BADEUTIL(LOC)
 .S:DUSER DUZ=DUSER
 S POV=$$GET^HLOPRS(.SEGFT1,19)
 ;Provider ID
 S PROV=+$$GET^HLOPRS(.SEGFT1,20,1)
 ;S PROV="" S PROV=+$O(^VA(200,"ANPI",PRVNPI,PROV))
 I 'PROV D ACK(HLMSGIEN,DFN,"Missing provider in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S BADIN("PROVIDER")=PROV
 S PNAME=$P($G(^VA(200,PROV,0)),U,1)
 S PROVLN=$$GET^HLOPRS(.SEGFT1,20,2)
 S PROVFN=$$GET^HLOPRS(.SEGFT1,20,3)
 S PROVMN=$$GET^HLOPRS(.SEGFT1,20,4)
 S MOD=$$GET^HLOPRS(.SEGFT1,26,1)  ;Operative Site Code (may contain text)
 S SURGDES=$$GET^HLOPRS(.SEGFT1,26,2)  ;Operative Site Descriptive Text
 S APCDTOS=$S(NOOPSITE:"",1:$$GETTOS^BADEHL4(MOD,SURGDES))
 I 'NOOPSITE,'APCDTOS S BADERR=" Message lacks a valid ADA Code. Mod/Surg:"_MOD_"/"_SURGDES  D ACK(HLMSGIEN,DFN,BADERR) Q
 S APCDTSUR=$$GET^HLOPRS(.SEGFT1,26,4)  ;Surface Code
 D VISIT
 Q
VISIT ;Create the visit
 S BADIN("PAT")=DFN
 S BADIN("TIME RANGE")=0  ; Try for exact match
 S BADIN("SRV CAT")="A"    ; Ambulatory
 S BADIN("VISIT TYPE")=$S($P($G(^APCCCTRL(DUZ(2),0)),U,4)]"":$P(^(0),U,4),1:"I")
 S CCODE="" S CCODE=$O(^DIC(40.7,"C",56,CCODE))  ;Stop Code
 S BADIN("CLINIC CODE")=CCODE
 S BADIN("HOS LOC")=PARLOC  ;
 S BADIN("SITE")=DUZ(2)
 S BADIN("USR")=DUZ
 S BADIN("APCDOPT")=$$GETOPT()
 S BADIN("NEVER ADD")=1
 S FVST=$$FNDVST(.BADIN)
 I 'FVST D
 .S FVST=$$MAKEVST(.BADIN) ; FAILED TO FIND MATCH
 .S VTYPE="NEW"
 E  D
 .S VTYPE="ADD"
 I 'FVST S BADERR=" Unable to create visit for message "
 I BADERR'="" D ACK(HLMSGIEN,DFN,BADERR) Q
 S APCDVSIT=FVST
 ;Add the data to the dental file
 ;Deletion type to existing visit
 ;IHS/MGH/MGH added parameter to PRV call for patch 1
 I VTYPE="NEW" D POV,PRV("P"),DENT
 I VTYPE="ADD" D CHECKPRV,DENT
 N MSHMSG,MSA
 I DATA("HDR","APP ACK TYPE")="AL" D ACK(BADERR)
 Q
ACK(HLMSGIEN,DFN,BADERR) ;Send acknowledgement IHS/MSC/AMF 11/23/10 More descriptive alert
 N STR
 I BADERR'="" D
 .S STR="" I $L(DFN) S STR=$E($P($G(^DPT(DFN,0)),U,1),1,15)_" ["_DFN_"]"
 .S BADERR="Msg: "_HLMSGIEN_" "_BADERR_" "_STR
 .D NOTIF(HLMSGIEN,BADERR)
 ; End IHS/MSC/AMF 11/23/10
 N PARMS,ACK,ERR
 I BADERR=""  S PARMS("ACK CODE")="AA",MSHMSG="Transaction successful"
 I BADERR'="" S PARMS("ACK CODE")="AR",MSHMSG=BADERR
 S:PARMS("ACK CODE")'="AA" PARMS("ERROR MESSAGE")=BADERR
 I '$$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR) D NOTIF(HLMSGIEN,ERR) Q
 ; Comment out following line to not send ACK's to Dentrix  IHS/MSC/VAC 8/2010
 ;I '$$SENDACK^HLOAPI2(.ACK,.ERR) D NOTIF(HLMSGIEN,ERR) Q
 Q
POV ;Store the POV
 N APCDALVR
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDTNQ")="DENTAL/ORAL HEALTH VISIT"
 S APCDALVR("APCDOVRR")=1
 S APCDALVR("APCDTPOV")="V72.2"
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]" D EN^APCDALVR
 K APCDOVRR,APCDALVR("APCDOVRR")
 Q
CHECKPRV ;Check to see if the provider in the message is already on this visit
 ;If not, add the provider
 N VPRV,MATCH,PRVIEN,PRIM ;IHS/MSC/MGH 7/2010 new var PRIM for patch 1
 S PRIM="P"
 S MATCH=0
 S VPRV="" F  S VPRV=$O(^AUPNVPRV("AD",APCDVSIT,VPRV)) Q:VPRV=""  D
 .S PRVIEN=$P($G(^AUPNVPRV(VPRV,0)),U,1)
 .;IHS/MSC/MGH 7/2010 Check for primary provider patch 1
 .I $P($G(^AUPNVPRV(VPRV,0)),U,4)="P" S PRIM="S"
 .I PROV=PRVIEN S MATCH=1
 I MATCH=0 D PRV(PRIM)   ;patch 1 parameter added
 Q
PRV(PRIMARY) ;Store the provider patch 1 added parameter
 N APCDALVR
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDTPRO")="`"_PROV
 S APCDALVR("APCDTPS")=PRIMARY
 I DESC=0 S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]" D EN^APCDALVR
 I DESC=2 S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]" D EN^APCDALVR
 Q
DENT ;Store the procedure
 N APCDALVR
 S APCDALVR("APCDACS")=""
 S APCDALVR("APCDTSC")="`"_CODEIEN
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("AUPNTALK")=""
 S APCDALVR("APCDANE")=""
 S APCDALVR("APCDTNOU")=1
 S APCDALVR("APCDTSUR")=APCDTSUR
 S APCDALVR("APCDTFEE")=APCDTFEE
 S APCDALVR("APCDTCDT")=APCDTCDT
 S APCDALVR("APCDTCLN")="DENTAL"
 S APCDALVR("APCDTEPR")=PNAME
 S APCDALVR("APCDTPRV")=PNAME
 S:APCDTOS APCDALVR("APCDTOS")="`"_APCDTOS
 S APCDALVR("APCDLOC")="`"_LOC
 S APCDALVR("APCDTEXK")=APCDTEXK
 I DESC=0 S APCDALVR("APCDATMP")="[APCDALVR 9000010.05 (ADD)]"
 I DESC=2 S APCDALVR("APCDATMP")="[APCDALVR 9000010.05 (ADD)]"
 D EN^APCDALVR
 ;IHS/FJE patch 1 added alert notification if VDENT is not added in PCC
 D:$D(APCDAFLG) ACK(HLMSGIEN,DFN,"Unable to create Dental Procedure entry in PCC")
 K APCDAFLG
 Q
 ; Return IEN to particular segment
FSEGIEN(SRC,SEG) ;Segment item
 N LP,RES
 S (LP,RES)=0
 F  S LP=$O(SRC(LP)) Q:'LP  D  Q:RES
 .I $G(SRC(LP,"SEGMENT TYPE"))=SEG S RES=LP
 Q RES
 ;Notification on errors
NOTIF(MSGIEN,MSG) ;Send a alert to a mail group
 N XQA,XQAID,XQDATA,XQAMSG
 S XQAMSG="Msg: "_MSGIEN_" "_$G(MSG) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S XQAID="ADEN,"_DFN_","_50
 S XQDATA="Message Number="_MSGIEN
 S XQA("G.RPMS DENTAL")=""
 D SETUP^XQALERT
 Q
 ; Return Option IEN used to Create
GETOPT() ; EP  IHS/MSC/MGH patch 1
 N RET
 S RET=$$FIND1^DIC(19,,"O","BADE EDR MAIN MENU")
 Q $S(RET:RET,1:"")
 ; Return whether an existing visit can be used or need to create one.
OPT(IEN) ;Check to see if the option n the visit matches the dental option
 N MATCH,OPT
 S MATCH=0
 S OPT=$$GETOPT()
 I $P($G(^AUPNVSIT(IEN,0)),U,24)=OPT S MATCH=1
 Q MATCH
 ; end IHS/MSC/MGH patch 1
FNDVST(CRIT) ;EP
 N IEN,EFLG,OUT,RET
 S RET=0
 D GETVISIT^BSDAPI4(.CRIT,.OUT)
 Q:'OUT(0) 0  ; No visits were found
 S IEN=0,EFLG=0
 F  S IEN=$O(OUT(IEN)) Q:'IEN  D  Q:EFLG
 .I OUT(IEN)="ADD" D
 ..N X
 ..S X="CIANBEVT" X ^%ZOSF("TEST") I $T D BRDCAST^CIANBEVT("PCC."_DFN_".VST",IEN)
 .;IHS/MSC/MGH patch 1 added to check option
 .I $$OPT(IEN) S EFLG=1,RET=IEN Q
 ;IHS/MSC/MGH patch 1 added to check option
 Q $S(RET:RET,OUT(0)=1:$O(OUT(0)),1:0)
 ;
MAKEVST(CRIT) ;EP
 N RET,OUT
 K CRIT("NEVER ADD")
 S CRIT("FORCE ADD")=1
 D GETVISIT^BSDAPI4(.CRIT,.OUT)
 Q:'OUT(0) OUT(0)
 S RET=+$O(OUT(0))
 I OUT(RET)="ADD" D
 .N X
 .S X="CIANBEVT" X ^%ZOSF("TEST") I $T D BRDCAST^CIANBEVT("PCC."_DFN_".VST",RET)
 Q RET
