ABMDE30 ; IHS/ASDST/DMJ - Page 3 - QUESTIONS - Display ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p3 - nda-0402-180192 - Added new block 19 stuff
 ; IHS/SD/SDR - V2.5 p5 - Added code to change PATIENT to DISCHARGE STATUS
 ; IHS/SD/SDR - v2.5 p8 - IM14693/IM16105 - Added code for Number of Enclosures and Accident State
 ; IHS/SD/SDR - V2.5 P8 - IM12246/IM17548 - Reference and In-House CLIA numbers
 ; IHS/SD/SDR - v2.5 p9 - IM18516 - Delayed Reason Code
 ; IHS/SD/SDR - v2.5 p10 - IM20022 - Changed to use ROI/AOB multiples
 ; IHS/SD/SDR - v2.5 p10 - IM20076 - Added EPSDT referral info
 ; IHS/SD/SDR - v2.5 p10 - IM20462 - Fixed outside lab charges prompt
 ;   NOTE:  all old code removed due to routine size
 ; IHS/SD/SDR - v2.5 p10 - IM21944 -  Fix for error <SUBSCR>W34+3^ABMDE30
 ; IHS/SD/SDR - v2.5 p11 - NPI - Split routine due to size; new routine ABMDE301
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - modified AoB to accept "W"
 ; *********************************************************************
W1 ;EP - release of information
 W "Release of Information..: "
 D W1SET
 W $S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,4)="Y":"YES",1:"NO")
 I $E(ABMP("BTYP"),2)'<3 D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,4)="Y" D
 ..;ROI date
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,11)'="" D
 ...W ?37,"From: ",$$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,11))
 ..E  I $D(^AUPNPAT(ABMP("PDFN"),36,0)) D
 ...S ABMROIDT=$O(^AUPNPAT(ABMP("PDFN"),36,"B",""),-1)
 ...I $G(ABMROIDT)'="" D
 ....S DIE="^ABMDCLM(DUZ(2),"
 ....S DA=ABMP("CDFN")
 ....S DR=".711////"_ABMROIDT
 ....D ^DIE
 ....W ?37,"From: ",$$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,11))
 Q
 ;**********************************************************************
W1SET ;CHECK FOR RELEASE OF INFORMATION & SET
 Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,11)'=""
 Q:(+$O(^AUPNPAT(ABMP("PDFN"),36,0)))=0
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".74////Y;.711////"_$P($G(^AUPNPAT(ABMP("PDFN"),36,$O(^AUPNPAT(ABMP("PDFN"),36,9999999),-1),0)),U)
 D ^DIE K DR
 Q
 ;**********************************************************************
W2 ;EP - assignment of benefits
 W "Assignment of Benefits..: "
 D W2SET
 ;W $S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,5)="Y":"YES",1:"NO")  ;abm*2.6*6 5010
 W $S($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,5)="Y":"YES",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,5)="W":"Patient Refused",1:"NO")  ;abm*2.6*6 5010
 I $E(ABMP("BTYP"),2)'<3 D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,5)="Y" D
 ..;AOB date
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,12)'="" D
 ...W ?37,"From: ",$$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,12))
 ..E  I $D(^AUPNPAT(ABMP("PDFN"),71,0)) D
 ...S ABMAOBDT=$O(^AUPNPAT(ABMP("PDFN"),71,"B",""),-1)
 ...I $G(ABMAOBDT)'="" D
 ....S DIE="^ABMDCLM(DUZ(2),"
 ....S DA=ABMP("CDFN")
 ....S DR=".712////"_ABMAOBDT
 ....D ^DIE
 ...W ?37,"From: ",$$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,12))
 Q
 ;**********************************************************************
W2SET ;SET ASSIGNMENT OF BENEFITS   
 Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,12)'=""
 Q:(+$O(^AUPNPAT(ABMP("PDFN"),71,0)))=0
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".75////Y;.712////"_$P($G(^AUPNPAT(ABMP("PDFN"),71,$O(^AUPNPAT(ABMP("PDFN"),71,9999999),-1),0)),U)
 D ^DIE K DR
 Q
 ;**********************************************************************
W3 ;
 W "Accident Related........: "
 S ABM8=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8))
 I '$P(ABM8,U,2),'$P(ABM8,U,3) D  Q
 .W "NO"
 .K ABM8
 W "YES"
 I $P(ABM8,U,3) D
 .S ABM("Y")=$P(ABM8,U,3)
