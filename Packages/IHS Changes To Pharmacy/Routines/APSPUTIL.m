APSPUTIL ;IHS/BAO/DMH - Utilites to Support OP v7.0 -;28-Mar-2011 18:30;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1006,1007,1009,1011**;Sep 23, 2004;Build 17
 ;
PMS ; EP  ; called from PSORXL before go in to print the label  3/1/2002
 S DIR("A")="Do you want to print a Patient Med Sheet"
 S DIR("B")="N"
 S DIR(0)="Y"
 S DIR("?")="Please enter Y OR N to print Patient Medication Sheet Also"
 D ^DIR
 Q:$D(DIRUT)
 I Y=0 K DIR Q
 K DIR
 ;
 S APSQSTOP=0
 ;   need DFN set  and PPL
 S PPL=$G(PSORX("PSOL",1))
 D EN^APSEPPIM
 Q
 ;
 ; Prompt for a date range.
 ; .APSPB    Start date in FM format (returned)
 ; .APSPE    End date in FM format (returned)
 ; .APSPPOP  Abort flag (returned)
 ;  APSPBDF  Default begin date (optional)
 ;  APSPEDF  Default end date (optional)
 ;  APSPSAME If nonzero, default end date is begin date (optional)
 ;  APSPTIME If nonzero, ask for time (optional)
 ;
ASKDATES(APSPB,APSPE,APSPPOP,APSPBDF,APSPEDF,APSPSAME,APSPTIME) ; EP
 N APSPOPT
 W !!,"   *** Date Range Selection ***"
 S APSPPOP=0,APSPOPT=$S($G(APSPTIME):"T",1:"")
 S APSPB=$$ASKDATE("   Begin with DATE: ",.APSPBDF,,APSPOPT)
 S:'APSPPOP APSPE=$$ASKDATE("     End with DATE: ",$S($G(APSPSAME):APSPB,$G(APSPEDF):APSPEDF,1:""),APSPB,APSPOPT)
 Q
 ; Prompt for single date date
 ; APSPPMT = Prompt
 ; APSPDFL = Default value (optional)
 ; APSPMIN = Minimum value (optional)
 ; APSPOPT = Additional options (optional)
ASKDATE(APSPPMT,APSPDFL,APSPMIN,APSPOPT) ;
 N %DT,Y
 S %DT="APEX"_$G(APSPOPT)
 S %DT("A")=APSPPMT
 S:$G(APSPMIN) %DT(0)=APSPMIN
 I $G(APSPDFL) D
 .S Y=APSPDFL
 .D DD^%DT
 .S %DT("B")=Y
 D ^%DT
 S:Y<0 APSPPOP=1
 Q Y
 ;
 ; DIR call for required Y/N response
DIRYNR(APSPPMT,APSPDFL,APSPHLP,APSPPOP) ; EP
 N Y
 S Y=$$DIR("Y",.APSPPMT,.APSPDFL,.APSPHLP,.APSPPOP)
 Q Y
 ; DIR call for Y/N response
DIRYN(APSPPMT,APSPDFL,APSPHLP,APSPPOP) ; EP
 N Y
 S Y=$$DIR("YO",.APSPPMT,.APSPDFL,.APSPHLP,.APSPPOP)
 Q Y
 ; Paramerized DIR call
DIR(APSPDTP,APSPPMT,APSPDFL,APSPHLP,APSPPOP,APSPSCN) ; EP
 N DIR,DTOUT,DUOUT,Y
 S DIR(0)=APSPDTP,DIR("B")=$G(APSPDFL)
 I '$G(APSPPMT) M DIR("A")=APSPPMT
 E  D GETTEXT(APSPPMT,$NA(DIR("A")))
 I '$G(APSPHLP) M DIR("?")=APSPHLP
 E  D GETTEXT(APSPHLP,$NA(DIR("?")))
 S:$L($G(APSPSCN)) DIR("S")=APSPSCN
 D ^DIR
 S:$D(DUOUT)!$D(DTOUT) APSPPOP=1
 Q Y
 ; Pause for user input
DIRZ(APSPPMT) ; EP
 D DIR("E",.APSPPMT,,,.APSPPOP)
 Q
 ; Load dialog text into array
 ; APSPDG = Dialog index^optional parameters
 ; APSPAR = Array to receive text
GETTEXT(APSPDG,APSPAR) ;
 N APSPPM
 K @APSPAR
 F X=2:1:$L(APSPDG,U) S APSPPM(X-1)=$P(APSPDG,U,X)
 S APSPDG=$S(APSPDG<0:-APSPDG,1:+APSPDG)
 D BLD^DIALOG(APSPDG/1000+59000,.APSPPM,,APSPAR)
 Q
 ;
 ; Prompt for entry from file
 ; APSPFILE = File #
 ; APSPPMPT = Prompt
 ; APSPPOP =  Abort Flag (returned)
 ; APSPDIC0 = Additional DIC(0) parameters
GETIEN(APSPFILE,APSPPMPT,APSPPOP,APSPDIC0) ; EP
 N DIC,APSPD,Y
 S APSPPOP=0
 S APSPD=$$GET1^DIQ(APSPFILE,$$FIND1^DIC(APSPFILE,,," "),.01)
 S DIC=APSPFILE,DIC(0)="AE"_$G(APSPDIC0),DIC("A")=$G(APSPPMPT),DIC("B")=APSPD
 D ^DIC
 S:Y'>0 APSPPOP=1
 Q +Y
 ; Prompt for entry from file
 ; APSPFILE = File #
 ; APSPPMPT = Prompt
 ; APSPDFLD = Field whose value is to be used for default value
 ;          Set to -1 for no default value
 ; D - x-ref (C^D)
 ; APSPSCRN = DIC("S") SCREEN LOGIC
 ; APSPDFLT = Default value set in DIC("B") - not used if APSPDFLD is >0
GETIEN1(APSPFILE,APSPPMPT,APSPDFLD,D,APSPSCRN,APSPDFLT) ; EP
 N DIC,APSPD,Y
 S D=$G(D,"B")
 S:'$L(D) D="B"
 S APSPDFLD=$G(APSPDFLD,.01)
 S APSPD=""
 S DIC("S")=$G(APSPSCRN)
 S:APSPDFLD>0 APSPD=$$GET1^DIQ(APSPFILE,$$FIND1^DIC(APSPFILE,,," ",.D,DIC("S")),APSPDFLD)
 I APSPDFLD<0,$L($G(APSPDFLT)) S APSPD=APSPDFLT
 S DIC=APSPFILE,DIC(0)="AE",DIC("A")=$G(APSPPMPT),DIC("B")=APSPD
 I $L(D,U)>1,DIC(0)'["M" S DIC(0)=DIC(0)_"M"
 D MIX^DIC1
 S:Y'>0 APSPPOP=1,$P(APSPPOP,U,2)=X="@"
 Q +Y
