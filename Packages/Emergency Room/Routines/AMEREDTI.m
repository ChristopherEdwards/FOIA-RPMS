AMEREDTI ; IHS/OIT/SCR - SUB-ROUTINE FOR ER VISIT EDIT of INJURY INFORMATION
 ;;3.0;ER VISIT SYSTEM;**6**;MAR 03, 2009;Build 30
 ;
EDINJRY(AMERDA,AMERAIEN)   ;EP CALLED BY AMEREDIT when "INJURY" is selected for editing
 ;
 ;Make call to new injury editing code
 D INJURY($G(AMERDA),$G(AMERAIEN))
 ;
 Q 1
 ;
 ;AMER*3.0*6;Rewrote Injury Edit Option
INJURY(AMERDA,AMERAIEN) ;New edit injury section
 ;
 ;Edit all entries then perform an update to PCC
 ;
 NEW QUIT,AMERPOV,VAL,POV,CNT
 ;
 ;Reset QUIT value
INJ S QUIT=""
 ;
 ;Injury?
 D  I QUIT]"" G INJUPD
 . NEW INJ,DIR,X,Y,DIR,DUOUT,DTOUT,DR,NINJ,AMERSTRG
 . ;
 . ;Show warning message
 . D EN^DDIOL("**Setting the following field to No will cause all injury data to be deleted**","","!!?3")
 . ;
 . ;Retrieve current value and perform edit
 . S INJ=$$GET1^DIQ(9009080,AMERDA_",",3.1,"I"),INJ=$S(INJ=1:1,1:0)
 . S DIR("B")=$S(INJ=1:"YES",1:"NO")
 . S DIR(0)="YO",DIR("A")="Was this ER visit caused by an injury"
 . D ^DIR
 . S NINJ=Y
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S QUIT="^" Q
 . I $D(DTOUT) S QUIT=1 Q
 . ;
 . ;If original non injury and current non injury quit
 . I INJ=0,NINJ=0 S QUIT="^" Q
 . ;
 . ;If original injury and current injury quit
 . I INJ=1,NINJ=1 Q
 . ;
 . ;If original injury and current non injury - remove injury information
 . S DR="" I INJ=1,NINJ=0 S QUIT="^",DR=$S(DR'="":DR_";",1:""),DR=DR_"3.2////@;3.3////@;3.4////@;3.5////@;3.6////@;13.1////@;13.2////@;13.3////@;13.4////@;13.5////@;13.6////@"
 . ;
 . ;If original non injury and current injury - update the entry
 . S DR=DR_$S(DR="":";",1:"")_"3.1////"_NINJ
 . ;
 . ;File/Audit
 . I DR]"" D
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("3.1",$$EDDISPL^AMEREDAU(INJ,"B"),$$EDDISPL^AMEREDAU(NINJ,"B"),"INJURED")
 .. D DIE^AMEREDIT(AMERDA,DR)
 .. I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
 ;Cause of Injury Entry
INJ1 S QUIT="" D  G INJ:QUIT="^",INJUPD:QUIT
 . NEW AMERPCC,AMERQUIT,DFN,CAUSE,NCAUSE,EDIT,DUOUT,DTOUT
 . S AMERPCC=$$GET1^DIQ(9009080,AMERDA_",",.03,"I") I AMERPCC="" S QUIT=1 Q
 . S DFN=$$GET1^DIQ(9000010,AMERPCC_",",.05,"I") I DFN="" S QUIT=1 Q
 . ;
 . ;Show warning message
 . D EN^DDIOL("**Changing this Cause of Injury value can cause injury data to be deleted**","","!!?3")
 . ;
 . ;Get the current cause of injury
 . S CAUSE=$$GET1^DIQ(9009080,AMERDA_",",3.2,"I")
 . ;
 . ;Make the call to get the cause
 . D QD33^AMER2B(AMERPCC,.DTOUT)
 . I $D(DTOUT) S QUIT=1 Q
 . I $G(X)="^" S QUIT="^" Q
 . I +$G(Y)>0,'$D(^ICD9(+$G(Y),0)) S QUIT="^" Q
 . S NCAUSE=+Y
 . ;
 . ;If old cause does not equal new cause save/audit
 . I CAUSE'=NCAUSE D
 .. NEW DR,AMERSTRG
 .. S DR="3.2////"_NCAUSE
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("3.2",$$EDDISPL^AMEREDAU(CAUSE,"C"),$$EDDISPL^AMEREDAU(NCAUSE,"C"),"CAUSE OF INJURY")
 .. D DIE^AMEREDIT(AMERDA,DR)
 .. I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
 ;Setting of injury 
