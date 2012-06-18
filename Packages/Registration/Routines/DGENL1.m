DGENL1 ;ALB/RMO,ISA/KWP,Zoltan,ALB/BRM - Patient Enrollment - Build List Area; 10/23/00 9:49am ; 2/27/01 1:25pm
 ;;5.3;Registration;**121,147,232,266,343**;Aug 13,1993
 ;
EN(DGARY,DFN,DGENRIEN,DGCNT) ;Entry point to build list area
 ; for patient enrollment and patient enrollment history
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ;           DGENRIEN Enrollment IEN
 ; Output -- DGCNT    Number of lines in the list
 N DGENCAT,DGENR,DGLINE
 I DGENRIEN,$$GET^DGENA(DGENRIEN,.DGENR) ;set-up enrollment array
 S DGENCAT=$$CATEGORY^DGENA4(,$G(DGENR("STATUS")))  ;enrollment category
 S DGENCAT=$$EXTERNAL^DILFD(27.15,.02,"",DGENCAT)
 S DGLINE=1,DGCNT=0
 D ENR(DGARY,DFN,.DGENR,.DGLINE,.DGCNT) ;enrollment
 D PF(DGARY,DFN,.DGENR,.DGLINE,.DGCNT) ;priority factors
 D HIS^DGENL2(DGARY,DFN,DGENRIEN,.DGLINE,.DGCNT) ;history
 Q
 ;
ENR(DGARY,DFN,DGENR,DGLINE,DGCNT) ;Enrollment 
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ;           DGENR    Enrollment array
 ;           DGLINE   Line number
 ; Output -- DGCNT    Number of lines in the list
 N DGSTART
 ;
 S DGSTART=DGLINE ; starting line number
 D SET(DGARY,DGLINE,"Enrollment",31,IORVON,IORVOFF,,,,.DGCNT)
 ;
 ;Enrollment Date
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Enrollment Date: "_$S($G(DGENR("DATE")):$$EXT^DGENU("DATE",DGENR("DATE")),1:""),11,,,,,,.DGCNT)
 ;
 ;
 ;Enrollment End Date
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Enrollment End Date: "_$S($G(DGENR("END")):$$EXT^DGENU("END",DGENR("END")),1:""),7,,,,,,.DGCNT)
 ;
 ;Enrollment Application Date
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Application Date: "_$S($G(DGENR("APP")):$$EXT^DGENU("APP",DGENR("APP")),1:""),10,,,,,,.DGCNT)
 ;
 ;Source
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Source of Enrollment: "_$S($G(DGENR("SOURCE")):$$EXT^DGENU("SOURCE",DGENR("SOURCE")),1:""),6,,,,,,.DGCNT)
 ;
 ;Category
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Enrollment Category: "_DGENCAT,7,IORVON,IORVOFF,,,,.DGCNT)
 ;
 ;Status
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Enrollment Status: "_$S($G(DGENR("STATUS")):$$EXT^DGENU("STATUS",DGENR("STATUS")),1:""),9,,,,,,.DGCNT)
 ;
 ;Priority
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Enrollment Priority: "_$S($G(DGENR("PRIORITY")):DGENR("PRIORITY"),1:"")_$S($G(DGENR("SUBGRP")):$$EXT^DGENU("SUBGRP",DGENR("SUBGRP")),1:""),7,,,,,,.DGCNT)
 ;
 ;
 ;Effective date
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Effective Date: "_$S($G(DGENR("EFFDATE")):$$EXT^DGENU("EFFDATE",DGENR("EFFDATE")),1:""),12,,,,,,.DGCNT)
 ;
 ;Reason canceled/declined
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"",1,,,,,,.DGCNT)
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Reason Canceled/Declined: "_$S($G(DGENR("REASON")):$$EXT^DGENU("REASON",DGENR("REASON")),1:""),2,,,,,,.DGCNT)
 ;
 ;Canceled/declined remarks
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Canceled/Declined Remarks: "_$S($G(DGENR("REASON"))'="":$$EXT^DGENU("REMARKS",DGENR("REMARKS")),1:""),1,,,,,,.DGCNT)
 ;
 ;Entered by
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"",1,,,,,,.DGCNT)
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Entered By: "_$S($G(DGENR("USER")):$$EXT^DGENU("USER",DGENR("USER")),1:""),16,,,,,,.DGCNT)
 ;
 ;Date/time entered
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Date/Time Entered: "_$S($G(DGENR("DATETIME")):$$EXT^DGENU("DATETIME",DGENR("DATETIME")),1:""),9,,,,,,.DGCNT)
 ;
 ;Set line to start on next page
 F DGLINE=DGLINE+1:1:DGSTART+VALM("LINES") D SET(DGARY,DGLINE,"",1,,,,,,.DGCNT)
 Q
 ;
