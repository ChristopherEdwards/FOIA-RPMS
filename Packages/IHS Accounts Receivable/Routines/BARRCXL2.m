BARRCXL2 ; IHS/SD/LSL - Cancelled Bills Report - Print ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7,19**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 03/10/03 - Routine created
 ;      Called by BARRCXL
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892;
 ; BAR*1.8*19 IHS/SD/PKD 5/12/10 - Added Cancelling Official to ^TMP indexing
 ;                                 Report rewritten
 ;    Moved orig code to the end of routine
 ; ^TMP($J,"BAR-CXL",BARBCANC,   Mirrors 3PB rpt
 Q
 ; *************************
 ;
PRINT ; EP
 ; Print
 ; BAR*1.8*19 IHS/SD/PKD 5/12/10
 N BARLOC,BARACCT,BARPAT,BARBILL,BARBAMT,BARBAL,BARBCANC
 K BAR("D")
 S BAR("PG")=0
 I BARY("RTYP")=1 D DETAIL Q
 E  D SUMMARY
 Q
 ;
DETAIL ;
 ; BAR*1.8*19 IHS/SD/PKD 5/12/10 
 S BAR("COL")="W !?25,""Active"",?42,""Claim"",?53,""Visit"""
 S BAR("COL")=BAR("COL")_",!?2,""Patient"",?18,""HRN"",?25,""Insurer"",?42,""Number"",?53,""Date"",?66,""Reason"""
 S BAR("COL")=BAR("COL")_",!,?39,""# BILLS"",?51,""AMT BILLED"",?70,""BALANCE"""
 D HDB^BARRPSRB  ; Print HIPAA etc
 I '$D(^TMP($J,"BAR-CXL")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
CASHIER ;
 S BARBCANC=""  ; CANCELLING OFFICIAL
 F  S BARBCANC=$O(^TMP($J,"BAR-CXL",BARBCANC)) Q:BARBCANC=""!($G(BAR("F1")))  D DETCANC
 Q:$G(BAR("F1"))
 D SUMTOT  ; REPORT TOTALS
 Q
 ;
DETCANC  ;For each Cancelling Official (detail) do ...
 W !,"Cancelling Official:  "
 W $S(BARBCANC'=0:$P(^VA(200,BARBCANC,0),"^"),1:"Unknown Cancelling Official")
 S BARLOC=""
 F  S BARLOC=$O(^TMP($J,"BAR-CXL",BARBCANC,BARLOC)) Q:BARLOC=""!($G(BAR("F1")))  D DETLOC
 Q:$G(BAR("F1"))
 S BARTMP=^TMP($J,"BAR-CXL",BARBCANC)
 W "Cancelling Official Subtotal: "  ;,$J(+^TMP($J,"BAR-CXL",BARBCANC),10),!
 D TOTALS
 Q
 ; *****************************
 ;
DETLOC ;
 ; For each visit location (detail)
 Q:$G(BAR("F1"))
 W !?5,"VISIT Location: ",BARLOC
 N BAR3SORT S BAR3SORT=""	 ; 3RD SORT EITHER VISIT TYP or CLINIC
 F  S BAR3SORT=$O(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BAR3SORT)) Q:BAR3SORT=""!($G(BAR("F1")))  D DETPAT
 Q:$G(BAR("F1"))
 D SUMLTOT  ; DETAIL LOCATION TOTAL
 Q
 ; ******************************
DETPAT ;
 ; For each patient w/in AR Account w/in Visit location (detail) do...
 I BARY("SORT")="V" W !?10,"Visit Type: ",$P(^ABMDVTYP(BAR3SORT,0),U)
 I BARY("SORT")="C" W !,?10,"Clinic: ",$P(^DIC(40.7,BAR3SORT,0),U)
 S BARPAT=""
 F  S BARPAT=$O(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BAR3SORT,BARPAT)) Q:BARPAT=""!($G(BAR("F1")))  D DETBILL
 Q:$G(BAR("F1"))
 W !,?16 D SUMACCT  ;  Visit Type or Clinic subtotals
 Q
 ; *******************************
DETBILL ;
 ; For each bill w/in Patient w/in AR Account w/in
 N HRN,DOS,BARBREAS
 S (BARBILL,HRN,DOS)=""
 F  S BARBILL=$O(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BAR3SORT,BARPAT,BARBILL)) Q:BARBILL=""!($G(BAR("F1")))  D
 . S MORE=$G(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BAR3SORT,BARPAT,BARBILL,"MORE"))
 . S BARACCT=$P(MORE,U),DOS=$P(MORE,U,2),HRN=$P(MORE,U,3),BARBREAS=$P(MORE,U,4)
 . S Y=DOS D DD^%DT S DOS=Y
 . D DETLINE
 Q
 ; *****************************
 ;
