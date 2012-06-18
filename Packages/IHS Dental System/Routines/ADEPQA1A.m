ADEPQA1A ; IHS/HQT/MJL - USER TEMPLATE ;10:54 AM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
USRTMP(ADETFIL) ;EP - Returns NAME^DFN of template OR 0 if HAT
USR1 N ADETNAM,ADEJ,ADECNT,DIR,ADETDFN
 S ADETNAM=0
 K DIR
 S DIR(0)="Y",DIR("A")="Do you want to store the results of this search in a TEMPLATE?",DIR("A",1)="Template will be attached to the "_$S(ADETFIL=9000001:"PATIENT",1:"DENTAL PROCEDURE")_" FILE. "
 S DIR("B")="NO"
 D ^DIR
 Q:$$HAT() 0
 I 'Y D  Q ADETNAM_U_ADETDFN  ;FHL 9/9/98;Routine generates template name
 . S ADETNAM="ADEQA"_$P($H,",",2)
 . I $D(^DIBT("B",ADETNAM)) D DELTMP^ADEPQA($O(^DIBT("B",ADETNAM,0)))
 . S ADETDFN=$$TMPLAT^ADEPQA(ADETNAM,ADETFIL)
USR2 K DIR
 S DIR(0)="F^2:30"
 S DIR("A")="Enter Template Name"
 D ^DIR
 I X=""!($$HAT()) G USR1
 S ADETNAM=Y
 I $E(ADETNAM,1,5)="ADEQA" W !!,"Template name can't start with ADEQA. Please choose another name." G USR2
 I '$D(^DIBT("B",ADETNAM)) S ADETDFN=$$TMPLAT^ADEPQA(ADETNAM,ADETFIL) Q ADETNAM_U_ADETDFN
 ;Template name already exists. Possibilities:
 ;1. Another user already has a template by this name. Pick another name
 ;2. There is already more than one template by this name. Pick another
 ;3. You already have a template by this name. Delete it?
 ;4. We're using this template as a search parameter. Pick another ***
 D  I ADECNT>1 W !,"Several templates by this name already exist. Please choose another name.",! G USR2
 . S (ADEJ,ADECNT)=0
 . F  S ADEJ=$O(^DIBT("B",ADETNAM,ADEJ)) Q:'ADEJ  S ADECNT=ADECNT+1 Q:ADECNT>1
 S ADETDFN=$O(^DIBT("B",ADETNAM,0))
 I $P(^DIBT(ADETDFN,0),U,5)'=DUZ D  G USR2
 . W !,"Another user already has a template by this name.  Please choose another name.",!
 W !!,"You already have a template by this name."
 I +ADESTP,ADETDFN=$P(ADESTP,U,2) W !,"And it's being used as a Search Parameter.  Please choose another name." G USR2
 K DIR
 S DIR(0)="Y",DIR("A")="Do you want to overwrite the existing template"
 S DIR("B")="NO"
 D ^DIR
 I $$HAT() G USR2
 I 'Y G USR2
 D DELTMP^ADEPQA(ADETDFN)
 S ADETDFN=$$TMPLAT^ADEPQA(ADETNAM,ADETFIL)
 Q ADETNAM_U_ADETDFN
 ;
HAT() ;EP
 I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) Q 1
 Q 0