INJ2 S QUIT="" D  G INJ1:QUIT="^",INJUPD:QUIT
 . NEW DIC,X,Y,PLACE,NPLACE,DUOUT,DTOUT
 . S DIC("A")="*Setting of accident/injury: " K DIC("B")
 . S PLACE=$$GET1^DIQ(9009080,AMERDA_",",3.3,"I")
 . I PLACE'="" S DIC("B")=$$GET1^DIQ(9009083,PLACE_",",.01,"I")
 . S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("SCENE OF INJURY"),DIC(0)="AEQ"
 . ;
 . ;Get new value
 . D ^DIC K DIC
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S QUIT="^" Q
 . I $D(DTOUT) S QUIT=1 Q
 . ;
 . I Y<0 S NPLACE=""
 . E  S NPLACE=+Y
 . ;
 . ;Save/audit
 . I NPLACE'=PLACE D
 .. NEW AMERSTRG,DR
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("3.3",$$EDDISPL^AMEREDAU(PLACE,"S"),$$EDDISPL^AMEREDAU(NPLACE,"S"),"SCENE OF INJURY")
 .. S DR="3.3////"_$S(NPLACE]"":NPLACE,1:"@")
 .. D DIE^AMEREDIT(AMERDA,DR)
 .. I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
 ;Safety Equipment
INJ3 S QUIT="" D  G INJ2:QUIT="^",INJUPD:QUIT
 . NEW DIC,X,Y,SAFE,NSAFE,DUOUT,DTOUT
 . ;
 . ;Retrieve current value
 . S SAFE=$$GET1^DIQ(9009080,AMERDA_",",3.5,"I")
 . S:SAFE'="" DIC("B")=$$GET1^DIQ(9009083,SAFE_",",.01,"I")
 . ;
 . ;Get new value
 . S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("SAFETY EQUIPMENT"),DIC(0)="AEQ"
 . S DIC("A")="*Safety equipment used: "
 . D ^DIC K DIC
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S QUIT="^" Q
 . I $D(DTOUT) S QUIT=1 Q
 . ;
 . ;Save/audit
 . S NSAFE=+Y
 . I NSAFE'=+SAFE D
 .. NEW AMERSTRG,DR
 .. S DR="3.5////"_$S(+NSAFE>0:+NSAFE,1:"@")
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("3.5",$$EDDISPL^AMEREDAU(SAFE,"Q"),$$EDDISPL^AMEREDAU(+NSAFE,"Q"),"SAFETY EQUIPMENT")
 .. D DIE^AMEREDIT(AMERDA,DR)
 .. I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
 ;TIME OF INJURY
