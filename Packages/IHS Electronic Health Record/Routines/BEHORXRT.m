BEHORXRT ;IHS/MSC/MGH - E-Prescribing receipt ;14-Jul-2011 17:12;PLS
 ;;1.1;BEH COMPONENTS;**009004,009006,009007**;Mar 20, 2007
 ;=================================================================
 ; RPC: Retrieve reports for date range
GETRPTS(DATA,DFN,BEHFLG,STRT,END) ;EP
 S DATA=$$TMPGBL^CIAVMRPC
 D CAPTURE^CIAUHFS("D REPORTS^BEHORXRT(DFN,.BEHFLG,STRT,END)",DATA,80)
 S:'$D(@DATA) @DATA@(1)="No E-Prescriptions found within specified date range."
 Q
 ; RPC: Retrieve report
 ; Entry point for OE/RR REPORT file
OERRRPTS(ROOT,ORDFN,ID,ALPHA,OMEGA,ORDTRNG,REMOTE,ORMAX,ORFHIE) ;EP
 D GETRPTS(.ROOT,ORDFN,,ALPHA,OMEGA)
 Q
REPORTS(DFN,BEHFLG,STRT,END) ;
 N TRANSDT,IEN,DATA,RX,PAT
 K ^TMP("BEHRX",$J) K ^TMP("BEHRX2",$J)
 S TRANSDT=STRT,END=END\1+.2359
 F  S TRANSDT=$O(^PS(52.51,"AC1",TRANSDT)) Q:TRANSDT=""  D
 .I TRANSDT,TRANSDT'>END D
 ..S IEN="" F  S IEN=$O(^PS(52.51,"AC1",TRANSDT,IEN)) Q:IEN=""  D
 ...S DATA=$G(^PS(52.51,IEN,0))
 ...S PAT=$P(DATA,U,2),STATUS=$P($G(^PS(52.51,IEN,0)),U,10)
 ...I PAT=DFN&(STATUS=2) D SAVE(IEN,DATA)
 D RESORT,REPORT
 Q
SAVE(IEN,DATA) ;EP
 ; Generate specified report segments for a visit abstract
 N RX,PHARM,RXDRUG,DRUG,RXPHARM,PHARM,PROV
 S RX=$P(DATA,U,1)
 Q:RX=""
 S RXDRUG=$P($G(^PSRX(RX,0)),U,6)
 Q:RXDRUG=""
 S DRUG=$P($G(^PSDRUG(RXDRUG,0)),U,1)
 S RXPHARM=$P($G(^PSRX(RX,999999921)),U,4)
 Q:RXPHARM=""
 S PROV=$P($G(^PSRX(RX,0)),U,4)
 Q:PROV=""
 S PHARM=$P($G(^APSPOPHM(RXPHARM,0)),U,1)
 S DATE=$P(TRANSDT,".",1)
 S ^TMP("BEHRX",$J,PROV,RXPHARM,DATE,RX)=TRANSDT
 Q
RESORT ;
 N PROV,RXPHARM,TRANSDT,RX,CNT
 S CNT=0
 S PROV="" F  S PROV=$O(^TMP("BEHRX",$J,PROV)) Q:PROV=""  D
 .S RXPHARM="" F  S RXPHARM=$O(^TMP("BEHRX",$J,PROV,RXPHARM)) Q:RXPHARM=""  D
 ..S TRANSDT="" F  S TRANSDT=$O(^TMP("BEHRX",$J,PROV,RXPHARM,TRANSDT)) Q:TRANSDT=""  D
 ...S CNT=0 S RX="" F  S RX=$O(^TMP("BEHRX",$J,PROV,RXPHARM,TRANSDT,RX)) Q:RX=""  D
 ....S CNT=CNT+1
 ....S ^TMP("BEHRX2",$J,PROV,RXPHARM,TRANSDT)=CNT
 Q