PF(DGARY,DFN,DGENR,DGLINE,DGCNT) ;Priority factors 
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ;           DGENR    Enrollment array
 ;           DGLINE   Line number
 ; Output -- DGCNT    Number of lines in the list
 N DGSTART
 ;
 S DGSTART=DGLINE ; starting line number
 D SET(DGARY,DGLINE,"Priority Factors",31,IORVON,IORVOFF,,,,.DGCNT)
 ;
 ;POW
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"POW: "_$S($G(DGENR("ELIG","POW"))'="":$$EXT^DGENU("POW",DGENR("ELIG","POW")),1:""),19,,,,,,.DGCNT)
 ;
 ;Purple Heart - added for patch 343;brm;10/23/00
 N PHDAT
 S DGLINE=DGLINE+1
 S PHDAT=$$PHEART(DFN,$G(DGENRIEN),$G(DGENR("DATETIME")))
 D SET(DGARY,DGLINE,"Purple Hrt: "_$P(PHDAT,U),12,,,,,,.DGCNT)
 D:$P(PHDAT,U)="YES" SET(DGARY,DGLINE,"Status: "_$P(PHDAT,U,2),32,,,,,,.DGCNT)
 D:$P(PHDAT,U)="NO" SET(DGARY,DGLINE,"Remarks: "_$P(PHDAT,U,3),31,,,,,,.DGCNT)
 ;
 ;Agent orange
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"A/O Exp.: "_$S($G(DGENR("ELIG","AO"))'="":$$EXT^DGENU("AO",DGENR("ELIG","AO")),1:""),14,,,,,,.DGCNT)
 ;
 ;Ionizing radiation
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"ION Rad.: "_$S($G(DGENR("ELIG","IR"))'="":$$EXT^DGENU("IR",DGENR("ELIG","IR")),1:""),14,,,,,,.DGCNT)
 ;
 ;Environmental contaminants
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Env Contam: "_$S($G(DGENR("ELIG","EC"))'="":$$EXT^DGENU("EC",DGENR("ELIG","EC")),1:""),12,,,,,,.DGCNT)
 ;
 ;Military disability
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Mil Disab: "_$S($G(DGENR("ELIG","DISRET"))'="":$$EXT^DGENU("DISRET",DGENR("ELIG","DISRET")),1:""),13,,,,,,.DGCNT)
 ;
 ;Eligible for medicaid
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"",1,,,,,,.DGCNT)
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Eligible for MEDICAID: "_$S($G(DGENR("ELIG","MEDICAID"))'="":$$EXT^DGENU("MEDICAID",DGENR("ELIG","MEDICAID")),1:""),1,,,,,,.DGCNT)
 ;
 ;Service connected and percentage
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"",1,,,,,,.DGCNT)
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Svc Connected: "_$S($G(DGENR("ELIG","SC"))'="":$$EXT^DGENU("SC",DGENR("ELIG","SC")),1:""),9,,,,,,.DGCNT)
 D SET(DGARY,DGLINE,"SC Percent: "_$S($G(DGENR("ELIG","SCPER"))'="":$$EXT^DGENU("SCPER",DGENR("ELIG","SCPER"))_"%",1:""),52,,,,,,.DGCNT)
 ;
 ;Aid & attendance and housebound
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Aid & Attendance: "_$S($G(DGENR("ELIG","A&A"))'="":$$EXT^DGENU("A&A",DGENR("ELIG","A&A")),1:""),6,,,,,,.DGCNT)
 D SET(DGARY,DGLINE,"Housebound: "_$S($G(DGENR("ELIG","HB"))'="":$$EXT^DGENU("HB",DGENR("ELIG","HB")),1:""),52,,,,,,.DGCNT)
 ;
 ;VA Pension
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"VA Pension: "_$S($G(DGENR("ELIG","VAPEN"))'="":$$EXT^DGENU("VAPEN",DGENR("ELIG","VAPEN")),1:""),12,,,,,,.DGCNT)
 ;
 ;Total check amount
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Total Check Amount: "_$S($G(DGENR("ELIG","VACKAMT"))'="":$$EXT^DGENU("VACKAMT",DGENR("ELIG","VACKAMT")),1:""),4,,,,,,.DGCNT)
 ;
 ;Eligibility code
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Eligibility Code: "_$S($G(DGENR("ELIG","CODE"))'="":$$EXT^DGENU("CODE",DGENR("ELIG","CODE")),1:""),6,,,,,,.DGCNT)
 ;
 ;Means test
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Means Test Status: "_$S($G(DGENR("ELIG","MTSTA"))'="":$$EXT^DGENU("MTSTA",DGENR("ELIG","MTSTA")),1:""),5,,,,,,.DGCNT)
 ;
 ;Veteran Catastrophically Disabled
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Veteran CD Status: "_$S($G(DGENR("ELIG","VCD"))'="":$$EXT^DGENU("VCD",DGENR("ELIG","VCD")),1:""),5,,,,,,.DGCNT)
 ;
 ;Set line to start on next page
 F DGLINE=DGLINE+1:1:DGSTART+VALM("LINES") D SET(DGARY,DGLINE,"",1,,,,,,.DGCNT)
 Q
 ;
SET(DGARY,DGLINE,DGTEXT,DGCOL,DGON,DGOFF,DGSUB,DGNUM,DGDATA,DGCNT) ; -- set display array
 ; Input  -- DGARY    Global array subscript
 ;           DGLINE   Line number
 ;           DGTEXT   Text
 ;           DGCOL    Column to start at              (optional)
 ;           DGON     Highlighting on                 (optional)
 ;           DGOFF    Highlighting off                (optional)
 ;           DGSUB    Secondary list subscript        (optional)
 ;           DGNUM    Selection number                (optional)
 ;           DGDATA   Data associated with selection  (optional)
 ; Output -- DGCNT    Number of lines in the list
 N X
 S:DGLINE>DGCNT DGCNT=DGLINE
 S X=$S($D(^TMP(DGARY,$J,DGLINE,0)):^(0),1:"")
 S ^TMP(DGARY,$J,DGLINE,0)=$$SETSTR^VALM1(DGTEXT,X,DGCOL,$L(DGTEXT))
 D:$G(DGON)]""!($G(DGOFF)]"") CNTRL^VALM10(DGLINE,DGCOL,$L(DGTEXT),$G(DGON),$G(DGOFF))
 ;Set-up special index for secondary selection list
 S:$G(DGSUB)]"" ^TMP(DGARY_"IDX",$J,DGSUB,DGNUM,DGLINE)=DGDATA,^TMP(DGARY_"IDX",$J,DGSUB,0)=DGNUM
 Q
PHEART(DFN,DGENRIEN,PHENRDT) ;find Purple Heart information based on enrollment date
 N NXTENR,NXTENDT,PRVENR,PRVENDT,PHARY,PHI,PHST,PHRR,PHDIERR
 N NXTDIF,NXTENTM,NXTPHDT,NXTPHTM,PHENTM,PHREC,PRVDIF,PRVPHDT
 S U="^",(PRVDIF,NXTDIF)=""
 Q:'(PHENRDT&DGENRIEN) ""
 S PRVENDT=0,NXTENDT=9999999
 S PRVENR=$O(^DGEN(27.11,"C",DFN,DGENRIEN),-1)
 S:PRVENR PRVENDT=$P($G(^DGEN(27.11,PRVENR,"U")),U)
 S PRVPHDT=$O(^DPT(DFN,"PH","B",PHENRDT),-1)
 S NXTENR=$O(^DGEN(27.11,"C",DFN,DGENRIEN))
 S:NXTENR NXTENDT=$P($G(^DGEN(27.11,NXTENR,"U")),U)
 S NXTPHDT=$O(^DPT(DFN,"PH","B",PHENRDT-.0000001))
 I NXTPHDT<NXTENDT,$P(PHENRDT,".")=$P(NXTPHDT,".")  D
 .I $P(NXTENDT,".")=$P(NXTPHDT,".")  D
 ..S NXTPHTM=$P(NXTPHDT,".",2),NXTENTM=$P(NXTENDT,".",2),PHENTM=$P(PHENRDT,".",2)
 ..S NXTDIF=NXTENTM-NXTPHTM,PRVDIF=NXTPHTM-PHENTM
 ..S:PRVDIF<NXTDIF PHREC=$O(^DPT(DFN,"PH","B",NXTPHDT,""))
 .E  S PHREC=$O(^DPT(DFN,"PH","B",NXTPHDT,""))
 Q:'$D(PHREC)&('PRVPHDT) ""
 S:'$D(PHREC) PHREC=$O(^DPT(DFN,"PH","B",PRVPHDT,""))
 Q:'$D(PHREC) ""
 S PHARY=$G(^DPT(DFN,"PH",PHREC,0))
 S PHI=$$EXTERNAL^DILFD(2,.531,,$P(PHARY,U,2),.PHDIERR)
 S PHST=$$EXTERNAL^DILFD(2,.532,,$P(PHARY,U,3),.PHDIERR)
 S PHRR=$$EXTERNAL^DILFD(2,.533,,$P(PHARY,U,4),.PHDIERR)
 Q PHI_"^"_PHST_"^"_PHRR
