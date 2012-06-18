BIREPD3 ;IHS/CMI/MWR - REPORT, ADOLESCENT RATES; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW ADOLESCENT IMMUNIZATION RATES REPORT.
 ;
 ;
 ;----------
GETDATA(BICC,BIHCF,BICM,BIBEN,BIQDT,BIDAR,BIAGRPS,BISITE,BIUP,BITMP,BIERR) ;EP
 ;---> Gather Immunization History data on selected patients.
 ;---> Parameters:
 ;     1 - BICC    (req) Current Community array.
 ;     2 - BIHCF   (req) Health Care Facility array.
 ;     3 - BICM    (req) Case Manager array.
 ;     4 - BIBEN   (req) Beneficiary Type array.
 ;     5 - BIQDT   (req) Quarter Ending Date.
 ;     6 - BIDAR   (opt) Adolescent Age Range: "11-18^1" (years).
 ;     7 - BIAGRPS (req) String of Age Groups ("1112,1313,1317").
 ;     8 - BISITE  (req) Site IEN.
 ;     9 - BIUP    (req) User Population/Group (All, Imm, User, Active).
 ;    10 - BITMP   (ret) Stores Patient Totals by Age Group and Sex.
 ;    11 - BIERR   (ret) Error.
 ;
 S:'$G(BISITE) BISITE=$G(DUZ(2)) I '$G(BISITE) S BIERR=109 Q
 S:'$G(BIQDT) BIQDT=DT
 S:'$D(BIDAR) BIDAR="11-18^1"
 S:$G(BIUP)="" BIUP="u"
 ;
 ;---> Get Begin and End Dates (DOB's).
 D AGEDATE^BIAGE(BIDAR,BIQDT,.BIBEGDT,.BIENDDT,.BIERR)
 Q:$G(BIERR)]""
 ;
 ;---> Gather and sort patients.
 D GETPATS^BIREPD4(BIBEGDT,BIENDDT,.BICC,.BIHCF,.BICM,.BIBEN,BIQDT,BIAGRPS,BISITE,BIUP,.BITMP)
 Q
 ;
 ; Call from BIREPD2: F BIVGRP=4,6,7,8,9,16,10,17 D VGRP^BIREPD3(.BILINE,BIVGRP,BIAGRPS,BISEX,.BIERR)
 ;
 ;----------
