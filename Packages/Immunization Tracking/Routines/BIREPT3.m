BIREPT3 ;IHS/CMI/MWR - REPORT, TWO-YR-OLD RATES; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW TWO-YR-OLD IMMUNIZATION RATES REPORT.
 ;
 ;
 ;----------
GETDATA(BICC,BIHCF,BICM,BIBEN,BIQDT,BITAR,BIAGRPS,BISITE,BIUP,BIERR) ;EP
 ;---> Gather Immunization History data on selected patients.
 ;---> Parameters:
 ;     1 - BICC    (req) Current Community array.
 ;     2 - BIHCF   (req) Health Care Facility array.
 ;     3 - BICM    (req) Case Manager array.
 ;     4 - BIBEN   (req) Beneficiary Type array.
 ;     5 - BIQDT   (req) Quarter Ending Date.
 ;     6 - BITAR   (opt) Two-Yr-Old Age Range; default="19-35" (months).
 ;     7 - BIAGRPS (req) String of Age Groups (e.g., 3,5,7,16,19,24,36)
 ;     8 - BISITE  (req) Site IEN.
 ;     9 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;    10 - BIERR   (ret) Error.
 ;
 S:'$G(BISITE) BISITE=$G(DUZ(2)) I '$G(BISITE) S BIERR=109 Q
 S:'$G(BIQDT) BIQDT=DT
 S:'$D(BITAR) BITAR="19-35"
 S:$G(BIUP)="" BIUP="u"
 ;
 ;---> Get Begin and End Dates (DOB's).
 D AGEDATE^BIAGE(BITAR,BIQDT,.BIBEGDT,.BIENDDT,.BIERR)
 Q:$G(BIERR)]""
 ;
 ;---> Gather and sort patients.
 D GETPATS^BIREPT4(BIBEGDT,BIENDDT,.BICC,.BIHCF,.BICM,.BIBEN,BIQDT,BIAGRPS,BISITE,BIUP)
 Q
 ;
 ;
 ;----------
VGRP(BILINE,BIVGRP,BIAGRPS,BIERR) ;EP
 ;---> Write Stats lines for each Vaccine Group.
 ;---> Parameters:
 ;     1 - BILINE  (req) Line number in ^TMP Listman array.
 ;     2 - BIVGRP  (req) IEN of Vaccine Group.
 ;     3 - BIAGRPS (req) String of Age Groups (e.g., 3,5,7,16,19,24,36)
 ;     4 - BIERR   (ret) Error.
 ;
 I '$G(BIVGRP) D ERRCD^BIUTL2(510,.BIERR) Q
 I '$G(BIAGRPS) D ERRCD^BIUTL2(677,.BIERR) Q
 ;
 ;---> Write two lines for each Dose of this Vaccine Group.
 N BIDOSE,BIMAXD S BIMAXD=$$VGROUP^BIUTL2(BIVGRP,6)
 F BIDOSE=1:1:BIMAXD D
 .;---> BIX=text of the line to write.
 .;---> Write the Dose#-Vaccine Group in left margin.
 .N BIX S BIX="    "_BIDOSE_"-"_$$VGROUP^BIUTL2(BIVGRP,5)
 .S BIX=$$PAD^BIUTL5(BIX,13)_"|"
 .;
 .;---> Now loop through the 6 age groups, concating subtotals.
 .N BIAGRP,K
 .F K=1:1 S BIAGRP=$P(BIAGRPS,",",K) Q:'BIAGRP  D
 ..N Y S Y=$G(BITMP("STATS",BIVGRP,BIDOSE,BIAGRP))
 ..S BIX=BIX_$J(Y,7)_"  "
 .D WRITE(.BILINE,BIX)
 .D MARK^BIW(BILINE,3,"BIREPT1")
 .;
 .;---> Now write percentages line.
 .S BIX=$$SP^BIUTL5(13)_"|"
 .F K=1:1 S BIAGRP=$P(BIAGRPS,",",K) Q:'BIAGRP  D
 ..N Y S Y=$G(BITMP("STATS",BIVGRP,BIDOSE,BIAGRP))
 ..I 'Y S BIX=BIX_$J(Y,7)_"  " Q
 ..I '$G(BITMP("STATS","TOTLPTS")) S BIX=BIX_$J(Y,7)_"  " Q
 ..S Y=(Y*100)/$G(BITMP("STATS","TOTLPTS"))
 ..S BIX=BIX_$J(Y,7,0)_"% "
 .D WRITE(.BILINE,BIX)
 .Q:BIDOSE=BIMAXD
 .S BIX=$$SP^BIUTL5(13)_"|"_$$SP^BIUTL5(65,"-")
 .D WRITE(.BILINE,BIX)
 D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
 ;
 ;
 ;----------