DETLINE ; BAR*1.8*19 IHS/SD/PKD 5/12/10
 ; Report mainline for detail report
 Q:$G(BAR("F1"))
 I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BAR3SORT,BARPAT,BARBILL))
 W !,$E(BARPAT,1,17)  ;Patient Name
 W ?18,HRN
 W ?25,$E(BARACCT,1,14)
 W ?41,$P(BARBILL,"-",1,2)  ; Just the bill, not the HRN
 W ?52,DOS
 I BARBREAS W ?65,$E(^ABMCBILR(BARBREAS,0),1,15)
 E  W ?65,$E(BARBREAS,1,15)
 Q
 ; ********************************
 ;
SUMMARY ;
 ; Print Summary Report
 Q:$G(BAR("F1"))
 S BARDASH="W !?52,""-------- SUMMARY"
 S BAREQUAL="W !?52,""======="""
 S BAR("COL")="W !,""A/R ACCOUNT"",?39,""# BILLS"",?51,""AMT BILLED"",?70,""BALANCE"""
 D HDB^BARRPSRB
 I '$D(^TMP($J,"BAR-CXL")) D  Q           ; No data - quit
 . W !!!!!?25,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 ;
SUBCSH  ;
 Q:$G(BAR("F1"))
 S BARBCANC="" F  S BARBCANC=$O(^TMP($J,"BAR-CXL",BARBCANC)) Q:BARBCANC=""!($G(BAR("F1")))  D
 . D SUBHD  ;  Print CancOff'cl Name
 . S BARLOC=""
 . F  S BARLOC=$O(^TMP($J,"BAR-CXL",BARBCANC,BARLOC)) Q:BARLOC=""!($G(BAR("F1")))  D SUMLOC
 . S BARTMP=^TMP($J,"BAR-CXL",BARBCANC)
 . W "Cancelling Official Subtotal: "  ;,$J(+^TMP($J,"BAR-CXL",BARBCANC),10),!
 . Q:$G(BAR("F1"))  D TOTALS
 Q:$G(BAR("F1"))
 D SUMTOT
 Q
 ; *********************************
 ;
SUMLOC ;
 ; For Each Visit Location (Summary) do..
 Q:$G(BAR("F1"))
 W !?5,"VISIT Location: ",BARLOC,!
 S BAR3SORT=""  ; Visit Type or Clinic is 3rd sort
 F  S BAR3SORT=$O(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BAR3SORT)) Q:BAR3SORT=""!($G(BAR("F1")))  D SUMACCT
 Q:$G(BAR("F1"))
 D SUMLTOT
 Q
 ; **********************************
 ;
SUMACCT ;
 ; For each AR Account w/in Visit Location (Summary) do...
 Q:$G(BAR("F1"))
 I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BAR3SORT))
 ; Remove Re-Printing of Visit type or clinic
 ;N SUBNM,SUBCT
 ;I BARY("SORT")="V" S SUBNM=$P(^ABMDVTYP(BAR3SORT,0),U)
 ;. Q:BARY("RTYP")=1  W !,"Visit Type: " 
 ;I BARY("SORT")="C" S SUBNM=$P(^DIC(40.7,BAR3SORT,0),U)
 ;. Q:BARY("RTYP")=1  W !,"Clinic: " 
 ;S SUBCT=39-$L(SUBNM) 
 ;I BARY("RTYP")=1 W:$L(SUBNM)>26 !,?SUBCT ; drop a line if VstTy or Clnc Name>26
 ;W SUBNM
 N BARDSH S $P(BARDSH,"-",7)=""
 W ?40,BARDSH,?50,BARDSH,BARDSH,?64,BARDSH,BARDSH,!
 D TOTALS
 Q
 ; *********************************
SUMLTOT ;
 ; Visit location total (Summary) Report
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-CXL",BARBCANC,BARLOC))
 W !,?2," ** VISIT Location Subtotal"
 D TOTALS
 Q
 ; **********************************
SUMTOT ;
 ; Report Total (Summary)
 ; BAR*1.8*19 IHS/SD/PKD 5/12/10 remove Amt & Bal from totals
 Q:$G(BAR("F1"))
 S BARTMP=$G(^TMP($J,"BAR-CXL"))
 W !,"*** REPORT TOTAL"
 D TOTALS
 Q
 ; ***********************************
TOTALS  ;
 Q:$G(BAR("F1"))
 W ?39,$J($FN($P(BARTMP,U),","),7)              ; Bill count
 W ?49,$J($FN($P(BARTMP,U,2),",",2),13)         ; Billed Amount
 W ?63,$J($FN($P(BARTMP,U,3),",",2),13),!     ; Bill Balance
 Q
 ;