VGRP(BILINE,BIVGRP,BIAGRPS,BITMP,BISEX,BIERR) ;EP
 ;---> Write Stats lines for each Vaccine Group.
 ;---> Parameters:
 ;     1 - BILINE  (req) Line number in ^TMP Listman array.
 ;     2 - BIVGRP  (req) IEN of Vaccine Group.
 ;     3 - BIAGRPS (req) String of Age Groups ("1112,1313,1317").
 ;     4 - BITMP   (req) Stores Patient Totals by Age Group and Sex.
 ;     5 - BISEX   (opt) F or M for HPV.
 ;     6 - BIERR   (ret) Error.
 ;
 I '$G(BIVGRP) D ERRCD^BIUTL2(510,.BIERR) Q
 I '$G(BIAGRPS) D ERRCD^BIUTL2(677,.BIERR) Q
 ;
 ;---> Write two lines for each Dose of this Vaccine Group.
 N BIDOSE,BIMAXD S BIMAXD=$$VGROUP^BIUTL2(BIVGRP,7)
 ;
 ;---> Include exception here for Tdap.
 I ((BIVGRP=132)!(BIVGRP=221)) S BIMAXD=1
 ;
 F BIDOSE=1:1:BIMAXD D
 .;---> BIX=text of the line to write.
 .;
 .;---> First, write the Dose#-Vaccine Group in left margin.
 .N BIX D
 ..;---> Include exception here for Tdap.
 ..I BIVGRP=132 S BIX=" Hx of Chickenpox" Q
 ..I BIVGRP=221 S BIX="    1-Tdap" Q
 ..I BIVGRP=8 S BIX="    1-Tdap/Td" Q
 ..S BIX="    "_BIDOSE_"-"_$$VGROUP^BIUTL2(BIVGRP,5)
 .;
 .S BIX=$$PAD^BIUTL5(BIX,17)_"|"
 .;
 .;---> Write actual totals line for this dose for each Age Group
 .;---> (loop through the age groups, concating the totals horizontally).
 .N BIAGRP,K
 .F K=1:1 S BIAGRP=$P(BIAGRPS,",",K) Q:'BIAGRP  D
 ..N Y D
 ...;---> If HPV (17), append sex to age group to retrieve HPV stats.
 ...I BIVGRP=17 S Y=+$G(BITMP("STATS",BIVGRP,BIDOSE,BIAGRP_BISEX)) Q
 ...S Y=+$G(BITMP("STATS",BIVGRP,BIDOSE,BIAGRP))
 ..;
 ..S BIX=BIX_$J(Y,12)_" "
 .D WRITE(.BILINE,BIX)
 .D MARK^BIW(BILINE,3,"BIREPD1")
 .;
 .;
 .;---> Now write Percentages line for each Age Group (under the actual totals).
 .S BIX="" S:BIVGRP=132 BIX="    (Immune)"
 .S BIX=$$PAD^BIUTL5(BIX,17)_"|"
 .F K=1:1 S BIAGRP=$P(BIAGRPS,",",K) Q:'BIAGRP  D
 ..;N Y S Y=$G(BITMP("STATS",BIVGRP,BIDOSE,BIAGRP))
 ..N Y D
 ...;---> If HPV (17), append sex to age group to retrieve HPV stats.
 ...I BIVGRP=17 S Y=+$G(BITMP("STATS",BIVGRP,BIDOSE,BIAGRP_BISEX)) Q
 ...S Y=+$G(BITMP("STATS",BIVGRP,BIDOSE,BIAGRP))
 ..;
 ..I 'Y S BIX=BIX_$J("",12)_" " Q
 ..;
 ..;---> If Vaccine Group is HPV-17, use female denominators.
 ..N Z S Z=$G(BITMP("STATS",$S(BIVGRP=17:"TOTLFPTS",1:"TOTLPTS"),BIAGRP))
 ..;---> To avoid bomb if Z=0/null.
 ..S:'Z Y=0,Z=1 S Y=(Y*100)/Z
 ..S BIX=BIX_$J(Y,12,0)_"%"
 ..;S BIX=BIX_$J(Y,$S(K=1:9,1:12),0)_"%"
 .D WRITE(.BILINE,BIX)
 .Q:BIDOSE=BIMAXD
 .;
 .;---> Write a dashed line to close off this Dose.
 .S BIX=$$SP^BIUTL5(17)_"|"_$$SP^BIUTL5(62,"-")
 .D WRITE(.BILINE,BIX)
 ;
 ;---> Write a final dashed line to close off this Vaccine Group (unless Tdap).
 D
 .I BIVGRP=221 S BIX=$$SP^BIUTL5(17)_"|"_$$SP^BIUTL5(62,"-") Q
 .S BIX=$$SP^BIUTL5(79,"-")
 D WRITE(.BILINE,BIX)
 Q
 ;
 ;
 ;----------
