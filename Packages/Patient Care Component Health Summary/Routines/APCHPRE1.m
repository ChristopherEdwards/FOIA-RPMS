APCHPRE1 ; IHS/CMI/GRL - PATIENT HEALTH SUMMARY ;  
 ;;1.0;IHS PCC SUITE;**1**;MAR 14, 2008
 ;
EP(APCHSDFN) ;PEP - PASS DFN get back array of patient care summary
 K ^TMP("APCHPHS",$J,"PHS")
 S ^TMP("APCHPHS",$J,"PHS",0)=0
 D SETARRAY
 Q
 ;
SETARRAY ;set up array containing dm care summary
 ;CHECK TO SEE IF START1^APCLDF EXISTS
 S X="APCLDF" X ^%ZOSF("TEST") I '$T Q
 ;S X=$P($P(^DPT(APCHSDFN,0),U),",",2)_" "_$P($P(^DPT(APCHSDFN,0),U),",")_"   HRN:  "_$$HRN^AUPNPAT(APCHSDFN,DUZ(2)),$E(X,50)=$P(^DIC(4,DUZ(2),0),U) D S(X,2)
 S X=$P($P(^DPT(APCHSDFN,0),U),",",2)_" "_$P($P(^DPT(APCHSDFN,0),U),",")_"   HRN:  "_$$HRN^AUPNPAT(APCHSDFN,DUZ(2)),$E(X,50)=$S($P(^APCCCTRL(DUZ(2),0),U,13)]"":$P(^APCCCTRL(DUZ(2),0),U,13),1:$P(^DIC(4,DUZ(2),0),U)) D S(X,2)
 S X=$$VAL^XBDIQ1(2,APCHSDFN,.111),$E(X,50)=$$VAL^XBDIQ1(9000001,APCHSDFN,.14) D S(X)
 S X=$$VAL^XBDIQ1(2,APCHSDFN,.114)_$S($$VAL^XBDIQ1(2,APCHSDFN,.114)]"":",  ",1:" ")_$$VAL^XBDIQ1(2,APCHSDFN,.115)_"   "_$$VAL^XBDIQ1(2,APCHSDFN,.116),Y=$P(^AUTTLOC(DUZ(2),0),U,11),$E(X,50)=Y D S(X)
 S X="Hello "_$S($$SEX^AUPNPAT(APCHSDFN)="M":"Mr. ",1:"Ms. ")_$E($P($P(^DPT(APCHSDFN,0),U),","))_$$LOW^XLFSTR($E($P($P(^DPT(APCHSDFN,0),U),","),2,99))_","  D S(X,1)
 S X="Thanks for choosing "_$S($P(^APCCCTRL(DUZ(2),0),U,13)]"":$P(^APCCCTRL(DUZ(2),0),U,13),1:$P(^DIC(4,DUZ(2),0),U)) D S(X,1)
 S X="This sheet is a new way for you and your doctor to look at your health." D S(X)
 S X="DISEASE PREVENTION CARE" D S(X,1)
