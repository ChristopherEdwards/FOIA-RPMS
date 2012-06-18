PXRMXSC ; SLC/PJH - Reminder reports service category selection ;01/12/2002
 ;;1.5;CLINICAL REMINDERS;**6**;Jun 19, 2000
 ;
SCAT ;Get the list of service categories.
 N DIR,DIEA,IC,JC,NSC,PCESVC,SCA,VALID,X,Y
 K DIRUT,DTOUT,DUOUT
 ;Build a list of allowed service categories. PCE uses a subset of the
 ;categories in the file.  These are stored in PCESVC.
 S PCESVC="AHITSEDX"
 D HELP^DIE(9000010,"",.07,"S","SCA")
 S NSC=SCA("DIHELP")
 S DIR("?")=" "
 S DIR("?",1)="The possible service categories for the report are:"
 S JC=0
 F IC=2:1:NSC D
 . S X=$P(SCA("DIHELP",IC)," ",1)
 . I PCESVC[X D
 .. S JC=JC+1
 .. S DIR("?",JC)=SCA("DIHELP",IC)
 S NSC=JC
 S DIR("??")=U_"D SCATHELP^PXRMXSC"
SCATP ;
 S DIR(0)="FU"_U_"1:"_NSC
 S DIR("A")="Select SERVICE CATEGORIES"
 S DIR("B")="AI"
 W !
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 ;Make sure we have a valid list.
 S VALID=$$VLIST^PXRMXGUT(PCESVC,Y," is an invalid service category!")
 I 'VALID G SCATP
 S PXRMSCAT=$$UP^XLFSTR(Y)
 Q
 ;
SCATHELP ;?? help for service categories.
 W !!,"Enter the letter(s) corresponding to the desired service category or categories."
 W !,"For example AHTE would allow only encounters with service categories of"
 W !,"ambulatory, hospitalization, telecommunications, and event (historical) to be included."
 Q
 ;
