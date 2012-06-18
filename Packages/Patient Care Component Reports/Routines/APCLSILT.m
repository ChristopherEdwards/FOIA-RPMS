APCLSILT ;IHS/CMI/LAB - AGGREGATE ILI REPORT PRINT;  ; 10 Oct 2011  7:36 AM
 ;;3.0;IHS PCC REPORTS;**24,25,26,27,28**;FEB 05, 1997
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
 ;
ILISEX ;EP
 D HEADER^APCLSILR Q:$D(APCLQUIT)
 W "TABLE 2:  ILI Diagnoses by Sex"
 W !,"This table provides a patient/visit count, by sex, for ILI diagnosis.  An ILI"
 W !,"diagnosis is defined as a visit with one of the following influenza ICD9"
 W !,"diagnosis codes:  487* or 488*"
 W !,"   OR"
 W !,"a temperature of >=100 AND one of the following ICD9 codes:"
 W !,"079.99,382.00,382.9,460,461.8,461.9,462,463,464.00,464.10,,464.20,465.0,"
 W !,"465.8,465.9,466.0,466.19,478.9,480.9,485,486,490,780.6,780.60,780.61,786.2"
 W !!,"An unduplicated count of patients is also provided.",!!,?40,"# patients",?60,"# visits",!
 I APCLLOCT="O" G LOCSEX
 W !,"ALL FACILITIES COMBINED",!
 S APCLSEX="" F  S APCLSEX=$O(APCLILIS(APCLSEX)) Q:APCLSEX=""!($D(APCLQUIT))  D
 .I $Y>(IOSL-3) D HEADER^APCLSILR Q:$D(APCLQUIT)  D SUBHEAD3
 .W ?2,APCLSEX,?40,$$C($P(APCLILIS(APCLSEX),U,2),0,7),?60,$$C($P(APCLILIS(APCLSEX),U,1),0,7),!
 .Q
 Q:$D(APCLQUIT)
 W $$REPEAT^XLFSTR("-",79),!
LOCSEX S APCLLOC="" F  S APCLLOC=$O(APCLSEXL(APCLLOC)) Q:APCLLOC=""!($D(APCLQUIT))  D
 .I $Y>(IOSL-8) D HEADER^APCLSILR Q:$D(APCLQUIT)  D SUBHEAD3
 .W !!,APCLLOC
 .S APCLSEX="" F  S APCLSEX=$O(APCLSEXL(APCLLOC,APCLSEX)) Q:APCLSEX=""!($D(APCLQUIT))  D
 ..W !?2,APCLSEX,?40,$$C($P(APCLSEXL(APCLLOC,APCLSEX),U,2),0,7),?60,$$C($P(APCLSEXL(APCLLOC,APCLSEX),U,1),0,7),!
 .W $$REPEAT^XLFSTR("-",79),!
 Q
ILIAVM ;EP - meds
 D HEADER^APCLSILR Q:$D(APCLQUIT)
 W "TABLE 3:  ILI Anti-Viral Medications Dispensed"
 W !,"This table provides a count by drug name of the number of visits on which"
 W !,"an Anti-Viral Medication was dispensed.  Anti-Viral Medications are defined"
 W !,"as any medication contained in the FLU ANTIVIRAL MEDS taxonomy or any "
 W !,"Medication whose drug name contains OSELTAMIVIR or ZANAMIVIR.  An unduplicated"
 W !," unduplicated count of patients is also provided.",!,?40,"# patients",?60,"# visits",!
 S APCLD="" F  S APCLD=$O(APCLMEDS(APCLD)) Q:APCLD=""!($D(APCLQUIT))  D
 .I $Y>(IOSL-3) D HEADER^APCLSILR Q:$D(APCLQUIT)  D SUBHEAD4
 .W ?2,APCLD,?40,$$C($P(APCLMEDS(APCLD),U,2),0,7),?60,$$C($P(APCLMEDS(APCLD),U,1),0,7),!
 .Q
 Q
