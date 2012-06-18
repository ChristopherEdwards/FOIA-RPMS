IBINI0AU	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.0304,11,21,0)
	;;=^^2^2^2931130^
	;;^DD(399.0304,11,21,1,0)
	;;=The diagnosis most closely related to this procedure.  Used only for the
	;;^DD(399.0304,11,21,2,0)
	;;=HCFA 1500, block 24e.
	;;^DD(399.0304,11,"DT")
	;;=2931130
	;;^DD(399.0304,12,0)
	;;=ASSOCIATED DIAGNOSIS (3)^*P362.3'^IBA(362.3,^0;13^S DIC("S")="I +$P(^IBA(362.3,Y,0),U,2)=+$G(DA(1))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.0304,12,3)
	;;=Enter a diagnosis related to this procedure.
	;;^DD(399.0304,12,12)
	;;=Only Diagnosis for this bill may be chosen.
	;;^DD(399.0304,12,12.1)
	;;=S DIC("S")="I +$P(^IBA(362.3,Y,0),U,2)=+$G(DA(1))"
	;;^DD(399.0304,12,21,0)
	;;=^^2^2^2931130^
	;;^DD(399.0304,12,21,1,0)
	;;=The diagnosis most closely related to this procedure.  Used only for the
	;;^DD(399.0304,12,21,2,0)
	;;=HCFA 1500, block 24e.
	;;^DD(399.0304,12,"DT")
	;;=2931130
	;;^DD(399.0304,13,0)
	;;=ASSOCIATED DIAGNOSIS (4)^*P362.3'^IBA(362.3,^0;14^S DIC("S")="I +$P(^IBA(362.3,Y,0),U,2)=+$G(DA(1))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.0304,13,3)
	;;=Enter a diagnosis related to this procedure.
	;;^DD(399.0304,13,12)
	;;=Only Diagnosis for this bill may be chosen.
	;;^DD(399.0304,13,12.1)
	;;=S DIC("S")="I +$P(^IBA(362.3,Y,0),U,2)=+$G(DA(1))"
	;;^DD(399.0304,13,21,0)
	;;=^^2^2^2931130^
	;;^DD(399.0304,13,21,1,0)
	;;=The diagnosis most closely related to this procedure.  Used only for the
	;;^DD(399.0304,13,21,2,0)
	;;=HCFA 1500, block 24e.
	;;^DD(399.0304,13,"DT")
	;;=2931130
	;;^DD(399.04,0)
	;;=CONDITION CODE SUB-FIELD^^.01^1
	;;^DD(399.04,0,"NM","CONDITION CODE")
	;;=
	;;^DD(399.04,0,"UP")
	;;=399
	;;^DD(399.04,.01,0)
	;;=CONDITION CODE^MSX^02:CONDITION EMPLOYMENT RELATED;03:PT COVERED BY INSURANCE NOT REFLECTED HERE;05:LIEN FILED;06:ESRD PT IN 1ST YR OF ENTITLEMENT;17:PT OVER 100 YRS. OLD;18:MAIDEN NAME RETAINED;^0;1^I X=17!(X=18) D AGE^IBCU K IBC
	;;^DD(399.04,.01,3)
	;;=Select code(s) used to identify conditions relating to this patient that may affect insurance processing.
	;;^DD(399.04,.01,"DT")
	;;=2930513
	;;^DD(399.041,0)
	;;=OCCURRENCE CODE SUB-FIELD^^.04^4
	;;^DD(399.041,0,"DIK")
	;;=IBXX
	;;^DD(399.041,0,"DT")
	;;=2931221
	;;^DD(399.041,0,"ID",.02)
	;;=W ""
	;;^DD(399.041,0,"IX","B",399.041,.01)
	;;=
	;;^DD(399.041,0,"NM","OCCURRENCE CODE")
	;;=
	;;^DD(399.041,0,"UP")
	;;=399
	;;^DD(399.041,.01,0)
	;;=OCCURRENCE CODE^M*P399.1'^DGCR(399.1,^0;1^S DIC("S")="I $P(^DGCR(399.1,+Y,0),U,4)=1,$S(+Y'=22:1,$P(^DPT($P(^DGCR(399,DA,0),U,2),0),U,2)=""F"":1,1:0)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.041,.01,1,0)
	;;=^.1
	;;^DD(399.041,.01,1,1,0)
	;;=399.041^B
	;;^DD(399.041,.01,1,1,1)
	;;=S ^DGCR(399,DA(1),"OC","B",$E(X,1,30),DA)=""
	;;^DD(399.041,.01,1,1,2)
	;;=K ^DGCR(399,DA(1),"OC","B",$E(X,1,30),DA)
	;;^DD(399.041,.01,3)
	;;=This code defines the event(s) relating to this bill which may affect           insurance processing.
	;;^DD(399.041,.01,9.6)
	;;=I X=10 S DFN=$P(^DGCR(399,DA,0),"^",2) I $D(^DPT(DFN,0)),$P(^DPT(DFN,0),"^",2)="M" W !!,"This patient is a MALE!! Occurrence Code 10 applies only to FEMALES!!",!! K DFN,X Q
	;;^DD(399.041,.01,12)
	;;=Valid MCCR Occurrence Codes only!
	;;^DD(399.041,.01,12.1)
	;;=S DIC("S")="I $P(^DGCR(399.1,+Y,0),U,4)=1,$S(+Y'=22:1,$P(^DPT($P(^DGCR(399,DA,0),U,2),0),U,2)=""F"":1,1:0)"
	;;^DD(399.041,.01,"DT")
	;;=2890131
	;;^DD(399.041,.02,0)
	;;=DATE^RD^^0;2^S %DT="E" D ^%DT S X=Y K:DT<X!(2000101>X) X
	;;^DD(399.041,.02,3)
	;;=TYPE A DATE ON OR BEFORE TODAY
	;;^DD(399.041,.02,21,0)
	;;=^^2^2^2931221^^
	;;^DD(399.041,.02,21,1,0)
	;;=This is the date that this event occured.
