BEDDUTW	;VNGT/HS/BEE-BEDD Utility Routine - Cache Calls ; 08 Nov 2011  12:00 PM
 	;;2.0;IHS EMERGENCY DEPT DASHBOARD;**1**;Apr 02, 2014
	;
	;This routine is included in the BEDD XML 2.0 install and is not in the KIDS
	; 
	Q
	;
BEDDED(BEDDIEN,BEDDSTAT,BEDDTRG,BEDDROOM,BEDDWTIM,BEDDDFN)	; EP - Pull from BEDD.EDVISIT Class
	;
	; Pull entry from BEDD.EDVISIT
	;
	; Input:
	; BEDDIEN - Entry IEN
	; 
	; Output:
	; BEDDSTAT - PtStatI
	; BEDDTRG - TrgA
	; BEDDROOM - Room
	; BEDDWTIM - WtgTime
	; BEDDDFN - DFN
	;
	;Error Trap
	NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
	;
	NEW ED
	S ED=##CLASS(BEDD.EDVISIT).%OpenId(BEDDIEN)
	S BEDDSTAT=ED.PtStatI,BEDDTRG=ED.TrgA,BEDDROOM=ED.Room,BEDDWTIM=ED.WtgTime,BEDDDFN=ED.PtDFN
	S ED=""
	Q
	;
RMAV(BLST)	;EP - Check room Avail
	;
	NEW IEN,RLST,RIEN
	;
	S IEN="" F  S IEN=$O(BLST("L",IEN)) Q:IEN=""  D
	. ;
	. NEW ED,ROOM
	. S ED=##CLASS(BEDD.EDVISIT).%OpenId(IEN)
	. S ROOM=ED.Room
	. S ED=""
	. S:ROOM]"" RLST(ROOM)=""
	. ;
	;
	;Locate room in BEDD.EDRooms
	S RIEN="" F  S RIEN=$O(^BEDD.EDRoomsD(RIEN)) Q:RIEN=""  D
	. ;
	. NEW EDROOM,ROOM,RS
	. ;
	. S EDROOM=##CLASS(BEDD.EDRooms).%OpenId(RIEN)
	. S ROOM=EDROOM.RoomNo Q:ROOM=""
	. ;
	. ;If room is shown as occupied and a patient is listed quit
	. I EDROOM.Occupied="Yes",$D(RLST(ROOM)) S EDROOM="" Q
	. ;
	. ;If room is shown as empty and now patient is listed quit
	. I EDROOM.Occupied="No",'$D(RLST(ROOM)) S EDROOM="" Q
	. ;
	. ;If room is shown as occupied and no patient listed clear
	. I EDROOM.Occupied="Yes",'$D(RLST(ROOM)) D  Q
	.. S EDROOM.Occupied="No"
	.. S RS=EDROOM.%Save()
	.. S EDROOM=""
	. ;
	. ;If room is shown as empty and patient is listed, make occupied
	. I EDROOM.Occupied="No",$D(RLST(ROOM)) D
	.. S EDROOM.Occupied="Yes"
	.. S RS=EDROOM.%Save()
	.. S EDROOM=""
	;
	Q
	;
DSPINFO(BEDDIEN)	; EP - Retrieve BEDD.EDVISIT Info Value
	;
	; Pull Info entry from BEDD.EDVISIT
	;
	; Input:
	; BEDDIEN - Entry IEN
	;
	; Output:
	; BEDD.EDVISIT field Info
	;
	NEW BEDDINFO,BEDDSIZE,BEDDIENT
	;
	;Error Trap
	NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
	;
	S BEDDINFO="" S BEDDIENT=##CLASS(BEDD.EDVISIT).%OpenId(BEDDIEN)
	S BEDDSIZE=BEDDIENT.Info.SizeGet(),BEDDINFO=BEDDIENT.Info.Read(BEDDSIZE)
	S BEDDIENT=""
	Q BEDDINFO
	;
