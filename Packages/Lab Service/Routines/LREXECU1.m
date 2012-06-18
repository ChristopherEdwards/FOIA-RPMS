LREXECU1 ; IHS/DIR/FJE - EXECTUE CODE UTILITY 1 3/31/88 3:54 PM ; [ 07/30/2002  11:01 AM ]
 ;;5.2;LR;**1013**;JUL 15, 2002
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 ;
VIRAL ;ANMC-IHS/RGG;VIRAL SERUM TITER SAMPLE;JAN 31,1992
 K DIR S DIR(0)="SBO^A:ACUTE;C:CONVALESCENT" S DIR("T")=300
 S DIR("A")="Is the sample ACUTE or CONVALESCENT"
 S DIR("?",1)="YOU MUST ANSWER THIS QUESTION!"
 S DIR("?")="Just enter a 'A' or 'C'." D ^DIR
 I X["^"!(X="") W *7,!,"YOU MUST ANSWER THIS QUESTION!" G VIRAL
 I Y="A" W !!,"   Hold sample in freezer and submit to Reference Lab" W !,"    with the Convalescent sample."  S X="ACUTE"
 I Y="C" W !!,"   Submit this sample to the Reference Lab with the" W !,"    previous sample being held in the freezer." S X="CONVALESCENT"
 S LRCCOM="~SAMPLE IS EXPECTED TO BE "_X_"." D RCS^LRORD2,RCS^LRXO9
 R !!,"ADDITIONAL COMMENT: ",LRCCOM:DTIME Q
 Q
HEP ;ANMC-IHS/RGG;HEPATITIS INTERPETATIONS;MARCH 16,1992
 S VAR=$CHAR(10,13) S LRCCOM="~"_VAR
 F INDEX=1:1:4 S LRCCOM=LRCCOM_$P($TEXT(OPTIONS+INDEX),";",3)_VAR
 D LOADCCOM
 S LRCCOM="~"_VAR
 F INDEX=5:1:8 S LRCCOM=LRCCOM_$P($TEXT(OPTIONS+INDEX),";",3)_VAR
 D LOADCCOM
 S LRCCOM="~"_VAR
 F INDEX=9:1:10 S LRCCOM=LRCCOM_$P($TEXT(OPTIONS+INDEX),";",3)_VAR
 D LOADCCOM
 S LRCCOM="~"_VAR
 F INDEX=11:1:14 S LRCCOM=LRCCOM_$P($TEXT(OPTIONS+INDEX),";",3)_VAR
 D LOADCCOM
 S LRCCOM="~"_VAR
 F INDEX=15:1:16 S LRCCOM=LRCCOM_$P($TEXT(OPTIONS+INDEX),";",3)_VAR
 D RCS^LRORD2,RCS^LRXO9
ADDCCOM ;
 R !,"ADDITIONAL COMMENTS: ",LRCCOM:DTIME Q
LOADCCOM ;
 D RCS^LRORD2,RCS^LRXO9
 Q
LDL ;ANMC-IHS/RGG ; ROUTINE TO CALCULATE THE LDL ; 12/7/92
 Q:'$D(LRSB(80))!'$D(LRSB(12))!'$D(LRSB(47))
 I (LRSB(12)["c")!(LRSB(47)["c")!(LRSB(80)["c")!(LRSB(80)["p")!($P(LRSB(47),"^")>400) W !,"UNABLE TO CALCULATE LDL, DUE TO ELEVATED TRIG OR LACK OF DATA." S LRSB(292)="canc" D CHOLHDL G ENDLDL
 I $D(LRSB(12)),$D(LRSB(47)),$D(LRSB(80)) S LRCHOL=$P(LRSB(12),"^"),LRTRIG=$P(LRSB(47),"^"),LRHDL=$P(LRSB(80),"^"),LRSB(292)=LRCHOL-LRHDL-(LRTRIG/5),LRSB(293)=$J(LRCHOL/LRHDL,0,1)
 G ENDLDL
CHOLHDL S LRCHOL=$P(LRSB(12),"^"),LRHDL=$P(LRSB(80),"^")
 I (LRCHOL!LRHDL'?.N)!(LRHDL=0) S LRSB(293)="canc" W !!,"UNABLE TO CALCULATE RATIO DUE TO LACK OF DATA" Q  ;IHS/ANMC/RPM 09/23/93
 I (LRHDL'?.N)!(LRHDL=0) S LRSB(293)="canc" Q
 S LRSB(293)=$J(LRCHOL/LRHDL,0,1)
 Q
ENDLDL K LRCHOL,LRHDL,LRTRIG
 Q
CHLAMYDI ;ANMC-IHS/RGG ; NON STANDARD COLLECTION SPECIMEN ; 10/15/92
 S LRCCOM="~Effective 9/4/92 this test has been FDA cleared for endocervical,male urethral and conjunctival swab specimens only. Results from other sites may not be accurate." D RCS^LRORD2,RCS^LRXO9
 R !,"ADDITIONAL COMMENTS: ",LRCCOM:DTIME Q
 Q
OPTIONS ;
 ;;INTERPETATIONS                 HAIgG HAIgM HBsAg HBsAb HBcAb HBeAg HBeAb HDAb
 ;;Past history of HAV infection     +     -
 ;;Recent or current HAV infection   +     +
 ;;No prior HBV exposure                                    -
 ;;Immune via vaccine, no exposure              -     +     -
 ;;Immune prior infection                       -     +     +
 ;;Convalescense window, ?immunity,
 ;;? carrier, ?false positive                   -     -     +
 ;;Early infection or false positive            +     -     -     -     -
 ;;Acute or chronic HBV                         +     -     +     -     -
 ;;Acute HBV, or chronic infection
 ;;very infectious!                             +     -     +     +     -
 ;;Early recovery, acute or chronic
 ;;infection                                    +     +     +     -   (+/-)
 ;;Positive for Delta Ab, may or
 ;;Co-infection w/ Delta & HBV                  +   (+/-)   +   (+/-) (+/-)   +
HIVRISK ;ANMC-IHS/RGG;HIV RISK PROMPT;4/11/92
 K DIR S DIR(0)="NA^1:31" S DIR("T")=300
 S DIR("A")="HIV RISK CATEGORY (1-31):"
 S DIR("?",1)="01-PHYSICIAN                          16-PROSTITUTE"
 S DIR("?",2)="02-NURSES                             17-CONTACT:BISEXUAL"
 S DIR("?",3)="03-DENTIST                            18-CONTACT:IV DRUG USER"
 S DIR("?",4)="04-DENTAL HYGIENTIST                  19-CONTACT:PROSTITUTE"
 S DIR("?",5)="05-HOUSEHOLD CONTACT/KNOWN CARRIER    20-BLOOD DONOR"
 S DIR("?",6)="06-INMATE/CORRECTIONAL FACILITY       21-HISTORY OF RECENT TRANSFUSION"
 S DIR("?",7)="07-HOMOSEXUAL                         22-HEMOPHILIAC"
 S DIR("?",8)="08-PATIENT/INST.MENTALLY RETARDED     23-PREVIOUS HB SURFACE ANTIGEN POS"
 S DIR("?",9)="09-STAFF/INST.MENTALLY RETARDED       24-PREVIOUS HB CORE ANTIBODY POS"
 S DIR("?",10)="10-HOSP.STAFF (NOT MD OR NURSE)       25-PAST HISTORY OF HEPATITIS"
 S DIR("?",11)="11-INFANT BORN TO CARRIER MOTHER      26-IMMUNIZED:HBs ANTIBODY CHECK"
 S DIR("?",12)="12-INJECTABLE DRUG USER               27-FREQUENT HETEROSEXUAL PARTNERS"
 S DIR("?",13)="13-OTHER (SPECIFY IN REMARKS)         28-HEPATITIS CASE"
 S DIR("?",14)="14-PRENATAL SCREEN                    29-PREVIOUS HTLV III POSITIVE"
 S DIR("?",15)="15-BISEXUAL                           31-SEXUAL CONTACT:KNOWN HIV (+)"
 S DIR("?")="30-STATE PUBLIC HEALTH LABORATORY - FAIRBANKS QUALITY CONTROL TESTS"
 D ^DIR
 I X["^"!(X="") W *7,!,"You MUST Supply a HIV RISK Category!" G HIVRISK
 S:$S($D(LRCOM(LRSAMP,LRSPEC,1)):$S(LRCOM(LRSAMP,LRSPEC,1)["~For Test:":1,1:0),1:0) LRCOM(LRSAMP,LRSPEC)=0
 S RISKCOM="HIV RISK CATEGORY IS "_X
 R !,"ADDITIONAL REMARKS: ",REMCOM:DTIME
 S LRCCOM=RISKCOM_"     "_REMCOM
 Q
