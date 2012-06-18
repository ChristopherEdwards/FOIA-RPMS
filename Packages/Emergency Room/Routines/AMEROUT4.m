AMEROUT4 ; IHS/ANMC/GIS - HOURLY WORKLOAD REPORTS ; 
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
NEW N X,Y,Z,%,AMERHSRT,DN1,DN2,DDB,AMERFLTR S AMERFLTR=0
 K ^TMP("AMER HOUR",$J),^TMP("AMER HF",$J),^TMP("AMER PRINT",$J)
RUN D SORT I $D(AMERQUIT) G EXIT
 D FILTER^AMEROUT5 I $D(AMERQUIT) G EXIT
 ;
 ; Allow user to pick a shift to report on
 S AMERSHFT=$$SHIFT()
 I AMERSHFT'=-1 D
 .D GET(AMERSHFT)
 .D SUBTOT(AMERSHFT)
 .D FORMAT(AMERSHFT)
 .D ZIS^AMEROUT5
 .Q
 ;
EXIT ;ENTRY POINT FROM AMEROUT5
 K ^TMP("AMER HOUR",$J),^TMP("AMER TOT",$J),^TMP("AMER PRINT",$J)
 Q
 ;
SORT ; SORT BY PROVIDER?
 S DIR(0)="SO^1:SORT BY A SPECIFIC PROVIDER;2:SORT BY ALL PROVIDERS;3:DO NOT SORT BY PROVIDER",DIR("A")="Sort option",DIR("?")="",DIR("B")=3 D ^DIR K DIR
 D OUT^AMEROUT I $D(AMERQUIT) Q
 I Y=3 S AMERHSRT="" Q
 I Y=2 S AMERHSRT=0 Q
 N DIC S DIC="^VA(200,",DIC("A")="Enter PROVIDER NAME: ",DIC(0)="AEQM"
 ; Screen so only providers with key can be selected
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 D ^DIC,OUT^AMEROUT I $D(AMERQUIT) Q
 I $G(Y)'>0 G SORT
 S AMERHSRT=+Y
 Q
 ;
GET(AMERSHFT) ; GET ENTRIES WITHIN THE SORT RANGES
 N A,B,C,N,I,%,D,X,Y,Z
 S D=$O(^AMERVSIT("B",AMERD1),-1),I=0
 ; Looking at every visit time stamp, quitting if the time stamp is bigger than end date
 F  S D=$O(^AMERVSIT("B",D)) Q:'D  Q:D>AMERD2  S N=0 F  S N=$O(^AMERVSIT("B",D,N)) Q:'N  S X=$G(^AMERVSIT(N,0)),Y=$G(^(6)) I X]"",Y]"" D
 .I AMERHSRT,$P(Y,U,3)'=AMERHSRT Q
 .; If we are sorting by provider, quit if this isn't the provider we are working with right now
 .S %=+X
 .; quit if this isn't the time range we are working with
 .I $P(AMERSHFT,U,1)>+$E($P(%,".",2),1,2) Q
 .I +$E($P(%,".",2),1,2)>$P(AMERSHFT,U,2) Q
 .S I=I+1
 .S A("TIME")=+$E($P(%,".",2),1,2),A("DAY")=$P(%,"."),%=$P(X,U,17),A("AGE")="" I % S A("AGE")=(%<14)
 .S A("ETOH")=+$P($G(^AMERVSIT(N,11)),U)
 .S A("TRAUMA")=($P($G(^AMERVSIT(N,3)),U)>0)
 .S A("PRV")=$P(Y,U,3) I A("PRV")="" Q  ; MISSING PROVIDER
 .S A("P TIME")=$P($G(^AMERVSIT(N,12)),U,3),A("T TIME")=$P($G(^(12)),U,4)
 .I AMERFLTR D
 ..S %=A("P TIME") I %,%>240 S A("P TIME")=""
 ..S %=A("T TIME") I %,%<-5,%>120 S A("T TIME")=""
 ..Q
 .S %=A("AGE")_U_A("ETOH")_U_A("TRAUMA")_U_A("T TIME")_U_A("P TIME")
 .S ^TMP("AMER HOUR",$J,$S(AMERHSRT="":0,1:A("PRV")),A("DAY"),A("TIME"),N)=%
 .Q
 Q
 ;
