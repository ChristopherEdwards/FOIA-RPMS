AGCMATCH ; IHS/ASDS/SDH-Patient Registration ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;This report is used for checking blank community, blank mailing
 ;address city, and it they don't match.  Also checks if these fields
 ;contain "unknown" anything.
 ;
 S AGALL=""
 S (AGCNT1,AGCNT2,AGCNT3)=0
 W !!,"WARNING:  "
 W !,"COMPLETE REPORT COULD BE LARGE DEPENDING ON THE SIZE OF YOUR FACILITY!!"
 W !,"It is recommended that Medical Records Staff print this report to a capture file on a PC, and not to a printer!"
 W !,"Please see the release notes for patch 13 and consult your Site Manager for assistance in printing to a capture file."
 S DIR(0)="S^C:COMPLETE(BLANKS, MISMATCHES, AND UNKNOWNS)"
 S DIR(0)=DIR(0)_";B:BLANKS ONLY"
 S DIR(0)=DIR(0)_";U:UNKNOWNS ONLY (ALSO INCLUDES ""OTH"")"
 S DIR(0)=DIR(0)_";A:BOTH BLANKS AND UNKNOWNS"
 S DIR("A")="WHICH REPORT WOULD YOU LIKE "
 S DIR("B")="B"
 D ^DIR K DIR
 Q:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)
 S AGALL=Y
 D ^%ZIS
 Q:POP
 S AGBM=IOSL-4
 U IO
 N AGADDR,AGMAIL,AGCNT
 S U="^"
 S AGNAME=""
 S AG1=""
 S AGFLAG1=""
 S AGPAGE=1
 F  S AG1=$O(^DPT("B",AG1)) Q:AG1=""!AGFLAG1  D
 .S AG2=0
 .F  S AG2=$O(^DPT("B",AG1,AG2)) Q:'AG2!AGFLAG1  D
 ..S AGWFLG=""
 ..S AGEFLG=0,AGERROR=0
 ..D AGCHECK                  ;checks if they have HRN
 ..I $D(HRN),HRN["T" Q        ;check if temp numbers are included
 ..I AGFLAG=0 Q
 ..S AGNAME=$P($G(^DPT(AG2,0)),U)
 ..I AGNAME'=AG1 Q                     ;makes sure names match
 ..S AGCOMM=$P($G(^AUPNPAT(AG2,11)),U,18)  ;current community
 ..S AGADDR=$P($G(^DPT(AG2,.11)),U,4)      ;mailing address city
 ..I AGALL="C" D                           ;if complete
 ...I AGCOMM=""!(AGADDR="")!(AGCOMM["UNK")!(AGCOMM["OTH")!(AGCOMM'=AGADDR) D  Q
 ....I AGCOMM'="",AGADDR'="",AGCOMM'=AGADDR S AGERROR=3,AGEFLG=1
 ....I AGCOMM=""!(AGADDR="") S AGERROR=1,AGEFLG=AGEFLG+1
 ....I AGCOMM["UNK"!(AGCOMM["OTH")!(AGADDR["UNK")!(AGADDR["OTH") S AGERROR=2,AGEFLG=AGEFLG+1
 ....I AGEFLG>1 D ERRCHK     ;if there is more than one error
 ....D SAVE
 ..I AGALL="B",((AGCOMM="")!(AGADDR="")) D  Q   ;blank
 ...S AGERROR=1
 ...D SAVE
 ..;if unknowns
 ..I AGALL="U",(AGCOMM["UNK"!(AGCOMM["OTH")!(AGADDR["UNK")!(AGADDR["OTH")) D  Q
 ...S AGERROR=2
 ...D SAVE
 ..;blanks&unknowns
 ..I AGALL="A" D
 ...I (AGCOMM="")!(AGADDR="")!(AGCOMM["UNK")!(AGCOMM["OTH")!(AGADDR["UNK")!(AGADDR["OTH") D  Q
 ....I AGCOMM=""!(AGADDR="") S AGERROR=1
 ....I AGCOMM["UNK"!(AGCOMM["OTH")!(AGADDR["UNK")!(AGADDR["OTH") S AGERROR=2
 ....D SAVE
 D WRITE
 D ^%ZISC
 K AGNAME,AG2,AGCOMM,AGADDR,AGFLAG1,AGPAGE,AGWFLG
 K AGCNT1,AGCNT2,AGCNT3,TOT
 Q
ERRCHK ;if more than one error sets priority error
 I AGADDR="" S AGERROR=1 Q
 I AGCOMM["UNK"!(AGCOMM["OTH")!(AGADDR["UNK")!(AGADDR["OTH") S AGERROR=2 Q
 I AGCOMM]"",AGADDR]"",AGCOMM'=AGADDR S AGERROR=3
 Q
SAVE ;
 I HRN="" S HRN="NO HRN"
 S AGINACT=$P($G(^AUPNPAT(AG2,41,AGDUZ2,0)),U,3)  ;inactive/deleted
 S AGDOD=$P($G(^DPT(AG2,.35)),U)                  ;date of death
 I $G(AGINACT)'=""!($G(AGDOD)'="") S AGADD="I"
 E  S AGADD="A"
 I AGCOMM="" S AGCOMM="AANONE"
 S ^AGTMP($J,AGERROR,AGCOMM,AGADD,AGNAME,HRN)=AGADDR
 I AGERROR=1 S AGCNT1=AGCNT1+1
 I AGERROR=2 S AGCNT2=AGCNT2+1
 I AGERROR=3 S AGCNT3=AGCNT3+1
 S AGWFLG=1
 Q
WRITE ;writes record to temp global if condition is met.  Also checks
 ;for active/inactive status of patient; checks for new page/header.
 ;
 D HDR
 S (AGER,AGHRN,AGNM,AGADD,AGCOM,AGADDR)=""
 F  S AGER=$O(^AGTMP($J,AGER)) Q:AGER=""!AGFLAG1  D
 .I AGER=1 W !,"BLANK CITY/COMMUNITY",!
 .I AGER=2 W !,"UNKNOWN/OTHER",!
 .I AGER=3 W !,"MISMATCHES",!
 .F  S AGCOM=$O(^AGTMP($J,AGER,AGCOM)) Q:AGCOM=""!AGFLAG1  D
 ..F  S AGADD=$O(^AGTMP($J,AGER,AGCOM,AGADD))  Q:AGADD=""!AGFLAG1  D
 ...F  S AGNM=$O(^AGTMP($J,AGER,AGCOM,AGADD,AGNM)) Q:AGNM=""!AGFLAG1  D
 ....F  S AGHRN=$O(^AGTMP($J,AGER,AGCOM,AGADD,AGNM,AGHRN))  Q:AGHRN=""!AGFLAG1  D
 .....S AGREC=$G(^AGTMP($J,AGER,AGCOM,AGADD,AGNM,AGHRN))
 .....S AGADDR=$P(AGREC,U)
 .....I AGCOM["AANONE" S AGCOMM=""
 .....E  S AGCOMM=AGCOM
 .....W ?3,AGNM
 .....W ?27,AGADD
 .....W ?31,AGHRN
 .....W ?40,AGADDR
 .....W ?60,AGCOMM
 .....W !
 .....I $Y>AGBM D
 ......D RTRN^AG
 ......I $D(DUOUT)!$D(DTOUT)!$D(DFOUT) S AGFLAG1=1 Q
 ......D HDR
 .I 'AGFLAG1 D
 ..F Z=1:1:80 W "-"
 ..W !
 W !!,"*** END OF REPORT ***",!!
 I IO["C" D
 .S DIR(0)="E"
 .S DIR("A")="ENTER RETURN TO CONTINUE"
 .D ^DIR
 K ^AGTMP($J)
 Q
HDR ;
 S TOT=0
 D NOW^%DTC
 D YX^%DTC
 S DATE=$P(Y,"@")
 W $$S^AGVDF("IOF")
 S X=DATE_"         COMMUNITY/CITY MISMATCH REPORT         Page "_AGPAGE
 D CTR^AG
 W !,X
 S X=$P(^AUTTLOC(DUZ(2),0),U,2)
 D CTR^AG
 W !,X
 I AGALL="C" S AGALL="BUM"
 I AGALL="A" S AGALL="BU"
 I AGPAGE=1 D
 .W !!,"This report contains "
 .I AGALL["B" D  ;blanks
 ..W !?10,"BLANKS",?20,$J(+$G(AGCNT1),10)
 ..S TOT=TOT+AGCNT1
 .I AGALL["U" D                                 ;unknowns
 ..W !?10,"UNKNOWNS",?20,$J(+$G(AGCNT2),10)
 ..S TOT=TOT+AGCNT2
 .I AGALL["M" D                                 ;mismatches
 ..W !?10,"MISMATCHES",?20,$J(+$G(AGCNT3),10)
 ..S TOT=TOT+AGCNT3
 .W !?10,"TOTAL:  ",?20,$J(TOT,10)
 W !!?3,"NAME",?26,"A/I",?31,"HRN",?40,"MAIL.ADDR-CITY",?60,"CURRENT COMM",!
 F AG=1:1:80 W "="
 W !
 S AGPAGE=AGPAGE+1
 Q
AGCHECK ;
 ;looks that they have an HRN
 S AGFLAG=0
 S AGDUZ2=0
 F  S AGDUZ2=$O(^AUPNPAT(AG2,41,AGDUZ2)) Q:AGDUZ2=""  D  Q:AGFLAG
 .I AGDUZ2=DUZ(2) S HRN=$P($G(^AUPNPAT(AG2,41,AGDUZ2,0)),U,2),AGFLAG=1 Q
 Q
