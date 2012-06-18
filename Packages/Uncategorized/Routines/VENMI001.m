VENMI001 ; ; 28-NOV-2006
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQ(9000010.46)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(9000010.46,0,"GL")
 ;;=^AUPNVWC(
 ;;^DIC("B","V WELL CHILD",9000010.46)
 ;;=
 ;;^DD(9000010.46,0)
 ;;=FIELD^^81203^42
 ;;^DD(9000010.46,0,"DDA")
 ;;=N
 ;;^DD(9000010.46,0,"DT")
 ;;=3060217
 ;;^DD(9000010.46,0,"IX","AA",9000010.46,.03)
 ;;=
 ;;^DD(9000010.46,0,"IX","AATOO",9000010.46,.02)
 ;;=
 ;;^DD(9000010.46,0,"IX","AC",9000010.46,.02)
 ;;=
 ;;^DD(9000010.46,0,"IX","AD",9000010.46,.03)
 ;;=
 ;;^DD(9000010.46,0,"IX","AV10",9000010.46,.03)
 ;;=
 ;;^DD(9000010.46,0,"IX","AV9",9000010.46,.01)
 ;;=
 ;;^DD(9000010.46,0,"IX","B",9000010.46,.01)
 ;;=
 ;;^DD(9000010.46,0,"NM","V WELL CHILD")
 ;;=
 ;;^DD(9000010.46,0,"PT",9000010.46,1208)
 ;;=
 ;;^DD(9000010.46,.01,0)
 ;;=WELL CHILD VISIT TYPE^RS^1:FIRST WELL CHILD VISIT;0:ROUTINE WELL CHILD VISIT;2:SPECIAL WELL CHILD VISIT;^0;1^Q
 ;;^DD(9000010.46,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(9000010.46,.01,1,1,0)
 ;;=9000010.46^B
 ;;^DD(9000010.46,.01,1,1,1)
 ;;=S ^AUPNVWC("B",$E(X,1,30),DA)=""
 ;;^DD(9000010.46,.01,1,1,2)
 ;;=K ^AUPNVWC("B",$E(X,1,30),DA)
 ;;^DD(9000010.46,.01,1,2,0)
 ;;=9000010.46^AV9^MUMPS
 ;;^DD(9000010.46,.01,1,2,1)
 ;;=S:$D(APCDLOOK) DIC("DR")=""
 ;;^DD(9000010.46,.01,1,2,2)
 ;;=Q
 ;;^DD(9000010.46,.01,3)
 ;;=
 ;;^DD(9000010.46,.01,12)
 ;;=Allow only active Exams to be selected.
 ;;^DD(9000010.46,.01,12.1)
 ;;=S DIC("S")="I $P(^(0),U,4)'=1"
 ;;^DD(9000010.46,.01,21,0)
 ;;=^^2^2^2951024^^
 ;;^DD(9000010.46,.01,21,1,0)
 ;;=This is the entry in the Exam file that represents what type of exam was
 ;;^DD(9000010.46,.01,21,2,0)
 ;;=done at the encounter.
 ;;^DD(9000010.46,.01,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.46,.01,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTEX")
 ;;^DD(9000010.46,.01,"AUDIT")
 ;;=n
 ;;^DD(9000010.46,.01,"DT")
 ;;=3051207
 ;;^DD(9000010.46,.02,0)
 ;;=PATIENT NAME^RP9000001'I^AUPNPAT(^0;2^Q
 ;;^DD(9000010.46,.02,1,0)
 ;;=^.1
 ;;^DD(9000010.46,.02,1,1,0)
 ;;=9000010.46^AC
 ;;^DD(9000010.46,.02,1,1,1)
 ;;=S ^AUPNVWC("AC",$E(X,1,30),DA)=""
 ;;^DD(9000010.46,.02,1,1,2)
 ;;=K ^AUPNVWC("AC",$E(X,1,30),DA)
 ;;^DD(9000010.46,.02,1,2,0)
 ;;=9000010.46^AATOO^MUMPS
 ;;^DD(9000010.46,.02,1,2,1)
 ;;=I $P(^AUPNVWC(DA,0),U,3)]"" S ^AUPNVWC("AA",X,(9999999-$P(+^AUPNVSIT($P(^AUPNVWC(DA,0),U,3),0),".",1)),DA)=""
 ;;^DD(9000010.46,.02,1,2,2)
 ;;=I $P(^AUPNVWC(DA,0),U,3)]"" K ^AUPNVWC("AA",X,(9999999-$P(+^AUPNVSIT($P(^AUPNVWC(DA,0),U,3),0),".",1)),DA)
 ;;^DD(9000010.46,.02,1,2,"DT")
 ;;=3051214
 ;;^DD(9000010.46,.02,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.46,.02,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDPAT")
 ;;^DD(9000010.46,.02,"DT")
 ;;=3051214
 ;;^DD(9000010.46,.03,0)
 ;;=VISIT^R*P9000010'I^AUPNVSIT(^0;3^S DIC("S")="I $P(^(0),U,5)=$P(^AUPNVWC(DA,0),U,2)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 ;;^DD(9000010.46,.03,1,0)
 ;;=^.1
 ;;^DD(9000010.46,.03,1,1,0)
 ;;=9000010.46^AD
 ;;^DD(9000010.46,.03,1,1,1)
 ;;=S ^AUPNVWC("AD",$E(X,1,30),DA)=""
 ;;^DD(9000010.46,.03,1,1,2)
 ;;=K ^AUPNVWC("AD",$E(X,1,30),DA)
 ;;^DD(9000010.46,.03,1,1,"%D",0)
 ;;=^^4^4^2950901^
 ;;^DD(9000010.46,.03,1,1,"%D",1,0)
 ;;=This cross reference is used for searches by the visit pointer and
 ;;^DD(9000010.46,.03,1,1,"%D",2,0)
 ;;=internal entry number. 
 ;;^DD(9000010.46,.03,1,1,"%D",3,0)
 ;;= 
 ;;^DD(9000010.46,.03,1,1,"%D",4,0)
 ;;=  "AD",VISIT,DA
 ;;^DD(9000010.46,.03,1,2,0)
 ;;=9000010.46^AA^MUMPS
 ;;^DD(9000010.46,.03,1,2,1)
 ;;=Q:$P(^AUPNVWC(DA,0),U,2)=""  S ^AUPNVWC("AA",$P(^AUPNVWC(DA,0),U,2),(9999999-$P(+^AUPNVSIT(X,0),".",1)),DA)=""
 ;;^DD(9000010.46,.03,1,2,2)
 ;;=Q:$P(^AUPNVWC(DA,0),U,2)=""  K ^AUPNVWC("AA",$P(^AUPNVWC(DA,0),U,2),(9999999-$P(+^AUPNVSIT(X,0),".",1)),DA)
 ;;^DD(9000010.46,.03,1,2,"DT")
 ;;=3051214
 ;;^DD(9000010.46,.03,1,3,0)
 ;;=9000010.46^AV10^MUMPS
 ;;^DD(9000010.46,.03,1,3,1)
 ;;=D ADD^AUPNVSIT
 ;;^DD(9000010.46,.03,1,3,2)
 ;;=D SUB^AUPNVSIT
 ;;^DD(9000010.46,.03,1,3,"%D",0)
 ;;=^^2^2^2940131^
 ;;^DD(9000010.46,.03,1,3,"%D",1,0)
 ;;=This cross-reference adds and subtracts from the dependent entry count in
 ;;^DD(9000010.46,.03,1,3,"%D",2,0)
 ;;=the VISIT file.
 ;;^DD(9000010.46,.03,3)
 ;;=Enter the visit date/time for the encounter where the exam was done.
 ;;^DD(9000010.46,.03,12)
 ;;=VISIT MUST BE FOR CURRENT PATIENT
 ;;^DD(9000010.46,.03,12.1)
 ;;=S DIC("S")="I $P(^(0),U,5)=$P(^AUPNVWC(DA,0),U,2)"
 ;;^DD(9000010.46,.03,21,0)
 ;;=^^2^2^2950901^
 ;;^DD(9000010.46,.03,21,1,0)
 ;;=This is the encounter in the Visit file that represents when and where the
 ;;^DD(9000010.46,.03,21,2,0)
 ;;=exam was done.
 ;;^DD(9000010.46,.03,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.46,.03,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDVSIT")
 ;;^DD(9000010.46,.03,"DT")
 ;;=3051214
 ;;^DD(9000010.46,.04,0)
 ;;=ANT GUIDANCE PROVIDER^P200'^VA(200,^0;4^Q
 ;;^DD(9000010.46,.04,"DT")
 ;;=3051206
 ;;^DD(9000010.46,.05,0)
 ;;=ANT GUIDANCE TIME (MIN)^NJ3,0^^0;5^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(9000010.46,.05,3)
 ;;=Type a Number between 1 and 999, 0 Decimal Digits
 ;;^DD(9000010.46,.05,"DT")
 ;;=3051129
 ;;^DD(9000010.46,.06,0)
 ;;=ANT GUIDANCE LOU^S^1:POOR;2:FAIR;3:GOOD;4:N/A;5:REFUSED;^0;6^Q
 ;;^DD(9000010.46,.06,"DT")
 ;;=3051129
 ;;^DD(9000010.46,.07,0)
 ;;=NUTR TIME PT ED (MIN)^NJ3,0^^0;7^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(9000010.46,.07,3)
 ;;=Type a Number between 1 and 999, 0 Decimal Digits
 ;;^DD(9000010.46,.07,"DT")
 ;;=3051007
 ;;^DD(9000010.46,.08,0)
 ;;=NUTRITION LOU^S^1:POOR;2:FAIR;3:GOOD;4:NA;5:REFUSED;^0;8^Q
 ;;^DD(9000010.46,.08,"DT")
 ;;=3051007
 ;;^DD(9000010.46,.09,0)
 ;;=NUTRITION PROVIDER^P200'^VA(200,^0;9^Q
 ;;^DD(9000010.46,.09,"DT")
 ;;=3051202
 ;;^DD(9000010.46,.1,0)
 ;;=INFORMAL DEVEL ASSESSMENT^S^P:PASS;B:BORDERLINE;F:FAIL;^0;10^Q
 ;;^DD(9000010.46,.1,"DT")
 ;;=3051207
 ;;^DD(9000010.46,1,0)
 ;;=ANTICIPATORY GUIDANCE TOPICS^9000010.461^^1;0
 ;;^DD(9000010.46,1,"DT")
 ;;=3050929
 ;;^DD(9000010.46,2.01,0)
 ;;=ASQ - FINE MOTOR^F^^2;1^K:$L(X)>12!($L(X)<1) X
 ;;^DD(9000010.46,2.01,3)
 ;;=Answer must be 1-12 characters in length.
 ;;^DD(9000010.46,2.01,"DT")
 ;;=3060111
 ;;^DD(9000010.46,2.02,0)
 ;;=ASQ - GROSS MOTOR^F^^2;2^K:$L(X)>12!($L(X)<1) X
 ;;^DD(9000010.46,2.02,3)
 ;;=Answer must be 1-12 characters in length.
 ;;^DD(9000010.46,2.02,"DT")
 ;;=3060111
 ;;^DD(9000010.46,2.03,0)
 ;;=ASQ - COMMUNICATION^F^^2;3^K:$L(X)>12!($L(X)<1) X
 ;;^DD(9000010.46,2.03,3)
 ;;=Answer must be 1-12 characters in length.
 ;;^DD(9000010.46,2.03,"DT")
 ;;=3060112
 ;;^DD(9000010.46,2.04,0)
 ;;=ASQ - PERSONAL-SOCIAL^F^^2;4^K:$L(X)>12!($L(X)<1) X
 ;;^DD(9000010.46,2.04,3)
 ;;=Answer must be 1-12 characters in length.
 ;;^DD(9000010.46,2.04,"DT")
 ;;=3060202
 ;;^DD(9000010.46,2.05,0)
 ;;=ASQ - PROBLEM SOLVING^F^^2;5^K:$L(X)>12!($L(X)<1) X
 ;;^DD(9000010.46,2.05,3)
 ;;=Answer must be 1-12 characters in length.
 ;;^DD(9000010.46,2.05,"DT")
 ;;=3060111
 ;;^DD(9000010.46,2.06,0)
 ;;=ASQ - AUTISM SCREEN^F^^2;6^K:$L(X)>12!($L(X)<1) X
 ;;^DD(9000010.46,2.06,3)
 ;;=Answer must be 1-12 characters in length.
 ;;^DD(9000010.46,2.06,"DT")
 ;;=3060111
 ;;^DD(9000010.46,2.07,0)
 ;;=ASQ QUESTIONNAIRE (MOS)^P19707.14'^VEN(7.14,^2;7^Q
 ;;^DD(9000010.46,2.07,"DT")
 ;;=3060112
 ;;^DD(9000010.46,3.01,0)
 ;;=DEVELOPMENT - FINE MOTOR^F^^3;1^K:$L(X)>60!($L(X)<1) X
 ;;^DD(9000010.46,3.01,3)
 ;;=Answer must be 1-60 characters in length.
 ;;^DD(9000010.46,3.01,"DT")
 ;;=3051227
 ;;^DD(9000010.46,3.02,0)
 ;;=DEVELOPMENT - GROSS MOTOR^F^^3;2^K:$L(X)>60!($L(X)<1) X
 ;;^DD(9000010.46,3.02,3)
 ;;=Answer must be 1-60 characters in length.
 ;;^DD(9000010.46,3.02,"DT")
 ;;=3051227
 ;;^DD(9000010.46,3.03,0)
 ;;=DEVELOPMENT - LANGUAGE^F^^3;3^K:$L(X)>60!($L(X)<1) X
 ;;^DD(9000010.46,3.03,3)
 ;;=Answer must be 1-60 characters in length.
 ;;^DD(9000010.46,3.03,"DT")
 ;;=3051227
 ;;^DD(9000010.46,3.04,0)
 ;;=DEVELOPMENT - SOCIAL^F^^3;4^K:$L(X)>60!($L(X)<1) X
