ABSPOSQP ; IHS/FCS/DRS - SGM 05:46 PM 20 Jan 1997 ;     [ 09/12/2002  10:18 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,12,40**;JUN 21, 2001
 ; Entry points:
 ;   EN     called from ABSPOSQB from ABSPOSQ1
 ;   PAGE7  called from ABSPOSI7
 ;
 ;----------------------------------------------------------------------
 ;IHS/SD/lwj 3/1/05 patch 12
 ; Puyallup noticed that the calculation for determining the price
 ; differed between the original claim and the "new" claim.  Pam and
 ; Carlene authorized the logic to be altered to be consistent between
 ; the two.  Need to check for zero and null, not just null.
 ;----------------------------------------------------------------------
 Q
EN ;EP -   PRICING   ; called from ABSPOSQB
 ;
 ; Need lots of stuff set up
 ; including ABSBRXI,ABSBRXR,ABSBNDC,INSURER
 ; Set up lots of variables:
 ;  DRGDFN,DRGNAME
 ;  PROVDFN,PROV
 ;  PRICING,PRICALC
 ;  where PRICING=qty^unit price^subtotal^disp fee^total^^incentive amount
 ;     (Not necessarily rounded off until "total")
 ; Stores PRICING in the ^ABSPT(ABSBRXI,5) for you.
 ;
 N DRGDFN S DRGDFN=ABSBDRGI
 S DRGNAME=$P($G(^PSDRUG(DRGDFN,0)),U,1) ; (DRUG,GENERIC NAME)
 I DRGNAME="" S DRGNAME="Missing ^PSDRUG("_DRGDFN_")"
 S PROVDFN=$P($G(^PSRX(ABSBRXI,0)),U,4) ; (PRESCRIPTION,PROVIDER)
 I PROVDFN S PROV=$P($G(^VA(200,PROVDFN,0)),U,1)
 E  S PROV=""
 I PROV="" S PROV="Missing ^VA(200,"_PROVDFN_")"
 D PRICING()
 Q
METHNUM()          ; pricing method number
 N METHOD S METHOD=0
 I INSURER S METHOD=$P($G(^ABSPEI(INSURER,100)),U,6)
 I 'METHOD S METHOD=1
 Q METHOD
METHOD() ; what pricing method to use?
 ; point to an entry in 9002313.53 and return the zero node
 Q $G(^ABSP(9002313.53,$$METHNUM,0))
GETAWP() ; Given ABSBNDC, get AWP-MED TRANSACTION file's avg. wholesale price
 I ABSBNDC="" Q "" ; should never happen, in theory, but it does
 N X S X=$O(^APSAMDF("B",ABSBNDC,0))
 I X Q $P($G(^APSAMDF(X,0)),U,3)
 E  Q ""
GETAWPPD()         ; Given DRGDFN
 Q $P($G(^PSDRUG(DRGDFN,999999931)),U,2) ; AWP PER DISP UNIT field
GETPPDU()          ; Given DRGDFN
 Q $P($G(^PSDRUG(DRGDFN,660)),U,6) ; PRICE PER DISPENSE UNIT
GETCPTRT()         ; Given DRGDFN, try to find it in the CHARGE file RATE field
 N CPTDFN S CPTDFN=$O(^ABSCPT(9002300,"AVMED",DRGDFN,0))
 I 'CPTDFN Q ""
 Q $P($G(^ABSCPT(9002300,CPTDFN,0)),U,5)
GETPSRXA()         ; get unit price from ^PSRX prescription file, AWP field
 I '$G(ABSBRXR) Q $P($G(^PSRX(ABSBRXI,9999999)),U,6)
 E  Q $P($G(^PSRX(ABSBRXI,1,ABSBRXR,9999999)),U,6)
GETPSRXU()         ; get unit price from ^PSRX prescription file
 I '$G(ABSBRXR) Q $P(^PSRX(ABSBRXI,0),U,17)
 Q $P(^PSRX(ABSBRXI,1,ABSBRXR,0),U,11)
UNITPRI()          ;  unit price ; NOT ROUNDED!!!
 ; KEEP UNITPRI1() BASICALLY THE SAME AS UNITPRI!!
 ; If one method fails, others might be tried
 N X,Y ; METHOD already set up by caller
 S Y=$P(METHOD,U,2),X=""
 I Y="APSAMDF" S X=$$GETAWP
 I Y="PSDRUG-AWPPDU" S X=$$GETAWPPD
 I Y="PSDRUG-PPDU" S X=$$GETPPDU
 I Y="PSRX-AWP" S X=$$GETPSRXA
 I Y="PSRX-UNIT" S X=$$GETPSRXU
 I Y="ABSCPT" S X=$$GETCPTRT
 ; If primary method failed, try all the others, finally default to $1
 I 'X S X=$$GETAWP ; these are in order of priority, from highest...
 I 'X S X=$$GETAWPPD
 I 'X S X=$$GETPSRXA
 I 'X S X=$$GETPSRXU
 I 'X S X=$$GETPPDU
 I 'X S X=$$GETCPTRT ; ... to lowest
 I 'X S X=1.001 ; just stuff this price for now
 I $P(METHOD,U,3)="STEP" S X=$$STEP(X)
 ; E  it must be ="LINEAR"
 Q X
UNITPRI1()         ; same as UNITPRI except retval is price^method
 N X,Y ; caller already set up method
 S Y=$P(METHOD,U,2)
 S X=$$UNITPRI2(Y) ; try the primary method first
 ; and if it failed, try all the other methods, in order
 ;IHS/SD/lwj 3/1/05 patch 12 - nxt seven lines remkd out
 ; following 7 lines added.  Logic altered to match the
 ; calculation of price for the original claim - need to
 ; check for zero and null - not just null.
 ;
 ;I X="" S X=$$UNITPRI2("APSAMDF")
 ;I X="" S X=$$UNITPRI2("PSDRUG-AWPPDU")
 ;I X="" S X=$$UNITPRI2("PSDRUG-PPDU")
 ;I X="" S X=$$UNITPRI2("PSRX-AWP")
 ;I X="" S X=$$UNITPRI2("PSRX-UNIT")
 ;I X="" S X=$$UNITPRI2("ABSCPT")
 ;I X="" S X=$$UNITPRI2("")
 ;
 I 'X S X=$$UNITPRI2("APSAMDF")
 I 'X S X=$$UNITPRI2("PSDRUG-AWPPDU")
 I 'X S X=$$UNITPRI2("PSDRUG-PPDU")
 I 'X S X=$$UNITPRI2("PSRX-AWP")
 I 'X S X=$$UNITPRI2("PSRX-UNIT")
 I 'X S X=$$UNITPRI2("ABSCPT")
 I 'X S X=$$UNITPRI2("")
 ;
 Q X
UNITPRI2(Y)        ; given Y = method,
 ; return  unit price ^ method,
 ;  or return "" if price not found using that method
 I Y="APSAMDF" S X=$$GETAWP
 E  I Y="PSDRUG-AWPPDU" S X=$$GETAWPPD
 E  I Y="PSDRUG-PPDU" S X=$$GETPPDU
 E  I Y="PSRX-AWP" S X=$$GETPSRXA
 E  I Y="PSRX-UNIT" S X=$$GETPSRXU
 E  I Y="ABSCPT" S X=$$GETCPTRT
 E  I Y="" S Y="NOT FOUND",X=1.01 ; hardcode desperation default of $1.01 per unit
 E  D IMPOSS^ABSPOSUE("DB,P","TI","No match on price source "_Y,,"UNITPRI2",$T(+0))
 Q $S(X="":"",1:X_U_Y)
STEP(X) ; INCOMPLETE!!!!   deal with step formula in 9002313.53
 D IMPOSS^ABSPOSUE("DB,P","TI","STEP formulas not implemented",,"STEP",$T(+0))
 Q
 ; This is what Cherokee will want to have
 ;S PRICALC=PRICALC_"$$STEP("_X_")="
 ; then compute it
 ;S PRICALC=PRICALC_result 
 ;S PRICALC=PRICALC_";"
 ;Q retval
PRICING()          ; compute the price - want to integrate with $$UNITPRI
 S PRICALC="" ; side effect - sets PRICALC
 N METHOD S METHOD=$$METHOD ; pricing method data
 ; METHOD = name^unit price source^formula^multiplier^disp fee
 N QTY S QTY=$$QTY I QTY'=1 S PRICALC=PRICALC_QTY
 N UNITPRI S UNITPRI=$$UNITPRI S PRICALC=PRICALC_"*"_UNITPRI
 N MULTIP S MULTIP=$P(METHOD,U,4) S:'MULTIP MULTIP=1
 I MULTIP'=1 S UNITPRI=UNITPRI*MULTIP,PRICALC=PRICALC_"*"_MULTIP
 N DISPFEE S DISPFEE=$$DISPFEE I DISPFEE S PRICALC=PRICALC_"+"_DISPFEE
 ;IHS/OIT/SCR 11/20/08 ADD INCENTIVE AMOUNT SUBMITTED TO PRICING
 N ABSPINCN S ABSPINCN=0 S PRICALC=PRICALC_"+"_ABSPINCN
 ;N X S X=$$ROUND(UNITPRI*QTY+DISPFEE) S PRICALC=PRICALC_"="_X
 N X S X=$$ROUND(UNITPRI*QTY+DISPFEE+ABSPINCN) S PRICALC=PRICALC_"="_X
 S PRICING=QTY_U_UNITPRI_U_(QTY*UNITPRI)_U_DISPFEE_U_X
 S PRICING=PRICING_U_U_ABSPINCN ;IHS/OIT/SCR 11/20/08
 S ^ABSPT(IEN59,5)=PRICING
 Q:$Q X Q
IEN59() Q ABSBRXI_"."_$TR($J(ABSBRXR,4)," ","0")_"1"
ROUND(X) Q X*100+.5\1/100 ; round to the nearest cent
QTY() ; given ABSBRXI, ABSBRXR
 I $G(ABSBRXR) Q $P($G(^PSRX(ABSBRXI,1,ABSBRXR,0)),U,4) ; REFILL,QTY
 Q $P($G(^PSRX(ABSBRXI,0)),U,7) ; QTY
DISPFEE()          ;
 N FEE
 ; First, see if we have a dispensing fee for this e-insurer.
 I INSURER D  I FEE]"" Q FEE
 . S FEE=$P($G(^ABSPEI(INSURER,100)),U,2)
 ;
 ; Default is in PEC/MIS - Setup file
 ; No, I guess there's none in there.
 ;
 ; There may be one in METHOD
 S FEE=$P($$METHOD,U,5) I FEE]"" Q FEE
 ;
 ; Next, we look in the BILLING SETUP file.
 ; Now there's a multiple on RX2 that varies the fee depending on cost.
 ; Ignore that for now, just take the constant value.
 ;
 S FEE=$P($G(^ABSSETUP(9002314,1,"RX")),U) ;RX MARKUP field
 I FEE]"" Q FEE
 ; Can't come up with a fee, just say zero for now.
 Q 0