SUBHEAD3 ;
 W !,"TABLE 2:  ILI Diagnoses by Sex",!,?40,"# patients",?60,"# visits",!
 Q
SUBHEAD4 ;
 W "TABLE 3:  ILI Anti-Viral Medications Dispensed",!!,?40,"# patients",?60,"# prescriptions",!
 Q
ILIAGEP ;EP
 D HEADER^APCLSILR
 W "TABLE 4:  ILI Diagnoses by Age by Visit"
 W !,"This table displays a visit count by age group.  Only visits on which "
 W !,"there was at least one ILI diagnosis are counted. An ILI diagnosis"
 W !,"is defined as a visit with one of the following influenza ICD9"
 W !,"diagnosis codes:  487* or 488*"
 W !,"   OR"
 W !,"a temperature of >=100 AND one of the following ICD9 codes:"
 W !,"079.99,382.00,382.9,460,461.8,461.9,462,463,464.00,464.10,,464.20,465.0,"
 W !,"465.8,465.9,466.0,466.19,478.9,480.9,485,486,490,780.6,780.60,780.61,786.2"
 W !,"The visits have to be defined as 'surveillance' visits.  The definition "
 W !,"of these visits is the following:"
 W !,"   - a Hospitalization"
 W !,"   - a visit to a PHN"
 W !,"   - an Ambulatory visit (service categories A, O, R, S) to one of the "
 W !,"     following clinics:  01 GENERAL, 06 DIABETIC, 10 GYN, 12 IMMUNIZATION,"
 W !,"               13 INTERNAL MEDICINE, 20 PEDIATRICS, 24 WELL CHILD CARE, "
 W !,"               28 FAMILY PRACTICE, 30 EMERGENCY ROOM, 57 EPSDT, "
 W !,"               70 WOMEN'S HEALTH, 80 URGENT CARE, 89 EVENING"
 W !!,"Age",?19," 0-4y",?29,"5-24y",?39,"25-49y",?49,"50-64y",?59,"65y+",?69,"TOTAL",!
 W !,"Ambulatory ILI"
 W ?19,$$C($G(APCLAGEG("I","A","0-4y")),0,7)
 W ?29,$$C($G(APCLAGEG("I","A","5-24y")),0,7)
 W ?39,$$C($G(APCLAGEG("I","A","25-49y")),0,7)
 W ?49,$$C($G(APCLAGEG("I","A","50-64y")),0,7)
 W ?59,$$C($G(APCLAGEG("I","A","65y+")),0,7)
 W ?69,$$C($G(APCLAGEG("I","A","TOTAL")),0,7),!
 W "Diagnosis",!
 W $$REPEAT^XLFSTR("-",79),!
 ;W !,"Ambulatory"
 ;W ?14,$$C($G(APCLAGEG("H","A","6-23m")),0,7)
 ;W ?22,$$C($G(APCLAGEG("H","A","24-59m")),0,7)
 ;W ?30,$$C($G(APCLAGEG("H","A","60m-18y")),0,7)
 ;W ?38,$$C($G(APCLAGEG("H","A","19-24y")),0,7)
 ;W ?46,$$C($G(APCLAGEG("H","A","25-49y")),0,7)
 ;W ?54,$$C($G(APCLAGEG("H","A","50-64y")),0,7)
 ;W ?62,$$C($G(APCLAGEG("H","A","65+y")),0,7)
 ;W ?72,$$C($G(APCLAGEG("H","A","TOTAL")),0,7),!
 ;W "H1N1 DXS",!
 ;W $$REPEAT^XLFSTR("-",79),!
 W !,"Hospital ILI"
 W ?19,$$C($G(APCLAGEG("I","H","0-4y")),0,7)
 W ?29,$$C($G(APCLAGEG("I","H","5-24y")),0,7)
 W ?39,$$C($G(APCLAGEG("I","H","25-49y")),0,7)
 W ?49,$$C($G(APCLAGEG("I","H","50-64y")),0,7)
 W ?59,$$C($G(APCLAGEG("I","H","65y+")),0,7)
 W ?69,$$C($G(APCLAGEG("I","H","TOTAL")),0,7),!
 W "Diagnosis",!
 W $$REPEAT^XLFSTR("-",79),!
 ;W !,"Hospital"
 ;W ?14,$$C($G(APCLAGEG("H","H","6-23m")),0,7)
 ;W ?22,$$C($G(APCLAGEG("H","H","24-59m")),0,7)
 ;W ?30,$$C($G(APCLAGEG("H","H","60m-18y")),0,7)
 ;W ?38,$$C($G(APCLAGEG("H","H","19-24y")),0,7)
 ;W ?46,$$C($G(APCLAGEG("H","H","25-49y")),0,7)
 ;W ?54,$$C($G(APCLAGEG("H","H","50-64y")),0,7)
 ;W ?62,$$C($G(APCLAGEG("H","H","65+y")),0,7)
 ;W ?72,$$C($G(APCLAGEG("H","H","TOTAL")),0,7),!
 ;W "H1N1 DXS",!
 ;W $$REPEAT^XLFSTR("-",79),!
 Q
