BDGCPT ; IHS/ANMC/LJF - LIST CPT CODES FOR INPT STAY ;  [ 07/22/2002  1:16 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;follows printing of Final A Sheet
 ;incoming variables:
 ;  DFN = IEN of patient
 ;  DGPMCA = IEN in file 405 for admission
 ;  BDGFIN = 2 for full CPT listing with all providers, cpt codes
 ;                tran codes, radiology, medications, supplies, labs
 ;                and immunizations
 ;         = 3 for Medicare/Medicaid listing which only includes
 ;                radiology, tran codes and cpt codes
 ;
 K ^TMP("BDGCPT",$J)
 NEW DGV,DGVN,DGVV,DGI
 S DGV=$$GET1^DIQ(405,DGPMCA,.27,"I") Q:'DGV  ;visit ien
 ;
 ; -- find v file entries for hosp
 S DGVV=DGV
 I BDGFIN=3 F DGI="RAD","TRAN","CPT" D @DGI I 1  ;medicare a sheet
 E  F DGI="PRV","CPT","TRAN","RAD","MED","SUP","LAB","IMM" D @DGI
 ;
 ; -- find all I visits during hosp and related v file entries
 S DGVN=0 F  S DGVN=$O(^AUPNVSIT("AD",DGV,DGVN)) Q:'DGVN  D
 . S DGVV=DGVN
 . I BDGFIN=3 F DGI="RAD","TRAN","CPT" D @DGI I 1  ;medicare a sheet
 . E  F DGI="CPT","TRAN","RAD","MED","SUP","LAB","IMM" D @DGI
 ;
 ; -- find all other visits during hosp
 D AMB^BDGCPT1
 ;
 ; -- print report
 D HEAD
 I BDGFIN=3 F DGI="RAD","TRAN","CPT" D PRINT I 1
 E  F DGI="VSIT","CPT","TRAN","PRV","RAD","MED","SUP","LAB","IMM" D PRINT
 K ^TMP("BDGCPT",$J)
 Q
 ;
PRINT ; -- print line
 Q:'$D(^TMP("BDGCPT",$J,DGI))
 D HDG2(DGI)
 S DGDT=0
 F  S DGDT=$O(^TMP("BDGCPT",$J,DGI,DGDT)) W:DGDT="" !! Q:DGDT=""  D
 . S DGN=0  F  S DGN=$O(^TMP("BDGCPT",$J,DGI,DGDT,DGN)) Q:DGN=""  D
 .. W !,^TMP("BDGCPT",$J,DGI,DGDT,DGN)
 .. I $Y>(IOSL-4)  D HEAD
 Q
 ;
TRAN ; -- find all trans codes
 I BDGFIN=3 D TRAN^BDGCPT1 Q  ;M/M style trans code section
 NEW DGN,DGDT,LINE,TRAN
 S DGN=0 F  S DGN=$O(^AUPNVTC("AD",DGVV,DGN)) Q:'DGN  D
 . S DGDT=$$DATE(9000010.33,DGN),LINE=$$FMTE^XLFDT(DGDT,"D")
 . S LINE=LINE_" "_$$AMB(DGVV)  ;is trans code from amb visit?
 . S LINE=$$PAD(LINE,17)_"HCPCS: "_$$GET1^DIQ(9000010.33,DGN,.07)
 . S LINE=$$PAD(LINE_$$GET1^DIQ(9000010.33,DGN,.08),31)  ;cpt modfier
 . S TRAN=$$GET1^DIQ(9000010.33,DGN,.01)
 . S LINE=$$PAD(LINE,34)_"TRANS: "_$$GET1^DIQ(9000010.33,DGN,.01)
 . S LINE=$$PAD(LINE,52)_$E($$GET1^DIQ(9000010.33,DGN,.11),1,27)
 . D SET(LINE,"TRAN",TRAN_":"_DGDT,DGN)
 Q
 ;
PRV ; -- find all providers
 D PRV^BDGCPT1 Q
 ;
RAD ; -- find all v radiology entries
 NEW DGN,DGDT,LINE
 S DGN=0 F  S DGN=$O(^AUPNVRAD("AD",DGVV,DGN)) Q:'DGN  D
 . S DGDT=$$DATE(9000010.22,DGN),LINE=$$FMTE^XLFDT(DGDT,"D")
 . S LINE=LINE_" "_$$AMB(DGVV)  ;is xray from amb visit
 . S LINE=$$PAD(LINE,17)_"CPT: "_$$GET1^DIQ(9000010.22,DGN,.019)
 . S LINE=$$PAD(LINE,30)_$E($$GET1^DIQ(9000010.22,DGN,.01),1,18)
 . S LINE=$$PAD(LINE,50)_"DX: "_$$GET1^DIQ(9000010.22,DGN,.06)  ;dx
 . S LINE=$$PAD(LINE,60)_$E($$GET1^DIQ(9000010.22,DGN,1204),1,20)
 . D SET(LINE,"RAD",DGDT,DGN)
 Q
 ;
MED ; -- find all v med entries
 ;
 ; -- get pyxis unit dose meds
 NEW IEN,DATE,LINE,RDT,LAST,ARRAY,ARRAY1,DRUGID,QTY,MEDSTN
 ;
 ; start at discharge date or today if still an inpatient
 ;7/18/02 WAR - REMd next line and changed code per LJF14
 ;S RDT=9999999-($S($$DSCDT^ADGU1(DGPMCA)]"":$$DSCDT^ADGU1(DGPMCA),1:DT))-1
 S RDT=9999999-($S($$DSCDT(DGPMCA)]"":$$DSCDT(DGPMCA),1:DT))-1  ;LJF14
 S LAST=9999999-$P($$GET1^DIQ(405,DGPMCA,.01,"I"),".")
 F  S RDT=$O(^VEFS(19234.2,"AA",DFN,RDT)) Q:'RDT  Q:(RDT>LAST)  D
 . K ARRAY,ARRAY1            ;arrays for grouping same drug on same day
 . ;
 . ;  for each date count up quantities by drug id #
 . S IEN=0 F  S IEN=$O(^VEFS(19234.2,"AA",DFN,RDT,IEN)) Q:'IEN  D
 .. S QTY=$$GET1^DIQ(19234.2,IEN,.05)
 .. S DRUGID=$$GET1^DIQ(19234.2,IEN,6)
 .. S MEDSTN=$$GET1^DIQ(19234.2,IEN,5.01) S:MEDSTN="" MEDSTN=" "
 .. S ARRAY(DRUGID,MEDSTN)=$G(ARRAY(DRUGID,MEDSTN))+QTY
 .. S:'$D(ARRAY1(DRUGID,MEDSTN)) ARRAY1(DRUGID,MEDSTN)=$$GET1^DIQ(19234.2,IEN,.01)
 . ;
 . ; -- now set display line for each drug for this date
 . S DRUGID=0 F  S DRUGID=$O(ARRAY(DRUGID)) Q:DRUGID=""  D
 .. S MEDSTN=0  F  S MEDSTN=$O(ARRAY(DRUGID,MEDSTN)) Q:MEDSTN=""  D
 ... S DATE=9999999-RDT,LINE=$$FMTE^XLFDT(DATE,"D")
 ... S LINE=$$PAD(LINE,15)_$E(ARRAY1(DRUGID,MEDSTN),1,30)  ;drug name
 ... S LINE=$$PAD(LINE,48)_"QTY: "_ARRAY(DRUGID,MEDSTN)
 ... S LINE=$$PAD(LINE,57)_"ID: "_DRUGID
 ... S LINE=$$PAD(LINE,70)_$E(MEDSTN,1,10)
 ... D SET(LINE,"MED","UNIT:"_DATE_MEDSTN,DRUGID)
 ;
 ; -- get iv meds
 NEW IEN,DATE,LINE,RDT,LAST
 ;
 ; start at discharge date or today if still an inpatient
 ;7/18/02 WAR - REMd next line and changed code per LJF14
 ;S RDT=9999999-($S($$DSCDT^ADGU1(DGPMCA)]"":$$DSCDT^ADGU1(DGPMCA),1:DT))-1
 S RDT=9999999-($S($$DSCDT(DGPMCA)]"":$$DSCDT(DGPMCA),1:DT))-1  ;LJF14
 S LAST=9999999-$P($$GET1^DIQ(405,DGPMCA,.01,"I"),".")
 F  S RDT=$O(^VEFS(19234.35,"AA",DFN,RDT)) Q:'RDT  Q:((RDT\1)>LAST)  D
 . S IEN=0 F  S IEN=$O(^VEFS(19234.35,"AA",DFN,RDT,IEN)) Q:'IEN  D
 .. ;
 .. ; set up display line for IV drug
 .. S DATE=9999999-RDT,LINE=$$FMTE^XLFDT(DATE,"D")
 .. S LINE=$$PAD(LINE,15)_"IV: "_$$GET1^DIQ(19234.35,IEN,.01)
 .. S LINE=$$PAD(LINE,30)_"QTY: "_$$GET1^DIQ(19234.35,IEN,.05)
 .. S LINE=$$PAD(LINE,40)_$$GET1^DIQ(19234.35,IEN,2.01)  ;solution
 .. S LINE=$$PAD(LINE,72)_$$GET1^DIQ(19234.35,IEN,2.02)  ;volume
 .. D SET(LINE,"MED","IV:"_DATE,IEN)
 .. ;
 .. ; then set up possible multiple lines for additives
 .. K ARRAY D ENPM^XBDIQ1(19234.351,IEN_",0",".01;.02","ARRAY(")
 .. S X=0 F  S X=$O(ARRAY(X)) Q:'X  D
 ... S LINE=$$SP(30)_"ADDITIVE: "_$G(ARRAY(X,.01))_"  "_$G(ARRAY(X,.02))
 ... D SET(LINE,"MED","IV:"_DATE,IEN_"."_X)
 ;
 ; -- get discharge meds
 NEW DGN,DGDT,LINE
 S DGN=0 F  S DGN=$O(^AUPNVMED("AD",DGVV,DGN)) Q:'DGN  D
 . S DGDT=$$DATE(9000010.14,DGN),LINE=$$FMTE^XLFDT(DGDT,"D")
 . S LINE=$$PAD(LINE,15)_$E($$GET1^DIQ(9000010.14,DGN,.01),1,25)
 . S LINE=$$PAD(LINE,45)_"QTY: "_$$GET1^DIQ(9000010.14,DGN,.06)
 . S LINE=$$PAD(LINE,55)_$E($$GET1^DIQ(9000010.14,DGN,.05),1,25)  ;sig
 . D SET(LINE,"MED","Z"_DGDT,DGN)
 Q
 ;
