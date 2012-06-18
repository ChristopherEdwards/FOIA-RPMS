BGPMUDD1 ; IHS/MSC/SAT - Print MI measure NQF0028 ;21-Mar-2011 13:15;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;Delimited output
 ;Get printout for Tobacco Assessment measure 0028A
TOB2 ;EP
 D P1A
 K ^TMP("BGPMU0028A")
 Q
P1A ;Write individual measure
 N BGPPTYPE,X,Y,Z,DEN,NUM,PC,STRING1,STRING2,PRD,PRN,PRD1,PRN1
 S BGPPTYPE="D"
 S STRING1=$$A28("C")
 S STRING2=$$A28("P")
 S STRING3=$$A28("B")
 D SUM28A^BGPMUDP1
 S PRD1=$P(STRING1,U,7)-$P(STRING2,U,7)
 S PRD2=$P(STRING1,U,8)-$P(STRING2,U,8)
 S PRB1=$P(STRING1,U,7)-$P(STRING3,U,7)
 S PRB2=$P(STRING1,U,8)-$P(STRING3,U,8)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 18+"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_U_$P(STRING3,U,1) D S^BGPMUDEL(X,2,1)
 S X="# w/tob screen-24 mos"_U_$P(STRING1,U,2)_U_$P(STRING1,U,7)_U_$P(STRING2,U,2)_U_$P(STRING2,U,7)_U_PRD1_U_$P(STRING3,U,2)_U_$P(STRING3,U,7)_U_PRB1
 D S^BGPMUDEL(X,2,1)
 S X="# w/o tob screen-24 mos"_U_$P(STRING1,U,3)_U_$P(STRING1,U,8)_U_$P(STRING2,U,3)_U_$P(STRING2,U,8)_U_PRB2_U_$P(STRING3,U,3)_U_$P(STRING3,U,7)_U_PRB2
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D TA
 Q
A28(TF) ;Get the numbers for this measure
 N ARRAY,DEN1,NONUM,NUM1,PC1
 S DEN1=+$G(^TMP("BGPMU0028A",$J,TF,"DEN",1))
 S NUM1=+$G(^TMP("BGPMU0028A",$J,TF,"INCL",1))
 S NONUM=+$G(^TMP("BGPMU0028A",$J,TF,"NOT",1))
 I DEN1=0 S (PC1,PC2)=0
 I DEN1>0 D
 .S PC1=$$ROUND^BGPMUA01((NUM1/DEN1),3)*100
 .S PC2=$$ROUND^BGPMUA01((NONUM/DEN1),3)*100
 S ARRAY=DEN1_U_NUM1_U_NONUM_U_""_U_""_U_""_U_PC1_U_PC2
 Q ARRAY
