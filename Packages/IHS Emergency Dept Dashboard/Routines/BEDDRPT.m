BEDDRPT ;VNGT/HS/BEE-BEDD Report Routine - Cache Calls ; 08 Nov 2011  12:00 PM
 ;;2.0;IHS EMERGENCY DEPT DASHBOARD;;Apr 02, 2014
 ;
 ;This routine is included in the BEDD XML 1.0 install and is not in the KIDS
 ; 
 Q
 ;
 ;Reports by Date Range (Admit or Discharge)
 ;
ALST(BEGDT,ENDDT,RTYPE,INDEX) ;EP - Assemble List of Information for Date Range
 ;
 ;Input:
 ; BEGDT - Report Beginning Date
 ; ENDDT - Report End Date
 ; RTYPE - Report to run
 ; INDEX (optional) - Index/Sort to use (ADMIT/DISCH/TRGA) - Default is ADMIT
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDRPT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW DDATE,DIEN,RCNT
 ;
 S BEGDT=$G(BEGDT,"")
 S ENDDT=$G(ENDDT,"")
 S RTYPE=$G(RTYPE,"")
 S INDEX=$G(INDEX,"") S:INDEX="" INDEX="ADMIT"
 ;
 ;Initialie Record Count
 S RCNT=0
 ;
 ;Reset scratch global
 K ^TMP("BEDDADT",$J)
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
 S ^TMP("BEDDADT",$J,"XBDT")=BEGDT
 S ^TMP("BEDDADT",$J,"XEDT")=ENDDT
 S ^TMP("BEDDADT",$J,"XIND")=INDEX
 ;
 S BEGDT=$P($$TODLH^BEDDUTIL(BEGDT),",")
 S ENDDT=$P($$TODLH^BEDDUTIL(ENDDT),",")
 ;
 ;Set internal parameters in scratch global
 S ^TMP("BEDDADT",$J,"IBDT")=BEGDT
 S ^TMP("BEDDADT",$J,"IEDT")=ENDDT
 ;
 ;Select Index
 S IDX="ArrIdx"
 I INDEX="DISCH" S IDX="DisIdx"
 I RTYPE="DI" S IDX="DisIdx"
 ;
 ;Assemble list of entries
 S DDATE=$S($G(BEGDT)]"":BEGDT-1,1:"")
 F  S DDATE=$O(^BEDD.EDVISITI(IDX,DDATE)) Q:((DDATE>ENDDT)!(DDATE=""))  D
 . S DIEN="" F  S DIEN=$O(^BEDD.EDVISITI(IDX,DDATE,DIEN)) Q:DIEN=""  D
 .. NEW EDVST,AMERVSIT
 .. S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(DIEN)
 .. S AMERVSIT=EDVST.AMERVSIT
 .. ;
 .. ;Admission Summary Report
 .. I RTYPE="AS" D AS
 .. ;
 .. ;Central Log
 .. I RTYPE="CL" D CL(DIEN,.RCNT)
 .. ;
 .. ;Check in Summary By Hour
 .. I RTYPE="CI" D CI
 .. ;
 .. ;Discharge Summary By Hour
 .. I RTYPE="DI" D DI
 ;
 Q
 ;
AS ;EP - Set up entry for Admission Summary
 ;
 NEW ADMDT,TRGA,ARRMD,DISP,INJ
 ;
 ;Disposition
 S DISP=EDVST.DispN S:DISP="" DISP="BLANK"
 ;
 ;Screen out Registered in Error entries
 I DISP="REGISTERED IN ERROR" Q
 S ^TMP("BEDDADT",$J,"DISP",DISP)=$G(^TMP("BEDDADT",$J,"DISP",DISP))+1
 ;
 ;Initial Acuity
 S ADMDT=EDVST.PtCIDT S:ADMDT="" ADMDT="DATE"
 S TRGA=EDVST.TrgA S:TRGA="" TRGA="BLANK"
 S ^TMP("BEDDADT",$J,"TRGA",TRGA)=$G(^TMP("BEDDADT",$J,"TRGA",TRGA))+1
 ;
 ;Arrival Mode
 S ARRMD=EDVST.ArrMode S:ARRMD="" ARRMD="BLANK"
 S ^TMP("BEDDADT",$J,"ARRMD",ARRMD)=$G(^TMP("BEDDADT",$J,"ARRMD",ARRMD))+1
 ;
 ;Injury
 S INJ=EDVST.Injury S:INJ="" INJ="BLANK"
 S ^TMP("BEDDADT",$J,"INJ",INJ)=$G(^TMP("BEDDADT",$J,"INJ",INJ))+1
 Q
 ;