INJ4 S QUIT="" D  G INJ3:QUIT="^",INJUPD:QUIT
 . NEW DIR,INJDT,NINJDT,VDT,X,Y,DUOUT,DTOUT
 . ;
 . ;Pull the current value
 . S INJDT=$$GET1^DIQ(9009080,AMERDA_",",3.4,"I")
 . I INJDT'="" S Y=INJDT X ^DD("DD") S DIR("B")=Y
 . ;
 . ;Get the admission date/time
 . S VDT=$$GET1^DIQ(9009080,AMERDA_",",.01,"I")
 . ;
 . ;Prompt for the new value
 . S DIR(0)="DO^::ER",DIR("A")="*Enter the exact time and date of injury"
 . S DIR("?")="Enter a time and date in the usual FileMan format (e.g., 1/3/90@1PM)."
 . F  D  I (Y="^")!(QUIT) Q
 .. NEW DUOUT,DTOUT
 .. D ^DIR
 .. ;
 .. ;Process timeouts and "^"
 .. I $D(DUOUT) S QUIT="^" Q
 .. I $D(DTOUT) S QUIT=1 Q
 .. ;
 .. I $$TCK^AMER2A(VDT,Y,0,"admission")=0  D
 ... S NINJDT=Y
 ... S:NINJDT<0 NINJDT=""
 ... ;
 ... ;Save/Audit
 ... I NINJDT'=INJDT D
 .... NEW AMERSTRG,DR
 .... S AMERSTRG=$$EDAUDIT^AMEREDAU("3.4",$$EDDISPL^AMEREDAU(INJDT,"D"),$$EDDISPL^AMEREDAU(NINJDT,"D"),"TIME OF INJURY")
 .... S DR="3.4////"_$S(NINJDT]"":NINJDT,1:"@")
 .... D DIE^AMEREDIT(AMERDA,DR)
 .... I AMERSTRG="^" Q
 .... D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 .... S Y="^"
 ... E  S Y="^"
 ;
 ;Town of Injury
INJ5 S QUIT="" D  G INJ4:QUIT="^",INJUPD:QUIT
 . NEW DIR,TOWN,NTOWN,DUOUT,DTOUT,X,Y
 . ;
 . ;Retrieve the old value
 . S TOWN=$$GET1^DIQ(9009080,AMERDA_",",3.6,"I")
 . I TOWN]"" S DIR("B")=TOWN
 . ;
 . ;Prompt for the new value
 . S DIR(0)="FO^1:30",DIR("A")="Town/village where injury occurred"
 . D ^DIR
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S QUIT="^" Q
 . I $D(DTOUT) S QUIT=1 Q
 . ;
 . S NTOWN=Y
 . S:NTOWN<0 NTOWN=""
 . ;
 . ;Save/Audit
 . I NTOWN'=TOWN D
 .. NEW AMERSTRG,DR
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("3.6",TOWN,NTOWN,"TOWN OF INJURY")
 .. S DR="3.6////"_$S(NTOWN]"":NTOWN,1:"@")
 .. D DIE^AMEREDIT(AMERDA,DR)
 ..I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
 ;Description of MVA Location
INJ6 S QUIT="" D  G INJ5:QUIT="^",INJUPD:QUIT
 . NEW DIR,DUOUT,DTOUT,MVAL,NMVAL,X,Y
 . ;
 . ;Retrieve current value
 . S MVAL=$$GET1^DIQ(9009080,AMERDA_",",13.1,"I")
 . I MVAL]"" S DIR("B")=MVAL
 . ;
 . ;Get the new value
 . S DIR(0)="FO^1:100",DIR("A")="Location of MVC (if applicable)"
 . S DIR("?")="If MVC, enter free text location description (100 characters max.)"
 . D ^DIR
 . S NMVAL=Y
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S QUIT="^" Q
 . I $D(DTOUT) S QUIT=1 Q
 . ;
 . ;Save/Audit
 . I NMVAL'=MVAL D
 .. NEW AMERSTRG,DR
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("13.1",MVAL,NMVAL,"EXACT MVC LOCATION")
 .. S DR="13.1////"_$S(NMVAL]"":NMVAL,1:"@")
 .. D DIE^AMEREDIT(AMERDA,DR)
 .. I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
 ;MVC - Driver Insurance Company