GLUCOSE ;
 I $$AGE^AUPNPAT(APCHSDFN)>10 D
 .Q:$$DMDX(APCHSDFN)=""
 .S X="",$E(X,5)="Since you have diabetes - this helps see how well your" D S(X,1)
 .S X="",$E(X,5)="treatment is working." D S(X)
 .S T=$O(^ATXLAB("B","DM AUDIT FASTING GLUCOSE TESTS",0)) I $G(T)]"" S APCHLFGV=$$LAB(APCHSDFN,T),APCHLFGD=$P($G(APCHLFGV),"|||",2),APCHLFGV=$P($G(APCHLFGV),"|||") D
 ..S X="",$E(X,5)="Last Fasting Blood Sugar: "_$S($G(APCHLFGV)]"":APCHLFGV_" ("_APCHLFGD_")",1:"No Fasting Blood Sugar on File") D S(X)
 ..;get last FBS date.  If > 2 yr write "You are due to have a blood sugar level checked"
 ..I APCHLFGD]"" S X=APCHLFGD D ^%DT S APCHLFGD=Y S X1=DT,X2=APCHLFGD I $$FMDIFF^XLFDT(X1,X2)>365 S X="",$E(X,5)="Since it's been over 1 year - time to do this test again." D S(X)
 .I $G(APCHLFGV)']"" S T=$O(^ATXLAB("B","DM AUDIT GLUCOSE TESTS TAX",0)) I $G(T)]"" S APCHLGLV=$$LAB(APCHSDFN,T),APCHLGLD=$P($G(APCHLGLV),"|||",2),APCHLGLV=$P($G(APCHLGLV),"|||") D
 .I $G(APCHLGLV)]"" S X="",$E(X,5)="Last Blood Sugar: "_APCHLGLV_" ("_APCHLGLD_")" D S(X)
 .Q
 ;
 I $$DMDX(APCHSDFN)="" D
 .Q:$$AGE^AUPNPAT(APCHSDFN)<18
 .S T=$O(^ATXLAB("B","DM AUDIT GLUCOSE TESTS TAX",0)) I $G(T)]"" S APCHLGLV=$$LAB(APCHSDFN,T),APCHLGLD=$P($G(APCHLGLV),"|||",2),APCHLGLV=$P($G(APCHLGLV),"|||") D
 ..I $G(APCHLGLV)']"" S X="",$E(X,5)="No Blood Sugar on file - should be done now." D S(X) Q
 ..I APCHLGLV]"" S X="",$E(X,5)="Last Blood Sugar: "_APCHLGLV_" ("_APCHLGLD_")" D S(X)
 ..I APCHLGLD]"" S X=APCHLGLD D ^%DT S APCHLGLD=Y S X1=DT,X2=APCHLGLD I $$FMDIFF^XLFDT(X1,X2)>730 S X="",$E(X,5)="Since it's been over 2 years - time to do this test again." D S(X)
 .Q
 ;
IMMUN ;Immunizaitons
 S X="IMMUNIZATIONS(SHOTS)   Getting shots protects you from some diseases and" D S(X,1)
 S X="illnesses." D S(X)
 ;
 D IMMFORC^BIRPC(.APCHIMM,APCHSDFN)
 I $E($G(APCHIMM),1,2)="No" S X="",$E(X,5)="Good news!  Your immunizations are up to date" D S(X)
 I $E($G(APCHIMM),1,2)="  " F APCHIMMN=1:1 S APCHIMMT=$P($P(APCHIMM,U,APCHIMMN),"|") Q:$G(APCHIMMT)']""  D
 .I $E(APCHIMMT,1,2)="  " S APCHIMMT=$E(APCHIMMT,3,99)
 .I $G(APCHIMMT)]"" S APCHI(APCHIMMN)=APCHIMMT
 .Q
 I $G(APCHIMM)]"",+APCHIMM S X="",$E(X,5)="Immunizations are due." D S(X)
 I $D(APCHI) S APCHICTR=0 D
 .S X="",$E(X,5)="Immunizations due:" D S(X)
 .F  S APCHICTR=$O(APCHI(APCHICTR)) Q:APCHICTR'=+APCHICTR  D
 ..S APCHIMDU=$P(APCHI(APCHICTR),U),X="",$E(X,5)=APCHIMDU D S(X)
 ..Q
 ;
