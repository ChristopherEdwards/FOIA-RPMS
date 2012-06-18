BIREPL2 ;IHS/CMI/MWR - REPORT, ADULT IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW ADULT IMMUNIZATION REPORT, GATHER DATA.
 ;
 ;
 ;----------
HEAD(BIQDT,BICC,BIHCF,BIBEN,BICPTI,BIUP) ;EP
 ;---> Produce Header array for ADULT Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BIBEN  (req) Beneficiary Type array.
 ;     5 - BICPTI (req) 1=Include CPT Coded Visits, 0=Ignore CPT
 ;     6 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 ;---> Check for required Variables.
 Q:'$G(BIQDT)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BIBEN)
 I '$D(BICPTI) S BICPTI=0
 Q:'$D(BIUP)
 ;
 K VALMHDR
 N BILINE,X S BILINE=0
 ;
 N X S X=""
 ;---> If Header array is NOT being for Listmananger include version.
 S:'$D(VALM("BM")) X=$$LMVER^BILOGO()
 ;
 D WH^BIW(.BILINE,X)
 S X=$$REPHDR^BIUTL6(DUZ(2)) D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X="*  Adult Immunization Report  *" D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(27)_"Report Date: "_$$SLDT1^BIUTL5(DT)
 D WH^BIW(.BILINE,X)
 ;
 S X=$$SP^BIUTL5(28)_"Date Range: "_$$SLDT1^BIUTL5(BIQDT-10000)_" - "_$$SLDT1^BIUTL5(BIQDT)
 D WH^BIW(.BILINE,X,1)
 ;
 S X=" "_$$BIUPTX^BIUTL6(BIUP)
 I BICPTI S X=$$PAD^BIUTL5(X,52)_"* CPT Coded Visits Included"
 D WH^BIW(.BILINE,X)
 D WH^BIW(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 D
 .;---> If specific Communities were selected (not ALL), then print
 .;---> the Communities in a subheader at the top of the report.
 .D SUBH^BIOUTPT5("BICC","Community",,"^AUTTCOM(",.BILINE,.BIERR,,13)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Health Care Facilities, print subheader.
 .D SUBH^BIOUTPT5("BIHCF","Facility",,"^DIC(4,",.BILINE,.BIERR,,13)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .;---> If specific Beneficiary Types, print Beneficiary Type subheader.
 .D SUBH^BIOUTPT5("BIBEN","Beneficiary Type",,"^AUTTBEN(",.BILINE,.BIERR,,13)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,.X) D WH^BIW(.BILINE,X) Q
 .;
 .S X=$$SP^BIUTL5(59)_"Number   Percent"
 .D WH^BIW(.BILINE,X)
 ;
 ;---> If Header array is being built for Listmananger,
 ;---> reset display window margins for Communities, etc.
 D:$D(VALM("BM"))
 .S VALM("TM")=BILINE+3
 .S VALM("LINES")=VALM("BM")-VALM("TM")+1
 .;---> Safeguard to prevent divide/0 error.
 .S:VALM("LINES")<1 VALM("LINES")=1
 Q
 ;
 ;
 ;----------