INJ7 S QUIT="" D  G INJ6:QUIT="^",INJUPD:QUIT
 . NEW DIR,DUOUT,DTOUT,MVAC,NMVAC,X,Y
 . ;
 . ;Pull current value
 . S MVAC=$$GET1^DIQ(9009080,AMERDA_",",13.2,"I")
 . I MVAC'="" S DIR("B")=MVAC
 . ;
 . ;Get the new value
 . S DIR(0)="FO^1:100",DIR("A")="Driver's insurance company (if applicable)"
 . S DIR("?")="Enter free text description"
 . D ^DIR
 . S NMVAC=Y
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S QUIT="^" Q
 . I $D(DTOUT) S QUIT=1 Q
 . ;
 . ;Save/Audit
 . I NMVAC'=MVAC D
 .. NEW AMERSTRG,DR
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("13.2",MVAC,NMVAC,"DRIVER INSURANCE COMPANY")
 .. S DR="13.2////"_$S(NMVAC]"":NMVAC,1:"@")
 .. D DIE^AMEREDIT(AMERDA,DR)
 .. I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
INJ8 S QUIT="" D  G INJ7:QUIT="^",INJUPD:QUIT
 . NEW DIR,DIPN,NDIPN,X,Y,DUOUT,DTOUT
 . ;
 . ;Retrieve current value
 . S DIPN=$$GET1^DIQ(9009080,AMERDA_",",13.3,"I")
 . I DIPN]"" S DIR("B")=DIPN
 . ;
 . ;Get the new value
 . S DIR(0)="FO^1:100",DIR("A")="Driver's insurance policy number (if applicable)"
 . S DIR("?")="Enter free text description"
 . D ^DIR
 . S NDIPN=Y
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S QUIT="^" Q
 . I $D(DTOUT) S QUIT=1 Q
 . ;
 . ;Save/Audit
 . I NDIPN'=DIPN D
 .. NEW AMERSTRG,DR
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("13.3",DIPN,NDIPN,"DRIVER POLICY #")
 .. S DR="13.3////"_$S(NDIPN]"":NDIPN,1:"@")
 .. D DIE^AMEREDIT(AMERDA,DR)
 .. I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
 ;Owners name
INJ9 S QUIT="" D  G INJ8:QUIT="^",INJUPD:QUIT
 . NEW DIR,OWN,NOWN,X,Y,DUOUT,DTOUT
 . ;
 . ;Retrieve the current value
 . S OWN=$$GET1^DIQ(9009080,AMERDA_",",13.4,"I")
 . I OWN]"" S DIR("B")=OWN
 . ;
 . ;Get the new value
 . S DIR(0)="FO^1:100",DIR("A")="Owner of vehicle, if different than driver (if applicable)"
 . S DIR("?")="Enter free text description"
 . D ^DIR
 . S NOWN=Y
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S QUIT="^" Q
 . I $D(DTOUT) S QUIT=1 Q
 . ;
 . ;Save/Audit
 .I NOWN'=OWN D
 .. NEW AMERSTRG,DR
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("13.4",OWN,NOWN,"OWNER NAME")
 ..S DR="13.4////"_$S(NOWN]"":NOWN,1:"@")
 .. D DIE^AMEREDIT(AMERDA,DR)
 .. I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
 ;Owners Insurance Company
INJ10 S QUIT="" D  G INJ9:QUIT="^",INJUPD:QUIT
 . NEW DIR,X,Y,DUOUT,DTOUT,OINS,NOINS
 . ;
 . ;Retrieve the current value
 . S OINS=$$GET1^DIQ(9009080,AMERDA_",",13.5,"I")
 . I OINS]"" S DIR("B")=OINS
 . ;
 . ;Get the new value
 . S DIR(0)="FO^1:100",DIR("A")="Owner's insurance company (if applicable)"
 . S DIR("?")="Enter free text description"
 . D ^DIR
 . S NOINS=Y
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S QUIT="^" Q
 . I $D(DTOUT) S QUIT=1 Q
 . ;
 . ;Save/Audit
 . I NOINS'=OINS D
 .. NEW AMERSTRG,DR
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("13.5",OINS,NOINS,"OWNER INSURANCE CO.")
 .. S DR="13.5////"_$S(NOINS]"":NOINS,1:"@")
 .. D DIE^AMEREDIT(AMERDA,DR)
 .. I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