TA ;Do the Details
 N PT,NODE,NAME,BP,PTCT
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 ;D HEADER^BGPMUPH Q:BGPQUIT
 S X="Preventive Care and Screening Measure Pair: Tobacco Use Assessment, NQF 0028a/PQRI 114" D S^BGPMUDEL(X,2,1)
 S X="Patients 18+ with at least 1 or 2 encounters with the EP during the reporting period, with documented tobacco screening within 24 months, if any." D S^BGPMUDEL(X,2,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,2,1)
 S X="The following are the abbreviations used in the denominator column:" D S^BGPMUDEL(X,2,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR" D S^BGPMUDEL(X,2,1)
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
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;
DATA3(NODE) ;GET DATA
 N AGE,DEN,DFN,COMM,HRN,NAME,NUM,SEX
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,15)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,9)
 S DEN=$P(NODE,U,2)
 S NUM=$P(NODE,U,3)
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE
 S X=X_U_"EN:"_$P($$FMTE^XLFDT($P($P(DEN,":",1),";",1),2),"@",1)
 S X=X_$S($L($P(DEN,":",1),";")>1:";",1:"")_$S($P($P(DEN,":",1),";",2)'="":"EN:"_$P($$FMTE^XLFDT($P($P(DEN,":",1),";",2),2),"@",1),1:"")_$S($P(DEN,":",2)'="":";"_"HF:"_$P($$FMTE^XLFDT($P(DEN,":",2),2),"@",1),1:"")
 S X=X_U_$S(NUM'="":"M:"_$P(NUM,";",1)_" "_$$FMTE^XLFDT($P(NUM,";",2),2),1:"NM:")
 D S^BGPMUDEL(X,1,1)
 Q
 ;
 ;Get printout for Tobacco Cessation measure 0028B
TOB ;EP
 D P1B
 K ^TMP("BGPMU0028B")
 Q
P1B ;Write individual measure
 N BGPPTYPE,X,Y,Z,DEN,NUM,PC,STRING1,STRING2,PRD,PRN,PRD1,PRN1
 S BGPPTYPE="D"
 S STRING1=$$B28("C")
 S STRING2=$$B28("P")
 S STRING3=$$B28("B")
 D SUM28B^BGPMUDP1
 S PRD1=$P(STRING1,U,7)-$P(STRING2,U,7)
 S PRD2=$P(STRING1,U,8)-$P(STRING2,U,8)
 S PRB1=$P(STRING1,U,7)-$P(STRING3,U,7)
 S PRB2=$P(STRING1,U,8)-$P(STRING3,U,8)
 S X=U_"REPORT PERIOD"_U_"%"_U_"PREV YR PERIOD"_U_"%"_U_"CHG FROM PREV YR"_U_"BASE YEAR"_U_"%"_U_"CHG FROM BASE"
 D S^BGPMUDEL(X,2,1)
 S X="Pts 18+/Tobacco user/24mos"_U_$P(STRING1,U,1)_U_U_$P(STRING2,U,1)_U_U_U_$P(STRING3,U,1) D S^BGPMUDEL(X,2,1)
 S X="# w/cess counsel/agent/24 mos"_U_$P(STRING1,U,2)_U_$P(STRING1,U,7)_U_$P(STRING2,U,2)_U_$P(STRING2,U,7)_U_PRD1_U_$P(STRING3,U,2)_U_$P(STRING3,U,7)_U_PRB1
 D S^BGPMUDEL(X,2,1)
 S X="# w/o cess counsel/agent/24mos"_U_$P(STRING1,U,3)_U_$P(STRING1,U,7)_U_$P(STRING2,U,3)_U_$P(STRING2,U,7)_U_PRB2_U_$P(STRING3,U,3)_U_$P(STRING3,U,7)_U_PRB2
 D S^BGPMUDEL(X,1,1)
 I $D(BGPLIST(BGPIC)) D TC
 Q
B28(TF) ;Get the numbers for this measure
 N ARRAY,DEN1,NONUM,NUM1,PC1
 S DEN1=+$G(^TMP("BGPMU0028B",$J,TF,"DEN",1))
 S NUM1=+$G(^TMP("BGPMU0028B",$J,TF,"INCL",1))
 S NONUM=+$G(^TMP("BGPMU0028B",$J,TF,"NOT",1))
 I DEN1=0 S (PC1,PC2)=0
 I DEN1>0 D
 .S PC1=$$ROUND^BGPMUA01((NUM1/DEN1),3)*100
 .S PC2=$$ROUND^BGPMUA01((NONUM/DEN1),3)*100
 S ARRAY=DEN1_U_NUM1_U_NONUM_U_""_U_""_U_""_U_PC1_U_PC2
 Q ARRAY
TC ;Do the Details
 N PT,NODE,NAME,BP
 S X="**** CONFIDENTIAL PATIENT INFORMATION COVERED BY PRIVACY ACT ****" D S^BGPMUDEL(X,2,1)
 ;D HEADER^BGPMUPH Q:BGPQUIT
 S X="Preventive Care and Screening Measure Pair: Tobacco Use Assessment, NQF 0028b/PQRI 115" D S^BGPMUDEL(X,2,1)
 S X="Patients 18+ with at least 1 or 2 encounters with the EP during the reporting" D S^BGPMUDEL(X,2,1)
 S X="period and who have been identified as tobacco users within the last 24 months," D S^BGPMUDEL(X,1,1)
 S X="with documented cessation intervention, if any." D S^BGPMUDEL(X,1,1)
 S X="Patients who do not meet the numerator criteria are listed first (NM:), followed" D S^BGPMUDEL(X,2,1)
 S X="by patients who do meet the numerator criteria (M:)." D S^BGPMUDEL(X,1,1)
 S X="The following are the abbreviations used in the denominator column:" D S^BGPMUDEL(X,2,1)
 S X="EN=Encounter" D S^BGPMUDEL(X,1,1)
 S X="HF=Tobacco User health Factor" D S^BGPMUDEL(X,1,1)
 S X="PATIENT NAME"_U_"HRN"_U_"COMMUNITY"_U_"SEX"_U_"AGE"_U_"DENOMINATOR"_U_"NUMERATOR" D S^BGPMUDEL(X,1,1)
 S PTCT=0
 I BGPLIST="D"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0028B"","_$J_",""C"",""NOT"",""PAT"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA4(NODE)
 I BGPLIST="N"!(BGPLIST="A") D
 .K BGPARR
 .D PTLSORT^BGPMUUTL(.BGPARR,"^TMP(""BGPMU0028B"","_$J_",""C"",""INCL"",""PAT"",1)")
 .S PT=0 F  S PT=$O(BGPARR(PT)) Q:PT=""  D
 ..S PTCT=PTCT+1
 ..S NODE=$G(BGPARR(PT))
 ..D DATA4(NODE)
 S X="Total # of patients on list: "_PTCT D S^BGPMUDEL(X,2,1)
 Q
 ;
DATA4(NODE) ;GET DATA
 N AGE,DEN,DFN,COMM,HRN,NAME,NUM,SEX
 S DFN=$P(NODE,U,1)
 S NAME=$E($$GET1^DIQ(2,$P(NODE,U,1),.01),1,15)
 S HRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 S AGE=$$AGE^AUPNPAT(DFN,BGPED)
 S SEX=$$SEX^AUPNPAT(DFN)
 S COMM=$E($$GET1^DIQ(9000001,DFN,1118),1,9)
 S DEN=$P(NODE,U,2),NUM=$P(NODE,U,3)
 ;line 1
 S X=NAME_U_HRN_U_COMM_U_SEX_U_AGE
 S X=X_U_$S($P(DEN,";",1)'="":"EN:"_$P($$FMTE^XLFDT($P(DEN,";",1),2),"@",1)_$S($L(DEN,";")>1:";",1:""),1:"")
 I $L(DEN,";")>1 S X=X_";"_$S($P(DEN,";",2)'="":"EN:"_$P($$FMTE^XLFDT($P(DEN,";",2),2),"@",1),1:"")
 S X=X_U_$S(NUM'="":"M:"_$E($P(NUM,";",1),1,15),1:"NM:")
 I $L(NUM,";")>1 S X=X_";"_$S($P(NUM,";",2)'="":$P($$FMTE^XLFDT($P(NUM,";",2),2),"@",1),1:"")
 D S^BGPMUDEL(X,1,1)
 Q
 ;
XML0028A ;XML output for TOBACCO ASSESSMENT measure
 ; BGPXML(i)=Population Number^Numerator Number^Denominator Count
 N STRING
 S STRING=$$A28("C")
 S BGPXML(1)="NQF_0028A"_U_U_+$P(STRING,U,1)_U_+$P(STRING,U,2)
 K ^TMP("BGPMU0028A",$J)
 Q
 ;
XML0028B ;XML output for TOBACCO ASSESSMENT measure
 ; BGPXML(i)=Population Number^Numerator Number^Denominator Count
 N STRING
 S STRING=$$B28("C")
 S BGPXML(1)="NQF_0028B"_U_U_+$P(STRING,U,1)_U_+$P(STRING,U,2)
 K ^TMP("BGPMU0028B",$J)
 Q