REPORT ;
 N SNAME,ADDRESS,CITY,INAME,IADDRESS,ICITY,IPHONE,IFAX
 N PROV,RXPHARM,TRANSDT,RX,RX0,INST,HLOC,PAGE,NNAME
 S PAGE=0,FIRST=1
 D HDR
 S PROV="" F  S PROV=$O(^TMP("BEHRX",$J,PROV)) Q:PROV=""  D
 .;I FIRST=0 D FOOTER,HDR
 .S NNAME=$P($G(^VA(200,PROV,0)),U,1)
 .S RXPHARM="" F  S RXPHARM=$O(^TMP("BEHRX",$J,PROV,RXPHARM)) Q:RXPHARM=""  D
 ..;I FIRST=0 D FOOTER,HDR
 ..D PHARM
 ..S TRANSDT="" F  S TRANSDT=$O(^TMP("BEHRX",$J,PROV,RXPHARM,TRANSDT)) Q:TRANSDT=""  D
 ...I FIRST=0 D FOOTER,HDR
 ...S CNT=$G(^TMP("BEHRX2",$J,PROV,RXPHARM,TRANSDT))
 ...S DTE=$$FMTE^XLFDT(TRANSDT)
 ...W !,CNT_" prescription(s) were sent on: "_DTE
 ...W !,"Prescriptions were sent electronically and securely to:"
 ...W !,$$CJ^XLFSTR(SNAME,IOM)
 ...W !,$$CJ^XLFSTR(ADDRESS,IOM)
 ...W !,$$CJ^XLFSTR(CITY,IOM)
 ...W !,"The prescription(s) sent were:",!
 ...W !,"MEDICATION",?50,"SENT"
 ...S RX="" F  S RX=$O(^TMP("BEHRX",$J,PROV,RXPHARM,TRANSDT,RX)) Q:RX=""  D
 ....I FIRST=1 S FIRST=0
 ....S RX0=$G(^PSRX(RX,0))
 ....S HLOC=$P(RX0,U,5)
 ....S INST=$$GET1^DIQ(44,HLOC,3,"I")
 ....D INST
 ....S DRUG=$P(RX0,U,6),DNAME=$P($G(^PSDRUG(DRUG,0)),U,1)
 ....S TDATE=$G(^TMP("BEHRX",$J,PROV,RXPHARM,TRANSDT,RX))
 ....W !,DNAME,?50,$$FMTE^XLFDT(TDATE)
 D FOOTER
 Q
PHARM ;Get the data for the pharmacy
 S SNAME=$$VAL^XBDIQ1(9009033.9,RXPHARM,.1)
 S ADDRESS=$$VAL^XBDIQ1(9009033.9,RXPHARM,1.1)_" "_$$VAL^XBDIQ1(9009033.9,RXPHARM,1.2)
 S CITY=$$VAL^XBDIQ1(9009033.9,RXPHARM,1.3)_" "_$$VAL^XBDIQ1(9009033.9,RXPHARM,1.4)_" "_$$VAL^XBDIQ1(9009033.9,RXPHARM,1.5)
 Q
INST ;Get the data for the institution
 S INAME=$$GET1^DIQ(4,INST,.01)
 S IADDRESS=$$GET1^DIQ(4,INST,1.01)  ;Street Address 1
 S ICITY=$$GET1^DIQ(4,INST,1.03)_", "_$$GET1^DIQ(4,INST,.02)_"  "_$$GET1^DIQ(4,INST,1.04)
 S IPHONE=$$GET1^DIQ(9999999.06,INST,.13)
 S IFAX=$$GET^XPAR("ALL","APSP AUTO RX FAXED FROM NUMBER")
 Q
 ; Start new page and output header if exceed line count
HDR S CNT=$G(CNT,1),PAGE=PAGE+1
 W @IOF
 ;W #
 W !,$$CJ^XLFSTR("RECEIPT",IOM)
 W !,$$CJ^XLFSTR("E-Prescription Transmission Summary",IOM),!!
 S NAME=$P($G(^DPT(DFN,0)),U,1)
 S LNAME=$P(NAME,",",1),FNAME=$P(NAME,",",2)
 S NAME=FNAME_" "_LNAME
 W !,$$CJ^XLFSTR(NAME,IOM),!
 Q
FOOTER ;
 W !!!,"Important Note: This is the summary of your medications"
 W !,"you will be receiving from your pharmacy.  You do not have"
 W !,"to present this slip at your pharmacy in order to pick up your"
 W !,"prescription(s), but sharing this slip with the pharmacist can"
 W !,"help to  ensure that you get all of the medicines that have been"
 W !,"prescribed for you",!!
 W !,"To the Pharmacist:",!
 W !,"Prescriptions for the medications listed above were sent to your"
 W !,"pharmacy via the Surescripts network. Please look for these"
 W !,"prescriptions in your computer's electronic prescriptions queue"
 W !,"and/or your fax machine.",!!
 W !,$$CJ^XLFSTR(NNAME,IOM)
 W !,$$CJ^XLFSTR(INAME,IOM)
 W !,$$CJ^XLFSTR(IADDRESS,IOM)
 W !,$$CJ^XLFSTR(ICITY,IOM)
 W !,$$CJ^XLFSTR("Phone: "_IPHONE,IOM)
 W !,$$CJ^XLFSTR("Fax: "_IFAX,IOM)
 S PAGE=PAGE+1
 W !!,$$REPEAT^XLFSTR("=",80),!
 F I=$Y:1:IOSL-8 W !
 Q
 ; Return XML array for a list of prescriptions