CRECTAL ;Colorectal screening
 I $$AGE^AUPNPAT(APCHSDFN)>50 D
 .Q:$$CRC(APCHSDFN,DT)=1  ;has CRC dx  
 .S X="COLORECTAL SCREENING   This test may show cancer, even when you feel ok." D S(X,1)
 .S APCHLFOB=$$LASTFOBT^APCLAPI3(APCHSDFN),APCHLBE=$$LASTBE^APCLAPI4(APCHSDFN),APCHLCOL=$$LASTCOLO^APCLAPI(APCHSDFN),APCHLSIG=$$LASTFSIG^APCLAPI(APCHSDFN)
 .S APCHLDRE=$$LASTRECT^APCLAPI2(APCHSDFN)
 .S APCHSCRN=""
 .I $G(APCHLDRE)]"" S APCHSCRN=APCHLDRE I $$FMDIFF^XLFDT(DT,APCHLDRE)<720 S APCHCOLO=1
 .I $G(APCHLFOB)]"",APCHLFOB>APCHSCRN S APCHSCRN=APCHLFOB I $$FMDIFF^XLFDT(DT,APCHLFOB)<720 S APCHCOLO=1
 .I $G(APCHLCOL)]"",APCHLCOL>APCHSCRN S APCHSCRN=APCHLCOL I $$FMDIFF^XLFDT(DT,APCHLCOL)<3650 S APCHCOLO=1
 .I $G(APCHLBE)]"",APCHLBE>APCHSCRN S APCHSCRN=APCHLBE I $$FMDIFF^XLFDT(DT,APCHLBE)<1825 S APCHCOLO=1
 .I $G(APCHLSIG)]"",APCHLSIG>APCHSCRN S APCHSCRN=APCHLSIG I $$FMDIFF^XLFDT(DT,APCHLSIG)<1825 S APCHCOLO=1
 .I $G(APCHSCRN)]"" S X="",$E(X,5)="Your last colorectal screening was performed on "_$$FMTE^XLFDT(APCHSCRN) D S(X)
 .I $G(APCHCOLO)'=1 S X="",$E(X,5)="Your colorectal screening is due now" D S(X)
 ;
WOMENS ;Womens health issues
 ;first get cervical and breast needs from BW package
 S APCHPNV=$$VAL^XBDIQ1(9002086,APCHSDFN,.11) I $G(APCHPNV)["PAP" S APCHPND=$$VALI^XBDIQ1(9002086,APCHSDFN,.12)
 S APCHMNV=$$VAL^XBDIQ1(9002086,APCHSDFN,.18) I $G(APCHMNV)["Mammo"!($G(APCHMNV)["MAM") S APCHMND=$$VALI^XBDIQ1(9002086,APCHSDFN,.19)
 ;now check last PAP and mammogram
 I $$SEX^AUPNPAT(APCHSDFN)="F",$$AGE^AUPNPAT(APCHSDFN)>18,$$AGE^AUPNPAT(APCHSDFN)<66 S X="MAMMOGRAM and PAP SCREEN   These may show cancer even when you feel ok." D S(X,1) D
 .S APCHSPAP=$$LASTPAP^APCLAPI1(APCHSDFN) I APCHSPAP]"" S X="",$E(X,5)="Your last PAP was performed on "_$$FMTE^XLFDT($$LASTPAP^APCHSMU(APCHSDFN)) D S(X,1)
 .I $G(APCHPNV)']"",APCHSPAP]"" S X1=DT,X2=APCHSPAP I $$FMDIFF^XLFDT(X1,X2)>1095 S X="",$E(X,5)="Your PAP is due now" D S(X)
 .I '$G(APCHPND),APCHSPAP="" S X="",$E(X,5)="Your PAP is due now" D S(X,1)
 .I $G(APCHPND)]"",APCHPND<DT,APCHPND>APCHSPAP S X="",$E(X,5)="Your PAP is due now" D S(X)
 .I $$AGE^AUPNPAT(APCHSDFN)>49 D
 ..S APCHMAM=$$LASTMAM^APCLAPI1(APCHSDFN) I APCHSMAM]"" S X="",$E(X,5)="Your last mammogram was performed on "_$$FMTE^XLFDT(APCHSMAM) D S(X)
 ..I $G(APCHMNV)']"",APCHSMAM]"" S X1=DT,X2=APCHSMAM I $$FMDIFF^XLFDT(X1,X2)>365 S X="",$E(X,5)="Your mammogram is due now" D S(X)
 ..I APCHSMAM="" S X="",$E(X,5)="Your mammogram is due now" D S(X)
 ..I $G(APCHMND)]"",APCHMND<DT,APCHMND>APCHSMAM S X="",$E(X,5)="Your mammogram is due now" D S(X)
 ..I $G(APCHMND)]"",APCHMND<DT,APCHMND=APCHSMAM S X="",$E(X,5)="Your mammogram is due now" D S(X)  ;WH MAM need date not updated
 ;
 I $$SEX^AUPNPAT(APCHSDFN)="F",$$AGE^AUPNPAT(APCHSDFN)>40,$$AGE^AUPNPAT(APCHSDFN)<50,APCHSMAM="" S X="",$E(X,5)="Your mammogram is due at age 50" D S(X)
 ;