CL(OBJID,RCNT) ;EP - Set up entry for Central Log
 ;
 NEW CDT,TRGA,ODT,CIDT,CITM,ADDTTM,ODT,DCDT,DCTM,DCDTTM,DDT,CONS,CTWT
 NEW ARRMD,PTNAME,COMP,CHART,AGE,SEX,DOB,DIAG,APRV,DISP,TRGDTM,ROOM,RMDTTM
 NEW DFN,INJ,LOS,PCP,RDWT,RMDTMH,TRGDT,TRGH,TRGTM,TRWT,VIEN,DPRV,DNRS,FINA
 NEW XORMDT,ORMDT,ORMTM,ORMDTTM,PRMNRS,DCADDTM,APRVDTM
 ;
 ;Disposition
 S DISP=EDVST.DispN
 I DISP="REGISTERED IN ERROR" Q
 ;
 ;Get entry value
 S RCNT=RCNT+1
 ;
 ;Check-In Date/Time
 S CIDT=EDVST.CIDt,CITM=EDVST.CITm S:CITM>0 CITM="00000"_CITM,CITM=$E(CITM,$L(CITM)-4,$L(CITM))
 S ADDTTM=CIDT_","_CITM S:ADDTTM="," ADDTTM="" S:ADDTTM="-1" ADDTTM=""
 S ODT=ADDTTM S:ODT="" ODT="99999,99999"
 S CDT=EDVST.PtCIDT
 ;
 ;Initial Acuity
 S TRGA=EDVST.TrgA
 I INDEX="TRGA" S ODT=" "_TRGA
 ;
 ;Arrival Mode
 S ARRMD=EDVST.ArrMode
 ;
 ;Patient Name
 S PTNAME=EDVST.PtName
 ;
 ;Presenting Complaint
 S COMP=EDVST.Complaint
 ;
 ;Chart
 S CHART=EDVST.Chart
 ;
 ;Age
 S AGE=EDVST.Age
 ;
 ;Sex
 S SEX=EDVST.Sex
 ;
 ;Date of Birth
 S DOB=EDVST.DOB
 ;
 ;Diagnosis
 D DXCNT^BEDDUTIS(OBJID,1,.DIAG,1)
 S DIAG=$P(DIAG,"^",4)
 S DIAG=$$GET1^DIQ(80,DIAG_",",.01,"I")_" "_$$GET1^DIQ(80,DIAG_",",3,"I") S:DIAG=" " DIAG=""
 ;
 ;Admitting Physician
 S APRV=EDVST.AdmPrv
 S:APRV]"" APRV=$$GET1^DIQ(200,APRV_",",".01","I")
 ;
 ;Medical Screening Exam Time
 S APRVDTM=$$FMTE^BEDDUTIL(EDVST.AdPvDtm)
 ;
 ;Primary Nurse
 S PRMNRS=EDVST.PrmNurse
 S:PRMNRS]"" PRMNRS=$$GET1^DIQ(200,PRMNRS_",",".01","I")
 ;
 ;Decision to Admit Dt/Tm
 S DCADDTM=EDVST.NewDecAdmit
 ;
 ;Triage Date/Time
 S TRGDT=EDVST.TrgDt,TRGTM=EDVST.TrgTm S:TRGTM>0 TRGTM="00000"_TRGTM,TRGTM=$E(TRGTM,$L(TRGTM)-4,$L(TRGTM))
 S TRGH=TRGDT_","_TRGTM S:TRGH="," TRGH="" S:TRGH="-1" TRGH=""
 S TRGDTM=EDVST.TrgDtTm S:TRGDTM]"" TRGDTM=$$FMTE^BEDDUTIL(TRGDTM)
 ;
 ;CI/Triage Wait Time
 S CTWT=""
 I TRGH]"",ADDTTM]"" S CTWT=$P($$HDIFF^XLFDT(TRGH,ADDTTM,2)/60,".")
 ;
 ;Room Info
 S ROOM=$P($$RMLST^BEDDUTW(OBJID),"^",2)
 S RMDTTM=$P($$RMLST^BEDDUTW(OBJID),"^")
 S RMDTMH=$$TODLH^BEDDUTIL(RMDTTM) S:RMDTMH="," RMDTMH="" S:RMDTMH="-1" RMDTMH=""
 ;
 S ORMDT=EDVST.ORmDt
 S ORMTM=EDVST.ORmTm
 S ORMDTTM=ORMDT_","_ORMTM S:ORMDTTM="," ORMDTTM=""
 S XORMDT=$$HTFM^XLFDT(ORMDTTM) S:XORMDT="-1" XORMDT=""
 S XORMDT=$$FMTE^BEDDUTIL(XORMDT)
 ;
 ;Tr/Rm Wait Time
 S TRWT=""
 I TRGH]"",ORMDTTM]"" S TRWT=$P($$HDIFF^XLFDT(ORMDTTM,TRGH,2)/60,".")
 ;
 ;Disposition Date
 S DCDT=EDVST.DCDt,DCTM=EDVST.DCTm S:DCTM>0 DCTM="00000"_DCTM,DCTM=$E(DCTM,$L(DCTM)-4,$L(DCTM))
 S DCDTTM=DCDT_","_DCTM S:DCDTTM="," DCDTTM="" S:DCDTTM="-1" DCDTTM=""
 S DDT=EDVST.PtDCDT
 I INDEX="DISCH" S ODT=DCDTTM S:DCDTTM="" ODT="99999,99999"
 ;
 ;Rm/Disp Wait Time
 S RDWT=""
 I ORMDTTM]"",DCDTTM]"" S RDWT=$P($$HDIFF^XLFDT(DCDTTM,ORMDTTM,2)/60,".")
 ;
 ;LOS
 S LOS=""
 I ADDTTM]"",DCDTTM]"" S LOS=$P($$HDIFF^XLFDT(DCDTTM,ADDTTM,2)/60,".")
 ;
 ;Injury
 S INJ=EDVST.Injury
 ;
 ;Consult
 S CONS="NO"
 I $$EDCNT^BEDDUTIS(OBJID)>0 S CONS="YES"
 ;
 ;IENS
 S VIEN=EDVST.VIEN,DFN=EDVST.PtDFN,AMERVSIT=EDVST.AMERVSIT
 ;
 ;PCP
 S PCP=$$PPR^BEDDUTIL(VIEN,OBJID,DFN)
 ;
 ;Primary Provider
 S PPRV=EDVST.DCPrv
 S:PPRV]"" PPRV=$$GET1^DIQ(200,PPRV_",",".01","I")
 ;
 ;Discharge Nurse
 S DNRS=EDVST.DCNrs
 S:DNRS]"" DNRS=$$GET1^DIQ(200,DNRS_",",".01","I")
 ;
 ;Final Acuity
 S FINA=EDVST.FinA
 ;
 ;Save Entry
 S ^TMP("BEDDADT",$J,"CLOG",ODT,RCNT,0)=CDT_"^"_ARRMD_"^"_PTNAME_"^"_COMP_"^"_CHART_"^"_AGE_"^"_SEX_"^"_DOB
 S ^TMP("BEDDADT",$J,"CLOG",ODT,RCNT,1)=TRGA_"^"_DIAG_"^"_APRV_"^"_DISP_"^"_TRGDTM_"^"_CTWT_"^"_ROOM_"^"_XORMDT_"^"_TRWT_"^"_DDT_"^"_APRVDTM
 S ^TMP("BEDDADT",$J,"CLOG",ODT,RCNT,2)=RDWT_"^"_LOS_"^"_INJ_"^"_CONS_"^"_PCP_"^"_AMERVSIT_"^"_OBJID_"^"_VIEN_"^"_DFN_"^"_PPRV_"^"_DNRS_"^"_FINA_"^"_PRMNRS_"^"_DCADDTM
 ;
 Q
 ;
