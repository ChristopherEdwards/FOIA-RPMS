AGED3 ; IHS/ASDS/EFG - EDIT PG 3 - EMERGENCY CONTACT/NEXT OF KIN ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 S AG("N")=14
VAR D DRAW
 W !,AGLINE("EQ")
 K DIR
 S DIR("A")="CHANGE which item? (1-"_AG("N")_") NONE// "
 S DIR("?")=""
 S DIR("?",1)="You may enter the item number of the field you wish to edit,"
 S DIR("?",2)="OR you can enter 'P#' where P stands for 'page' and '#' stands for"
 S DIR("?",3)="the page you wish to jump to, OR enter '^' to go back one page"
 S DIR("?",4)="OR, enter '^^' to exit the edit screens, OR RETURN to go to the next screen."
 D READ^AGED1
 I $D(MYERRS("C","E")),(Y'?1N.N),(Y'=AGOPT("ESCAPE")) W !,"ERRORS ON THIS PAGE. PLEASE FIX BEFORE EXITING!!" H 3 G VAR
 Q:Y=AGOPT("ESCAPE")
 G:$D(AG("ED"))&'$D(AGXTERN) @("^AGED"_AG("ED"))
 G END:$D(DLOUT)!(Y["N")!$D(DUOUT),VAR:$D(AG("ERR"))
 Q:$D(DFOUT)!$D(DTOUT)
 I $D(DQOUT)!(+Y<1)!(+Y>AG("N")) W !!,"You must enter a number from 1 to ",AG("N") H 2 G VAR
 S AG("C")="ECNAME^AG8A,ECPH^AG8A,ECREL^AG8A,ECSTR^AG8A,ECCITY^AG8A,ECST^AG8A,ECZIP^AG8A,NKNAME^AG8B,NKPH^AG8B,NKREL^AG8B,NKSTR^AG8B,NKCITY^AG8B,NKST^AG8B,NKZIP^AG8B"
 S AGY=Y
 F AGI=1:1 S AG("SEL")=+$P(AGY,",",AGI) Q:AG("SEL")<1!(AG("SEL")>AG("N"))  D @($P(AG("C"),",",AG("SEL")))
 D UPDATE1^AGED(DUZ(2),DFN,3,"")
 K AGI,AGY
 G VAR
END K AG,DLOUT,DTOUT,DFOUT,DQOUT,DA,DIC,DR,AGSCRN,Y
 K ROUTID
 Q:$D(AGXTERN)
 Q:$D(DIROUT)
 G ^AGED2:$D(DUOUT),^AGED4A
DRAW ;EP
 S AG("PG")=3
 S ROUTID=$P($T(+1)," ")  ;SET ROUTINE ID FOR PROGRAMMER VIEW
 S DA=DFN
 D ^AGED
 K ^UTILITY("DIQ1",$J)
 W !,"--- Emergency Contact Data " F A=1:1:53 W "-"
 F AG=1:1:14 D
 . S AGSCRN=$P($T(@1+AG),";;",2,15)
 . S DIC=$P(AGSCRN,U,3)
 . S DR=$P(AGSCRN,U,4)
 . I AG=8 W !,"--- Next of Kin Data " F A=1:1:59 W "-"
 . W !,AG,".",?(29-$L($P($G(^DD(DIC,DR,0)),U))),$P($G(^DD(DIC,DR,0)),U)," :  "
 . W $$GET1^DIQ(DIC,DFN,DR)
 W !,AGLINE("-")
 K MYERRS,MYVARS
 D FETCHERR^AGEDERR(AG("PG"),.MYERRS)
 S MYVARS("DFN")=DFN,MYVARS("FINDCALL")="",MYVARS("SELECTION")=$G(AGSELECT),MYVARS("SITE")=DUZ(2)
 D EDITCHEK^AGEDERR(.MYERRS,.MYVARS,1)
 Q
 ; ****************************************************************
 ; ON LINES BELOW:
 ; PIECE 1= FLD LBL
 ; PIECE 2= POSITION ON LINE TO DISP FLD
 ; PIECE 3= FILE #
 ; PIECE 4= FIELD #
1 ;
 ;;EMERGENCY CONTACT^5^2^.331
 ;;EC PHONE^14^2^.339
 ;;EC RELATIONSHIP^7^9000001^3102
 ;;EC ADDRESS-STREET^5^2^.333
 ;;EC ADDRESS-CITY^7^2^.336
 ;;EC ADDRESS-STATE^6^2^.337
 ;;EC ADDRESS-ZIP^8^2^.338
 ;;NEXT OF KIN^11^2^.211
 ;;NOK PHONE^13^2^.219
 ;;NOK RELATIONSHIP^6^9000001^2802
 ;;NOK ADDRESS-STREET^4^2^.213
 ;;NOK ADDRESS-CITY^6^2^.216
 ;;NOK ADDRESS-STATE^5^2^.217
 ;;NOK ADDRESS-ZIP^7^2^.218