HEARING ;
 I $$AGE^AUPNPAT(APCHSDFN)>64 D
 .S X="HEARING TEST   This may show loss of good hearing - and if a hearing aid" D S(X,1)
 .S X="would help." D S(X)
 .;get hearing test history
 .I $$LASTHEAR^APCLAPI3(APCHSDFN)]"" S X="",$E(X,5)="Your last hearing test was performed on "_$$FMTE^XLFDT($$LASTHEAR^APCLAPI3(APCHSDFN)) D S(X,1)
 .I $$LASTHEAR^APCLAPI3(APCHSDFN)="" S X="",$E(X,5)="Your hearing test is due now" D S(X,1)
 .Q
 ;
 S X="",$E(X,5)="Ask your provider about ways you can stay healthy." D S(X,2)
 ;
HABITS ;
 S X="HEALTH HABITS" D S(X,1)
 S X="Please answer the questions.  Mark the box next to your answer." D S(X,1)
 S X="FEELING SAD" D S(X,1)
 S X="During the past month, have you felt down, depressed, or hopeless?" D S(X)
 S X="" S $E(X,5)="[ ] Yes",$E(X,15)="[ ] No" D S(X)
 S X="During the past month, have you felt little interest or pleasure in"  D S(X)
 S X="doing things you used to like to do?" D S(X)
 S X="" S $E(X,5)="[ ] Yes",$E(X,15)="[ ] No" D S(X)
 S X="ALCOHOL USE" D S(X,1)
 S X="In the past year, how often do you drink? A drink is one bottle of beer," D S(X)
 S X="one glass of wine, one wine cooler, one cocktail or one shot of hard liquor" D S(X)
 S X="(like whiskey, scotch, gin or vodka)." D S(X)
 S X="",$E(X,5)="[ ] Never",$E(X,25)="[ ] Monthly or less",$E(X,45)="[ ] 2-4 times/month" D S(X)
 S X="",$E(X,5)="[ ] 2-3 times/week",$E(X,25)="[ ] 4-5 times/week",$E(X,45)="[ ] 6+ days/week" D S(X)
 S X="When you drink, about how many drinks do you have?" D S(X,1)
 S X="",$E(X,5)="[ ] 0 drinks",$E(X,25)="[ ] 1-2 drinks",$E(X,45)="[ ] 3-4 drinks" D S(X)
 S X="",$E(X,5)="[ ] 5-6 drinks",$E(X,25)="[ ] 7-9 drinks",$E(X,45)="[ ] 10+ drinks" D S(X)
 S X="How many times in the past year did you have "_$S($$SEX^AUPNPAT(APCHSDFN)="M":"6 or more drinks in one day?",1:"4 or more drinks in one day?") D S(X,1)
 S X="",$E(X,5)="[ ] Never",$E(X,25)="[ ] Monthly",$E(X,45)="[ ] Less than monthly" D S(X)
 S X="",$E(X,5)="[ ] Weekly",$E(X,25)="[ ] Daily or almost daily" D S(X)
 S X="TOBACCO" D S(X,1)
 S X="Mark the answers which best describe your smoking history." D S(X)
 S X="",$E(X,5)="[ ] Never used tobacco(lifetime non-tobacco user)" D S(X)
 S X="",$E(X,5)="[ ] Current Smoker (cigarettes or cigars)" D S(X)
 S X="",$E(X,10)="[ ] Trying to quit smoking" D S(X)
 S X="",$E(X,5)="[ ] Current chewing (smokeless) tobacco user" D S(X)
 S X="",$E(X,10)="[ ] Trying to quit chewing" D S(X)
 S X="",$E(X,5)="[ ] Used to smoke - but quit" D S(X)
 S X="",$E(X,5)="[ ] Used to chew - but quit" D S(X)
 S X="",$E(X,5)="[ ] Only use for religious or cultural reasons" D S(X)
 S X="Does anyone smoke at your home?     [ ] Yes    [ ] No" D S(X)
 Q:$$SEX^AUPNPAT(APCHSDFN)="M"
 Q:$$AGE^AUPNPAT(APCHSDFN)<16
 S X="FAMILY PLANNING" D S(X,1)
 S X="Are you planning to have a baby this week, this month, this year? [ ] Yes [ ] No"  D S(X)
 S X="Do you or your partner use a form of birth control?    [ ] Yes   [ ] No" D S(X)
 S X="",$E(X,5)="[ ] Condom        [ ] Diaphragm  [ ] Birth Control Pills  [ ] Sterilization" D S(X)
 S X="",$E(X,5)="[ ] Rhythm Method [ ] A shot     [ ] Other   [ ] I do not use birth control" D S(X)
 Q
 ;
 ;
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("APCHPHS",$J,"PHS",0),U)+1,$P(^TMP("APCHPHS",$J,"PHS",0),U)=%
 S ^TMP("APCHPHS",$J,"PHS",%)=X
 Q