DD ;
 I  D
 .S ABM("Y0")=$P(^DD(9002274.3,.83,0),U,3)
 .S ABM("Y0")=$P($P(ABM("Y0"),ABM("Y")_":",2),";",1)
 .W "  ",ABM("Y0")
 .W " ",$$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,2))," "
 .W:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,4)]"" $P(^(8),U,4),"00HRS"
 K ABM8
 I ABMP("EXP")=25,($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,16)'="") D
 .W " ",$P($G(^DIC(5,$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,16),0)),U,2)
 Q
 ;**********************************************************************
W4 ;EP - for Employment Info
 W "Employment Related......: "
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U)'="Y" D  Q
 .W "NO"
 W "YES"
 I $E(ABM("QU"),$L(ABM("QU")))="B",$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,3)]"" D  Q
 .W ?36,"Unable to Work Fr: ",$$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,3))
 .W ?66,"To: ",$$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,4))
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,2)]"" D
 .W ?37,"Date Able to Work...: "
 .W $$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,2))
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,3)]"" D
 .W !?37,"Total Disab. From...: "
 .W $$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,3))
 .W ?68,"To: ",$$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,4))
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,5)]"" D
 .W !?37,"Partial Disab. From.: "
 .W $$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,5))
 .W ?68,"To: ",$$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,6))
 Q
 ;**********************************************************************
W5 ;EP to Disp ER Info
 W "Emergency Room Required.: "
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)) D
 .I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,5)="Y" D
 ..W "YES"
 ..I ABMP("PAGE")[8&($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,10)) D
 ...W "  $",$FN($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,10),",",2)
 .E  W "NO"
 Q
 ;**********************************************************************
W6 ;EP to Disp Sp Prog
 W "Special Program.........: "
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),59))=10 D
 .S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,0))
 .I ABM("X")]"" D
 ..S ABM("X")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,ABM("X"),0),U)
 ..I $D(^ABMDCODE(ABM("X"),0)) D
 ...W "YES  ",$P(^ABMDCODE(ABM("X"),0),U,3)
 ...I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,ABM("X"),1,0)) D
 ....S ABMIEN=0
 ....W ?60,"Referral: "
 ....F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,ABM("X"),1,ABMIEN)) Q:+ABMIEN=0  D
 .....W $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,ABM("X"),1,ABMIEN,0)),U)_" "
 I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,0))=0 W "NO"
 Q
 ;**********************************************************************
W7 ;EP to Disp Lab Info
 W "Outside Lab Charges.....: "
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)) D
 .I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,1)>0  D
 ..W "YES  $",$FN($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U),",",2)
 .E  W "NO  $",$FN($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U),",",2)
 Q
 ;**********************************************************************
W8 ;EP to Disp Blood Info
 W "Blood Furnished.(pints).: "
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)) D
 .I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,6)>0 D
 ..W "YES"
 ..W ?37,"Furnished.....: ",$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,6)
 ..W ?59,"Replaced...: ",$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,7)
 ..W !?37,"Not Replaced..: ",$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,8)
 ..W ?59,"Deductible.: ",$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,9)
 .E  W "NO"
 Q
 ;**********************************************************************
W9 ;EP to Disp 1st Symp
 W "Date of First Symptom...: "
 W $$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,6))
 Q
 ;**********************************************************************
W10 ;EP to Disp Siml Symptom
 W "Date of Similar Symptom.: "
 W $$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,9))
 Q
 ;**********************************************************************
W11 ;EP to Disp 1st Consult
 W "Date of 1st Consultation: "
 W $$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,7))
 Q
 ;**********************************************************************
W12 ;EP to Disp Referring Phys
 W "Referring Phys. (FL17)  : "
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)) D
 .I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,8)]"" D
 ..W $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,8)
 ..S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..I ABMNPIU="N" D
 ...W "    NPI: ",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,17)
 ..I ABMNPIU="B" D
 ...W "    ID/NPI: ",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,11)_"/"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,17)
 ..I ABMNPIU=""!(ABMNPIU="L") D
 ...W:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,11) "    I.D. Number: ",$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,11)
 Q
 ;**********************************************************************
W13 ;EP to Disp Revenue Info
 W "Revenue Code/Charge.....: "
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)) D
 .Q:'$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,8)
 .W $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,7),"  $"
 .W $FN($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),9),U,8),",",2)
 Q
 ;**********************************************************************
W14 ;EP to Disp Case Number
 W "Case No. (External ID)..: "
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),4)),U,8)]"" D
 .W $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),4),U,8)
 Q
 ;**********************************************************************
W15 ;EP to Disp MCD Number
 W "Resubmission(Control) No: "
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),4)),U,9)]"" D
 .W $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),4),U,9)
 Q
 ;**********************************************************************