SUBTOT(AMERSHFT) ; COMPUTE THE HOURLY SUBTOTALS
 N D,H,A,E,T,G,N,F,X,%,P,V,AMERPRV,AMERI
 S G="^TMP(""AMER HOUR"",$J,AMERPRV)"
 S AMERPRV="" F  S AMERPRV=$O(@G) Q:AMERPRV=""  S D=0 F  S D=$O(@G@(D)) Q:'D  D
 .K F S AMERI=0
 .; LOOP control modified to only total the selected shift
 .F H=$P(AMERSHFT,U,1):1:$P(AMERSHFT,U,2) D
 ..;IF THERE IS SOMETHING FOR THIS DATE AT THIS HOUR SET F(H)
 ..I '$O(@G@(D,H,0)) S F(H)="" Q
 ..K P,V S (A,E,T,P,V,N,I)=0
 ..F  S N=$O(@G@(D,H,N)) Q:'N  S X=@G@(D,H,N) D
 ...S AMERI=AMERI+1,I=I+1
 ...S %=+X I % S A=A+1
 ...S %=$P(X,U,2) I % S E=E+1
 ...S %=$P(X,U,3) I % S T=T+1
 ...S %=$P(X,U,4) I % D
 ....S P=P+1
 ....I P=1 S P(0)=%,P(1)=%,P(2)=% Q
 ....S P(2)=P(2)+%
 ....I %<P(0) S P(0)=% Q
 ....I %>P(1) S P(1)=%
 ....Q
 ...S %=$P(X,U,5) I % D
 ....S V=V+1
 ....I V=1 S V(0)=%,V(1)=%,V(2)=% Q
 ....S V(2)=V(2)+%
 ....I %<V(0) S V(0)=% Q
 ....I %>V(1) S V(1)=%
 ....Q
 ...Q
 ..I P S %=P(2)/P,P(3)=$J(%,0,1)
 ..I V S %=V(2)/V,V(3)=$J(%,0,1)
 ..S %=I_U_A_U_E_U_T_U_$G(P(0))_U_$G(P(1))_U_$G(P(3))_U_$G(V(0))_U_$G(V(1))_U_$G(V(3))
 ..S F(H)=%
 ..Q
 .S %=$S(AMERHSRT="":0,1:AMERPRV)
 .M ^TMP("AMER TOT",$J,%,D)=F      ;M(ERGE) command
 .D TOTALS(AMERPRV,AMERI,D)
 .Q
 Q
 ;
TOTALS(P,J,D) ; GET TOTALS AND AVERAGES FOR A GIVEN PROVIDER-DAY
 ; 1=TOTAL,2=AGE<14,3=ETOH,4=TRAUMA,5=P MIN,6=P MAX,7=P AVE,8=T MIN,9=T MAX,10=T AVE
 N X,H,%,I,T,J,K,L,M,R,Q
 F I=1:1:10 S T(I)=0 I I>4 S T(I,0)=0
 F I=11:1:16 S T(I)=""
 S H="" F  S H=$O(F(H)) Q:H=""  S X=F(H) F I=1:1:10 I $P(X,U,I)]"" S T(I)=$P(X,U,I)+T(I) I I>4 S T(I,0)=T(I,0)+1
 F I=5:1:10 S %=T(I,0) I % S %=T(I)/T(I,0),T(I+6)=$J(%,0,1)
 S (J,K,L,M)=0,Q=""
 F  S Q=$O(^TMP("AMER HOUR",$J,P,D,Q)) Q:'Q  S R=0 F  S R=$O(^TMP("AMER HOUR",$J,P,D,Q,R)) Q:'R  S Z=^(R),%=$P(Z,U,4) S:%]"" J=J+1,K=K+% S %=$P(Z,U,5) S:%]"" L=L+1,M=M+%
 S T(13)="" I J S %=K/J,T(13)=$J(%,0,1)
 S T(16)="" I L S %=M/L,T(16)=$J(%,0,1)
 S ^TMP("AMER TOT",$J,P,D)=T(1)_U_T(2)_U_T(3)_U_T(4)_U_T(11)_U_T(12)_U_T(13)_U_T(14)_U_T(15)_U_T(16)
 Q
 ;
FORMAT(AMERSHFT) ; CREATE FORMATTED OUTPUT AND STORE IN AN ARRAY
 N A,B,C,X,Y,Z,%,I,J,H,L,S,OCXI
 S OCXI=0
 S A="VISIT TIME^# PTS^MINS TO TRIAGER ^MINS TO PROVIDER^AGE<14^ETOH^INJURY"
 S B=0,J=0 F I=1:1:($L(A,U)-1) S X=$P(A,U,I),J=J+$L(X)+2,B=B_U_J
 S C="" F I=1:1:$L(A,U) S X=$P(A,U,I) S:C]"" C=C_U S C=C_$L(X)
 S H="" F I=1:1:$L(A,U) S:H]"" H=H_"  " S H=H_$P(A,U,I)
 S %="MIN   MAX   AVE"
 S X="",$P(X," ",$P(B,U,3)+1)="" S Z=X_%_"   "_%
 S %="----  ----  ----"
 S L="" F I=1:1:7 S X=$P(C,U,I) D
 . I L]"" S L=L_"  "
 . I I=3!(I=4) S L=L_% Q
 . S Y="",$P(Y,"-",X+1)="",L=L_Y
 . Q
 I $O(^TMP("AMER TOT",$J,0)) D F1(AMERSHFT) Q
 D F2(0,AMERSHFT)
 Q
 ;