SUP ; -- get pyxis supply items
 NEW IEN,DATE,LINE,RDT,LAST,TOTAL,QTY
 S TOTAL=0                             ;total cost of all supply items
 ;
 ; start at discharge date or today if still an inpatient
 ;7/18/02 WAR - REMd next line and changed code per LJF14
 ;S RDT=9999999-($S($$DSCDT^ADGU1(DGPMCA)]"":$$DSCDT^ADGU1(DGPMCA),1:DT))-1
 S RDT=9999999-($S($$DSCDT(DGPMCA)]"":$$DSCDT(DGPMCA),1:DT))-1  ;LJF14
 S LAST=9999999-$P($$GET1^DIQ(405,DGPMCA,.01,"I"),".")
 F  S RDT=$O(^VEFS(19234.3,"AA",DFN,RDT)) Q:'RDT  Q:((RDT\1)>LAST)  D
 . S IEN=0 F  S IEN=$O(^VEFS(19234.3,"AA",DFN,RDT,IEN)) Q:'IEN  D
 .. ;
 .. S DATE=9999999-RDT,LINE=$$FMTE^XLFDT(DATE,"D")
 .. S LINE=$$PAD(LINE,15)_$$GET1^DIQ(19234.3,IEN,.01)_": "  ;id
 .. S LINE=LINE_$$GET1^DIQ(19234.3,IEN,.1)                  ;item
 .. S QTY=$$GET1^DIQ(19234.3,IEN,.05)
 .. S LINE=$$PAD(LINE,55)_"QTY: "_QTY
 .. S LINE=$$PAD(LINE,65)_"COST: "_$J($$COST(IEN,QTY,.TOTAL),7,2)
 .. D SET(LINE,"SUP",DATE,IEN)
 ;
 I $D(LINE) D SET($$SP(59)_"TOTAL COST: "_$J(TOTAL,7,2),"SUP",9999999,TOTAL)
 Q
 ;