INJ11 S QUIT="" D  G INJ10:QUIT="^",INJUPD:QUIT
 . NEW DIR,X,Y,DTOUT,DUOUT,POL,NPOL
 . ;
 . ;Retrieve the current value
 . S POL=$$GET1^DIQ(9009080,AMERDA_",",13.6)
 . I POL]"" S DIR("B")=POL
 . ;
 . ;Get current value
 . S DIR(0)="FO^1:100",DIR("A")="Owner's insurance policy number (if applicable)"
 . S DIR("?")="Enter free text description"
 . D ^DIR
 . S NPOL=Y
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S QUIT="^" Q
 . I $D(DTOUT) S QUIT=1 Q
 . ;
 . ;Save/Audit
 . I NPOL'=POL D
 .. NEW AMERSTRG,DR
 .. S AMERSTRG=$$EDAUDIT^AMEREDAU("13.6",POL,NPOL,"OWNER POLICY #")
 .. S DR="13.6////"_$S(NPOL]"":NPOL,1:"@")
 .. D DIE^AMEREDIT(AMERDA,DR)
 .. I AMERSTRG="^" Q
 .. D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 ;
INJUPD ;Push changes to V POV
 ;
 ;First get the POV entries on file
 S AMERPOV=$$POV^AMERUTIL("",AMERPCC,.AMERPOV)
 ;
 ;Get the number of V POV entries
 S POVCNT=+$G(AMERPOV) Q:'POVCNT
 ;
 ;Set up scratch global
 K ^TMP("AMER",$J)
 ;
 ;Pull Injury Date
 S VAL=$P($$GET1^DIQ(9009080,AMERDA_",",3.4,"I"),".")
 S ^TMP("AMER",$J,2,32)=VAL
 ;
 ;Pull Injury Cause
 S VAL=$$GET1^DIQ(9009080,AMERDA_",",3.2,"I")
 S ^TMP("AMER",$J,2,33)=VAL
 ;
 ;Place of Accident - Convert
 S VAL=$$GET1^DIQ(9009080,AMERDA_",",3.3,"I")
 S ^TMP("AMER",$J,2,34)=VAL
 ;
 ;If only 1 POV on file update that one
 I $P(AMERPOV,U)=1 D  G XINJURY
 . NEW VPOVIEN
 . Q:'$D(AMERPOV(1))
 . S VPOVIEN=$P($G(AMERPOV(1)),U,6) Q:VPOVIEN=""
 . D UPDPOV^AMER31(VPOVIEN)
 ;
 ;If multiple POV on file select the correct one(s)
 I $P(AMERPOV,U)>1 D
 . NEW POVLST
 . W $$S^AMERUTIL("RVN")
 . W !!,"Current POV information on file:"
 . W $$S^AMERUTIL("RVF")
 . W !!,"# ",?3,"P/S",?7,"Code",?18,"Description",?50,"Provider Narrative"
 . F CNT=1:1:POVCNT D
 .. Q:'$D(AMERPOV(CNT))
 .. W !,CNT,?3,$P(AMERPOV(CNT),U,2),?7,$P(AMERPOV(CNT),U),?18,$E($P(AMERPOV(CNT),U,5),1,30),?50,$E($P(AMERPOV(CNT),U,3),1,29)
 . ;
 . ;Prompt user for which one(s) to match injury to
 . S DIR(0)="L^1:"_POVCNT
 . S DIR("A")="Select the POV entry or entries to match the injury information to"
 . W !
 . D ^DIR
 . I $D(DIRUT) S X="^" Q
 . S POVLST=Y
 . ;
 . ;Match selected entry or entries to the injury information
 . F CNT=1:1:$L(POVLST,",") S VAL=$P(POVLST,",",CNT) I +VAL D
 .. NEW VPOVIEN
 .. Q:'$D(AMERPOV(+VAL))
 .. S VPOVIEN=$P($G(AMERPOV(+VAL)),U,6) Q:VPOVIEN=""
 .. D UPDPOV^AMER31(VPOVIEN)
 ;
XINJURY ;
 Q
