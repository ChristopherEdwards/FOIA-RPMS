BSDHS ; IHS/ANMC/LJF - HS BY CLINIC ;  [ 08/20/2004  11:54 AM ]
 ;;5.3;PIMS;**1001,1010**;APR 26, 2002
 ;
 ;cmi/anch/maw 10/20/2008 PATCH 1010 RQMT79 added the ability to select health summary
 ;
 ;
 NEW BSDDT,VAUTD,VAUTC,BSDSRT
DATE ; -- select date
 S BSDDT=$$READ^BDGF("DO^::EX","Print Health Summaries for Which Date")
 Q:BSDDT<1
 ;
CLINIC ; -- all clinics or selected ones?
 ; if ALL clinics are selected, VAUTC=1
 ;   otherwise the VAUTC array is set and VAUTC=0
 D CLINIC^BSDU(1) I Y<0 D END Q
 ;
SORTS ; -- sort by
 NEW DIR0,DIRA,DIRB
 ;S DIR0="S^C:BY CLINIC CODE;P:BY PRINCIPAL CLINIC"
 S DIR0="S^C:BY CLINIC NAME;P:BY PRINCIPAL CLINIC;T:BY TERMINAL DIGIT;N:BY PATIENT NAME"  ;IHS/ITSC/LJF 4/8/2004
 S DIRA="HEALTH SUMMARIES SORT ORDER"
 S BSDSRT=$$READ^BDGF(DIR0,DIRA,"P","^D HELP1^BSDHS")
 ;I "CP"'[BSDSRT D END Q
 I "CPTN"'[BSDSRT D END Q   ;IHS/ITSC/LJF 4/8/2004
 ;
OTHER ; -- print other forms too?
 S BSDFORM=$$READ^BDGF("YO","Do you want to also print other forms","YES","^D HELP2^BSDHS")
 I (BSDFORM="")!(BSDFORM=U) D END Q
 ;
DEVICE ; -- select print device
 I VAUTD=1 S DIV=$$DIV^BSDU  ;user's division if all divisions selected
 I VAUTD=0 S DIV=$O(VAUTD(0)) I 'DIV S DIV=$$DIV^BSDU  ;or first div
 S DEFAULT=$$GET1^DIQ(9009020.2,DIV,.06)  ;default hs printer
 S BSDHST=$$READ^BDGF("P^9001015:EMZ","Select Health Summary")  ;cmi/maw 10/20/2008 PATCH 1010 RQMT79 added call for user to select Heath Summary Type
 D ZIS^BDGF("QP","START^BSDHS","HS BY CLINICS","BSDDT;BSDSRT;BSDHST;VAUTC*;VAUTD*;BSDFORM",DEFAULT)
 ;
END ; -- eoj
 K ALL,DIV,ORD,ORDER,RMSEL,SDIQ,SDREP,SDSP,SDSTART
 K SDX,X,Y,C,V,I,SDEF,%I Q
 ;
START ;EP; loop thru clinics and appts to get patients
 ; build sorted array
 U IO K ^TMP("BSDHS",$J)
 S X=$S(VAUTC=1:"ALL",1:"SOME") D @X
 ;
 ; loop thru sorted array and call forms to print
 NEW A,B,C,D S BSDLN=0
 S A=0 F  S A=$O(^TMP("BSDHS",$J,A)) Q:A=""  D
 . S B=0 F  S B=$O(^TMP("BSDHS",$J,A,B)) Q:B=""  D
 .. S C=0 F  S C=$O(^TMP("BSDHS",$J,A,B,C)) Q:C=""  D
 ... ;D FORMS(C,B)
 ... ;D FORMS(B,C)   ;IHS/ITSC/LJF 1/2/2004
 ... D FORMS(^TMP("BSDHS",$J,A,B,C),C)   ;IHS/ITSC/LJF 4/8/2004
 ;
 D ^%ZISC,END   ;IHS/ITSC/LJF 7/14/2004 PATCH #1001
 K ^TMP("BSDHS",$J)
 Q
 ;
ALL ; -- loop thru all clinics
 NEW BSDCLN,BSDSUB
 S BSDCLN=0 F  S BSDCLN=$O(^SC(BSDCLN)) Q:'BSDCLN  D
 . Q:'$$ACTV^BSDU(BSDCLN,BSDDT)                 ;quit if inactive
 . I VAUTD=0 Q:'$D(VAUTD(+$$DIVC^BSDU(BSDCLN)))  ;quit if not select div
 . F BSDSUB="S","C" D GETAPPT          ;get all appt & chart requests
 Q
 ;
SOME ; -- loop thru selected clinics
 NEW BSDCL,BSDCLN,BSDSUB
 S BSDCL=0 F  S BSDCL=$O(VAUTC(BSDCL)) Q:BSDCL=""  D
 . S BSDCLN=VAUTC(BSDCL)          ;clinic ien
 . Q:'$$ACTV^BSDU(BSDCLN,BSDDT)   ;quit if inactive
 . F BSDSUB="S","C" D GETAPPT     ;get all appt & chart requests
 Q
 ;