COST(IEN,QTY,TOTAL) ; -- find total cost for supply item(s)
 NEW ITEM,UNITCOST
 S ITEM=$O(^DIZ(111700,"B",+$$GET1^DIQ(19234.3,IEN,.01,"I"),0))
 I 'ITEM Q 0
 S UNITCOST=$$GET1^DIQ(111700,ITEM,.07)
 S TOTAL=TOTAL+(QTY*UNITCOST)
 Q QTY*UNITCOST
 ;
CPT ; -- find all v cpt entries
 NEW DGN,DGDT,LINE
 S DGN=0 F  S DGN=$O(^AUPNVCPT("AD",DGVV,DGN)) Q:'DGN  D
 . S DGDT=$$DATE(9000010.18,DGN),LINE=$$FMTE^XLFDT(DGDT,"D")
 . S LINE=$$PAD(LINE,15)_$$GET1^DIQ(9000010.18,DGN,.01)
 . S LINE=$$PAD(LINE_$$GET1^DIQ(9000010.18,DGN,.08),22)  ;cpt modfier
 . S LINE=LINE_" "_$E($$GET1^DIQ(9000010.18,DGN,.019),1,17)
 . S LINE=$$PAD(LINE,42)_"QTY: "_$$GET1^DIQ(9000010.18,DGN,.16)
 . S LINE=$$PAD(LINE,50)_"DX: "_$$GET1^DIQ(9000010.18,DGN,.05)
 . S LINE=$$PAD(LINE,60)_$E($$GET1^DIQ(9000010.18,DGN,1204),1,18)
 . D SET(LINE,"CPT",DGDT,DGN)
 Q
 ;