RECXML(DATA,RXARY,DFN) ;EP-
 N DAT,ID,CNT,PNM,RX,LP
 S DATA=$$TMPGBL^CIAVMRPC
 K @DATA
 S CNT=0
 S PNM=$$GET1^DIQ(2,DFN,.01)
 S PNM=$P(PNM,",",2)_" "_$P(PNM,",")
 D ADD("<?xml version=""1.0"" ?>")
 D ADD($$TAG("Transactions",0))
 D ADD($$TAG("PatientName",2,PNM))
 S LP=0 F  S LP=$O(RXARY(LP)) Q:'LP  D
 .S RX=$$GETPSIFN^BEHORXFN(RXARY(LP))
 .D:RX ADDXML(RX)
 D ADD($$TAG("Transactions",1))
 Q
ADDXML(RX) ;EP-
 N PHMI,INI,PFN
 S PFN=9009033.9
 S PHMI=$$GET1^DIQ(52,RX,9999999.24,"I")
 S INI=$$GET1^DIQ(44,$$GET1^DIQ(52,RX,5,"I"),3,"I")
 D ADD($$TAG("Transaction",0))
 I PHMI D
 .D ADD($$TAG("PharmacyName",2,$$GET1^DIQ(PFN,PHMI,.1)))
 .D ADD($$TAG("PharmacyAddr1",2,$$GET1^DIQ(PFN,PHMI,1.1)))
 .D ADD($$TAG("PharmacyAddr2",2,$$GET1^DIQ(PFN,PHMI,1.2)))
 .D ADD($$TAG("PharmacyCity",2,$$GET1^DIQ(PFN,PHMI,1.3)))
 .D ADD($$TAG("PharmacyState",2,$$GET1^DIQ(PFN,PHMI,1.4)))
 .D ADD($$TAG("PharmacyZip",2,$$GET1^DIQ(PFN,PHMI,1.5)))
 I INI D
 .D ADD($$TAG("InstitutionName",2,$$GET1^DIQ(4,INI,.01)))
 .D ADD($$TAG("InstitutionAddr1",2,$$GET1^DIQ(4,INI,1.01)))
 .D ADD($$TAG("InstitutionCity",2,$$GET1^DIQ(4,INI,1.03)))
 .D ADD($$TAG("InstitutionState",2,$$GET1^DIQ(4,INI,.02)))
 .D ADD($$TAG("InstitutionZip",2,$$GET1^DIQ(4,INI,1.04)))
 .D ADD($$TAG("InstitutionFax",2,$$GET^XPAR("ALL","APSP AUTO RX FAXED FROM NUMBER")))
 D ADD($$TAG("DrugName",2,$$GET1^DIQ(52,RX,6)))
 D ADD($$TAG("DEA",2,$$GET1^DIQ(50,$$GET1^DIQ(52,RX,6,"I"),3)))
 D ADD($$TAG("Provider",2,$$GET1^DIQ(52,RX,4)))
 D ADD($$TAG("Date_Time",2,$$XMTDATE(RX)))
 D ADD($$TAG("Transaction",1))
 Q
 ; Return formatted transmission date/time
XMTDATE(RX) ;EP-
 N IEN,TDT
 S IEN=$O(^PS(52.51,"B",RX,0))
 Q $$GET1^DIQ(52.51,IEN,3)
 ; Add data to array
ADD(VAL) ;EP-
 S CNT=CNT+1
 S @DATA@(CNT)=VAL
 Q
 ; Returns formatted tag
 ; Input: TAG - Name of Tag
 ;        TYPE - (-1) = empty 0 =start <tag>   1 =end </tag>  2 = start -VAL - end
 ;        VAL - data value
TAG(TAG,TYPE,VAL) ;EP -
 S TYPE=$G(TYPE,0)
 S:$L($G(VAL)) VAL=$$SYMENC^MXMLUTL(VAL)
 I TYPE<0 Q "<"_TAG_"/>"  ;empty
 E  I TYPE=1 Q "</"_TAG_">"
 E  I TYPE=2 Q "<"_TAG_">"_$G(VAL)_"</"_TAG_">"
 Q "<"_TAG_">"
