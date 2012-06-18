ACRFDF ;IHS/OIRM/DSD/THL,AEF - DISTRIBUTE FUNDS; [ 07/23/2002  5:47 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**3**;NOV 05, 2001
 ;;ROUTINE USED TO MANAGE DISTRIBUTION OF FUNDS
EN ;EP;TO DISTRIBUTE FUNDS
 F  D EN1 Q:$D(ACRQUIT)!$D(ACROUT)!$D(@ACRGL@("M",ACRZDA))
EXIT K ACRX,ACRQUIT,ACRY,ACRZ,ACRDM,ACRDGDA,ACRDG,ACRGL,ACRCUM,ACRDFN,ACRGLB,ACRACTPT
 Q
EN1 ;SELECT TYPE OF DISTRIBUTION
 W @IOF
 W !,"Distribute Funds to:"
 S DIR(0)="SO^1:Distribution Group;2:Single Distribution^K:X'?1N!(X<1)!(X>2) X"
 S DIR("A")="  Option"
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)
 I X=1 D GROUP K ACRQUIT Q
 S:X=2 ACRQUIT=""
 Q
GROUP ;EP;TO DISTRIBUTE FUNDS TO A FUNDS DISTRIBUTION GROUP
 W !!,"Distribute Funds by:"
 S DIR(0)="SO^1:Percent;2:Standard Percent;3:Fixed Amount^K:X'?1N!(X<1)!(X>3) X"
 S DIR("A")="  Option"
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)
 S ACRDM=$S(X=1:1,X=2:2,1:3)
 S ACRGL=$P($P($T(@ACRENTRY^ACRFCTL1),";;",3),"(")
 D GET^ACRFEDG1
 Q:'$D(ACRDG)!$D(ACRQUIT)!$D(ACROUT)
 D DISPLAY^ACRFEDG
 S DIR(0)="YO"
 S DIR("A")="Distribute the funds to Group Members listed above"
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 Q:Y'=1
 S (ACRCUM,ACRX)=0
 F  S ACRX=$O(^ACRDG(ACRDGDA,"GP",ACRX)) Q:'ACRX  D GROUP1 Q:'$D(ACRX)   ;ACR*2.1*3.14
 Q:'$D(ACRX)
 F  D ED Q:$D(ACRQUIT)!$D(ACROUT)
 K ACRQUIT
 S DIR(0)="YO"
 S DIR("A")="Complete Distribution (Y/N)"
 W !
 D DIR^ACRFDIC
 I "N"[X!'$D(ACRX)!$D(ACRQUIT)!$D(ACROUT) D  Q
 .W !!,*7,*7,"This distribution was NOT completed."
 .W !,"You must begin again to complete the distribution."
 .H 2
 W !!,"To complete the Distribution you must enter detailed information"
 W !,"on each distribution.  This data entry process will now begin."
 S DIR(0)="YO"
 S DIR("A")="Sure you want to continue"
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 Q:Y'=1
 D DIST^ACRFDF1
 Q
GROUP1 N X,Y
 S X=$G(^ACRDG(ACRDGDA,"GP",ACRX,0))
 S Y=$G(^ACRDG(ACRDGDA,"GP",ACRX,"DT"))
 S ACRY=$P(X,U)
 S ACRACTPT=$P(X,U,2)
 S ACRGLB=$P(Y,U)
 S ACRDFN=$P(Y,U,2)
 D SARRAY^ACRFDF1
 I $D(ACRQUIT)!$D(ACROUT) D GMESS Q
 Q
ED ;DISPLAY AND EDIT CURRENT DISTRIBUTION
 W @IOF
 W !,"Current Distribution:"
 W !!,"ID NO."
 W ?8,"LOCATION"
 W ?40,$S(ACRDM=1:"PERCENT",1:"AMOUNT")
 W !,"------"
 W ?8,"------------------------------"
 W ?40,"------------"
 S (ACRZ,ACRX,ACRJ)=0
 F  S ACRX=$O(ACRX(ACRX)) Q:'ACRX  D ED1
 W !,"------"
 W ?8,"------------------------------"
 W ?40,"------------"
 W !?20,"TOTAL DISTRIBUTED:"
 W ?40,$J($FN(ACRZ,"P",2),10),$S(ACRDM=1:"%",1:"")
 I ACRDM=2 S ACRQUIT="" Q
 S DIR(0)="YO"
 S DIR("A")="Change Distribution (Y/N)"
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)!(X["N")
 S DIR(0)="NO^1:"_ACRJ_"^K:'$D(ACRX(X)) X"
 S DIR("A")="Which ID NO."
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)
 S ACRX=X
 S ACRY=$P(ACRX(X),U)
 S ACRCUM=ACRCUM-$P(ACRX(X),U,2)
 D SARRAY^ACRFDF1
 K ACRQUIT
 Q
ED1 ;DISPLAY DISTIBUTION
 S ACRJ=ACRJ+1
 W !,ACRX
 W ?8,$P(ACRX(ACRX),U)
 W ?40,$J($FN($P(ACRX(ACRX),U,2),"P",2),10)
 S ACRZ=ACRZ+$P(ACRX(ACRX),U,2)
 Q
PAUSE K ACRPSE
 S DIR(0)="YO"
 S DIR("A")="         List more MEMBERS"
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 Q:Y=1
 S ACRPSE=""
 Q
GMESS K ACRX
 W !!,*7,*7,"This distribution was not completed."
 W !,"All entries must be redone."
 Q