SUBHD  ; 
 Q:$G(BAR("F1"))
 W !,"Cancelling Official: "
 W $S(BARBCANC'=0:$P(^VA(200,BARBCANC,0),"^"),1:"Unknown Cancelling Official")
 Q
 ;  END OF REWRITTEN CODE BAR*1.8*19 PKD
 ; *********************************
 ; *********************************
 ;Pre-Patch 19 totals BELOW  BAR*1.8*19 IHS/SD/PKD 6/1/10
 ; *********************************
 ; *********************************
 ;PRINT ; EP
 ; Print
 ;N BARLOC,BARACCT,BARPAT,BARBILL,BARBAMT,BARBAL
 ;K BAR("D")
 ;S BAR("PG")=0
 ;I BARY("RTYP")=1 D DETAIL Q
 ;E  D SUMMARY
 ;Q
 ; *********************************************************************
 ;
 ;DETAIL ;
 ;S BARDASH="W ?38,""-------------"",?63,""----------------"""
 ;S BAREQUAL="W !?38,""============="",?63,""================"""
 ;S BAR("COL")="W !?3,""BILL"",?19,""PATIENT NAME"",?41,""AMT BILLED"",?55,""DOS"",?72,""BALANCE"""
 ;D HDB^BARRPSRB
 ;I '$D(^TMP($J,"BAR-CXL")) D  Q           ; No data - quit
 .; W !!!!!?25,"*** NO DATA TO PRINT ***"
 . ;D EOP^BARUTL(0)
 ;
 ;S BARLOC=""
 ;F  S BARLOC=$O(^TMP($J,"BAR-CXL",BARLOC)) Q:BARLOC=""  D DETLOC Q:$G(BAR("F1"))
 ;D DETTOT
 Q
 ; ********************************************************************
 ;
 ;DETLOC ;
 ; For each visit location (detail) do...
 ;W !?5,"VISIT Location: ",BARLOC
 ;S BARACCT=""
 ;F  S BARACCT=$O(^TMP($J,"BAR-CXL",BARLOC,BARACCT)) Q:BARACCT=""  D DETACCT Q:$G(BAR("F1"))
 ;D DETLTOT
 ;Q
 ; ********************************************************************
 ;
 ;DETACCT ;
 ; For each AR Account w/in Visit Location (detail) do...
 ;W !?10,"A/R Account: ",BARACCT,!
 ;S BARDOS=0
 ;F  S BARDOS=$O(^TMP($J,"BAR-CXL",BARLOC,BARACCT,BARDOS)) Q:'+BARDOS  D DETPAT Q:$G(BAR("F1"))
 ;D DETATOT
 Q
 ; ********************************************************************
 ;
 ;DETPAT ;
 ; For each patient w/in AR Account w/in Visit location (detail) do...
 ;S BARPAT=""
 ;F  S BARPAT=$O(^TMP($J,"BAR-CXL",BARLOC,BARACCT,BARDOS,BARPAT)) Q:BARPAT=""  D DETBILL Q:$G(BAR("F1"))
 ;Q
 ; ********************************************************************
 ;
 ;DETBILL ;
 ; For each bill w/in Patient w/in AR Account w/in
 ; Visit Location (detail) do...
 ;S BARBILL=""
 ;F  S BARBILL=$O(^TMP($J,"BAR-CXL",BARLOC,BARACCT,BARDOS,BARPAT,BARBILL)) Q:BARBILL=""  D DETLINE Q:$G(BAR("F1"))
 Q
 ; ********************************************************************
 ;
 ;DETLINE ;
 ; Report mainline for detail report
 ;I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 ;S BARTMP=$G(^TMP($J,"BAR-CXL",BARLOC,BARACCT,BARDOS,BARPAT,BARBILL))
 ;W !,$E(BARBILL,1,18)                         ; AR Bill
 ;W ?19,$E(BARPAT,1,18)                        ; Patient
 ;W ?38,$J($FN($P(BARTMP,U),",",2),13)         ; Billed Amount
 ;W ?52,$$SDT^BARDUTL(BARDOS)
 ;W ?63,$J($FN($P(BARTMP,U,2),",",2),16)       ; Bill Balance
 ;Q
 ; ********************************************************************
 ;
 ;DETATOT ;
 ; AR Account Total for Detail Report
 ;S BARTMP=$G(^TMP($J,"BAR-CXL",BARLOC,BARACCT))
 ;W !
 ;X BARDASH
 ;W !?38,$J($FN($P(BARTMP,U,2),",",2),13)         ; Billed Amount
 ;W ?52,"(",$P(BARTMP,U)," bills)"             ; Bill count
 ;W ?63,$J($FN($P(BARTMP,U,3),",",2),16),!     ; Bill Balance
 Q
 ; ********************************************************************
 ;
 ;DETLTOT ;
 ; Visit location total for Detail Report
 ;S BARTMP=$G(^TMP($J,"BAR-CXL",BARLOC))
 ;X BARDASH
 ;W !?5," ** VISIT Location Subtotal"
 ;W ?38,$J($FN($P(BARTMP,U,2),",",2),13)         ; Billed Amount
 ;W ?52,"(",$P(BARTMP,U)," bills)"             ; Bill count
 ;W ?63,$J($FN($P(BARTMP,U,3),",",2),16),!     ; Bill Balance
 Q
 ; ********************************************************************
 ;
 ;DETTOT ;
 ; Report total for detail report
 ;S BARTMP=$G(^TMP($J,"BAR-CXL"))
 ;X BAREQUAL
 ;W !?5,"*** REPORT TOTAL"
 ;W ?38,$J($FN($P(BARTMP,U,2),",",2),13)         ; Billed Amount
 ;W ?52,"(",$P(BARTMP,U)," bills)"             ; Bill count
 ;W ?63,$J($FN($P(BARTMP,U,3),",",2),16)       ; Bill Balance
 Q
 ; ********************************************************************
 ;
 ;SUMMARY ;
 ; Print Summary Report
 ;S BARDASH="W !?32,""-------  -------------   ----------------"""
 ;S BAREQUAL="W !?32,""=======  =============   ================"""
 ;S BAR("COL")="W !,""A/R ACCOUNT"",?32,""# BILLS"",?44,""AMT BILLED"",?66,""BALANCE"""
 ;D HDB^BARRPSRB
 ;I '$D(^TMP($J,"BAR-CXL")) D  Q           ; No data - quit
 ;. W !!!!!?25,"*** NO DATA TO PRINT ***"
 ;. D EOP^BARUTL(0)
 ;
 ;S BARLOC=""
 ;F  S BARLOC=$O(^TMP($J,"BAR-CXL",BARLOC)) Q:BARLOC=""  D SUMLOC Q:$G(BAR("F1"))
 ;D SUMTOT
 ;Q
 ; ********************************************************************
 ;
 ;SUMLOC ;
 ; For Each Visit Location (Summary) do...
 ;W !?5,"VISIT Location: ",BARLOC,!
 ;S BARACCT=""
 ;F  S BARACCT=$O(^TMP($J,"BAR-CXL",BARLOC,BARACCT)) Q:BARACCT=""  D SUMACCT Q:$G(BAR("F1"))
 ;D SUMLTOT
 Q
 ; ********************************************************************
 ;
 ;SUMACCT ;
 ; For each AR Account w/in Visit Location (Summary) do...
 ;I $Y>(IOSL-5) D HD^BARRPSRB Q:$G(BAR("F1"))
 ;S BARTMP=$G(^TMP($J,"BAR-CXL",BARLOC,BARACCT))
 ;W !,$E(BARACCT,1,30)
 ;W ?32,$J($FN($P(BARTMP,U),","),7)              ; Bill count
 ;W ?41,$J($FN($P(BARTMP,U,2),",",2),13)         ; Billed Amount
 ;W ?57,$J($FN($P(BARTMP,U,3),",",2),16)       ; Bill Balance
 ;Q
 ; ********************************************************************
 ;
 ;SUMLTOT ;
 ; Visit location total (Summary) Report
 ;S BARTMP=$G(^TMP($J,"BAR-CXL",BARLOC))
 ;X BARDASH
 ;W !," ** VISIT Location Subtotal"
 ;W ?32,$J($FN($P(BARTMP,U),","),7)               ; Bill count
 ;W ?41,$J($FN($P(BARTMP,U,2),",",2),13)         ; Billed Amount
 ;W ?57,$J($FN($P(BARTMP,U,3),",",2),16),!     ; Bill Balance
 Q
 ; ********************************************************************
 ;
 ;SUMTOT ;
 ; Report Total (Summary)
 ;S BARTMP=$G(^TMP($J,"BAR-CXL"))
 ;X BAREQUAL
 ;W !,"*** REPORT TOTAL"
 ;W ?32,$J($FN($P(BARTMP,U),","),7)              ; Bill count
 ;W ?41,$J($FN($P(BARTMP,U,2),",",2),13)         ; Billed Amount
 ;W ?57,$J($FN($P(BARTMP,U,3),",",2),16)       ; Bill Balance
 Q
