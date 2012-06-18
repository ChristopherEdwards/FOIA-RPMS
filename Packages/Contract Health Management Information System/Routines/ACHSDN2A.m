ACHSDN2A ;IHS/ITSC/PMF - DENIAL SET UP & DISPLAY ;   [ 04/17/2002  2:08 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3,4,18,19**;JUN 11, 2001
 ;ACHS*3.1*3  handle 'Alternate resource available' special - ENTIRE ROUTINE IS NEW
 ;ACHS*3.1*4  remove blank spaces from an input
 ;ACHS*3.1*18 Request for type of insurance
 ;
 ;we get here if any of the reasons for this denial are
 ;Alternate Resource Available
 ;
 ;here we find out which alternate resource they mean
 ;
 ;ACHS*3.1*18 IHS/OIT/FCJ NEW SECTION FOR TYPE OF ALT RESOURCE
 ;ACHS*3.1*19 IHS/OIT.FCJ CHANGED ACHSCT TO ACHSOCT IN NXT SECTION
TYPPRI ;EP-ALT RES TYPE FOR PRIMARY REASON
 I $P(^ACHSDENS($$DN^ACHS(250,1),20,ACHDROPT,0),U)["IHS/Tribal" D DICFAC I +ACHDFC I '$$DIE^ACHSDN("253///"_ACHDFC) Q   ;ACHS*3.1*18 
 I ($P(^ACHSDENS($$DN^ACHS(250,1),20,ACHDROPT,0),U)["Eligible")!($P(^ACHSDENS($$DN^ACHS(250,1),20,ACHDROPT,0),U)["Failure") D
 .S ACHSQUIT=0,ACHSOCT=0
 .F  D  Q:(ACHSOCT>0)&(ACHSQUIT=1)
 ..S Y=+$$ALTOPT(ACHDENR) I Y<0 S ACHSQUIT=1
 ..I Y>0,$$DIE^ACHSDN("256///"_Y) S ACHSOCT=ACHSOCT+1,ACHSQUIT=0
 ..I ACHSOCT=0 W !,"You must enter a Alternate Resource Type."
 G:$P(^ACHSDENS($$DN^ACHS(250,1),20,ACHDROPT,0),U)["Other" ALT  ;ACHS*3.1*19 NOW TEST FOR OTHER BEFORE ASKING ALT
 Q   ;ACHS*3.1*19
 ;
TYPOTH ;EP-OTHER DENIAL REASON TYPE FOR ALT RES
 I $P(^ACHSDENS(ACHDOTR,20,ACHDROPT,0),U)["IHS/Tribal" D DICFAC I +ACHDFC S $P(^ACHSDEN(DUZ(2),"D",ACHSA,300,ACHDORNM,0),U,3)=+ACHDFC   ;ACHS*3.1*18
 I ($P(^ACHSDENS(ACHDOTR,20,ACHDROPT,0),U)["Eligible")!($P(^ACHSDENS(ACHDOTR,20,ACHDROPT,0),U)["Failure") D
 .S ACHSQUIT=0,ACHSOCT=0
 .S ^ACHSDEN(DUZ(2),"D",ACHSA,300,ACHDORNM,4,0)="^9002071.44^0^0"
 .S DA=0 F  D  Q:(ACHSOCT>0)&(ACHSQUIT=1)
 ..S Y=+$$ALTOPT(ACHDOTR) I +Y>0 S ACHSOCT=ACHSOCT+1
 ..I ACHSOCT=0 W !,"You must enter an Alternate Resource Type." Q
 ..I +Y<0,ACHSOCT>0 S ACHSQUIT=1 Q   ;ACHS*3.1*19
 ..S DA=DA+1
 ..S DIE="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",300,"_ACHDORNM_",4,"
 ..S DA(3)=DUZ(2)
 ..S DA(2)=ACHSA
 ..S DA(1)=ACHDORNM
 ..S DR=".01///"_Y
 ..D ^DIE
 ..S $P(^ACHSDEN(DUZ(2),"D",ACHSA,300,ACHDORNM,4,0),U,3,4)=DA_"U"_DA
 S ACHSQUIT=0
 ;;ACHS*3.1*18 IHS/OIT/FCJ END OF CHANGES
 Q:$P(^ACHSDENS(ACHDOTR,20,ACHDROPT,0),U)'["Other"   ;ACHS*3.1*19
ALT ;
 ;first of all, if this is not a registered patient, we
 ;can't do nothing here
 I '$G(DFN) Q
 ;set up some vars, then call a routine that returns this patient's
 ;alternate resource info in array INS
 S ACHSFDT=$G(ACHSFDT) I ACHSFDT="" S ACHSFDT=$G(ACHSDOS)
 I $G(DFN) D GET^ACHSRPIN,PRT^ACHSRPIN
 ;
 N OK,ZZ
 D GETREC
 ;
 ;if any quit condition occured, stop. Or, if none chosen, stop.
 I $D(DTOUT)!$D(DUOUT)!$G(ACHSQUIT)!'+Y Q
 ;
 ;if not quitting, then Y is a list of pointers to array INS,
 ;which is a list of resources.  Get the resource pointers out of
 ;INS and record them.
 ;
 N NUM
 K ^ACHSDEN(DUZ(2),"D",ACHSA,320)
 S ^ACHSDEN(DUZ(2),"D",ACHSA,320,0)=$$ZEROTH^ACHS(9002071,1,320)
 F ZZ=1:1:$L(Y,",") D
 . S NUM=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,320,0)),U,3)+1
 . S ^ACHSDEN(DUZ(2),"D",ACHSA,320,NUM,0)=NUM_U_$P(INS($P(Y,",",ZZ)),U,7,9)
 . S $P(^ACHSDEN(DUZ(2),"D",ACHSA,320,0),U,3,4)=NUM_U_NUM
 . Q
 ;
 Q
 ;
GETREC ;
 W !!,"Enter the number(s) of the resources relevant to this denial.",!,"If more than one, separate with commas  (1,2,3..): "
 D READ^ACHSFU
 I $D(DUOUT)!$D(DTOUT) Q
 I Y="" Q
 I Y?1N.N,(Y>0),(Y'>INS) Q
 ;
 ;ACHS*3.1*4  3/28/02  pmf  get rid of blanks
 S Y=$TR(Y," ")  ;  ACHS*3.1*4
 ;
 S OK=1 F ZZ=1:1:$L(Y,",") S X=$P(Y,",",ZZ) D  Q:'OK
 . I X'?1N.N S OK=0 Q
 . I X<1 S OK=0 Q
 . I X>INS S OK=0 Q
 . Q
 I 'OK W " ??",! G GETREC
 Q
 ;
ALTOPT(X,Y) ; --- Select ALT RES TYPE
 I '$D(^ACHSDENS(X,30,0)) Q -1
 N DIC
 W !!
 S DIC="^ACHSDENS("_X_",30,"
 S DIC(0)="QAEMZ"
 S DIC("A")="Enter "_$G(Y)_"Alternate Resource Type: "
 S DA(1)=X
 D ^DIC
 Q Y
DICFAC ;EP FR ACHSDN4
 N DIC
 W !!
 S ACHDFC="",DIC="^AUTTLOC(",DIC(0)="QAEM"
 S DIC("A")="Enter the IHS/Tribal Facility that was available: "
 D ^DIC S ACHDFC=+Y
 G:Y<0 DICFAC
 Q