VCOMB(BILINE,BICOMB,BIAGRPS,BITMP,BISEX,BIERR) ;EP
 ;---> Write Stats lines for each Vaccine Combination.
 ;---> Parameters:
 ;     1 - BILINE  (req) Line number in ^TMP Listman array.
 ;     2 - BICOMB  (req) Numeric code of Vaccine Combination.
 ;     3 - BIAGRPS (req) String of Age Groups ("1112,1313,1317").
 ;     4 - BITMP   (ret) Stores Patient Totals by Age Group and Sex.
 ;     5 - BISEX   (opt) F or M for HPV.
 ;     6 - BIERR   (ret) Error.
 ;
 I '$G(BIAGRPS) D ERRCD^BIUTL2(677,.BIERR) Q
 ;
 ;---> Build the left-most cell that lists the vaccines for this combo.
 N BIX,I,Q,X S Q=0
 F I=1:1:4 S BIX(I)=""
 F I=1:1 S X=$P(BICOMB,U,I) Q:Q  D
 .I ((X="")&(BICOMB'[17)) S Q=1 Q
 .S:(X="") X=$S(BISEX="F":"(females)",BISEX="M":"(males)",1:"???"),Q=1
 .S:'Q X=$P(X,"|",2)_"-"_$$VGROUP^BIUTL2($P(X,"|"),5)
 .I I<3 S BIX(1)=BIX(1)_" "_X Q
 .I I<5 S BIX(2)=BIX(2)_" "_X Q
 .I I<7 S BIX(3)=BIX(3)_" "_X Q
 .S BIX(4)=BIX(4)_" "_X
 ;
 ;---> Write actual totals line for this Combo for each Age Group
 ;---> (loop through the Age Groups.
 S BIX=BIX(1),BIX=$$PAD^BIUTL5(BIX,17)_"|"
 N BIAGRP,K
 F K=1:1 S BIAGRP=$P(BIAGRPS,",",K) Q:'BIAGRP  D
 .N Y D
 ..;---> If HPV (17), append sex to age group to retrieve HPV stats.
 ..I $G(BISEX)="F" S Y=+$G(BITMP("STATS",BICOMB,BIAGRP_"F")) Q
 ..I $G(BISEX)="M" S Y=+$G(BITMP("STATS",BICOMB,BIAGRP_"M")) Q
 ..S Y=+$G(BITMP("STATS",BICOMB,BIAGRP))
 .;
 .S BIX=BIX_$J(Y,12)_" "
 D WRITE(.BILINE,BIX)
 S I=3 S:BIX(3)]"" I=4 S:BIX(4)]"" I=5
 D MARK^BIW(BILINE,I,"BIREPD1")
 ;
 ;---> Now write percentages line.
 S BIX=BIX(2),BIX=$$PAD^BIUTL5(BIX,17)_"|"
 F K=1:1 S BIAGRP=$P(BIAGRPS,",",K) Q:'BIAGRP  D
 .N Y D
 ..;---> If HPV (17), append sex to age group to retrieve HPV stats.
 ..I $G(BISEX)="F" S Y=$G(BITMP("STATS",BICOMB,BIAGRP_"F")) Q
 ..I $G(BISEX)="M" S Y=$G(BITMP("STATS",BICOMB,BIAGRP_"M")) Q
 ..S Y=$G(BITMP("STATS",BICOMB,BIAGRP))
 .;
 .I 'Y S BIX=BIX_$J("",12)_" " Q
 .I '$G(BITMP("STATS","TOTLPTS")) S BIX=BIX_$J(Y,7)_"  " Q
 .N Z S Z=$G(BITMP("STATS",$S(BICOMB[17:"TOTLFPTS",1:"TOTLPTS"),BIAGRP))
 .;---> To avoid bomb if Z=0/null.
 .S:'Z Y=0,Z=1 S Y=(Y*100)/Z
 .S BIX=BIX_$J(Y,12,0)_"%"
 .;S BIX=BIX_$J(Y,$S(K=1:9,1:12),0)_"%"
 D WRITE(.BILINE,BIX)
 ;
 F I=3,4 D:BIX(I)]""
 .S BIX=BIX(I),BIX=$$PAD^BIUTL5(BIX,17)_"|"
 .D WRITE(.BILINE,BIX)
 ;
 D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPD1",$G(BIVAL),$G(BIBLNK))
 ;
 ;--->Set VALMCNT (Listman line count) for errors calls above.
 S VALMCNT=BILINE
 Q