VACAGEP ;EP
 D HEADER^APCLSILR
 W "TABLE 5:  Seasonal Flu Immunizations by Age by Visit"
 W !,"This table displays a count for immunizations by age group.  Only visits on"
 W !,"which a Seasonal Flu immunization was dispensed are counted.  The "
 W !,"definition of the immunizations are:"
 W !," - Seasonal Flu:  Immunization CVX codes 15, 16, 88, 111, 135, 140, 141, 144"
 W !,"                  CPT 90654-90662, 90724, G0008, G8108"
 W !,"                  Procedure 99.52, Diagnoses V04.8, V04.81, V06.6"
 I APCLLOCT="O" G LOCAGE
 W !!,"ALL FACILITIES"
 W !!,"Age",?14," 6-23m",?22,"24-59m",?30,"60m-18y",?38,"19-24y",?46,"25-49y",?54,"50-64y",?62,"  65+y",?72,"TOTAL",!
 W !,"Seasonal"
 W ?14,$$C($G(APCLIMMG("I","A","6-23m")),0,7)
 W ?22,$$C($G(APCLIMMG("I","A","24-59m")),0,7)
 W ?30,$$C($G(APCLIMMG("I","A","60m-18y")),0,7)
 W ?38,$$C($G(APCLIMMG("I","A","19-24y")),0,7)
 W ?46,$$C($G(APCLIMMG("I","A","25-49y")),0,7)
 W ?54,$$C($G(APCLIMMG("I","A","50-64y")),0,7)
 W ?62,$$C($G(APCLIMMG("I","A","65+y")),0,7)
 W ?72,$$C($G(APCLIMMG("I","A","TOTAL")),0,7),!
 W "Flu",!
 W $$REPEAT^XLFSTR("-",79),!
 ;W !,"H1N1"
 ;W ?14,$$C($G(APCLIMMG("H","A","6-23m")),0,7)
 ;W ?22,$$C($G(APCLIMMG("H","A","24-59m")),0,7)
 ;W ?30,$$C($G(APCLIMMG("H","A","60m-18y")),0,7)
 ;W ?38,$$C($G(APCLIMMG("H","A","19-24y")),0,7)
 ;W ?46,$$C($G(APCLIMMG("H","A","25-49y")),0,7)
 ;W ?54,$$C($G(APCLIMMG("H","A","50-64y")),0,7)
 ;W ?62,$$C($G(APCLIMMG("H","A","65+y")),0,7)
 ;W ?72,$$C($G(APCLIMMG("H","A","TOTAL")),0,7),!
 ;W $$REPEAT^XLFSTR("-",79),!
