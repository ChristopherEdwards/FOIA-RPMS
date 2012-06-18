BGPMUDP1 ; IHS/MSC/SAT - Print MU EP  measure NQF0028b ;02-Mar-2011 10:55;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;This routine does the printed output of these 2 EP measures
TOB ;EP
 D P1
 K ^TMP("BGPMU0028B")
 Q
P1 ;Write individual measure
 N J,X,Y,Z,LIST1,LIST2,LIST3
 N BGPPTYPE,DEN1,NUM1,PC1,STRING1,STRING2,STRING3,PRD1,PRD2,PRB1,PRB2
 S J=$J
 S BGPPTYPE="P"
 S STRING1=$$G28B("C")
 S STRING2=$$G28B("P")
 S STRING3=$$G28B("B")
 S PRD1=$P(STRING1,U,7)-$P(STRING2,U,7)
 S PRD2=$P(STRING1,U,8)-$P(STRING2,U,8)
 S PRB1=$P(STRING1,U,7)-$P(STRING3,U,7)
 S PRB2=$P(STRING1,U,8)-$P(STRING3,U,8)
 D HEADER^BGPMUPH Q:BGPQUIT
 D HDRBLK^BGPMUPH
 W !,"Pts 18+/Tobacco user/24mos",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?64,$P(STRING3,U,1)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !!,"# w/cess counsel/agent/24 mos",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,7),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,7),5,1),?56,$J($FN(PRD1,",+",1),6),?64,$P(STRING3,U,2),?68,$J($P(STRING3,U,7),5,1),?74,$J($FN(PRB1,",+",1),6)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o cess counsel/agent/24 mos",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,8),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,8),5,1),?56,$J($FN(PRD2,",+",1),6),?64,$P(STRING3,U,3),?68,$J($P(STRING3,U,8),5,1),?74,$J($FN(PRB2,",+",1),6)
 I $D(BGPLIST(BGPIC)) D P2
 D SUM28B
 Q
G28B(BGPMUTF) ;Get the numbers for this measure
 N ARRAY,N
 S J=$J
 S DEN1=+$G(^TMP("BGPMU0028B",J,BGPMUTF,"DEN",1))
 S NUM1=+$G(^TMP("BGPMU0028B",J,BGPMUTF,"INCL",1))
 S NONUM=+$G(^TMP("BGPMU0028B",J,BGPMUTF,"NOT",1))
 I DEN1=0 S (PC1,PC2)=0
 I DEN1>0 D
 .S PC1=$$ROUND^BGPMUA01((NUM1/DEN1),3)*100
 .S PC2=$$ROUND^BGPMUA01((NONUM/DEN1),3)*100
 S ARRAY=DEN1_U_NUM1_U_NONUM_U_""_U_""_U_""_U_PC1_U_PC2
 Q ARRAY
P2 ;Do the Details
 N J,PT,NODE,NAME,VST,BMI,FOL,X,BGPARR
 S J=$J
 D HEADERL^BGPMUPH Q:BGPQUIT
 S X="Patients 18+ with at least 1 or 2 encounters with the EP during the reporting" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="period and who have been identified as tobacco users within the last 24 months," D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="with documented cessation intervention, if any." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="by patients who do meet the numerator criteria (M:)." D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="The following are the abbreviations used in the denominator column:" D W^BGPMUPP(X,0,2,BGPPTYPE)
 S X="EN=Encounter" D W^BGPMUPP(X,0,1,BGPPTYPE)
 S X="HF=Tobacco User Health Factor" D W^BGPMUPP(X,0,1,BGPPTYPE)
 W !!,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?63,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 S PTCT=0
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0028B"","_$J_",""C"",""NOT"",""PAT"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0028B"","_$J_",""C"",""INCL"",""PAT"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA(NODE)
 W !!,"Total # of patients on list: "_PTCT
 Q