CI ;EP - Check in summary by hour
 ;
 NEW DISP,CIDT,CITM,CIDTTM,XCDTTM,XCIDT,XCITM
 ;
 ;Disposition
 S DISP=EDVST.DispN
 ;
 ;Screen out Registered in Error entries
 I DISP="REGISTERED IN ERROR" Q
 ;
 S CIDT=EDVST.CIDt
 S CITM=EDVST.CITm
 S CIDTTM=CIDT_","_CITM S:$TR(CIDTTM,",")="" CIDTTM=""
 S XCDTTM=$$HTE^XLFDT(CIDTTM)
 S XCIDT=$P(XCDTTM,"@") Q:XCIDT=""
 S XCITM=$P($P(XCDTTM,"@",2),":") S:XCITM="" XTM="."
 S XCITM=" "_XCITM S:XCITM'["." XCITM=XCITM_":00"
 ; 
 ;Check-In Hour
 S ^TMP("BEDDADT",$J,"HOUR",XCIDT,XCITM)=$G(^TMP("BEDDADT",$J,"HOUR",XCIDT,XCITM))+1
 ;
 Q
 ;
DI ;EP - Discharge summary by hour
 ;
 NEW DISP,CIDT,CITM,CIDTTM,XCDTTM,XCIDT,XCITM
 ;
 ;Disposition
 S DISP=EDVST.DispN
 ;
 ;Screen out Registered in Error entries
 I DISP="REGISTERED IN ERROR" Q
 ;
 S CIDT=EDVST.DCDt
 S CITM=EDVST.DCTm
 S CIDTTM=CIDT_","_CITM S:$TR(CIDTTM,",")="" CIDTTM=""
 S XCDTTM=$$HTE^XLFDT(CIDTTM)
 S XCIDT=$P(XCDTTM,"@") Q:XCIDT=""
 S XCITM=$P($P(XCDTTM,"@",2),":") S:XCITM="" XTM="."
 S XCITM=" "_XCITM S:XCITM'["." XCITM=XCITM_":00"
 ; 
 ;Check-In Hour
 S ^TMP("BEDDADT",$J,"HOUR",XCIDT,XCITM)=$G(^TMP("BEDDADT",$J,"HOUR",XCIDT,XCITM))+1
 ;
 Q
 ;
 ;Room Report by Date Range
 ;