GETAPPT ; -- for clinic, get appts & chart requests for date
 NEW BSDT,BSDEND,BSDN,NODE,HRCN,TERM,SORT,LINE,X
 S BSDT=BSDDT-.0001,BSDEND=BSDDT_".2400"
 F  S BSDT=$O(^SC(BSDCLN,BSDSUB,BSDT)) Q:'BSDT  Q:(BSDT>BSDEND)  D
 . S BSDN=0
 . F  S BSDN=$O(^SC(BSDCLN,BSDSUB,BSDT,1,BSDN)) Q:'BSDN  D
 .. S NODE=$G(^SC(BSDCLN,BSDSUB,BSDT,1,BSDN,0)) Q:'NODE
 .. ;
 .. ;
 .. ; set sort values
 .. ;IHS/ITSC/LJF 4/8/2004 rewrote this section of subroutine
 .. S HRCN=$$HRCN^BDGF2(+NODE,$$FAC^BSDU(BSDCLN))  ;chart #
 .. I $$GET1^DIQ(9009020.2,+$$DIVC^BSDU(BSDCLN),.18)="NO" D
 ... S TERM=$$HRCND^BDGF2(HRCN)              ;no terminal digit per site param
 .. E  S TERM=$$HRCNT^BDGF2(HRCN)            ;terminal digit format
 .. ;
 .. I BSDSRT="C" S SORT=$$GET1^DIQ(44,BSDCLN,.01)     ;clinic name
 .. I BSDSRT="P" S SORT=$$PRIN^BSDU(BSDCLN)        ;principal clinic
 .. ;I SORT="UNAFFILIATED CLINICS" S SORT=$$GET1^DIQ(44,BSDCLN,.01)
 .. I $G(SORT)="UNAFFILIATED CLINICS" S SORT=$$GET1^DIQ(44,BSDCLN,.01)  ;IHS/ITSC/LJF 4/21/2004
 .. I BSDSRT="N" S SORT=$$GET1^DIQ(2,+NODE,.01)   ;sort by patient name
 .. I BSDSRT="T" S SORT=TERM                     ;terminal digit sort
 .. ;
 .. ;S ^TMP("BSDHS",$J,SORT,TERM,+NODE)=""
 .. S ^TMP("BSDHS",$J,SORT,TERM,+NODE)=BSDCLN  ;IHS/ITSC/LJF 4/16/2004
 Q
 ;
FORMS(CLINIC,DFN) ; -- call forms code if turned on for clinic
 NEW A,B,C   ;IHS/ITSC/LJF 1/2/2004
 ; -- health summary first
 I $$GET1^DIQ(9009017.2,CLINIC,.04)'="YES" Q
 ;S X=$$GET1^DIQ(9009017.2,CLINIC,.05,"I")  ;hs type  cmi/maw 10/20/2008 orig line
 ;D HS^BSDFORM(DFN,X)  ;cmi/maw 10/20/2008 orig line
 D HS^BSDFORM(DFN,+BSDHST)  ;cmi/maw 10/20/2008 health summary is now BSDHST
 ;
 I BSDFORM=0 Q    ;quit if not printing other forms
 ; -- rx profile
 S BSDRX=$$GET1^DIQ(9009017.2,CLINIC,.06,"I")   ;rx profile flag
 I BSDRX=1 D MP^BSDFORM(DFN)
 I BSDRX=2 D APRO^BSDFORM(CLINIC,DFN,BSDDT)
 ;
 ; -- address/insurance update form
 I $$VAL^XBDIQ1(9009017.2,CLINIC,.07)="YES" D AIU^BSDFORM(DFN)
 ;
 Q
 ;
 ;
HELP1 ;EP; -- help for sort question
 ;IHS/ITSC/LJF 4/8/2004 rewrote subroutine to add terminal digit and patient sorts
 D MSG^BDGF("Answer C to sort by clinic, P to sort by principal clinic,",2,0)
 D MSG^BDGF("T to sort by terminal digit or chart # and N to sort by",1,0)
 D MSG^BDGF("patient name.  Within clinic or principal clinic, the health",1,0)
 D MSG^BDGF("summaries will be sorted by terminal digit or chart #",1,0)
 D MSG^BDGF("depending on how your file room parameter is set.",1,1)
 Q
 ;
HELP2 ;EP; -- help for other forms question
 D MSG^BDGF("Answer YES to print not only Health Summaries but",2,0)
 D MSG^BDGF("also Address/Insurance Updates, Medication Profiles",1,0)
 D MSG^BDGF("or Action Profiles if turned on for clinics selected.",1,1)
 D MSG^BDGF("Answer NO to print ONLY Health Summaries.",1,1)
 Q