PAGE7 ;EP -  called from ABSPOSI7 - pop-up page for pricing
 ; want to set some defaults
 I ^TMP("DDS",$J,$P(DDS,U),"F9002313.512",DDSDA,.02,"D")="" S DDSERROR=299 Q   ;IHS/OIT/CNI/SCR patch 40 avoid undefined when user saves blank RX
 N INSURER,ABSBRXI,ABSBRXR,DRGDFN,METHOD,ABSBNDC
 S INSURER=$$GET^DDSVAL(DIE,.DA,7.01)
 S ABSBRXI=$$GET^DDSVAL(DIE,.DA,1.01)
 I ABSBRXI="" D  Q  ; special case:  CPT code, not a prescription drug
 . N CPTIEN S CPTIEN=$$GET^DDSVAL(DIE,.DA,1.08)
 . I 'CPTIEN D IMPOSS^ABSPOSUE("DB,P","TI","code for supply item is not yet here? should be",,"PAGE7",$T(+0))
 . ; must have CPTIEN by now ?!
 . I $$GET^DDSVAL(DIE,.DA,5.01)="" D PUT^DDSVAL(DIE,.DA,5.01,1)
 . I $$GET^DDSVAL(DIE,.DA,5.02)="" D
 . . N PRICE S PRICE=$P(^ABSCPT(9002300,CPTIEN,0),U,5)
 . . I PRICE="" D  Q
 . . . D PUT^DDSVAL(DIE,.DA,5.03,"")
 . . . D PUT^DDSVAL(DIE,.DA,5.04,"")
 . . . D PUT^DDSVAL(DIE,.DA,5.05,"")
 . . E  D
 . . . D PUT^DDSVAL(DIE,.DA,5.02,PRICE)
 . . . D PUT^DDSVAL(DIE,.DA,5.04,0)
 . . . D PUT^DDSVAL(DIE,.DA,5.06,"ABSCPT",,"I")
 . . . D RECALC1^ABSPOSI7
 S ABSBRXR=$$GET^DDSVAL(DIE,.DA,1.02)
 S METHOD=$$METHOD
 S DRGDFN=$$GET^DDSVAL(DIE,.DA,1.03)
 S ABSBNDC=$$GET^DDSVAL(DIE,.DA,.03)
 I ABSBNDC["-" S ABSBNDC=$$MAKE11N^ABSPOS9(ABSBNDC)
 D PUT^DDSVAL(DIE,.DA,5.01,$$QTY)
 N X S X=$$UNITPRI1 ; price^source
 D PUT^DDSVAL(DIE,.DA,5.02,$$ZEROES($P(X,U)))
 D PUT^DDSVAL(DIE,.DA,5.04,$J($$DISPFEE,0,2))
 D PUT^DDSVAL(DIE,.DA,5.06,$P(X,U,2),,"I")
 ;IHS/OIT/SCR 11/20/08 add INCENTIVE AMOUNT
 N ABSPINCT
 S ABSPINCT=$$GET^DDSVAL(DIE,.DA,5.07)
 I ABSPINCT="" S ABSPINCT=0
 D PUT^DDSVAL(DIE,.DA,5.07,$$ZEROES(ABSPINCT))
 ;IHS/OIT/SCR 11/19/08 END CHANGES
 D RECALC1^ABSPOSI7 ; do the math
 Q
ZEROES(X)          ; strip leading and trailing zeroes, and "." if not needed
 F  Q:$E(X)'="0"  S X=$E(X,2,$L(X))
 I X["." D
 . F  Q:$E(X,$L(X))'="0"  S X=$E(X,1,$L(X)-1)
 I $E(X,$L(X))="." S X=$E(X,1,$L(X))
 Q X
NEWENTRY ;EP - this is called by ENTRY ACTION of option ABSP SETUP PRICING
 N COUNT S COUNT=$P(^ABSP(9002313.53,0),U,4)
 W !!,"At this time, you have "
 I COUNT=1 D
 . W "only the STANDARD pricing formula.",!
 E  D
 . W COUNT," pricing formulas on file.",!
 . D ASK^ABSPOSS3 ; "Do you want to see a list?"
 Q
