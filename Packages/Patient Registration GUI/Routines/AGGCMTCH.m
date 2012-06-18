AGGCMTCH ; VNGT/HS/KDC - COMMUNITY REPORT;  
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ; Copied from AGCMATCH
 ; 
 ;This report is used for checking blank community, blank mailing
 ;address city, and it they don't match.  Also checks if these fields
 ;contain "unknown" anything.
 ;
 ;
 Q
 ;
EN(DATA,TYPE,AGGDUZ2) ; EP -- AGG COMMUNITY REPORT
 ;Description
 ;  Generates AGG COMMUNITY REPORT
 ;
 ;Input
 ;  TYPE - Type of daily report
 ;
 ;Output
 ;  DATA - Name of global in which data is stored(^TMP("AGGCMTCH"))
 ;
 NEW UID,X,AGGI,HSTEXT,HSPATH,HSFN,Y,I,N,AGDOD,AGDUZ2
 NEW AG,AGB,AGE,AGIO,G,ZTDESC,ZTRTN,ZTSAVE,ZTSK,ZTUCI
 NEW AGGI,AGALL,AGCNT1,AGCNT2,AGCNT3,AG1,AGADD,AGCOM
 NEW AGEFLG,AGER,AGDUZ2,AGFLAG,AGHRN,AGINACT,AGNM,AGREC
 NEW AGERROR,HRN,IO
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGCMTCH",UID))
 K @DATA
 S AGGI=0
 D HDR
 I $G(TYPE)="" S TYPE="B"
 ;
 I $$TMPFL^AGGUL1("W",UID,"AGG"_$J) G DONE
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGCMTCH D UNWIND^%ZTER"
 S AGALL=""
 S (AGCNT1,AGCNT2,AGCNT3)=0
 S AGALL=TYPE
 ;S AGBM=IOSL-4
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
 D BGL
 K AGNAME,AG2,AGCOMM,AGADDR,AGFLAG1,AGPAGE,AGWFLG
 K AGCNT1,AGCNT2,AGCNT3,TOT
 Q
 ;
ERRCHK ;if more than one error sets priority error
 I AGADDR="" S AGERROR=1 Q
 I AGCOMM["UNK"!(AGCOMM["OTH")!(AGADDR["UNK")!(AGADDR["OTH") S AGERROR=2 Q
 I AGCOMM]"",AGADDR]"",AGCOMM'=AGADDR S AGERROR=3
 Q
 ;
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
 ;
WRITE ;writes record to temp global if condition is met.  Also checks
 ;for active/inactive status of patient; checks for new page/header.
 ;
 NEW Z
 D RHDR
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
 .I 'AGFLAG1 D
 ..F Z=1:1:80 W "-"
 ..W !
 W !!,"*** END OF REPORT ***",!!
 K ^AGTMP($J)
 Q
 ;
RHDR ;
 NEW DATE
 S TOT=0
 S DATE=$$UP^XLFSTR($$FMTE^XLFDT(DT))
 S X=DATE_"         COMMUNITY/CITY MISMATCH REPORT         Page "_AGPAGE
 D CTR^AG
 W !,X
 S X=$P(^AUTTLOC(AGGDUZ2,0),U,2)
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
 ;
AGCHECK ;
 ;looks that they have an HRN
 S AGFLAG=0
 S AGDUZ2=0
 F  S AGDUZ2=$O(^AUPNPAT(AG2,41,AGDUZ2)) Q:AGDUZ2=""  D  Q:AGFLAG
 .I AGDUZ2=AGGDUZ2 S HRN=$P($G(^AUPNPAT(AG2,41,AGDUZ2,0)),U,2),AGFLAG=1 Q
 Q
 ;
BGL ;
 U IO W $C(9)
 ;
 I $$TMPFL^AGGUL1("C") G DONE
 I $$TMPFL^AGGUL1("R",UID,"AGG"_$J) G DONE
 ;
 F  U IO R HSTEXT:.1 Q:HSTEXT[$C(9)  D
 . S HSTEXT=$$STRIP^XLFSTR(HSTEXT,"^")
 . I HSTEXT="" S HSTEXT=" "
 . S HSTEXT=$$CTRL^AGGUL1(HSTEXT)
 . ;S AGGI=AGGI+1,@DATA@(AGGI)=HSTEXT_$C(30)
 . S AGGI=AGGI+1,@DATA@(AGGI)=HSTEXT_$C(13)_$C(10)_$C(30)
 ;S AGGI=AGGI+1,@DATA@(AGGI)=$C(30)
 ;
 I $$TMPFL^AGGUL1("C") G DONE
 I $$TMPFL^AGGUL1("D",UID,"AGG"_$J) G DONE
 ;
DONE ;
 S AGGI=AGGI+1,@DATA@(AGGI)=$C(31)
 Q
 ;
HDR ;
 S @DATA@(AGGI)="T32000REPORT_TEXT"_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(AGGI),$D(DATA) S AGGI=AGGI+1,@DATA@(AGGI)=$C(31)
 I $$TMPFL^AGGUL1("C")
 Q
