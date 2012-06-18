ACHSPAI ; IHS/ITSC/PMF - DOCUMENT PAYMENT - INTEREST & PENALTY ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
EDIT ;EP - From Option. Edit Interest and Penalty Data.
 Q
 ;
 D SEL^ACHSPAM       ;SELECT DOCUMENT AND DISPLAY DATA
 I $D(DUOUT)!($D(DTOUT))!'$D(ACHSDIEN) D END Q
 ;
 D PROMPT            ;input to Interest fields from EOBR.
 I $D(DUOUT)!$D(DTOUT) D END Q
 ;
 D PROCESS           ;
 ;
 D RTRN^ACHS
 ;
 D END
 Q
 ;
END ; Kill vars, quit.
 K DR,D0,D1
 Q
 ;
PROMPT ; Prompt user for input to Interest fields from EOBR.
 N DIC,DIE
 S:'$D(D0) D0=DUZ(2)
 S:'$D(D1) D1=ACHSDIEN
 I '$G(ACHSTIEN) S ACHSTIEN=$$SELTRANS^ACHSUD(ACHSDIEN)
 Q:$D(DUOUT)!$D(DTOUT)
 S DA(2)=DUZ(2),DA(1)=ACHSDIEN,DA=ACHSTIEN
 F ACHS=22:1:29 S ACHS(ACHS)=$$DIR^XBDIR("9002080.02,"_ACHS_"""","",$$VAL^XBDIQ1(9002080.02,.DA,ACHS)) Q:$D(DUOUT)!$D(DTOUT)  S:X="@" ACHS(ACHS)="@"
 Q
 ;
PROCESS ;TRY TO ENTER THE DATA
 I '$$DIET^ACHS("22////"_$P(ACHS(22),U)_";23////"_ACHS(23)_";24///"_ACHS(24)_";25///"_ACHS(25)_";26///"_ACHS(26)_";27///"_ACHS(27)_";28///"_ACHS(28)) D
 . W:'$D(ZTQUEUED) *7,"Interest data failed DIE at PROCESS^ACHSPAI"
 . I $D(ACHSISAO) S ACHSERRE=37,ACHSEDAT="" D ^ACHSEOBG   ;INTEREST DATA FAILED DIE;W
 ;
 Q
 ;
DISP ;EP - Display Interest info from selected doc.
 D ^ACHSUD
 Q:$D(DUOUT)!$D(DTOUT)!'$D(ACHSDIEN)
 S ACHSTIEN=$$SELTRANS^ACHSUD(ACHSDIEN)
 Q:$D(DUOUT)!$D(DTOUT)
 S DA(2)=DUZ(2),DA(1)=ACHSDIEN,DA=ACHSTIEN
 F ACHS=22:1:28 W !?5,$P(^DD(9002080.02,ACHS,0),U),$E($$REPEAT^XLFSTR(".",35),1,35-$L($P(^(0),U)))," ",$$VAL^XBDIQ1(9002080.02,.DA,ACHS)
 D RTRN^ACHS
 Q
 ;
INT ;EP - Calculate Interest amount.
 N ACHSP,ACHSI,ACHSD
 W !,"You need to enter Pay amount, Interest rate, and # days late."
 S ACHSP=$$DIR^XBDIR("N^::2","           Enter Payment Amount")
 Q:$D(DUOUT)!$D(DTOUT)
 S ACHSI=$$DIR^XBDIR("N^::2","Enter Interest Rate, e.g., 5.87")
 Q:$D(DUOUT)!$D(DTOUT)
 S ACHSD=$$DIR^XBDIR("N^::2","      Enter Number of Days Late")
 Q:$D(DUOUT)!$D(DTOUT)
 W !,"The calculated Interest Amount is $",$FN(ACHSP*ACHSI*.01*ACHSD/360,",",2)
 W !,"  ( amt * rate * days / 360 )"
 W !,"  ( ",ACHSP," * ( ",ACHSI," * .01 ) * ",ACHSD," / 360 )"
 D RTRN^ACHS
 Q
 ;
AUTO ;EP - For auto EOBR processing of Interest data.
 F ACHS=22:1:28 S ACHS(ACHS)=$G(ACHSEOBR("I",ACHS-14))
 ;
 ; Interest CAN
 S %=$O(^ACHS(2,"B",ACHS(22),0))
 I % S ACHS(22)=%
 E  I ACHS(22)?7UN S ACHSERRE=38,ACHSEDAT=ACHS(22) D ^ACHSEOBG
 I ACHS(22)?1." " S ACHS(22)=""
 ;
 ; Interest OCC
 S %=$O(^ACHS(3,DUZ(2),1,"B",ACHS(23),0))
 I % S ACHS(23)=%
 E  I ACHS(23)?4UN S ACHSERRE=39,ACHSEDAT=ACHS(23) D ^ACHSEOBG
 I ACHS(23)?1." " S ACHS(23)=""
 ;
 ; Interest Rate
 I ACHS(24) S %=ACHS(24),%=+$E(%,1,2)_"."_$E(%,3,5),ACHS(24)=%
 E  S ACHS(24)=""
 ;
 ; Interest Days Eligible
 I ACHS(25) S ACHS(25)=+ACHS(25)
 E  S ACHS(25)=""
 ;
 ; Interest Paid
 I ACHS(26) S %=ACHS(26),%=+$E(%,1,7)_"."_$E(%,8,9),ACHS(26)=%
 E  S ACHS(26)=""
 ;
 ; Interest Additional Penalty Paid
 I ACHS(27) S %=ACHS(27),%=+$E(%,1,4)_"."_$E(%,5,6),ACHS(27)=%
 E  S ACHS(27)=""
 ;
 ; Interest Total Paid This Transaction
 I ACHS(28) S %=ACHS(28),%=+$E(%,1,8)_"."_$E(%,9,10),ACHS(28)=%
 E  S ACHS(28)=""
 ;
 D PROCESS
 Q
 ;
