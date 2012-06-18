BIUTL3 ;IHS/CMI/MWR - UTIL: ZTSAVE, ASKDATE, DIRZ.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: SAVE ANY AND ALL BI VARIABLES FOR QUEUEING TO TASKMAN,
 ;;  ASK DATE RANGE, DIRZ (PROMPT TO CONTINUE).
 ;
 ;
 ;----------
ZSAVES ;EP
 ;---> Single central calling point for saving BI local
 ;---> variables and arrays in ZTSAVE for queuing to Taskman.
 ;---> Any of the BI variables listed below, if defined,
 ;---> will be stored in the ZTSAVE array.
 ;---> To add additional variables or arrays, simply document
 ;---> in the list and add to appropriate FOR loop below.
 ;
 ;---> Variables:
 ;
 ;        ZTSAVE  (ret) Taskman array of saved variables and arrays.
 ;
 ;     Single:
 ;     -------
 ;        BIACT   (opt) All or ACTIVE Only in Patient Errors.
 ;        BIAG    (opt) Age Range in months.
 ;        BIAGRP  (opt) Node/number for this Age Group.
 ;        BIAGRPS (opt) Age Groups in Two-Year-Old Report.
 ;        BIBEGDT (opt) Begin date of report.
 ;        BICOLL  (opt) Order of Lot Number listing, 1-4.
 ;        BICPTI  (opt) 1=Include CPT Coded Visits, 0=Ignore CPT (default).
 ;        BIDAR   (opt) Adolescent Report Age Range: "11-18^1" (years).
 ;        BIDED   (opt) Include Deceased Patients (0=no, 1=yes).
 ;        BIDFN   (opt) Patient's IEN in VA PATIENT File #2.
 ;        BIDLOC  (opt) Date-Location Line of letter.
 ;        BIDLOT  (opt) Display report by Lot Number (VAC).
 ;        BIENDDT (opt) End date of report.
 ;        BIFDT   (opt) Forecast/Clinic date.
 ;        BIFH    (opt) F=report on Flu Vaccine Group, H=H1N1 group.
 ;        BIHIST  (opt) Include Historical (Vac Acct Report).
 ;        BIHPV   (opt) 1=include HepA, Pneumo & Var, 0=exclude.
 ;        BILET   (opt) IEN of Letter in BI LETTER File.
 ;        BIMD    (opt) Minimum Interval days since last letter.
 ;        BINFO   (opt) Additional Information for each patient (no longer used).
 ;        BIORD   (opt) Order of listing.
 ;        BIPG    (opt) Patient Group (see calling routine).
 ;        BIQDT   (opt) Quarter Ending Date.
 ;        BIRDT   (opt) Date Range for Received Imms (form BEGDATE:ENDDATE).
 ;        BIRPDT  (opt) Report Date in View List (if passed from reports).
 ;        BISITE  (opt) IEN of Site.
 ;        BISUBT  (opt) Subtitle String for Lot Order in BILOT.
 ;        BITAR   (opt) Two-Yr-Old Report Age Range.
 ;        BIUP    (opt) User Population/Group (Registered, User, Active).
 ;        BIVFC   (opt) VFC Eligibility for Imm Visits.
 ;        BIYEAR  (opt) Report Year.
 ;
 ;     Arrays:
 ;     -------
 ;        BIBEN   (opt) Beneficiary Type array.
 ;        BICC    (opt) Current Community array.
 ;        BICM    (opt) Case Manager array.
 ;        BIDPRV  (opt) Designated Provider array.
 ;        BIHCF   (opt) Health Care Facility array.
 ;        BILOT   (opt) Lot Number array.
 ;        BIMMD   (opt) Immunization Due array.
 ;        BIMMR   (opt) Immunization Received array.
 ;        BIMMRF  (opt) Immunization Received Filter array.
 ;        BIMMLF  (opt) Lot Number Filter array.
 ;        BINFO   (opt) Additional Information for each patient.
 ;        BIVT    (opt) Visit Type array.
 ;
 ;---> Save local variables for queueing Due List/Letters.
 K ZTSAVE N BISV
 ;
 F BISV="ACT","AG","AGRP","AGRPS","BEGDT","COLL","CPTI","DAR","DED","DFN" D
 .S BISV="BI"_BISV
 .I $D(@(BISV)) S ZTSAVE(BISV)=""
 ;
 F BISV="DLOC","DLOT","ENDDT","FDT","FH","HIST","HPV","LET","MD","NFO","ORD" D
 .S BISV="BI"_BISV
 .I $D(@(BISV)) S ZTSAVE(BISV)=""
 ;
 F BISV="PG","QDT","RDT","RPDT","SITE","SUBT","T","TAR","UP","VFC","YEAR" D
 .S BISV="BI"_BISV
 .I $D(@(BISV)) S ZTSAVE(BISV)=""
 ;
 ;---> Save local arrays for queueing Due List/Letters.
 F BISV="BEN","CC","CM","DPRV","HCF","LOT","MMD","MMLF","MMR","MMRF","VT" D
 .S BISV="BI"_BISV
 .D:$D(@BISV)
 ..N N S N=0 F  S N=$O(@(BISV_"("""_N_""")")) Q:N=""  D
 ...S ZTSAVE(BISV_"("""_N_""")")=""
 Q
 ;
 ;
 ;----------
ASKDATES(BIB,BIE,BIPOP,BIBDF,BIEDF,BISAME,BITIME) ;EP
 ;---> Ask date range.
 ;---> Parameters:
 ;     1 - BIB    (ret) Begin Date, Fileman format.
 ;     2 - BIE    (ret) End Date, Fileman format.
 ;     3 - BIPOP  (ret) BIPOP=1 If quit, fail, DTOUT, DUOUT.
 ;     4 - BIBDF  (opt) Begin Date default, Fileman format.
 ;     5 - BIEDF  (opt) End Date default, Fileman format.
 ;     6 - BISAME (opt) Force End Date default=Begin Date.
 ;     7 - BITIME (opt) Ask times.
 ;
 ;---> Example:
 ;        D ASKDATES^BIUTL3(.BIBEGDT,.BIENDDT,.BIPOP,"T-365","T")
 ;
 S BIPOP=0 N %DT,Y
 W !!,"   *** Date Range Selection ***"
 ;
 ;---> Begin Date.
 S %DT="APEX"_$S($G(BITIME):"T",1:"")
 S %DT("A")="   Begin with DATE: "
 I $G(BIBDF)]"" S Y=BIBDF D DD^%DT S %DT("B")=Y
 D ^%DT K %DT
 I Y<0 S BIPOP=1 Q
 ;
 ;---> End Date.
 S (%DT(0),BIB)=Y K %DT("B")
 S %DT="APEX"_$S($D(BITIME):"T",1:"")
 S %DT("A")="   End with DATE:   "
 I $G(BIEDF)]"" S Y=BIEDF D DD^%DT S %DT("B")=Y
 I $D(BISAME) S Y=BIB D DD^%DT S %DT("B")=Y
 D ^%DT K %DT
 I Y<0 S BIPOP=1 Q
 S BIE=Y
 Q
 ;
 ;
 ;----------
DATE(BIDT,BIPOP,BIDFLT,BIPRMPT,BITIME) ;EP
 ;---> Ask Date.
 ;---> Parameters:
 ;     1 - BIDT    (ret) Selected Date, Fileman format.
 ;     2 - BIPOP   (ret) BIPOP=1 If quit, fail, DTOUT, DUOUT.
 ;     3 - BIDFLT  (opt) Default, Fileman format.
 ;     4 - BIPRMPT (opt) Prompt.
 ;     5 - BITIME  (opt) Ask times.
 ;
 ;---> EXAMPLE:
 ;        D DATE^BIUTL3(.BIDT,.BIPOP,DT)
 ;
 S BIPOP=0 N %DT,Y
 S %DT="APEX"_$S($G(BITIME):"T",1:"")
 S:$G(BIPRMPT)="" BIPRMPT="   Enter DATE: "
 S %DT("A")=BIPRMPT
 I $G(BIDFLT)]"" S Y=BIDFLT D DD^%DT S %DT("B")=Y
 D ^%DT K %DT
 I Y<0 S BIPOP=1 Q
 S BIDT=Y
 Q
 ;
 ;
 ;----------
LOCKED ;EP
 D EN^DDIOL("Another user is editing this entry.  Please, try again later.",,"!?5")
 D DIRZ()
 Q
 ;
 ;
 ;----------
DIRZ(BIPOP,BIPRMT,BIPRMT1,BIPRMT2,BIPRMTQ) ;EP - Press RETURN to continue.
 ;---> Call to ^DIR, to Press RETURN to continue.
 ;---> Parameters:
 ;     1 - BIPOP   (ret) BIPOP=1 if DTOUT or DUOUT
 ;     2 - BIPRMT  (opt) Prompt other than "Press RETURN..."
 ;     3 - BIPRMT1 (opt) Prompt other than "Press RETURN..."
 ;     4 - BIPRMT2 (opt) Prompt other than "Press RETURN..."
 ;     5 - BIPRMTQ (opt) Response to "?" other than standard
 ;
 ;---> Example: D DIRZ^BIUTL3(.BIPOP)
 ;
 N DDS,DIR,DIRUT,X,Y,Z
 D
 .I $G(BIPRMT)="" D  Q
 ..S DIR("A")="   Press ENTER/RETURN to continue or ""^"" to exit"
 .S DIR("A")=BIPRMT
 .I $G(BIPRMT1)]"" S DIR("A",1)=BIPRMT1
 .I $G(BIPRMT2)]"" S DIR("A",2)=BIPRMT2
 I $G(BIPRMTQ)]"" S DIR("?")=BIPRMTQ
 S DIR(0)="E" W ! D ^DIR W !
 S BIPOP=$S($D(DIRUT):1,Y<1:1,1:0)
 Q
 ;
 ;
 ;----------
NOW1 ;EP
 ;---> S BITTTS=Start time.
 N %,Y,X D NOW^%DTC S BITTTS=%
 Q
 ;
 ;
 ;----------
NOW2 ;EP
 ;---> S BITTTE=End time.
 N %,Y,X D NOW^%DTC S BITTTE=%
 ;
 ;---> Compare times.
 S Y=BITTTE X ^DD("DD") W !!?5,"End  : ",$P(Y,"@",2)
 S Y=BITTTS X ^DD("DD") W !?5,"Begin: ",$P(Y,"@",2)
 D DIRZ()
 K BITTTE,BITTTS
 Q