SINIT()	; EP - Init site settings
	;
	; This tag is called from BEDDLOGIN1.csp page. It verifies correct
	; sites will be displayed/editable in Dashboard Setup
	;
	; Input:
	; None
	;
	; Output:
	; None
	;
	NEW BEDDST,SIEN,CIEN,INST,SiteIEN
	;
	;Error Trap
	NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
	;
	;Pull list of valid sites
	D SITE^BEDDUTIL(.BEDDST)
	;
	;Set up list of inst
	S SIEN="" F  S SIEN=$O(BEDDST(SIEN)) Q:SIEN=""  S:($P(BEDDST(SIEN),"^",2)]"") INST($P(BEDDST(SIEN),"^",2))=$P(BEDDST(SIEN),"^")
	;
	;Loop through current Dashboard Setup sites
	S CIEN="" F  S CIEN=$O(^BEDD.EDSYSTEMD(CIEN)) Q:'CIEN  D
	. NEW EDID,SITE
	. S EDID=##CLASS(BEDD.EDSYSTEM).%OpenId(CIEN)
	. S SITE=EDID.Site
	. ;
	. ;If not valid site, remove entry (except Whiteboard - 999999)
	. I SITE]"",SITE'=999999,$D(INST(SITE)) K INST(SITE) Q
	. I SITE=999999 Q
	. S EDID=##CLASS(BEDD.EDSYSTEM).%DeleteId(CIEN)
	;
	;Check for new sites and add
	S SITE="" F  S SITE=$O(INST(SITE)) Q:SITE=""  D
	. NEW NID,RC
	. S NID=##CLASS(BEDD.EDSYSTEM).%New()
	. S NID.Site=SITE
	. S RC=NID.%Save()
	;
	;Look for Whiteboard Entry
 	S SiteIEN=$O(^BEDD.EDSYSTEMI("SiteIdx"," 999999",""))
 	I SiteIEN]"",'$D(^BEDD.EDSYSTEMD(SiteIEN)) D
 	. K ^BEDD.EDSYSTEMI("SiteIdx"," 999999")
 	. S SiteIEN=""
 	I SiteIEN="" D
 	. NEW NID,RC
 	. S NID=##CLASS(BEDD.EDSYSTEM).%New()
 	. S NID.Site=999999
 	. S NID.WhiteboardShowName=1
 	. S NID.WhiteboardShowAge=1
 	. S NID.WhiteboardShowProvider=1
 	. S NID.WhiteboardShowNurse=1
 	. S NID.WhiteboardShowOrders=1
 	. S NID.WhiteboardShowNotes=1
 	. S RC=NID.%Save()
	;
	Q
	;
LOADSYS(BEDDSYS,SITE,UDUZ)	; EP - Load System Vars
	;
	; Input:
	; SITE - User's SITE
	; UDUZ - User's DUZ
	;
	; Output:
	; BEDDSYS - System Variables
	;
	;Error Trap
	NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
	;
	NEW ERID,DFLT,II
	S UDUZ=$G(UDUZ)
	S SITE=$G(SITE) S:SITE="Whiteboard" SITE=999999
	S ERID="" F II=1:1 S ERID=$O(^BEDD.EDSYSTEMD(ERID)) Q:ERID=""  D  Q:$D(BEDDSYS)
	. ;
	. S:II=1 DFLT=ERID
	. D GSITE(ERID,SITE,.BEDDSYS,UDUZ)
	;
	I '$D(BEDDSYS) D GSITE(DFLT,"",.BEDDSYS,UDUZ)
    ;
    Q
	;
GSITE(ERID,SITE,BEDDSYS,UDUZ) ; EP - Retrieve individual site info
	;
	NEW EREF,TIME,STIME,UPIEN,UPREF
	S EREF=##CLASS(BEDD.EDSYSTEM).%OpenId(ERID)
	I SITE]"",EREF.Site'=$G(SITE) Q
	I EREF.AutoNote=1 S BEDDSYS("AN")=""
	I EREF.TwoClinics=1 S BEDDSYS("CLN")=""
	I EREF.ShoNrse=1 S BEDDSYS("SN")=""
	I EREF.ShoPrv=1 S BEDDSYS("PRV")=""
	I EREF.ShoDlySum=1 S BEDDSYS("DLYS")=""
	I EREF.ShoCons=1 S BEDDSYS("CONS")=""
	I EREF.CommBoard=1 S BEDDSYS("COMBRD")=""
	I EREF.TriageRpt=1 S BEDDSYS("TriageRpt")=""
	I EREF.SwitchEHRPat=1 S BEDDSYS("SwitchEHRPat")=""
	I EREF.WhiteboardShowProvider=1 S BEDDSYS("PShowProv")=""
	I EREF.WhiteboardShowNurse=1 S BEDDSYS("PShowNurse")=""
	I EREF.WhiteboardShowOrders=1 S BEDDSYS("PShowOrders")=""
	I EREF.WhiteboardShowNotes=1 S BEDDSYS("PShowNotes")=""
	I EREF.WhiteboardShowAge=1 S BEDDSYS("PShowAge")=""
	I EREF.WhiteboardShowComplaint=1 S BEDDSYS("PShowComplaint")=""
	I EREF.WhiteboardShowChartNumber=1 S BEDDSYS("PShowChartNumber")=""
	I EREF.WhiteboardShowRoom=1 S BEDDSYS("PShowRoom")=""
	I EREF.WhiteboardShowName=1 S BEDDSYS("PShowName")=""
	I EREF.WhiteboardShowAcuity=1 S BEDDSYS("PShowAcuity")=""
	;
	;BEDD*2.0*1;Added user preferences
	;Get user preferences
	S BEDDSYS("NameFRMT")="FLFF"
	;
 	;Look for existing entry
	I SITE]"",UDUZ]"" D
	. S UPIEN=$O(^BEDD.EDUserPreferencesI("DUZSiteIdx"," "_UDUZ," "_SITE,""))
 	. ;
 	. ;Entry exists
 	. I UPIEN]"" D
 	.. S UPREF=##class(BEDD.EDUserPreferences).%OpenId(UPIEN)
 	.. I UPREF.HideDOB=1 S BEDDSYS("HideDOB")=""
 	.. I UPREF.HideComp=1 S BEDDSYS("HideCOMP")=""
 	.. I UPREF.HideSex=1 S BEDDSYS("HideSEX")=""
 	.. S BEDDSYS("NameFRMT")=$S(UPREF.PatientNameFormat]"":UPREF.PatientNameFormat,1:"FLFF")
 	. S UPREF=""
	;
	;Determine Timeout
	S TIME=EREF.TimeOut
	S STIME=%session.AppTimeout
	I STIME>0,TIME>STIME S TIME=STIME-15
	I +TIME=0 S TIME=300
	S BEDDSYS("TimeOut")=TIME
	Q
	;