DATA(NODE) ;GET DATA
 N AGE,DEN,DFN,COMM,HRN,NAME,NUM,SEX
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,22)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S DEN=$P(NODE,U,2)
 S NUM=$P(NODE,U,3)
 I $Y>(BGPIOSL-2) D
 .D HEADER^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?63,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 ; line 1
 W !,NAME,?23,HRN,?30,COMM,?42,SEX,?46,AGE
 W ?50,$S($P($P(DEN,":",1),";",1)'="":"EN:"_$P($$FMTE^XLFDT($P($P(DEN,":",1),";",1),2),"@",1)_$S($L($P(DEN,":",1),";")>1:";",1:""),1:"")
 W ?63,$S(NUM'="":"M:"_$P(NUM,";",1)_" "_$$FMTE^XLFDT($P(NUM,";",2),2),1:"NM:")
 ;line 2
 S BGPTMP=$S($P($P(DEN,":",1),";",2)'="":"EN",1:"HF")
 W !,?50,$S(BGPTMP="EN":"EN:"_$P($$FMTE^XLFDT($P($P(DEN,":",1),";",2),2),"@",1),1:"HF:"_$P($$FMTE^XLFDT($P(DEN,":",2),2),"@",1))
 ;possible line 3
 I BGPTMP="EN" W !,?50,"HF:"_$P($$FMTE^XLFDT($P(DEN,":",2),2),"@",1)
 Q
 ;
TOB2 ;Tobacco print
 D P1A
 K ^TMP("BGPMU0028A")
 Q
P1A ;Write individual measure
 N BGPPTYPE,X,Y,Z,LIST1,LIST2,LIST3
 N DEN1,NUM1,PC1,STRING1,STRING2,STRING3,PRD1,PRD2,PRB1,PRB2,NONUM
 N LINE
 S BGPPTYPE="P"
 S STRING1=$$G28A("C")
 S STRING2=$$G28A("P")
 S STRING3=$$G28A("B")
 S PRD1=$P(STRING1,U,7)-$P(STRING2,U,7)
 S PRD2=$P(STRING1,U,8)-$P(STRING2,U,8)
 S PRB1=$P(STRING1,U,7)-$P(STRING3,U,7)
 S PRB2=$P(STRING1,U,8)-$P(STRING3,U,8)
 D HEADER^BGPMUPH Q:BGPQUIT
 D HDRBLK^BGPMUPH
 W !,"Pts 18+",?33,$P(STRING1,U,1),?44,$P(STRING2,U,1),?64,$P(STRING3,U,1)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !!,"# w/tob screen-24 mos",?33,$P(STRING1,U,2),?38,$J($P(STRING1,U,7),5,1),?44,$P(STRING2,U,2),?49,$J($P(STRING2,U,7),5,1),?56,$J($FN(PRD1,",+",1),6),?64,$P(STRING3,U,2),?68,$J($P(STRING3,U,7),5,1),?74,$J($FN(PRB1,",+",1),6)
 I $Y>(BGPIOSL-3) D HEADER^BGPMUPH Q:BGPQUIT
 W !,"# w/o tob screen-24 mos",?33,$P(STRING1,U,3),?38,$J($P(STRING1,U,8),5,1),?44,$P(STRING2,U,3),?49,$J($P(STRING2,U,8),5,1),?56,$J($FN(PRD2,",+",1),6),?64,$P(STRING3,U,3),?68,$J($P(STRING3,U,8),5,1),?74,$J($FN(PRB2,",+",1),6)
 I $D(BGPLIST(BGPIC)) D P2A
 D SUM28A
 Q
G28A(BGPMUTF) ;Get the numbers for this measure
 N ARRAY,DEN1,NONUM,NUM1,PC1
 S DEN1=+$G(^TMP("BGPMU0028A",$J,BGPMUTF,"DEN",1))
 S NUM1=+$G(^TMP("BGPMU0028A",$J,BGPMUTF,"INCL",1))
 S NONUM=+$G(^TMP("BGPMU0028A",$J,BGPMUTF,"NOT",1))
 I DEN1=0 S (PC1,PC2)=0
 I DEN1>0 D
 .S PC1=$$ROUND^BGPMUA01((NUM1/DEN1),3)*100
 .S PC2=$$ROUND^BGPMUA01((NONUM/DEN1),3)*100
 S ARRAY=DEN1_U_NUM1_U_NONUM_U_""_U_""_U_""_U_PC1_U_PC2
 Q ARRAY
P2A ;Do the Details
 N PT,NODE,NAME,VST,BMI,FOL,X,BGPARR,PTCT,LINE
 D HEADERL^BGPMUPH Q:BGPQUIT
 W !,"Patients 18+ with at least 1 or 2 encounters with the EP during the reporting "
 W !,"period, with documented tobacco screening within 24 months, if any."
 W !
 W !,"Patients who do not meet the numerator criteria are listed first (NM:), followed"
 W !,"by patients who do meet the numerator criteria (M:)."
 W !
 W !,"The following are the abbreviations used in the denominator column:"
 W !,"EN=Encounter"
 W !
 W !,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?63,"NUMERATOR"
 S LINE="",$P(LINE,"-",81)="" W !,LINE
 S PTCT=0
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0028A"","_$J_",""C"",""NOT"",""PAT"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA3(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0028A"","_$J_",""C"",""INCL"",""PAT"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA3(NODE)
 W !!,"Total # of patients on list: "_PTCT
 Q
DATA3(NODE) ;GET DATA
 N AGE,DEN,DFN,COMM,HRN,NAME,NUM,SEX
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,22)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,11)
 S DEN=$P(NODE,U,2)
 S NUM=$P(NODE,U,3)
 I $Y>(BGPIOSL-2) D
 .D HEADERL^BGPMUPH Q:BGPQUIT
 .W !,"PATIENT NAME",?23,"HRN",?30,"COMMUNITY",?42,"SEX",?46,"AGE",?50,"DENOMINATOR",?63,"NUMERATOR"
 .S LINE="",$P(LINE,"-",81)="" W !,LINE
 W !,NAME,?23,HRN,?30,COMM,?42,SEX,?46,AGE,?50,$S($P(DEN,";",1)'="":"EN:"_$P($$FMTE^XLFDT($P(DEN,";",1),2),"@",1)_$S($L(DEN,";")>1:";",1:""),1:""),?63,$S(NUM'="":"M:"_$E($P(NUM,";",1),1,15),1:"NM:")
 I ($L(DEN,";")>1)!($L(NUM,";")>1) W !,?50,$S($P(DEN,";",2)'="":"EN:"_$P($$FMTE^XLFDT($P(DEN,";",2),2),"@",1),1:""),?65,$S($P(NUM,";",2)'="":$P($$FMTE^XLFDT($P(NUM,";",2),2),"@",1),1:"")
 Q
 ;
XML28A ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="114"_U_""_U_+$G(^TMP("BGPMU0028A",$J,"C","DEN",1))_U_+$G(^TMP("BGPMU0028A",$J,"C","INCL",1))
 K ^TMP("BGPMU0028A",$J)
 Q
 ;
XML28B ;Populate the BGPXML array with data for each population/numerator
 ; BGPXMLOUT(i)=Population Number^Numerator Number^Denominator Count^Numerator Count^Exclusion Count
 S BGPXML(1)="115"_U_""_U_+$G(^TMP("BGPMU0028B",$J,"C","DEN",1))_U_+$G(^TMP("BGPMU0028B",$J,"C","INCL",1))
 K ^TMP("BGPMU0028B",$J)
 Q
 ;
SUM28A ;Populate "BGPMU SUMMARY" for Tobacco Assessment
 ;Initialize iCare/summary global
 N BGPDNCNT,BGPSSTR,J,N
 S BGPDNCNT=0
 K ^TMP("BGPMU SUMMARY",$J,BGPIC)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC)="0028a"_U_"114"
 S N=1 ;only 1 numerator
 ;Setup summary page/iCare ^TMP global
 S CDEN1CT=+$G(^TMP("BGPMU0028A",$J,"C","DEN",N))                 ;current
 S CNUM1CT=+$G(^TMP("BGPMU0028A",$J,"C","INCL",N))
 S CMP=$S(CDEN1CT>0:$$ROUND^BGPMUA01(CNUM1CT/CDEN1CT,3)*100,1:0)
 S PDEN1CT=+$G(^TMP("BGPMU0028A",$J,"P","DEN",N))                 ;previous
 S PNUM1CT=+$G(^TMP("BGPMU0028A",$J,"P","INCL",N))
 S PMP=$S(PDEN1CT>0:$$ROUND^BGPMUA01(PNUM1CT/PDEN1CT,3)*100,1:0)
 S BDEN1CT=+$G(^TMP("BGPMU0028A",$J,"B","DEN",N))                 ;baseline
 S BNUM1CT=+$G(^TMP("BGPMU0028A",$J,"B","INCL",N))
 S BMP=$S(BDEN1CT>0:$$ROUND^BGPMUA01(BNUM1CT/BDEN1CT,3)*100,1:0)
 S BGPDNCNT=BGPDNCNT+1
 S BGPSSTR="MU.EP.0028A."_N_U_"18+ screening w/in 24 mos"_U_0_U_CDEN1CT_U_CNUM1CT_U_CMP_U_U_U_U
 ; 11 12 13 14
 S BGPSSTR=BGPSSTR_U_""_U_PDEN1CT_U_PNUM1CT_U_PMP
 ; 15 16 17 18
 S BGPSSTR=BGPSSTR_U_""_U_BDEN1CT_U_BNUM1CT_U_BMP
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,BGPDNCNT)=BGPSSTR
 Q
 ;
