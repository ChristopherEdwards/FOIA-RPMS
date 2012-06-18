AMHLESHF ; IHS/CMI/LAB - calls from within screenman ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
HED ;EP - display last
 ;DISPLAY 2 YRS WORTH OF HF FROM MHSS/PCC
 I '$G(AMHPAT) S AMHMSG(1)="Unknown Patient" D HLP^DDSUTL(.AMHMSG) K AMHMSG Q
 NEW AMHX,AMHD,AMHC,AMHED,X,Y,R
 D HED1
 NEW C S C="Health Factors List for "_$P(^DPT(AMHPAT,0),U)
 D ARRAY^XBLM("^TMP(""AMHDSPEDS"",$J,",C)
 K ^TMP("AMHDSPEDS",$J),^TMP($J,"AMHGOT"),^TMP("AMHEDS",$J)
REFRESH ;
 S X=0 X ^%ZOSF("RM")
 W $P(DDGLVID,DDGLDEL,8)
 D REFRESH^DDSUTL
 Q
HED1 ;EP
 S %=$$FMADD^XLFDT(DT,-731),%1=""
 D GETMHED
 D GETPCCED
 D SETARRAY
 K ^TMP("AMHSEDS",$J)
 Q
SETARRAY ;
 K ^TMP("AMHDSPEDS",$J) S ^TMP("AMHDSPEDS",$J,0)=0
 S X=" " D S(X)
 S X=" " D S(X) S X="*** All health factors provided in past 2 years by BH programs ***" D S(X)
 S X="DATE",$E(X,11)="FACTOR",$E(X,44)="SEVERITY",$E(X,57)="QUANTITY",$E(X,68)="PROVIDER" D S(X)
 S X="----",$E(X,11)="------",$E(X,44)="--------",$E(X,57)="--------",$E(X,68)="--------" D S(X)
 S D=0 F  S D=$O(^TMP("AMHSEDS",$J,"M",D)) Q:D'=+D  D
 .S I=0 F  S I=$O(^TMP("AMHSEDS",$J,"M",D,I)) Q:I'=+I  S X=^TMP("AMHSEDS",$J,"M",D,I) D S(X)
 S X=" " D S(X) S X="*** All health factors documented in PCC in past 2 years ***" D S(X)
 S X="DATE",$E(X,11)="FACTOR",$E(X,44)="SEVERITY",$E(X,57)="QUANTITY",$E(X,68)="PROVIDER" D S(X,1)
 S X="----",$E(X,11)="------",$E(X,44)="--------",$E(X,57)="--------",$E(X,68)="--------" D S(X)
 S D=0 F  S D=$O(^TMP("AMHSEDS",$J,"P",D)) Q:D'=+D  D
 .S I=0 F  S I=$O(^TMP("AMHSEDS",$J,"P",D,I)) Q:I'=+I  S X=^TMP("AMHSEDS",$J,"P",D,I) D S(X)
 Q
GETMHED ;set array ^TMP("AMHSEDS",$J,"M" OF EDS IN MH FILE
 K ^TMP("AMHSEDS",$J,"M"),^TMP($J,"AMHGOT")
 S AMHED=$$FMADD^XLFDT(DT,-731),AMHC=0
 S AMHX=0 F  S AMHX=$O(^AMHRHF("AC",AMHPAT,AMHX)) Q:AMHX'=+AMHX  D
 .S R=$P(^AMHRHF(AMHX,0),U,3) Q:'R
 .Q:'$$ALLOWVI^AMHUTIL(DUZ,R)
 .S AMHD=$P($P($G(^AMHREC(R,0)),U),".")
 .Q:AMHD<AMHED
 .S T=$P(^AMHRHF(AMHX,0),U),T=$P(^AUTTHF(T,0),U,1),T=$E(T,1,30)
 .S E=$$VAL^XBDIQ1(9002011.08,AMHX,.04)
 .S P=$$VALI^XBDIQ1(9002011.08,AMHX,.05) I P S P=$P(^VA(200,P,0),U,2)
 .S Q=$$VAL^XBDIQ1(9002011.08,AMHX,.06)
 .S AMHC=AMHC+1
 .S X=$$DATE(AMHD),$E(X,11)=T,$E(X,44)=E,$E(X,57)=Q,$E(X,68)=P S ^TMP("AMHSEDS",$J,"M",(9999999-AMHD),AMHC)=X
 .S ^TMP($J,"AMHGOT",$P(^AMHRHF(AMHX,0),U),AMHD)=""
 .Q
 Q
GETPCCED ;
 K ^TMP("AMHSEDS",$J,"P")
 S AMHED=$$FMADD^XLFDT(DT,-731),AMHC=0
 S AMHX=0 F  S AMHX=$O(^AUPNVHF("AC",AMHPAT,AMHX)) Q:AMHX'=+AMHX  D
 .S R=$P(^AUPNVHF(AMHX,0),U,3) Q:'R
 .S AMHD=$P($P($G(^AUPNVSIT(R,0)),U),".")
 .Q:AMHD<AMHED
 .S T=$P(^AUPNVHF(AMHX,0),U)
 .Q:$D(^TMP($J,"AMHGOT",T,AMHD))
 .S T=$P(^AUTTHF(T,0),U,1),T=$E(T,1,30)
 .S E=$$VAL^XBDIQ1(9000010.23,AMHX,.04)
 .S P=$$VALI^XBDIQ1(9000010.23,AMHX,.05) I P S P=$P(^VA(200,P,0),U,2)
 .S Q=$$VAL^XBDIQ1(9000010.23,AMHX,.06)
 .S AMHC=AMHC+1
 .S X=$$DATE(AMHD),$E(X,11)=T,$E(X,44)=E,$E(X,57)=Q,$E(X,68)=P S ^TMP("AMHSEDS",$J,"P",(9999999-AMHD),AMHC)=X
 .Q
 Q
S(Y,F,C,T) ;
 I '$G(F) S F=0
 I '$G(T) S T=0
 ;blank lines
 F F=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("AMHDSPEDS",$J,0),U)+1,$P(^TMP("AMHDSPEDS",$J,0),U)=%
 S ^TMP("AMHDSPEDS",$J,%,0)=X
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
