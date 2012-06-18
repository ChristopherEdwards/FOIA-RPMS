PXRMDEV ; SLC/PKR - This is a driver for testing Clinical Reminders. ;05/18/2000
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;
 ;=======================================================================
DEB ;Prompt for DFN,PXRMITEM,PXRMHM
 N AGE,DFN,DIROUT,DTOUT,DUOUT,PXRMITEM,PXRHM,REF,SEX,X,Y
 S DIR(0)="LA"_U_"0"
 S DIR("A")="Enter DFN,PXRMITEM,PXRHM: "
 D ^DIR
 I $D(DIROUT)!$D(DTOUT)!$D(DUOUT) Q
 S DFN=$P(X,",",1),PXRMITEM=$P(X,",",2),PXRHM=$P(X,",",3)
 D DOREM
 K DIRUT,DTOUT,DUOUT
 Q
 ;
 ;=======================================================================
DEV ;Prompt for patient and reminder by name.
 N AGE,DFN,DIC,DIR,DTOUT,DUOUT,PXRMITEM,PXRHM,REF,SEX,X,Y
 S DIC=2,DIC("A")="Select Patient: "
 S DIC(0)="AEQMZ"
 D ^DIC
 I $D(DTOUT)!$D(DUOUT) Q
 S DFN=+$P(Y,U,1)
 S DIC=811.9,DIC("A")="Select Reminder: "
 D ^DIC
 I $D(DTOUT)!$D(DUOUT) Q
 S PXRMITEM=+$P(Y,U,1)
 ;
 S PXRHM=5
 ;
 D DOREM
 Q
 ;
 ;=======================================================================
DEVD ;Prompt for patient and reminder by name and evaluation date.
 N AGE,DFN,DIC,PXRMDATE,PXRMITEM,PXRHM,REF,SEX,X,Y
 S DIC=2,DIC("A")="Select Patient: "
 S DIC(0)="AEQMZ"
 D ^DIC
 S DFN=+$P(Y,U,1)
 S DIC=811.9,DIC("A")="Select Reminder: "
 D ^DIC
 K DTOUT,DUOUT
 S PXRMITEM=+$P(Y,U,1)
 ;
 S PXRHM=5
 ;
 N X,Y
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="DA^"_DT_"::EFTX"
 S DIR("A")="Enter date for reminder evalution: "
 S DIR("B")=$$FMTE^XLFDT($$DT^XLFDT,"D")
 S DIR("?")="This must be a future date."
 W !
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S PXRMDATE=Y
 ;
 D DOREM
 Q
 ;
 ;=======================================================================
DOREM ;Do the reminder
 ;PXRMDEV is defined so that PXRM will not kill the working array.
 ;This lets us examine it below.
 N FIEV,PXRMDEV,PXRMID
 S PXRMDEV=1
 I +$G(PXRMDATE)>0 D DATE^PXRM(DFN,PXRMITEM,PXRHM,1,PXRMDATE)
 I +$G(PXRMDATE)=0 D MAIN^PXRM(DFN,PXRMITEM,PXRHM,1)
 ;
 W !!,"The elements of the FIEV array are:"
 S REF="FIEV"
 D AWRITE^PXRMUTIL(REF)
 ;
 W !!,"The elements of the ^TMP(PXRMID,$J) array are:"
 S REF="^TMP(PXRMID,$J)"
 D AWRITE^PXRMUTIL(REF)
 ;
 W !!,"The elements of the ^TMP(""PXRHM"",$J) array are:"
 S REF="^TMP(""PXRHM"",$J)"
 D AWRITE^PXRMUTIL(REF)
 ;
 K PXRMTEXT
 K ^TMP("PXRM",$J)
 K ^TMP("PXRHM",$J)
 K ^TMP(PXRMID,$J)
 Q