IMM ; -- find all v immunization entries
 NEW DGN,DGDT,LINE
 S DGN=0 F  S DGN=$O(^AUPNVIMM("AD",DGVV,DGN)) Q:'DGN  D
 . S DGDT=$$DATE(9000010.11,DGN),LINE=$$FMTE^XLFDT(DGDT,"D")
 . S LINE=$$PAD(LINE,15)_"CPT: "_$$GET1^DIQ(9000010.11,DGN,.011)
 . S LINE=$$PAD(LINE,30)_$$GET1^DIQ(9000010.11,DGN,.01)  ;immun
 . D SET(LINE,"IMM",DGDT,DGN)
 Q
 ;
LAB ; -- find all v lab entries
 NEW DGN,DGDT,LINE,CPT,FIELD,X
 S DGN=0 F  S DGN=$O(^AUPNVLAB("AD",DGVV,DGN)) Q:'DGN  D
 . ;
 . ;include only billabel labs:
 . ;     if have cpt check routine
 . I $L($T(EN^LRZBILL)) D  Q:CPT=0
 .. S CPT=$$EN^LRZBILL(DGN)
 . ;
 . ;     or do manual search in V Lab
 . E  D  Q:CPT=0
 .. S CPT=$$GET1^DIQ(9000010.09,DGN,1402)
 .. I CPT="",$$GET1^DIQ(9000010.09,DGN,1208)]"" S CPT=0 Q  ;on panel
 .. I $$GET1^DIQ(9000010.09,DGN,.04)="canc" S CPT=0 Q  ;cancelled test
 .. I $$GET1^DIQ(9000010.09,DGN,1109)'="RESULTED" S CPT=0 Q  ;no result
 . ;
 . ; build display line
 . S DGDT=$$DATE(9000010.09,DGN),LINE=$$FMTE^XLFDT(DGDT,"D")
 . S LINE=LINE_" "_$$AMB(DGVV)  ;ambulatory visit lab?
 . S LINE=$$PAD(LINE,17)_"CPT: "_CPT
 . S LINE=$$PAD(LINE,30)_$E($$GET1^DIQ(9000010.09,DGN,.01),1,35)
 . D SET(LINE,"LAB",DGDT,"LAB"_DGN)
 . F FIELD=1301,1302,1303 D  ;comments
 .. S X=$$GET1^DIQ(9000010.09,DGN,FIELD) Q:X=""
 .. I FIELD=1301,(X["CANCELLED TEST") S Y=$$GET1^DIQ(9000010.09,DGN,.04) I (Y]""),(Y'="canc") Q  ;no comment if part of panel cancelled but this has result
 .. D SET($$SP(20)_X,"LAB",DGDT,"LAB"_DGN_"."_FIELD)
 ;
 ; find micro data
 S DGN=0 F  S DGN=$O(^AUPNVMIC("AD",DGVV,DGN)) Q:'DGN  D
 . S CPT=$$GET1^DIQ(9000010.25,DGN,1402)
 . I CPT="",$$GET1^DIQ(9000010.25,DGN,1208)]"" Q  ;part of panel
 . I $$GET1^DIQ(9000010.25,DGN,1109)'="RESULTED" Q  ;resulted only
 . S DGDT=$$DATE(9000010.25,DGN),LINE=$$FMTE^XLFDT(DGDT,"D")
 . S LINE=LINE_" "_$$AMB(DGVV)
 . S LINE=$$PAD(LINE,17)_"CPT: "_$P(CPT,"|")
 . S LINE=$$PAD(LINE,30)_$E($$GET1^DIQ(9000010.25,DGN,.01),1,35)
 . D SET(LINE,"LAB",DGDT,"MICRO"_DGN)
 Q
 ;