EDSYS(BEDDSYS)	; EP - Load System Variables For AMER Admission
	;
	; Input:
	; None
	;
	; Output:
	; BEDDSYS - Array of System Variables
	;
	;Error Trapping
	NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
	;
	NEW ERID,EREF
	S ERID=$O(^BEDD.EDSYSTEMD("")) Q:ERID=""
	S EREF=##CLASS(BEDD.EDSYSTEM).%OpenId(ERID)
	I EREF.RtSheet=1 S BEDDSYS("HIM")=""
	I EREF.PtArmBand=1 S BEDDSYS("ARM")=""
	I EREF.PtRtSheet=1 S BEDDSYS("PRS")=""
	I EREF.MedRec=1 S BEDDSYS("MRC")=""
	I EREF.PtLabels=1 S BEDDSYS("LBL")=""
	;
	Q
	;
CHKDATA(OBJID)	; EP - Save Primary Prov and Assigned Prov
	;
	D CHKDATA^BEDDUTW1($G(OBJID))
	Q
	;
UPPRV(OBJID,PPR) ; EP - Save Primary Prov
	;
	D UPPRV^BEDDUTW1($G(OBJID),$G(PPR))
	Q
	;
NEW(AMERDFN,VIEN)	; EP - Add New
	;
	;Error Trap
	NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
	;
	;Lock global
	L +^BEDD.EDVISIT(0):45 I $T=0 Q 0
	;
	NEW EDOBJ,STATUS,ID
	;
	S EDOBJ=##CLASS(BEDD.EDVISIT).%New()
	S EDOBJ.PtDFN=AMERDFN
	S EDOBJ.VIEN=VIEN
	S EDOBJ.DCFlag=0
	S EDOBJ.PtStatV=1
	S EDOBJ.DCDtH=""
	S STATUS=EDOBJ.%Save() I STATUS'=1 W !!,"Unable to save EDvisit" H 3 S ID=0 G XNEW
	S ID=EDOBJ.%Id()
	S EDOBJ=""
	;
	;Unlock global
XNEW	L -^BEDD.EDVISIT(0)
	Q ID
	;
ERR	;
	D ^%ZTER
	Q
	;
LKLST(BEDDLK,SITE,DUZ)	; EP - Assemble list of locked records dashboard
	;
	D LKLST^BEDDUTW1(.BEDDLK,$G(SITE),$G(DUZ))
	Q
	;
UNLK()	; EP - Unlock all
	;
	S OBJ="" F  S OBJ=$O(^BEDD.EDVISITD(OBJ)) Q:OBJ=""  D
	. NEW EDVST,SAVE
	. S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(OBJ)
	. S EDVST.RecLock=0,EDVST.RecLockDT="",EDVST.RecLockUser=""
	. S SAVE=EDVST.%Save()
	Q
	;
CHKLK(BEDDID,DUZ,TIMEOUT)	; EP - Check and Possibly Unlock
	;
	;Moved to overflow routine
	D CHKLK^BEDDUTW1($G(BEDDID),$G(DUZ),$G(TIMEOUT))
	Q
	;