LOCAGE W !
 S APCLLOC="" F  S APCLLOC=$O(APCLIMML(APCLLOC)) Q:APCLLOC=""!($D(APCLQUIT))  D
 .I $Y>(IOSL-14) D HEADER^APCLSILR
 .W !!,APCLLOC
 .W !!,"Age",?14," 6-23m",?22,"24-59m",?30,"60m-18y",?38,"19-24y",?46,"25-49y",?54,"50-64y",?62,"  65+y",?72,"TOTAL",!
 .W !,"Seasonal"
 .W ?14,$$C($G(APCLIMML(APCLLOC,"I","A","6-23m")),0,7)
 .W ?22,$$C($G(APCLIMML(APCLLOC,"I","A","24-59m")),0,7)
 .W ?30,$$C($G(APCLIMML(APCLLOC,"I","A","60m-18y")),0,7)
 .W ?38,$$C($G(APCLIMML(APCLLOC,"I","A","19-24y")),0,7)
 .W ?46,$$C($G(APCLIMML(APCLLOC,"I","A","25-49y")),0,7)
 .W ?54,$$C($G(APCLIMML(APCLLOC,"I","A","50-64y")),0,7)
 .W ?62,$$C($G(APCLIMML(APCLLOC,"I","A","65+y")),0,7)
 .W ?72,$$C($G(APCLIMML(APCLLOC,"I","A","TOTAL")),0,7),!
 .W "Flu",!
 .W $$REPEAT^XLFSTR("-",79),!
 .;W !,"H1N1"
 .;W ?14,$$C($G(APCLIMML(APCLLOC,"H","A","6-23m")),0,7)
 .;W ?22,$$C($G(APCLIMML(APCLLOC,"H","A","24-59m")),0,7)
 .;W ?30,$$C($G(APCLIMML(APCLLOC,"H","A","60m-18y")),0,7)
 .;W ?38,$$C($G(APCLIMML(APCLLOC,"H","A","19-24y")),0,7)
 .;W ?46,$$C($G(APCLIMML(APCLLOC,"H","A","25-49y")),0,7)
 .;W ?54,$$C($G(APCLIMML(APCLLOC,"H","A","50-64y")),0,7)
 .;W ?62,$$C($G(APCLIMML(APCLLOC,"H","A","65+y")),0,7)
 .;W ?72,$$C($G(APCLIMML(APCLLOC,"H","A","TOTAL")),0,7),!
 .;W $$REPEAT^XLFSTR("-",79),!
 Q