DMDX(P) ;
 ;check problem list OR must have 3 diagnoses
 N T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Yes"
 NEW APCHX
 S APCHX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,"APCHX(") G:E DMX I $D(APCHX(3)) S APCHX="Yes"
 I '$D(APCHX)="" S APCHX="No"
DMX ;
 Q APCHX
 ;
LAB(P,T,LT) ;EP
 I '$G(LT) S LT=""
 NEW D,V,G,X,J S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y!(G)  D
 ...I $D(^ATXLAB(T,21,"B",X)),$P(^AUPNVLAB(Y,0),U,4)]"" S G=Y Q
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...S G=Y
 ...Q
 ..Q
 .Q
 I 'G S R=$$REF(P,T) Q "||||||"_R
 Q $P(^AUPNVLAB(G,0),U,4)_"|||"_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0),U),"."))_"|||"_$$REF(P,T,$P($P(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0),U),"."))_"|||"_G
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
 ;
DATE(D) ;EP - convert to slashed date
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
REF(P,T,D) ;return refusal string after date D for test is tax T
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(D) S D=""
 N APCHREF,APCHT,V S APCHT=0 F  S APCHT=$O(^ATXLAB(T,21,"B",APCHT)) Q:APCHT'=+APCHT  D
 .S V=$$REF1(P,60,APCHT,D) I V]"" S APCHREF(9999999-$P(V,U,3))=V
 I $D(APCHREF) S %=0,%=$O(APCHREF(%)) I % S V=APCHREF(%) Q V
 Q ""
REF1(P,F,I,D,T) ; ;
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(D)="" S D=""
 I $G(T)="" S T="E"
 NEW X,N S X=$O(^AUPNPREF("AA",P,F,I,0))
 I 'X Q ""  ;none of this item was refused
 S N=$O(^AUPNPREF("AA",P,F,I,X,0))
 NEW Y S Y=9999999-X
 I D]"",Y>D Q $S(T="I":Y,1:$$TYPEREF(N)_"-"_$$DATE(Y))
 I T="I" Q Y  ;quit on internal form of date
 Q $$TYPEREF(N)_"-"_$$DATE(Y)
 ;
TYPEREF(N) ;
 NEW % S %=$P(^AUPNPREF(N,0),U,7)
 I %="R"!(%="") Q "Refused"
 I %="N" Q "Not Med Ind"
 I %="F" Q "No Resp to F/U"
 Q ""
 ; 
CRC(P,EDATE) ;
 K APCHG
 S Y="APCHG("
 S X=P_"^LAST DX [BGP COLORECTAL CANCER DXS;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(APCHG(1)) Q 1  ;has dx
 Q 0
 ;