START(BIQDT,BICC,BIHCF,BIBEN,BICPTI,BIUP) ;EP
 ;---> Produce array for ADULT Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BIBEN  (req) Beneficiary Type array.
 ;     5 - BICPTI (req) 1=Include CPT Coded Visits, 0=Ignore CPT (default).
 ;     6 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 N BILINE,BITMP,X S BILINE=0
 K ^TMP("BIREPL1",$J)
 ;
 ;---> Check for required Variables.
 ;---> Fix for v8.1 by adding .X to error calls below.
 I '$G(BIQDT) D ERRCD^BIUTL2(623,.X) D WRITE(.BILINE,X) Q
 I '$D(BICC) D ERRCD^BIUTL2(614,.X) D WRITE(.BILINE,X) Q
 I '$D(BIHCF) D ERRCD^BIUTL2(625,.X) D WRITE(.BILINE,X) Q
 I '$D(BIBEN) D ERRCD^BIUTL2(662,.X) D WRITE(.BILINE,X) Q
 I '$D(BICPTI) S BICPTI=0
 S:$G(BIUP)="" BIUP="u"
 ;
 D GETSTATS^BIREPL3(BIQDT,.BICC,.BIHCF,.BIBEN,BICPTI,BIUP,.BITOTS)
 D DISPLAY(BITOTS,.BILINE)
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
DISPLAY(BITOTS,BILINE) ;EP
 ;---> Write Adult Stats for display.
 ;---> Parameters:
 ;     1 - BITOTS (req) Totals delimited by "^":
 ;                      Pc   Variable
 ;                       1 - BI19=Total over 19
 ;                       2 - BIT19 = Number over 19 w/Tetanus past 10 years.
 ;                       3 - BITDAP = Number over 19 w/Tdap past 10 years.
 ;
 ;                       4 - BIHPVF  = Total number of Females age 19-26
 ;                       5 - BIHPVF1 = Number Females 19-26 w/HPV-1
 ;                       6 - BIHPVF2 = Number Females 19-26 w/HPV-2
 ;                       7 - BIHPVF3 = Number Females 19-26 w/HPV-3
 ;                       8 - BIHPVF  = Total number of Males age 19-26
 ;                       9 - BIHPVM1 = Number Males 19-26 w/HPV-1
 ;                      10 - BIHPVM2 = Number Males 19-26 w/HPV-2
 ;                      11 - BIHPVM3 = Number Males 19-26 w/HPV-3
 ;
 ;                      12 - BI60=Total over 60
 ;                      13 - BIZ60 = Number over 60 w/Zoster ever.
 ;                      14 - BI65=Total over 65
 ;                      15 - BIT65 = Number over 65 w/Tetanus past 10 years.
 ;                      16 - BIP65 = Number over 65 w/Pneumo at or after 65 years.
 ;                      17 - BIP65E = Number over 65 w/Pneumo EVER.
 ;
 ;
 ;     1 - BILINE (ret) Number of lines written to Listman scroll area.
 ;
 I $G(BITOTS)="" D ERRCD^BIUTL2(667,.X) D WRITE(.BILINE,X) Q
 ;
 ;---> Set totals into BIV local array, 1-15.
 N BIV,I F I=1:1:17 S BIV(I)=$P(BITOTS,U,I)
 ;
 S X=$$PAD("  Total Number of Patients over 19 years old",56)_": "
 S X=X_$$C(BIV(1),0,8) D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    TETANUS: # patients w/Td in past 10 years",56)
 S X=X_": "_$$C(BIV(2),0,8)
 I BIV(1) S X=X_$J((BIV(2)/BIV(1))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    TETANUS: # patients w/Tdap in past 10 years",56)
 S X=X_": "_$$C(BIV(3),0,8)
 I BIV(1) S X=X_$J((BIV(3)/BIV(1))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;---> Females (pcs 4-7).
 S X=$$PAD("    HPV: Total # Female patients age 19-26",56)
 S X=X_": "_$$C(BIV(4),0,8)
 I BIV(1) S X=X_$J((BIV(4)/BIV(1))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    HPV: # Female patients age 19-26 w/HPV1",56)
 S X=X_": "_$$C(BIV(5),0,8)
 I BIV(4) S X=X_$J((BIV(5)/BIV(4))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    HPV: # Female patients age 19-26 w/HPV2",56)
 S X=X_": "_$$C(BIV(6),0,8)
 I BIV(4) S X=X_$J((BIV(6)/BIV(4))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    HPV: # Female patients age 19-26 w/HPV3",56)
 S X=X_": "_$$C(BIV(7),0,8)
 I BIV(4) S X=X_$J((BIV(7)/BIV(4))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;---> Males (pcs 8-11).
 S X=$$PAD("    HPV: Total # Male patients age 19-26",56)
 S X=X_": "_$$C(BIV(8),0,8)
 I BIV(1) S X=X_$J((BIV(8)/BIV(1))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    HPV: # Male patients age 19-26 w/HPV1",56)
 S X=X_": "_$$C(BIV(9),0,8)
 I BIV(8) S X=X_$J((BIV(9)/BIV(8))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    HPV: # Male patients age 19-26 w/HPV2",56)
 S X=X_": "_$$C(BIV(10),0,8)
 I BIV(8) S X=X_$J((BIV(10)/BIV(8))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    HPV: # Male patients age 19-26 w/HPV3",56)
 S X=X_": "_$$C(BIV(11),0,8)
 I BIV(8) S X=X_$J((BIV(11)/BIV(8))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;---> Total patients over 60 & Zoster. (pcs 12-13).
 S X=$$PAD("  Total Number of Patients over 60 years old",56)
 S X=X_": "_$$C(BIV(12),0,8)
 I BIV(1) S X=X_$J((BIV(12)/BIV(1))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    ZOSTER: # patients w/Zostavax ever",56)
 S X=X_": "_$$C(BIV(13),0,8)
 I BIV(12) S X=X_$J((BIV(13)/BIV(12))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;
 ;---> Total patients over 65 (pcs 14-16).
 S X=$$PAD("  Total Number of Patients over 65 years old",56)
 S X=X_": "_$$C(BIV(14),0,8)
 I BIV(1) S X=X_$J((BIV(14)/BIV(1))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    TETANUS: # patients w/Td in past 10 years",56)
 S X=X_": "_$$C(BIV(15),0,8)
 I BIV(14) S X=X_$J((BIV(15)/BIV(14))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 ;S X=$$PAD("    INFLUENZA: # pts w/Influenza vaccine in past year",56)
 ;S X=X_": "_$$C(BIV(9),0,8)
 ;I BIV(7) S X=X_$J((BIV(9)/BIV(7))*100,7,1)
 ;D WRITE(.BILINE,X,1)
 ;
 S X=$$PAD("    PNEUMOVAX: # patients w/Pneumovax at or over 65 yrs",56)
 S X=X_": "_$$C(BIV(16),0,8)
 I BIV(14) S X=X_$J((BIV(16)/BIV(14))*100,7,1)
 D WRITE(.BILINE,X)
 ;
 S X=$$PAD("    PNEUMOVAX: # patients w/Pneumovax ever",56)
 S X=X_": "_$$C(BIV(17),0,8)
 I BIV(14) S X=X_$J((BIV(17)/BIV(14))*100,7,1)
 D WRITE(.BILINE,X,1)
 ;
 ;
 ;---> Now write total patients considered who had refusals.
 N M,N S (M,N)=0 F  S M=$O(BITMP("REFUSALS",M)) Q:'M  S N=N+1
 S X="  Total Patients included who had Refusals on record....:"_$J(N,8)
 D WRITE(.BILINE,X,1)
 ;
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPL1",$G(BIVAL),$G(BIBLNK))
 ;
 ;--->Set VALMCNT (Listman line count) for errors calls above.
 S VALMCNT=BILINE
 Q
 ;
 ;
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
 ;
 ;
 ;----------
PAD(D,L,C) ;EP
 Q $$PAD^BIUTL5($G(D),$G(L),".")
