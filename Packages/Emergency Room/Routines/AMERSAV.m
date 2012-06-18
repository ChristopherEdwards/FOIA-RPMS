AMERSAV ; IHS/ANMC/GIS -ISC - FILE INFO IN ER VISIT FILE ;  
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
 ;IHS/OIT/SCR 12/17/08
 ;This routine is called by AMERD upon discharge of ER
 ;TMP globals that are initially populated by info in ER ADMIT and now contain OUT info
 ;are being transfered to the ^AMERVSIT file
RUN ;
 ; Transfer PCC VISIT ien
 S AMERDR(1)=$$DR1("QA")
 S AMERDR(1)=AMERDR(1)_";.03////"_$P($G(^AMERADM(AMERDFN,0)),U,3)
 S AMERDR(2)=$$DR1("QD")_";.19////"_$G(DUZ)_";10.1////1"
 S %=$G(^TMP("AMER",$J,2,11,.1)) I %]"" S AMERDR(2)=AMERDR(2)_";5.2////"_+%_";5.3////"_$P($P(%,U,2)," [") ; PRIMARY DIAGNOSIS
 D INJ^AMERSAV1
 D CONSULT
 D STUFF(AMERDFN),DRM,KILLADM,TASK
EXIT Q
 ;
DR1(T) ; MAKES DR STRING FROM TMP GLOBALS. DOES NOT DO SUBFILES
 N X,Y,Z,%,I,J,N,A,AMERSTOP S A="",J=1+(T="QD")
 S X=T F  S X=$O(^AMER(2.3,"B",X)) Q:$E(X,1,2)'=T  S Y=$O(^(X,0)) Q:'Y  D
 .I X="QD5" D XXX
 .I T="QD",+$P(X,"QD",2)>30 Q
 .I X="QA2" S AMERDR(.01)=$G(^TMP("AMER",$J,1,2)) Q
 .S Z=^AMER(2.3,Y,0)
 .I $P(Z,U,7) Q
 .S N=$P(Z,U,5) I 'N Q
 .I X="QA3" S %=$G(^TMP("AMER",$J,1,3)) S:%]"" AMERDR(1.1)=N_"////"_% Q
 .I X="QD33" D  Q
 ..S %=$G(^TMP("AMER",$J,2,33)) S:% %=$G(^AMER(3,+%,"ICD")) S:% A=A_";"_N_"////"_% Q
 .I X="QD16" S %=$G(^TMP("AMER",$J,2,16)) S:%]"" AMERDR(2.1)=N_"////"_+% Q
 .I X]"QD19",X']"QD23" S Y=$E(X,3,4),%=$G(^TMP("AMER",$J,2,Y)) S:%]"" AMERDR(1)=AMERDR(1)_";"_N_"////"_+% Q
 .I X="QD24"!(X="QD25")!(X="QD9") S AMERDR(12)=$G(AMERDR(12)),Y=$E(X,3,4),%=$G(^TMP("AMER",$J,2,Y)) S:((AMERDR(12)]"")&%) AMERDR(12)=AMERDR(12)_";" S:% AMERDR(12)=AMERDR(12)_N_"////"_% Q
 .S I=$P(Z,U,3) I 'I Q
 .S %=$G(^TMP("AMER",$J,J,I)) I %?1.N1"^"1.E S %=+%
 .I A]"",%]"" S A=A_";"
 .I %]"" S A=A_N_"////"_%
 .Q
 Q A
 ;
DRM ; GIVEN THE 2ND DR STRING, ADD MULTIPLES
 N X,Y,A,%,C,B,Z,I,M
 F X=10,26,11 D
 .I $O(^TMP("AMER",$J,2,X,0)) D
 ..S Y=0,A=""
 ..F  S Y=$O(^TMP("AMER",$J,2,X,Y)) Q:'Y  D
 ...S:A]"" A=A_U
 ...S A=A_$G(^TMP("AMER",$J,2,X,Y))
 ...I A]"" S AMERDR($S(X=10:4,X=26:5,X=11:6))=A
 ..Q
 .Q
 I $O(^TMP("AMER",$J,2,11,0)) S (Y,I)=0,Z="" F  S Y=$O(^TMP("AMER",$J,2,11,Y)) Q:'Y  S A=^(Y) D
 .S B=+A,%=$P(A,U,2),C=$P(%," [")
 .I Z]"" S Z=Z_U
 .S Z=Z_B,I=I+1
 .S AMERDR(6)=Z,AMERDR(6,I)=C
 .Q
 ; ADDED FOR ER CONSULTANT MULTIPLE FIELD 
 I $O(^TMP("AMER",$J,2,7,0)) D
 .S (Y,I)=0,Z="" F  S Y=$O(^TMP("AMER",$J,2,7,Y)) Q:'Y  S A=^(Y) D
 ..S B=+A,%=$P(A,U,2),C=$P(%,U,1),T=$P(A,U,3),N=$P(A,U,4)
 ..I Z]"" S Z=Z_U
 ..S Z=Z_B,I=I+1
 ..S AMERDR(3)=Z,AMERDR(3,I,.01)=C,AMERDR(3,I,.02)=T,AMERDR(3,I,.03)=N
 ..Q
 .Q
 Q
 ;
KILLADM ; ENTRY POINT FROM AMER2
 K DIC,DIE,DA,DR
 S DIK="^AMERADM(",DA=AMERDFN D ^DIK
 K DIK,DA,DR,DIC,%,%H,X,Y
 K AMERDEST,AMERDFN,AMERFIN,AMERQNO,AMERQSEQ,AMERRUN,AMERSTRT,AUPNDAYS,AUPNPAT,AUPNDOB,AUPNDOD,AUPNSEX
 K ^TMP("AMER",$J)
 Q
 ;
