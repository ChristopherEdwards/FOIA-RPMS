PSJUTL2  ;BIR/LDT - MISC UTILITIES FOR INPATIENT MEDICATIONS ;18 Aug 98 / 2:48 PM
 ;;5.0; INPATIENT MEDICATIONS ;**63,58,81,105**;16 DEC 97
 ;
 ; Reference to ^PS(55 is supported by DBIA# 2191.
 ; Reference to ^PSBAPIPM is supported by DBIA# 3564.
 ;
BCMALG(PSJX,PSJY)     ;Returns BCMA Last Action formatted for printing
 N PSJLAST S PSJLACT=""
 I PSJY["V" Q:$G(^PS(55,PSJX,"IV",+PSJY,.2))="" ""
 S PSJLAST=$$EN^PSBAPIPM(PSJX,PSJY)
 I PSJLAST]"" S PSJLACT="BCMA ORDER LAST ACTION: "_$$ENDTC1^PSGMI($P(PSJLAST,"^",2))_" "_$$EXTERNAL^DILFD(53.79,.09,"",$P(PSJLAST,"^",3))
 I PSJLAST="" D PREV
 Q PSJLACT
 ;
PREV ;If the original order has no administration data logged against it then check to see if there is data for the previous order.
 N PREON
 S PREON=$S(PSJY["V":$P($G(^PS(55,PSJX,"IV",+PSJY,2)),"^",5),PSJY["U":$P($G(^PS(55,PSJX,5,+PSJY,0)),"^",25),1:$P($G(^PS(53.1,+PSJY,0)),"^",25))
 I PREON]"" S PSJLAST=$$EN^PSBAPIPM(PSJX,PREON)
 I PSJLAST]"" S PSJLACT="BCMA ORDER LAST ACTION: "_$$ENDTC1^PSGMI($P(PSJLAST,"^",2))_" "_$$EXTERNAL^DILFD(53.79,.09,"",$P(PSJLAST,"^",3))_"*"
 Q
 ;
DATE() ;Returns date in fileman format with a time in hours and minutes.
 S PSGDT="" N X,TIM
 D NOW^%DTC D
 .I $L(%)=12 S X=% Q
 .I $L(%)=14 S X=$E(%,13,14) S:X>29 X=$E(%,1,12)_5 S:X'>29 X=$E(%,1,12)_1 Q
 .I $L(%)=13 S X=$E(%,13)_0 S:X>29 X=$E(%,1,12)_5 S:X'>29 X=$E(%,1,12)_1 Q
 S PSGDT=$S($G(X)]"":+$FN($G(X),"",4),1:PSJDT) I '$P(PSGDT,".",2) S PSGDT=$$FMADD^XLFDT(PSGDT,-1,0,0,0)_.24
 S TIM=$P(PSGDT,".",2) I $E(TIM,3)=6 S TIM=$E(TIM,1,2)+1,PSGDT=$P(PSGDT,".")_"."_$TR($J(TIM,2)," ",0)
 Q PSGDT
 ;
DATE2(PSJDT) ;Returns date in fileman format with a time in hours and minutes
 Q:'$G(PSJDT) ""
 N X,TIM D
 .I $L(PSJDT)=12 S X=PSJDT Q
 .I $L(PSJDT)=14 S X=$E(PSJDT,13,14) S:X>29 X=$E(PSJDT,1,12)_5 S:X'>29 X=$E(PSJDT,1,12)_1 Q
 .I $L(PSJDT)=13 S X=$E(PSJDT,13)_0 S:X>29 X=$E(PSJDT,1,12)_5 S:X'>29 X=$E(PSJDT,1,12)_1 Q
 S PSJDT=$S($G(X)]"":+$FN($G(X),"",4),1:PSJDT) I '$P(PSJDT,".",2) S PSJDT=$$FMADD^XLFDT(PSJDT,-1,0,0,0)_.24
 S TIM=$P(PSJDT,".",2) I $E(TIM,3)=6 S TIM=$E(TIM,1,2)+1,PSJDT=$P(PSJDT,".")_"."_$TR($J(TIM,2)," ",0)
 Q PSJDT
