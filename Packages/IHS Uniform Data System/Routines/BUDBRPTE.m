BUDBRPTE ; IHS/CMI/LAB - UDS REPORT PROCESSOR 03 Feb 2014 1:15 PM ; 23 Jan 2014  10:19 AM
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;
 ;
PROC ;EP - called from xbdbque
 S BUDJ=$J,BUDH=$H
 K ^TMP($J)
 S ^XTMP("BUDBRPT1",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"UDS REPORT"
 S ^XTMP("BUDBRP6B",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^UDS TABLE 6B LISTS"
 S ^XTMP("BUDBRP7",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^BUD TABLE 7 LISTS"
 S ^XTMP("BUDARP9DEL",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^BUD TABLE 9 DELIMINTED FILE"
 ;TABLE 3A
 K BUDTOT F X=1:1:39 S $P(BUDTOT("M"),U,X)=0,$P(BUDTOT("F"),U,X)=0,$P(BUDTOT("ALL"),U,X)=0,BUDTOT("U")=0  ;3A
 S BUD019("M")="",BUD019("F")="",BUD019("ALL")=""
 ;TABLE 5
 F X=1:1:6 S BUDTAB5(X)="0^0"
 F X=7:1:38 S BUDTAB5(X)="0^0"
 F X="9A","9B","20A","20A1","20A2","20B","20C","22A","22B","22C","22D","29A","10A","27a","27b","30A","30B","30C" S BUDTAB5(X)="0^0"
 ;TABLE 3B
 K BUDRACET
 ;S BUDRACET(LINE)=LINE NUMBER^LABEL^HISP/LATINO^NOT HISPANIC^UNREP^TOTAL^LINE LABEL 2^LINE LABEL 3"
 S BUDRACET(1)="1.^Asian^0^0^0^0"
 S BUDRACET("2A")="2a.^Native Hawaiian^0^0^0^0"
 S BUDRACET("2B")="2b.^Other Pacific^0^0^0^0^Islander"
 S BUDRACET(2)="2.^Total Hawaiian/^0^0^0^0^Pacific Islander^(Sum Lines 2a+2b)"
 S BUDRACET(3)="3.^Black/African^0^0^0^0^American"
 S BUDRACET(4)="4.^American Indian/^0^0^0^0^Alaska Native"
 S BUDRACET(5)="5.^White^0^0^0^0"
 S BUDRACET(6)="6.^More than one^0^0^0^0^race"
 S BUDRACET(7)="7.^Unreported/^0^0^0^0^Refused to Report"
 S BUDRACET(8)="8.^Total Patients^0^0^0^0^(Sum Lines 1+2^+ 3 to 7)"
 K BUDLANG
 S BUDLANG(9)="9.^Patients Best Served in a Language Other Than^0^English"
 ;TABLE 6
 F X=1:1:26 S $P(BUDT6("V"),U,X)=0,$P(BUDT6("P"),U,X)=0
 ;TABLE 4
 K BUDT4V
 F X=1:1:6 S BUDT4V(X)=0
 F X=7,"8a","8b",8,9,"10a","10b",10,11,12 S BUDT4V(X)="0^0"
 F X=14:1:26 S BUDT4V(X)=0
 ;TABLE 9 DELIMITED
 S BUDT9C=0
 ;TABLE 9D
 K BUDT9TC
 F X=1,"2a","2b",3,4,"5a","5b",6,7,"8a","8b",9,10,"11a","11b",12,13,14 S BUDT9(X)="0^0"  ;COLUMN A & B
 Q