DLST(BEGDT,ENDDT)	; EP - Assemble List of Discharges for Date Ranges
	;
	;Error Trap
	NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
	;
	NEW DDATE,DIEN
	;
	;Reset scratch global
	K ^TMP("BEDDDSC",$J)
	;
	;Set in default dates if needed
	I $G(BEGDT)="",$G(ENDDT)="" D
	. S BEGDT="T-1"
	. S ENDDT="T"
	;
	;Reformat inputed dates
	S BEGDT=$$FMTE^XLFDT($$DATE^BEDDUTIL(BEGDT),"5Y")
	S ENDDT=$$FMTE^XLFDT($$DATE^BEDDUTIL(ENDDT),"5Y")
	;
	;Set external parameters in scratch global
	S ^TMP("BEDDDSC",$J,"XBDT")=BEGDT
	S ^TMP("BEDDDSC",$J,"XEDT")=ENDDT
	;
	S BEGDT=$P($$TODLH^BEDDUTIL(BEGDT),",")
	S ENDDT=$P($$TODLH^BEDDUTIL(ENDDT),",")
	;
	;Set internal parameters in scratch global
	S ^TMP("BEDDDSC",$J,"IBDT")=BEGDT
	S ^TMP("BEDDDSC",$J,"IEDT")=ENDDT
	;
	;Assemble list of discharges
	S DDATE=$S($G(BEGDT)]"":BEGDT-1,1:"")
	F  S DDATE=$O(^BEDD.EDVISITI("DisIdx",DDATE)) Q:((DDATE>ENDDT)!(DDATE=""))  D
	. S DIEN="" F  S DIEN=$O(^BEDD.EDVISITI("DisIdx",DDATE,DIEN)) Q:DIEN=""  D
	.. NEW EDVST,DSCDT,AMERVSIT,DISP
	.. S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(DIEN)
	.. S AMERVSIT=EDVST.AMERVSIT
	.. S DISP=EDVST.Disposition
	.. ;
	.. ;Filter out Register in Error
	.. I DISP]"",$$GET1^DIQ(9009083,DISP_",",".01","E")="REGISTERED IN ERROR" Q
	.. ;
	.. S DSCDT=$$GETF^BEDDUTIL(9009080,AMERVSIT,6.2,"I") Q:DSCDT=""
	.. S ^TMP("BEDDDSC",$J,"LST",DSCDT,DIEN)=""
	;
	Q
	;
DISCH(AMERVSIT)	; EP - Update Discharge Information From RPMS
	;
	; This process updates the BEDD information based on RPMS values
	; Called by AMERD
	;
	; Input:
	; AMERVSIT - Pointer to ER VISIT (9009080)
	;
	; Output:
	; None
	;
	I $G(AMERVSIT)="" Q
	;
	;Error Trap
	NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
	;
	NEW BEDDIEN,EDVST,SAVE,DISDT,VIEN,DISDH
	;
	S DISDT=$$GET1^DIQ(9009080,AMERVSIT_",",6.2,"I") Q:DISDT=""
	S DISDH=$$FMTH^XLFDT(DISDT)
	;
	;Pull Visit File IEN
	S VIEN=$$GET1^DIQ(9009080,AMERVSIT_",",.03,"I") Q:VIEN=""
	;
	;Locate BEDD.EDVISIT entry
	S BEDDIEN=$O(^BEDD.EDVISITI("ADIdx",VIEN,"")) Q:BEDDIEN=""
	;
	;Remove Patient From Room
	D RMRMV^BEDDUTW(BEDDIEN)
	;
	;Update Discharge $H
	S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(BEDDIEN)
	S EDVST.AMERVSIT=AMERVSIT
	S EDVST.DCDtH=$P(DISDH,","),EDVST.DCTmH=$P(DISDH,",",2)
	S EDVST.DCFlag=1
	S SAVE=EDVST.%Save()
	Q
	;
RMRMV(BEDDIEN)	; EP - Make Patient's Room Unoccupied
	;
	; Input:
	; OBJID - Pointer to BEDD.EDVISIT entry
	;
	; Output:
	; None
	;
	I $G(BEDDIEN)="" Q
	;
	;Error Trap
	NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
	;
	NEW EDVST,EDROOM,SAVE,RIEN,ROOM
	;
	;Remove from Visit
	S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(BEDDIEN)
	S ROOM=EDVST.Room Q:ROOM=""
	S EDVST.Room=""
	S EDVST.RoomDt=""
	S EDVST.RoomTime=""
	S EDVST.RoomDtTm=""
	S SAVE=EDVST.%Save()
	;
	;Now locate room in BEDD.EDRooms
	S RIEN=$O(^BEDD.EDRoomsI("Room"," "_ROOM,"")) Q:RIEN=""
	;
	S EDROOM=##CLASS(BEDD.EDRooms).%OpenId(RIEN)
	S EDROOM.Occupied="No"
	S SAVE=EDROOM.%Save()
	Q
	;