RMRPT(BEGDT,ENDDT) ;EP - Assemble Room Information By Date Range
 ;
 ;Input:
 ; BEGDT - Report Beginning Date
 ; ENDDT - Report End Date
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDRPT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW DDATE,RIEN,RCNT
 ;
 S BEGDT=$G(BEGDT,"")
 S ENDDT=$G(ENDDT,"")
 ;
 ;Initialize Record Count
 S RCNT=0
 ;
 ;Reset scratch global
 K ^TMP("BEDDRM",$J)
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
 S ^TMP("BEDDRM",$J,"XBDT")=BEGDT
 S ^TMP("BEDDRM",$J,"XEDT")=ENDDT
 ;
 S BEGDT=$P($$TODLH^BEDDUTIL(BEGDT),",")
 S ENDDT=$P($$TODLH^BEDDUTIL(ENDDT),",")
 ;
 ;Set internal parameters in scratch global
 S ^TMP("BEDDRM",$J,"IBDT")=BEGDT
 S ^TMP("BEDDRM",$J,"IEDT")=ENDDT
 ;
 ;Assemble list of entries
 S DDATE=$S($G(BEGDT)]"":BEGDT-1,1:"")
 F  S DDATE=$O(^BEDD.EDRoomUseI("RdtIdx",DDATE)) Q:((DDATE>ENDDT)!(DDATE=""))  D
 . S RIEN="" F  S RIEN=$O(^BEDD.EDRoomUseI("RdtIdx",DDATE,RIEN)) Q:RIEN=""  D
 .. ;
 .. S RMUSE=##CLASS(BEDD.EDRoomUse).%OpenId(RIEN)
 .. ;
 .. ;Room Use Report
 .. D RU
 ;
 Q
 ;
RU ;EP - Room Use Report
 ;
 NEW ROOM,RMDT,RMTM,RMDTTM,XRMDT,CHK
 ;
 ;Get ID
 S EDID=RMUSE.EDID
 S CHK=""
 I EDID]"" D  I CHK Q
 . NEW EDVST,DISP
 . S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(EDID)
 . S DISP=EDVST.DispN
 . I DISP="REGISTERED IN ERROR" S CHK=1
 ;
 ;Room
 S ROOM=RMUSE.RoomID S:ROOM="" ROOM="ROOM"
 ;
 ;Room Date/Time
 S RMDT=RMUSE.RoomDt
 S RMTM=RMUSE.RoomTime
 S RMDTTM=RMDT_","_RMTM S:$TR(RMDTTM,",")="" RMDTTM=""
 S XRMDT=$$HTE^XLFDT(RMDTTM)
 S XTM=$P($P(XRMDT,"@",2),":") S:XTM="" XTM="."
 S XTM=" "_XTM S:XTM'["." XTM=XTM_":00"
 ;
 S ^TMP("BEDDRM",$J,"ROOM",RMDT,XTM,ROOM)=$G(^TMP("BEDDRM",$J,"ROOM",RMDT,XTM,ROOM))+1
 S ^TMP("BEDDRM",$J,"RLST",ROOM)=$G(^TMP("BEDDRM",$J,"RLST",ROOM))+1
 S ^TMP("BEDDRM",$J,"RTOT",RMDT,ROOM)=$G(^TMP("BEDDRM",$J,"RTOT",RMDT,ROOM))+1
 ;
 Q
 ;
DLST(BEGDT,ENDDT) ;EP - Assemble List of Discharges for Date Ranges
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDRPT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
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
 .. NEW EDVST,DSCDT,AMERVSIT
 .. S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(DIEN)
 .. S AMERVSIT=EDVST.AMERVSIT
 .. S DSCDT=$$GETF^BEDDUTIL(9009080,AMERVSIT,6.2,"I")
 .. S ^TMP("BEDDDSC",$J,"LST",DSCDT,DIEN)=""
 ;
 Q
 ;
ERR ;
 D ^%ZTER
 Q