TAB7 ;EP - WRITE OUT TABLE 5
 D HEADER^APCLSILR
 W "TABLE 7:  Potential Adverse Events"
 W !!,"This table contains a tally of all patients who were seen for a"
 W !,"diagnosis that may be considered to be an adverse event.  Adverse"
 W !,"Event diagnoses are:"
 W !,"ITP: 287.31"
 W !,"2nd TP: 287.4"
 W !,"TP: 287.5"
 W !,"Bells Palsy: 351.0"
 W !,"GBS: 357.0"
 W !,"Febrile Seizures Simple: 780.31 < 5 yrs"
 W !,"Febrile Seizures Complex: 780.32 < 5 yrs"
 I $Y>(IOSL-16) D HEADER^APCLSILR Q:$D(APCLQUIT)
 D TAB7SUB
 W !,$$REPEAT^XLFSTR("-",79)
 W !
 I '$D(APCLTAB7) W !!,"There were no visits for adverse events during the time period.",!! Q
 F X="ITP: 287.31","2nd TP: 287.4","TP: 287.5","Bells Palsy: 351.0","GBS: 357.0","Febrile Seizures Simple: 780.31 < 5 yrs","Febrile Seizures Complex: 780.32 < 5 yrs" D
 .I '$D(APCLTAB7(X,1)) S APCLTAB7(X,1)=0
 .I '$D(APCLTAB7(X,0)) S APCLTAB7(X,0)=0
 F APCLX="ITP: 287.31","2nd TP: 287.4","TP: 287.5","Bells Palsy: 351.0","GBS: 357.0","Febrile Seizures Simple: 780.31 < 5 yrs","Febrile Seizures Complex: 780.32 < 5 yrs" Q:$D(APCLQUIT)  D
 .I $L(APCLX)<25 W APCLX
 .I $L(APCLX)>24 W $P(APCLX,":",1),!,$P(APCLX,":",2)
 .W ?26,$$C($G(APCLTAB7(APCLX,1)),0,7),?46,$$C($G(APCLTAB7(APCLX,0)),0,7)
 .W ?66,$$C(($G(APCLTAB7(APCLX,0))+$G(APCLTAB7(APCLX,1))),0,7),!
 .W $$REPEAT^XLFSTR("-",79),!
 .Q
 Q:$D(APCLQUIT)
 ;write footer
 I $Y>(IOSL-6) D HEADER^APCLSILR Q:$D(APCLQUIT)
 W !!,"Note:  Follow up investigation is needed to determine if the adverse event"
 W !,"could be associated with vaccine adverse events that may be a result of"
 W !,"vaccination should be reported to the Vaccine Adverse Event Reporting"
 W !,"System (VAERS)."
 W !
 Q
TAB7SUB ;
 W !!,"TABLE 7:  Potential Adverse Events"
 W !,"Potential Adverse",?26,"Seasonal flu",?46,"No seasonal flu",?66,"Total # of"
 W !,"Events",?26,"vaccine in the ",?46,"vaccine in the",?66,"Adverse Events"
 W !?26,"60 days prior to",?46,"60 days prior to"
 W !?26,"adverse event",?46,"adverse event"
 W !,$$REPEAT^XLFSTR("-",79)
 W !
 Q
TAB8 ;EP - WRITE OUT TABLE 8
 D HEADER^APCLSILR
 W "TABLE 8:  Potential Adverse Events from live virus seasonal Flu vaccine"
 W !!,"This table contains a tally of all patients who were seen for a"
 W !,"diagnosis that may be considered to be an adverse event after"
 W !,"receiving the Seasonal Flu Live Virus vaccine."
 W !,"The adverse event diagnoses are:"
 W !?5,"Asthma (ICD Codes): 493.0*, 493.9*"
 W !?5,"Wheezing (ICD Codes): 786.07"
 W !?5,"Influenza (ICD Codes): 488.1 (H1N1)"
 W !
 I $Y>(IOSL-16) D HEADER^APCLSILR Q:$D(APCLQUIT)
 W !,"Potential Adverse",?26,"Live virus vaccine",?46,"No Live virus",?66,"Total # of"
 W !,"Events",?26,"(CVX code 111) 14",?46,"vaccine (CVX code",?66,"Adverse Events"
 W !?26,"days prior to",?46,"111) 14 days prior"
 W !?26,"adverse event",?46,"to adverse event"
 W !
 W !,$$REPEAT^XLFSTR("-",79)
 W !
 I '$D(APCLTAB8) W !!,"There were no visits for adverse events during the time period.",!! Q
 F X="Asthma","Wheezing","Influenza" D
 .I '$D(APCLTAB8(X,1)) S APCLTAB8(X,1)=0
 .I '$D(APCLTAB8(X,0)) S APCLTAB8(X,0)=0
 S APCLX="" F  S APCLX=$O(APCLTAB8(APCLX)) Q:APCLX=""!($D(APCLQUIT))  D
 .W APCLX,?26,$$C($G(APCLTAB8(APCLX,1)),0,7),?46,$$C($G(APCLTAB8(APCLX,0)),0,7)
 .W ?66,$$C(($G(APCLTAB8(APCLX,1))+$G(APCLTAB8(APCLX,0))),0,7),!
 .W $$REPEAT^XLFSTR("-",79),!
 .Q
 Q:$D(APCLQUIT)
 ;write footer
 I $Y>(IOSL-6) D HEADER^APCLSILR Q:$D(APCLQUIT)
 W !!,"Note:  Follow up investigation is needed to determine if the adverse event"
 W !,"could be associated with vaccine adverse events that may be a result of"
 W !,"vaccination should be reported to the Vaccine Adverse Event Reporting"
 W !,"System (VAERS)."
 W !
 Q