DATE(FILE,IEN) ; -- find date for item
 NEW DATE
 S DATE=$$GET1^DIQ(FILE,IEN,1201,"I") I DATE]"" Q DATE  ;event date
 S DATE=$$GET1^DIQ(FILE,IEN,.03,"I")  ;visit ien
 S DATE=$$GET1^DIQ(9000010,DATE,.01,"I")  ;visit date
 Q DATE
 ;
 ;7/18/02 WAR - added this routine per LJF14
DSCDT(ADM)  ;EP - discharge date based on admit ien
 ;IHS/ANMC/LJF 7/6/2002 moved from obsolete routine ADGU1
 NEW DSC
 S DSC=$$GET1^DIQ(405,ADM,.17,"I") I 'DSC Q ""
 Q $$GET1^DIQ(405,DSC,.01,"I")
 ;
AMB(V) ; -- is this visit an ambulatory one?
 Q $S($$SC^APCLV(V,"I")="A":"(A)",1:"")
 ;
SET(LINE,SECTION,DATE,IEN) ; -- put display line into date order under section
 S ^TMP("BDGCPT",$J,SECTION,DATE,IEN)=$E(LINE,1,80)
 Q
 ;
HEAD ; -- page heading
 W @IOF W !,"CPT DATA FOR HOSPITALIZATION:  #",$$HRCN^BDGF2(DFN,DUZ(2))
 W "  ",$E($$GET1^DIQ(2,DFN,.01),1,20)                 ;pt name
 W "  ",$$GET1^DIQ(405,DGPMCA,.01)                       ;admit date
 W !,$$REPEAT^XLFSTR("=",80),!
 Q
 ;
HDG2(CAT) ; -- heading for each category
 NEW X
 F X=1:1 Q:$P($T(SECTION+X),";;",2)=""  D
 . I $P($T(SECTION+X),";;",2)=CAT W !,$P($T(SECTION+X),";;",3)
 Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
SECTION ;;
 ;;TRAN;;Transaction Codes:;;
 ;;CPT;;Miscellaneous CPT Codes:;;
 ;;LAB;;Laboratory Tests:;;
 ;;RAD;;Radiology Procedures:;;
 ;;MED;;Medications (IV, unit dose & disch meds):;;
 ;;IMM;;Immunizations:;;
 ;;SUP;;Supplies:;;
 ;;VSIT;;Other Visits for date range (72/24 rule):;;
 ;;PRV;;Hospitalization Providers:;;