SUM28B ;Populate "BGPMU SUMMARY" for Tobacco Cessation
 ;Initialize iCare/summary global
 N BGPDNCNT,BGPSSTR,J,N
 S BGPDNCNT=0
 K ^TMP("BGPMU SUMMARY",$J,BGPIC)
 S ^TMP("BGPMU SUMMARY",$J,BGPIC)="0028b"_U_"115"
 S N=1 ;only 1 numerator
 ;Setup summary page/iCare ^TMP global
 S CDEN1CT=+$G(^TMP("BGPMU0028B",$J,"C","DEN",N))                 ;current
 S CNUM1CT=+$G(^TMP("BGPMU0028B",$J,"C","INCL",N))
 S CMP=$S(CDEN1CT>0:$$ROUND^BGPMUA01(CNUM1CT/CDEN1CT,3)*100,1:0)
 S PDEN1CT=+$G(^TMP("BGPMU0028B",$J,"P","DEN",N))                 ;previous
 S PNUM1CT=+$G(^TMP("BGPMU0028B",$J,"P","INCL",N))
 S PMP=$S(PDEN1CT>0:$$ROUND^BGPMUA01(PNUM1CT/PDEN1CT,3)*100,1:0)
 S BDEN1CT=+$G(^TMP("BGPMU0028B",$J,"B","DEN",N))                 ;baseline
 S BNUM1CT=+$G(^TMP("BGPMU0028B",$J,"B","INCL",N))
 S BMP=$S(BDEN1CT>0:$$ROUND^BGPMUA01(BNUM1CT/BDEN1CT,3)*100,1:0)
 S BGPDNCNT=BGPDNCNT+1
 S BGPSSTR="MU.EP.0028B."_N_U_"18+ cessation counsel/agent w/in 24 mos"_U_0_U_CDEN1CT_U_CNUM1CT_U_CMP_U_U_U_U
 ; 11 12 13 14
 S BGPSSTR=BGPSSTR_U_""_U_PDEN1CT_U_PNUM1CT_U_PMP
 ; 15 16 17 18
 S BGPSSTR=BGPSSTR_U_""_U_BDEN1CT_U_BNUM1CT_U_BMP
 S ^TMP("BGPMU SUMMARY",$J,BGPIC,BGPDNCNT)=BGPSSTR
 Q
 ;
LARGE(N1,N2) ;large function returns the largest of the 2 values
 I N1>N2 Q N1
 I N2>N1 Q N2
 Q N1
 ;
TESTB ; debug target
 ;S U="^"
 ;S DUZ=1
 ;S DT=3110217
 ;S J=7404
 ;S BGPIOSL=20
 ;S BGPGPG=1
 ;S DFN=184
 ;S DFN=158
 ;S BGPBDATE=3100101
 ;S BGPEDATE=3110401
 ;S BGPPROV=2
 ;S BGPMUTF="C"
 ;D TOB
 Q