TASK ; SETS TASKMAN VARIABLES AND CALLS TASKMAN
NOTSK D UPDATE S ZTSK=1
TSK ;
 I $D(AMERSTUF) Q
 W !!,AMERLINE
 I $D(ZTSK)!($G(AMERDEMO)) W !!,"Data entry session successfully completed...Thank you" K ZTSK H 2 Q
 W !!,*7,"Data entry session terminated due to internal error.",!,"ER VISIT file not updated...Sorry!!!!"
 K ZTRTN,ZTIO,ZTDESC,ZTSAVE,ZTSK
 Q
 ;
UPDATE ; EP - UPDATE THE VISIT FILE
 N AMERAIEN,AMEREDNO,AMERDUZ,AMERPCC,AMERTIME,AMERDFN,AMERDISP,AMERREGX,AMERSTOP
 S AMERSTOP=0 ;IHS/OIT/SCR 10/14/08 - STOP THE PCC UPDATE IF DISPOSITION IS REGISTERED IN ERROR
 S AMERDA=$$RUN^AMERSAV1
 ; AMERDA contains the newly created ER VISIT SAVED FROM INFO IN AMERADM
 ; User has completed making initial changes to this visit and it is now in ER VISIT file
 ; NOW make sure all applical fields match this information in VISIT files
 S AMERPCC=$$FINDVSIT^AMERPCC(AMERDA)
  ;IHS/OIT/SCR 10/14/08 - START if the disposition that was just saved is REGISTERED IN ERROR
 ;   no visit should be created and an existing visit needs to be removed
 S AMERDISP=$P($G(^AMERVSIT(AMERDA,6)),U,1)
 N DIC,X,Y
 S DIC(0)="",DIC="^AMER(3,",X="REGISTERED IN ERROR"
 D ^DIC
 S AMERREGX=+Y
 ;S AMERREGX=144 
 S AMERSTOP=(AMERDISP=AMERREGX)
 I ((AMERPCC>0)&&(AMERSTOP=1))  S AMERPCC=0  ;IHS/OIT/SCR 10/14/08
 I ((AMERPCC<0)&&'AMERSTOP) D  ; IF WE HAVEN'T MADE A VISIT YET (AS IN BATCH ENTRY) MAKE IT NOW
 .S AMERTIME=$P($G(^AMERVSIT(AMERDA,0)),U,1)
 .S AMERDFN=$P($G(^AMERVSIT(AMERDA,0)),U,2)
 .; If the LOCATION is not set up for scheduling create a PCC VISIT through ERS PCC interface $$VISIT^AMPERPCC(AMERDFN,AMERTIME)
 .I $G(^AMER(2.5,DUZ(2),"SD"))="" S AMERPCC=$$VISIT^AMERPCC(AMERDFN,AMERTIME)
 .; If the LOCATION is set up for scheduling create a PCC VISIT through ERS interface CHECKIN^AMERBSDU(AMERDFN,AMERTIME)
 .I $G(^AMER(2.5,DUZ(2),"SD"))'="" S AMERPCC=$$ERCHCKIN^AMERBSDU(AMERDFN,AMERTIME)
 .D:+AMERPCC>0 SAVPCCO^AMERPCC(+AMERPCC,AMERDA)  ; SAVE PCC IEN TO ER VISIT FILE
 .Q
 D:(+AMERPCC>0&&'AMERSTOP) SYNCHPCC^AMERPCC(AMERDA)
 D:+AMERPCC<0
 .D EN^DDIOL("There was a problem updating PCC VISIT files for ER VISIT IEN: "_AMERDA,"","!!")
 .H 2
 .Q
 D:AMERSTOP
  .D DELETVST^AMERVSIT(AMERDA) ;THIS DELETES BOTH THE PCC VISIT AND THE ERS VISIT 
  .D EN^DDIOL("This REGISTERED IN ERROR VISIT has been deleted")
  .H 2
  .Q
 Q
 ;
STUFF(P) ; STUFF COMPUTED VALUES INTO DR STRING
 I '$G(P) Q
 N X,Y,Z,%,A,B,V
 S X="AA" F  S X=$O(^AMER(2.3,"B",X)) Q:X]"AA3"  S Y=$O(^(X,0)) Q:'Y  S Z=^AMER(2.3,Y,0) D
 .S A=$P(Z,U,4),B=$P(Z,U,5)
 .S %=$P($G(^DD(9009081,A,0)),U,4) I %="" Q
 .S V=$P($G(^AMERADM(P,$P(%,";"))),U,$P(%,";",2))
 .I V="" Q
 .I V?1.N1"^"1.E S V=+V
 .S AMERDR(1)=AMERDR(1)_";"_B_"////"_V
 .Q
 Q
 ;
CONSULT ; ER CONSULTANT WAS NOTIFIED indicated by an entry in ^TMP("AMER",$J,2,7,1)
 I '$O(^TMP("AMER",$J,2,7,0)) S AMERDR(2)=AMERDR(2)_";.22////0"
 E  S AMERDR(2)=AMERDR(2)_";.22////1"
 Q
200() ;ENTRY POINT FROM AMERSAV2
 ; -- SUBRTN to determine if PCC converted to file 200 yet
 Q $S($P(^DD(9000010.06,.01,0),U,2)[200:1,1:0)
XXX ;
