BLRALRP ;DAOU/ALA-Lab Audit Reports [ 11/18/2002  1:37 PM ]
 ;;5.2;LR;**1013,1015**;NOV 18, 2002
 ;
 ;**Program Description**
 ;  These are reports to view information about the Lab Audit
 ;
OPT W !,"     Report Options"
 W !!," 1) By Date Range "
 W !," 2) By Single Date "
 W !," 3) By User "
 W !," 4) By Menu Option"
 W !," 5) QUIT"
 S DIR("A")="Select Report Option",DIR(0)="L^1:5" D ^DIR
 I Y=U!(Y="") G EXIT
 S BLRSLCT=$E(Y,$L(Y)-1)
 I BLRSLCT["," K Y,X W !,"Please select one option at a time" G OPT
 K X,Y,DIR
 ;
 S $P(SPACES," ",55)=" "   ; used within Report Header
 ;
 I BLRSLCT=1 D RNGE G EXIT
 I BLRSLCT=2 D DATE G EXIT
 I BLRSLCT=3 D USER G EXIT
 I BLRSLCT=4 D MENU G EXIT
 G EXIT
MENU ;  Menu report
 S QFL=0
 ;  Look up menu options
 W !,"   Select Menu Option(s):"
 D MEN^BLRALUT
 I $G(BLRAVAL)=""!($G(BLRAVAL)=U) Q
 ;
 ;  Sort out and save data to temporary global
 F BLRAJ=1:1 S BLRAI=$P(BLRAVAL,",",BLRAJ) Q:BLRAI=""  D  Q:QFL
 . S BLRADTA=$G(^TMP($J,"BLRAUSC",BLRAI))
 . S L=0,DIC="^BLRALAB(9009027,",DHD="*** CONFIDENTIAL DATA ***"_SPACES_"BLRA LAB AUDIT REPORT BY MENU OPTION: "_$P(BLRADTA,U)
 . S FLDS="[BLRA LAB AUDIT REPORT]"
 . S BLRAUI=$P(BLRADTA,U,1)
 . S BY=.03,FR(1)=BLRAUI,TO(1)=BLRAUI
 . D EN1^DIP
 . I $E(IOST,1,2)="C-" R !,"Press return to continue, '^' to Quit",BLRNS:DTIME
 . I BLRNS=U S QFL=1
 Q
 ;
USER ;  Report by User
 S QFL=0
 ;  Select users
 W !,"   Select User(s):"
 D ULK^BLRALUT
 I $G(BLRAVAL)=""!($G(BLRAVAL)=U) Q
 ;
 ;  Sort out and save data to temporary global
 F BLRAJ=1:1 S BLRAI=$P(BLRAVAL,",",BLRAJ) Q:BLRAI=""  D  Q:QFL
 . S BLRADTA=$G(^TMP($J,"BLRAUSC",BLRAI))
 . S L=0,DIC="^BLRALAB(9009027,",DHD="*** CONFIDENTIAL DATA ***"_SPACES_"LAB AUDIT REPORT BY USER: "_$P(BLRADTA,U)
 . S FLDS="[BLRA LAB AUDIT REPORT]"
 . S BLRAUI=$P(BLRADTA,U,1)
 . S BY=.02,FR(1)=BLRAUI,TO(1)=BLRAUI
 . D EN1^DIP
 . I $E(IOST,1,2)="C-" R !,"Press return to continue, '^' to Quit",BLRNS:DTIME
 . I BLRNS=U S QFL=1
 Q
 ;
RNGE ;  Date Range
 K BLRNS
 S %DT("A")="Date to START with: ",%DT="AE" D ^%DT S LRSDT=Y
 S %DT("A")="Date to END with: ",%DT="AE" D ^%DT S LREDT=Y
 I LRSDT=U!(LREDT=U)!(LRSDT=-1)!(LREDT=-1) Q
 S RLRSDT=$$HLDATE^HLFNC(LRSDT),RLREDT=$$HLDATE^HLFNC(LREDT)
 S RLRSDT1=$E(RLRSDT,5,6)_"/"_$E(RLRSDT,7,8)_"/"_$E(RLRSDT,1,4)
 S RLREDT1=$E(RLREDT,5,6)_"/"_$E(RLREDT,7,8)_"/"_$E(RLREDT,1,4)
 S L=0,DIC="^BLRALAB(9009027,",DHD="*** CONFIDENTIAL DATA ***"_SPACES_"LAB AUDIT REPORT BY DATE RANGE: "_RLRSDT1_" THRU "_RLREDT1
 S FLDS="[BLRA LAB AUDIT REPORT]"
 S FR=LRSDT,TO=(LREDT\1),BY=.01
 D EN1^DIP
 I $E(IOST,1,2)="C-" R !,"Press return to continue",BLRNS:DTIME
 Q
 ;
EXIT D ^%ZISC
 K BLRADTA,BLRAUI,BLRNS,QFL,BLRAVAL,BLRAJ,BLRAI,LREDT,LREND,LRSDT,DIR
 K BLRSLCT,BLCT,BLRACT,BLRACTN,BLRAU,BLRAUN,BLRNS
 Q
 ;
DATE ;  Report by a single date
 S %DT("A")="Date to RUN with: ",%DT="AE" D ^%DT S LRSDT=Y
 I LRSDT=U!(LRSDT=-1) Q
 S RDTE=$$HLDATE^HLFNC(LRSDT)
 S RDTE1=$E(RDTE,5,6)_"/"_$E(RDTE,7,8)_"/"_$E(RDTE,1,4)
 S L=0,DIC="^BLRALAB(9009027,",DHD="*** CONFIDENTIAL DATA ***"_SPACES_"LAB AUDIT REPORT BY SINGLE DATE: "_RDTE1
 S FLDS="[BLRA LAB AUDIT REPORT]"
 S FR=LRSDT,TO=LRSDT,BY=.01
 D EN1^DIP
 I $E(IOST,1,2)="C-" R !,"Press return to continue",BLRNS:DTIME
 Q
MENCON(MIEN) ; Convert Menu Option name to Menu Text for Audit Printout
 ;
 N MTXT
 I MIEN="" Q ""
 S MIEN=$$GET1^DIQ(9009027,MIEN,.03,"I")
 S MTXT=$$GET1^DIQ(19,MIEN,.01,"E")
 I MTXT="LRRP2" S MTXT="INT RPT-IR"
 I MTXT="LRRD" S MTXT="IR BY MD"
 I MTXT="LRRS" S MTXT="IR BY LOC"
 I MTXT="LRRS BY LOC" S MTXT="IR FOR 1 LOC"
 I MTXT="BLR LRRD BY MD" S MTXT="IR FOR 1 MD"
 I MTXT="BLRA LAB REVIEW/SIGN RESULTS" S MTXT="E-SIG REVIEW"
 Q MTXT
