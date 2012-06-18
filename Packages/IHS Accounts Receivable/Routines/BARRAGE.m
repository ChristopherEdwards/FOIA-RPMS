BARRAGE ; IHS/SD/LSL - AGING RPT - AGE FEB 4,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
START ; EP
 ; Aging reports -Menu option RPT-Reports menu AGE-Aging Report
 ;
 S BAR("SITE")=$P(^DIC(4,DUZ(2),0),"^",1)
 S DIR(0)="S^F:FACILITY;I:INSURER;C:CLINIC;P:PATIENT"
 D ^DIR
 G:Y<0!($D(DUOUT))!($D(DTOUT)) END
 S BAR("SELECTION")=Y(0)
 S BARS=$S(Y(0)="FACILITY":"FAC",Y(0)="INSURER":"INS",Y(0)="PATIENT":"PAT",Y(0)="CLINIC":"CLIN",1:"END")
 D @BARS
 G:$D(BAR("QFLG")) END
 W !!,$$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")," Output is 132 columns.",!
 D AGE
 D PRINT
 ;
END ;
 K BAR,BARS,BARBRZ
 Q
 ; *********************************************************************
 ;
PRINT ;
 ; Print
 K DIC
 ;
S ;
 S DIC="90050.01"
 S L=0
 ;
PRINT2 ; EP
 S HDR="@"
 D EN1^DIP
 D ^%ZISC,HOME^%ZIS
 Q
 ; *********************************************************************
 ;
AGE ;
 ; Age
 S DHD="[BAR AGE HDR]"
 I $G(FR)="" S FR="@",BAR("CNAME")="ALL"
 I $G(TO)="" S TO="zzzzzzzz"
 S FLDS="[BAR AGE PRNT]"
 Q
 ; *********************************************************************
 ;
FAC ;
 ; Single Facility print
 S BY="[BAR AGE FAC SRT]"
 K DIC
 S DIC("A")="Select Facility or press <RETURN> for all Facilities: "
 S DIC="90052.05"
 S DIC(0)="AEMQZ"
 D ^DIC
 I ($D(DUOUT))!($D(DTOUT)) S BAR("QFLG")=1
 I Y<0 Q
 S BAR("CNAME")=Y(0,0)
 S FR=BAR("CNAME")
 S TO=BAR("CNAME")
 Q
 ; *********************************************************************
 ;
INS ;
 ;Single Insurer print
 S BY="[BAR AGE SRT]"
 K DIC
 S DIC("A")="Select Insurer or press <RETURN> for all Insurers: "
 S DIC="90050.02"
 S DIC(0)="AEMQZ"
 S DIC("S")="I $P(^(0),U)[""AUT"",$P(^(0),U,10)=$$VALI^XBDIQ1(200,DUZ,29)"
 D ^DIC
 I ($D(DUOUT))!($D(DTOUT)) S BAR("QFLG")=1
 I Y<0 Q
 S BAR("CNAME")=Y(0,0)
 S FR=BAR("CNAME")
 S TO=BAR("CNAME")
 Q
 ; *********************************************************************
 ;
CLIN ;
 ; Single Clinic print
 S BY="[BAR AGE CLIN SRT]"
 K DIC
 S DIC("A")="Select Clinic or press <RETURN> for all Clinics: "
 S DIC="40.7"
 S DIC(0)="AEMQZ"
 D ^DIC
 I ($D(DUOUT))!($D(DTOUT)) S BAR("QFLG")=1
 I Y<0 Q
 S BAR("CNAME")=Y(0,0)
 S FR=BAR("CNAME")
 S TO=BAR("CNAME")
 Q
 ; *********************************************************************
 ;
PAT ;
 ; Single Patient print
 S BY="[BAR AGE PAT SRT]"
 K DIC
 ; use dfn in specifying patient (block of lines)
 S DIC("A")="Select Patient or press <RETURN> for all Patients: "
 S DIC="^AUPNPAT("
 S DIC(0)="AEQMZI"
 D ^DIC
 I ($D(DUOUT))!($D(DTOUT)) S BAR("QFLG")=1
 I Y<0 Q
 S DFN=+Y
 S BAR("CNAME")=Y(0,0)
 S FR=DFN
 S TO=DFN
 ; 'end' use dfn in specifying patient
 Q
 ; *********************************************************************
 ;
XBLM ;
 S Y=$$DIR^XBDIR("S^P:PRINT Output;B:BROWSE Output on Screen","Do you wish to ","P","","","",1)
 K DA
 Q:$D(DIRUT)
 I Y'="B" Q
 S BARBRZ=1
 S XBFLD("BROWSE")=1
 D VIEWD^XBLM("EN1^DIP")
 D FULL^VALM1
 W $$EN^BARVDF("IOF")
 D CLEAR^VALM1 ;clears out all list man stuff
 K XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF
 K VALMCON,VALMDN,VALMEVL,VALMIOXY,VALMKEY,VALMLFT,VALMLST,VALMMENU
 K VALMSGR,VALMUP,VALMWD,VALMY,XQORS,XQORSPEW,VALMCOFF
XBLME ;
 Q