INC(X) ; STORE A PRINTABLE LINE IN THE ARRAY
 S OCXI=OCXI+1
 S ^TMP("AMER PRINT",$J,OCXI)=X
 Q
 ;
F2(P,AMERSHFT) ; DATE SORT
 N A,D,X,T,Y S D=0
 F  S D=$O(^TMP("AMER TOT",$J,P,D)) Q:'D  D
 .S Y=D X ^DD("DD") D INC(Y),INC(H),INC(Z),INC(L)
 .S T="" F  S T=$O(^TMP("AMER TOT",$J,P,D,T)) Q:T=""  S X=^(T) D
 ..I T=12 D
 ...D INC("<>")
 ...I $P($G(AMERSHFT),U,3)=0 D INC(H),INC(Z),INC(L)
 ..S A=$$HOUR(T)_"   "_$J(+X,$P(C,U,2))_"  "
 ..; Only print if not "daily"
 ..I X=""&$P($G(AMERSHFT),U,3)=0 D INC(A) Q
 ..F I=5:1:7 S %=$P(X,U,I) S:% %=%\1,%=$J(%,4),A=A_%_"  "
 ..F I=8:1:10 S %=$P(X,U,I) S:% %=%\1,%=$J(%,4),A=A_%_"  "
 ..F I=2:1:4 S %=$P(X,U,I),%=$J(%,$P(C,U,I+3)) S A=A_%_"  "
 ..; Only print if not "daily"
 ..I $P($G(AMERSHFT),U,3)=0 D INC(A)
 ..Q
 .D F3(P,D)
 .Q
 Q
 ;
F1(AMERSHFT) ; PROVIDER LOOP
 N P S P=0
 F  S P=$O(^TMP("AMER TOT",$J,P)) Q:'P  D:$O(^(P),-1) INC("<>") D INC($P(^VA(200,P,0),U)),F2(P,AMERSHFT)
 Q
 ; 
HOUR(X) ; CONVERT TIME TO HOUR RANGE
 N Y,Z,%
 I X=24 S X=0
 S Y=X_"00" I $L(Y)=3 S Y="0"_Y
 S Z=X_"59" I $L(Z)=3 S Z="0"_Z
 S %=Y_"-"_Z
 Q %
 ;
F3(P,D) ; TOTALS
 N X,Y,Z,%,A,I
 S X=$G(^TMP("AMER TOT",$J,P,D)) I X="" Q
 S A="TOTALS      "_$J(+X,5)
 S %="",$P(%," ",39)="",A=A_%
 F I=2:1:4 S %=$P(X,U,I),%=$J(+%,$P(C,U,I+3))_"  " S A=A_%
 D INC(" "),INC(A)
 S A="AVERAGES           "
 F I=5:1:10 S %=$P(X,U,I) S:%]"" %=%\1 S %=$J(%,4)_"  " S A=A_%
 D INC(A)
 Q
 ;
SHIFT() ;Allow user to select "DAILY TOTALS ONLY"
 ; OR
 ; Allow a start and stop military hour to be selected 
 N DIR,AMERTEMP,AMERRTRN,AMERSHOW,Y
 ; If daily totals are desired return 24 hour shift and a flag and quit
 S DIR("A")="Report daily totals only"
 S DIR(0)="Y",DIR("B")="YES"
 D ^DIR
 I Y=1 S AMERRTRN="00^23^1" Q AMERRTRN
 ; Daily totals are not desired, so allow START and STOP hour to be selected
 S DIR("B")=24
 S DIR(0)="N^1:24:0",DIR("A")="Enter STARTING hour",DIR("?")="Enter a number between 1-24"
 D ^DIR
 I Y=""!(Y="^") S AMERRTRN=-1
 E  D
 .S:Y=24 Y="00"
 .S AMERRTRN=Y
 .S AMERSHOW=Y_"00" I $L(AMERSHOW)=3 S AMERSHOW="0"_AMERSHOW
 .Q
 I AMERRTRN=-1 Q AMERRTRN
 S DIR("B")=24
 S DIR(0)="N^1:24:0",DIR("A")="Enter ENDING hour",DIR("?")="Enter a number between 1-24"
 D ^DIR
 I Y=""!(Y="^") S AMERRTRN=-1 Q AMERRTRN
 E  D
 .S Y=Y-1
 .S:Y=0 Y="00"
 .S AMERRTRN=AMERRTRN_"^"_Y
 .S AMERTEMP=Y_"59" I $L(AMERTEMP)=3 S AMERTEMP="0"_AMERTEMP
 .S AMERSHOW=AMERSHOW_"^"_AMERTEMP
 .Q
 S AMERRTRN=AMERRTRN_"^0"
 D EN^DDIOL("Reporting from: "_$P(AMERSHOW,U,1)_" to: "_$P(AMERSHOW,U,2),"","!!")
 Q AMERRTRN