W16 ;EP to Disp Radiographs
 W "Radiographs Enclosed....: "
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),4)),U,3) D
 .W "YES"
 .W ?37,"Number Submitted....: "
 .W $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),4),U,3)
 E  W "NO"
 Q
 ;**********************************************************************
W17 ;EP to Disp Orthodontics
 W "Orthodontic Related.....: "
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),4)),U,4) D
 .W "YES"
 .W ?37,"Placement Date...: "
 .W $$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),4),U,5))
 .W " for "_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),4)),U,13)_" mths"
 E  W "NO"
 Q
 ;**********************************************************************
W18 ;EP to Disp Prosthesis
 W "Init Prosthesis Placed..: "
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),4)),U,6) W "YES" Q
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),4)),U,6)=0 D
 .W "NO"
 .W ?37,"Prior Placement Date: "
 .W $$SDT^ABMDUTL($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),4),U,7))
 E  W "NO"
 Q
 ;**********************************************************************
W19 ;EP to Disp PRO Number
 W "PRO Approval Number.....: "
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,8)]"" D
 .W $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),5),U,8)
 Q
 ;**********************************************************************
W20 ;EP to Disp HCFA-1500B Block 19
 W "HCFA-1500B Block 19.....: "
 S ABMWRIT=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),10)),U)
 I $L(ABMWRIT)<48 W ABMWRIT
 E  S ABMU("TXT")=ABMWRIT,ABMU("LM")=25,ABMU("RM")=78,ABM("TAB")=5 D PRTTXT^ABMDWRAP
 K ABMWRIT
 Q
 ;**********************************************************************
W21 ;EP Admission Type
 W "Type of Admission.......: "
 S ABM(21)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U)
 I $D(^ABMDCODE(+ABM(21),0)) D
 .W " ",$P(^ABMDCODE(+ABM(21),0),U),"  "
 .W $E($P(^ABMDCODE(+ABM(21),0),U,3),1,40)
 Q
 ;**********************************************************************
W22 ;EP Admission Source
 W "Source of Admission.....: "
 S ABM(22)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,2)
 I $D(^ABMDCODE(+ABM(22),0)) D
 .W " ",$P(^ABMDCODE(+ABM(22),0),U),"  "
 .W $E($P(^ABMDCODE(+ABM(22),0),U,3),1,40)
 Q
 ;**********************************************************************
W23 ;EP Patient Status
 W "Discharge Status..........: "
 S ABM(23)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,3)
 I $D(^ABMDCODE(+ABM(23),0)) D
 .I $L($P(^ABMDCODE(+ABM(23),0),U))=1 W 0
 .W $P(^ABMDCODE(+ABM(23),0),U),"  "
 .N I
 .F I=1:1:$L($P(^ABMDCODE(+ABM(23),0),U,3)," ") D
 ..W $P($P(^ABMDCODE(+ABM(23),0),U,3)," ",I)," "
 ..I $X>70 W !,?35
 Q
 ;**********************************************************************
W24 ;EP Admitting DX
 W "Admitting Diagnosis.....: "
 S ABM(24)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,9)
 Q:'ABM(24)
 W $P($$DX^ABMCVAPI(ABM(24),""),U,2),"  ",$P($$DX^ABMCVAPI(ABM(24),ABMP("VDT")),U,4)  ;CSV-c
 Q
W25 ;EP Supervising Prov UPIN
 W "Supervising Prov.(FL19).: "
 S ABM(25)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,12)
 W ABM(25)
 S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 I ABMNPIU="N" D
 .W "    NPI: ",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,25)
 I ABMNPIU="B" D
 .W "    ID/NPI: ",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,24)_"/"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,25)
 I ABMNPIU=""!(ABMNPIU="L") D
 .W "    I.D. Number: ",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,24)
 W !,?7,"Date Last Seen: "
 S ABMDTSN=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,11)
 Q:'ABMDTSN
 W $$SDT^ABMDUTL(ABMDTSN)
 K ABMDTSN
 Q
 ;**********************************************************************
W26 ;EP Date of Last X-Ray
 W "Date of Last X-Ray......: "
 S ABM(26)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,13)
 Q:'ABM(26)
 W $$SDT^ABMDUTL(ABM(26))
 Q
 ;**********************************************************************
W27 ;EP Referral Number
 W "Referral Number.........: "
 S ABM(27)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,11)
 W ABM(27)
 Q
W28 ;EP Prior Authorization Number
 W "Prior Authorization #...: "
 S ABM(28)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,12)
 W ABM(28)
 Q
 ;**********************************************************************
W29 ;EP Homebound Indicator
 W "Homebound Indicator.....: "
 S ABM(29)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,14)
 W ABM(29)
 Q