SAVEDX(DX)	; EP - Save the DX information into the class
	;
	NEW EDREF,STAT
	;
	;Save primary DX information into BEDD class
	S EDREF=##CLASS(BEDD.EDVISIT).%OpenId(objid)
	S EDREF.PrimDx=$P(DX,"^")
	S EDREF.PrimICD=$P(DX,"^",3)
	S STAT=EDREF.%Save()
	S EDREF=""
	Q
	;
RMLST(BEDDIEN)	; EP - Return last room occupied (and date/time)
	;
	; Input:
	; BEDDIEN - Pointer to BEDD.EDVISIT
	;
	; Output:
	; Date and Time^Room Name
	;
	I $G(BEDDIEN)="" Q ""
	;
	;Error Trap
	NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
	;
	NEW RIEN,RM
	;
	S RIEN="" F  S RIEN=$O(^BEDD.EDRoomUseI("EDIDIdx"," "_BEDDIEN,RIEN)) Q:RIEN=""  D
	. ;
	. NEW EDRMUSE,ROOMID,ROOMDT,ROOMTM
	. ;
	. S EDRMUSE=##CLASS(BEDD.EDRoomUse).%OpenId(RIEN)
	. S ROOMID=EDRMUSE.RoomID Q:ROOMID=""
	. S ROOMDT=EDRMUSE.RoomDt
	. S ROOMTM=EDRMUSE.RoomTime
	. ;
	. S ROOMDT=ROOMDT_","_ROOMTM
	. Q:$TR(ROOMDT,",")=""
	. S ROOMDT=$$HTFM^XLFDT(ROOMDT)
	. Q:ROOMDT=""
	. S RM(ROOMDT,ROOMID)=""
	;
	;Return most recent
	S RM=$O(RM(""),-1) Q:RM="" ""
	Q $$FMTE^BEDDUTIL(RM)_"^"_$O(RM(RM,""))
	;
DPCP(OBJID)	; EP - Return PtDFN field value
	;
	NEW EDREF,DFN
	S EDREF=##CLASS(BEDD.EDVISIT).%OpenId(OBJID)
	S EDREF=""
	S DFN=EDREF.PtDFN
	I DFN]"" Q $$DPCP^BEDDUTIL(DFN)
	Q ""
	;
RMCHK(OBJID,ROOM)	; EP - Room Check
	;
	;Input:
	; OBJID - Patient CLASS pointer
	; ROOM - Room to check
	;
	;Output:
	; 1 - Room is occupied by someone other than patient
	; 0 - Room is either unoccupied or occupied by patient
	;
	NEW RIEN,EDROOM,OCC,EDVST
	;
	;See if patient is in room
	S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(OBJID)
	I EDVST.Room=ROOM S EDVST="" Q 0
	S EDVST=""
	;
	;Locate room in BEDD.EDRooms
	S RIEN=$O(^BEDD.EDRoomsI("Room"," "_ROOM,"")) Q:RIEN="" 0
	;
	S EDROOM=##CLASS(BEDD.EDRooms).%OpenId(RIEN)
	I EDROOM.Occupied="No" S OCC=0
	E  S OCC=1
	S EDROOM=""
	;
	Q OCC
	;
FNDDX(OBJID,DXCODE)	; EP - Locate DX code in patient visit
	;
	I $G(OBJID)="" Q ""
	I $G(DXCODE)="" Q ""
	;
	NEW DX,FND
	;
	S (FND,DX)="" F  S DX=$O(^BEDD.EDDiagnosisI("ObjIdx"," "_OBJID,DX)) Q:DX=""  D  Q:FND]""
	. NEW DIAG,CODE
	. S DIAG=##CLASS(BEDD.EDDiagnosis).%OpenId(DX) Q:DX=""
	. S CODE=DIAG.Code Q:CODE=""
	. I CODE=DXCODE S FND=DX
	;
	Q FND
	;
ISINJURY(OBJID)	;Returns whether visit is injury related
 ;
 ;Input:
 ;      OBJID - BEDD.EDVISIT pointer
 ;
 ;Ouput:
 ;       1 - Injury Related
 ;       0 - Not Injury Related
 ;
 I $G(OBJID)=0 Q ""
 ;
 NEW VISIT,INJ
 ;
 S VISIT=##class(BEDD.EDVISIT).%OpenId(OBJID,1)
