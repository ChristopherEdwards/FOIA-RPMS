PXRMREV ; SLC - Review Date routines. ;06/19/2001
 ;;1.5;CLINICAL REMINDERS;**6**;Jun 19, 2000
 ;
 ;Print review date reports
 ;-------------------------
START N DATE,DIROUT,DTOUT,DUOUT,FTYPE
 F  D FILE(.FTYPE) Q:$D(DTOUT)!($D(DUOUT))  D  Q:$D(DTOUT)
 .;
 .D DATE(.DATE) I $D(DTOUT)!($D(DUOUT)) Q
 .;
 .N BY,DHD,FLDS,FR,L,NOW,TO
 .S FR="01/01/2000"
 .S TO=DATE
 .S BY="REVIEW DATE"
 .S FLDS=".01,REVIEW DATE;C60"
 .S L=0
 .;
 .I FTYPE="R" S DIC="^PXD(811.9,",DHD="REMINDERS TO REVIEW"
 .I FTYPE="T" S DIC="^PXD(811.2,",DHD="TAXONOMIES TO REVIEW"
 .I FTYPE="C" S DIC="^PXRMD(811.4,",DHD="CF'S TO REVIEW"
 .I FTYPE="D" S DIC="^PXRMD(801.41,",DHD="DIALOGS TO REVIEW"
 .;
 .S DHD=DHD_" (up to "_$$FMTE^XLFDT(DATE)_")"
 .;Print
 .D EN1^DIP
 .S DTOUT=1
 Q
 ;
 ;Select file for review
 ;----------------------
FILE(Y) N X,DIR
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="S"_U_"C:Computed Finding;"
 S DIR(0)=DIR(0)_"D:Reminder Dialog;"
 S DIR(0)=DIR(0)_"R:Reminder Definition;"
 S DIR(0)=DIR(0)_"T:Reminder Taxonomy;"
 S DIR("A")="Select File to Review"
 S DIR("B")="R"
 S DIR("?")="Select from the codes displayed. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMREV(1)"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 Q
 ;
 ;Select the review date
 ;----------------------
DATE(RDATE) ;
 N X,Y,DONE,DIR
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DONE=0
 F  D  Q:$D(DTOUT)!($D(DUOUT))!DONE
 .S DIR(0)="DA^"_DT_"::EFTX"
 .S DIR("A")="Enter Review Cutoff Date: "
 .S DIR("B")=$$FMTE^XLFDT($$DT^XLFDT,"D")
 .S DIR("?")="This must be today or a future date. For detailed help type ??"
 .S DIR("??")=U_"D HELP^PXRMREV(2)"
 .W !
 .D ^DIR K DIR
 .I $D(DIROUT) S DTOUT=1
 .I $D(DTOUT)!($D(DUOUT)) Q
 .;I $E(Y,6,7)="00" W $C(7),"  ?? Enter exact date" Q
 .S RDATE=Y,DONE=1
 .K DIROUT,DIRUT,DTOUT,DUOUT
 Q
 ;
 ;General help text routine
 ;-------------------------
HELP(CALL) ;
 N DIWF,DIWL,DIWR,HTEXT,IC
 S DIWF="C70",DIWL=0,DIWR=70
 ;
 I CALL=1 D
 .S HTEXT(1)="Select the file for which a Review Date report is required."
 .S HTEXT(2)=" "
 .S HTEXT(3)="The report lists in review date order all file entries which"
 .S HTEXT(4)="have a review date prior to the cuttoff date."
 I CALL=2 D
 .S HTEXT(1)="Enter a future date or today. All review dates in the file"
 .S HTEXT(2)="selected which are prior or equal to this date will be reported."
 K ^UTILITY($J,"W")
 S IC=""
 F  S IC=$O(HTEXT(IC)) Q:IC=""  D
 . S X=HTEXT(IC)
 . D ^DIWP
 W !
 S IC=0
 F  S IC=$O(^UTILITY($J,"W",0,IC)) Q:IC=""  D
 . W !,^UTILITY($J,"W",0,IC,0)
 K ^UTILITY($J,"W")
 W !
 Q