VCOMB(BILINE,BICOMB,BIAGRPS,BIERR,BIUTD) ;EP
 ;---> Write Stats lines for each Vaccine Combination.
 ;---> Parameters:
 ;     1 - BILINE  (req) Line number in ^TMP Listman array.
 ;     2 - BICOMB  (req) Numeric code of Vaccine Combination.
 ;     3 - BIAGRPS (req) String of Age Groups (e.g., 3,5,7,16,19,24,36)
 ;     4 - BIERR   (ret) Error.
 ;     5 - BIUTD   (opt) If BIUTD=1, tack on text: "*UTD"
 ;
 I '$G(BIVGRP) D ERRCD^BIUTL2(678,.BIERR) Q
 I '$G(BIAGRPS) D ERRCD^BIUTL2(677,.BIERR) Q
 ;     vvv83
 ;
 N BIX,I,X
 F I=1:1:5 S BIX(I)=""
 F I=1:1 S X=$P(BICOMB,U,I) Q:X=""  D
 .S X=$P(X,"|",2)_"-"_$$VGROUP^BIUTL2($P(X,"|"),5)
 .I I<3 S BIX(1)=BIX(1)_" "_X Q
 .I I<5 S BIX(2)=BIX(2)_" "_X Q
 .I I<7 S BIX(3)=BIX(3)_" "_X Q
 .I I<9 S BIX(4)=BIX(4)_" "_X S:$G(BIUTD) BIX(4)=BIX(4)_"  *UTD" Q
 .S BIX(5)=BIX(5)_" "_X
 ;
 ;---> Now loop through the age groups, concating subtotals.
 S BIX=BIX(1),BIX=$$PAD^BIUTL5(BIX,13)_"|"
 N BIAGRP,K
 F K=1:1 S BIAGRP=$P(BIAGRPS,",",K) Q:'BIAGRP  D
 .N Y S Y=$G(BITMP("STATS",BICOMB,BIAGRP))
 .S BIX=BIX_$J(Y,7)_"  "
 D WRITE(.BILINE,BIX)
 S I=3 S:BIX(3)]"" I=4 S:BIX(4)]"" I=5
 D MARK^BIW(BILINE,I,"BIREPT1")
 ;
 ;---> Now write percentages line.
 S BIX=BIX(2),BIX=$$PAD^BIUTL5(BIX,13)_"|"
 F K=1:1 S BIAGRP=$P(BIAGRPS,",",K) Q:'BIAGRP  D
 .N Y S Y=$G(BITMP("STATS",BICOMB,BIAGRP))
 .I 'Y S BIX=BIX_$J(Y,7)_"  " Q
 .I '$G(BITMP("STATS","TOTLPTS")) S BIX=BIX_$J(Y,7)_"  " Q
 .S Y=(Y*100)/$G(BITMP("STATS","TOTLPTS"))
 .S BIX=BIX_$J(Y,7,0)_"% "
 D WRITE(.BILINE,BIX)
 ;
 F I=3,4,5 D:BIX(I)]""
 .S BIX=BIX(I),BIX=$$PAD^BIUTL5(BIX,13)_"|"
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
 D WL^BIW(.BILINE,"BIREPT1",$G(BIVAL),$G(BIBLNK))
 ;
 ;--->Set VALMCNT (Listman line count) for errors calls above.
 S VALMCNT=BILINE
 Q