TAB8SUB ;
 W "TABLE 8:  Potential Adverse Events Related to H1N1 Live Virus"
 W !,"Adverse",?40,"Patients who received"
 W !,"Events",?40,"H1N1 Live"
 W !?40,"Nasal Vaccine"
 W !,$$REPEAT^XLFSTR("-",79)
 W !
 Q
TAB9 ;EP - WRITE OUT TABLE 7
 Q  ;table 9 taken out in patch 27
 D HEADER^APCLSILR
 W "TABLE 9:  Adverse Events without an ILI / H1N1 vaccination"
 W !!,"This table contains a tally of all patient visits during the time"
 W !,"period ",$$FMTE^XLFDT(APCLBD)," to ",$$FMTE^XLFDT(APCLED)
 W !,"where a potential ILI or H1N1 adverse event is diagnosed for a "
 W !,"patient that does not have a documented H1N1 or ILI vaccination. "
 W !,"These adverse events diagnoses are:"
 W !?5,"Thrombocytopenia (ICD Codes): 287.31; 287.4; 287.5"
 W !?5,"Encephalitis/Myelitis (ICD Codes): 323.5; 323.51; 323.52; 323.6; 323.61;"
 W !?10,"323.62; 323.63; 323.8; 323.81; 323.82; 323.9; 341.2"
 W !?10,"Neuritis (ICD Codes): 351.0; 357.0; specifically Bell's palsy,"
 W !?10,"Guillain-Barre' syndrome, postinfectious polyneuritis"
 W !?5,"Optic Neuritis (ICD Codes):  377.30; 377.31; 377.32; 377.39"
 W !?5,"Anaphylactic Shock (ICD Codes): 995.0; 999.4"
 W !?5,"Other diagnosis in the SURVEILLANCE ADV EV NO H1N1 taxonomy: 798*; 674.90;"
 W !?10,"674.92; 674.94;"
 W !,"When finding the date of the most recent H1N1 vaccine, the search starts"
 W !,"on the 1st of June prior to the end date selected by the user.  If the"
 W !,"patient does not have a documented H1N1 vaccine after June 1 it is "
 W !,"assumed that they did not have a vaccination this 'flu season'."
 I $Y>(IOSL-16) D HEADER^APCLSILR Q:$D(APCLQUIT)
 W !,"Diagnosis or",?40,"No ILI or H1N1 Vaccination"
 W !,"Conditions",?40,"# visits"
 W !,$$REPEAT^XLFSTR("-",79)
 W !
 F X="Thrombocytopenia","Anaphylactic Shock","Sudden Death","Optic Neuritis","Encephalitis/Myelitis" D
 .I '$D(APCLTAB9(X)) S APCLTAB9(X)=0
 S APCLX="" F  S APCLX=$O(APCLTAB9(APCLX)) Q:APCLX=""!($D(APCLQUIT))  D
 .W APCLX,?40,$$C($G(APCLTAB9(APCLX)),0,7),!,!
 .W $$REPEAT^XLFSTR("-",79),!
 .Q
 Q
TAB9SUB ;
 W "TABLE 9:  Adverse Events without an ILI / H1N1 vaccination"
 W !,"Diagnosis or",?40,"No ILI or H1N1 Vaccination"
 W !,"Conditions",?40,"# visits"
 W !,$$REPEAT^XLFSTR("-",79)
 W !
 Q
