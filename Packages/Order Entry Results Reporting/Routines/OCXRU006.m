OCXRU006 ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*96) ;JAN 30,2001 at 11:16
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**96**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 D DOT^OCXRULE
 ;
 ;
 K REMOTE,LOCAL,OPCODE,REF
 F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
 .S ^TMP("OCXRULE",$J,$O(^TMP("OCXRULE",$J,"A"),-1)+1)=TEXT
 ;
 G ^OCXRU007
 ;
 Q
 ;
DATA ;
 ;
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^FLAB(|PATIENT IEN|,"SERUM CREATININE^SERUM UREA NITROGEN","SERUM SPECIMEN")
 ;;EOR^
 ;;EOF^OCXS(863.3)^1
 ;;SOF^860.9  ORDER CHECK NATIONAL TERM
 ;;KEY^860.9:^ANGIOGRAM (PERIPHERAL)
 ;;R^"860.9:",.01,"E"
 ;;D^ANGIOGRAM (PERIPHERAL)
 ;;R^"860.9:",.02,"E"
 ;;D^101.43
 ;;EOR^
 ;;KEY^860.9:^BLOOD SPECIMEN
 ;;R^"860.9:",.01,"E"
 ;;D^BLOOD SPECIMEN
 ;;R^"860.9:",.02,"E"
 ;;D^61
 ;;EOR^
 ;;KEY^860.9:^DANGEROUS MEDS FOR PTS > 64
 ;;R^"860.9:",.01,"E"
 ;;D^DANGEROUS MEDS FOR PTS > 64
 ;;R^"860.9:",.02,"E"
 ;;D^101.43
 ;;R^"860.9:",2,"E"
 ;;D^I $P($G(^ORD(100.98,$P($G(^ORD(101.43,+Y,0)),U,5),0)),U)="PHARMACY"
 ;;EOR^
 ;;KEY^860.9:^DNR
 ;;R^"860.9:",.01,"E"
 ;;D^DNR
 ;;R^"860.9:",.02,"E"
 ;;D^101.43
 ;;EOR^
 ;;KEY^860.9:^FOOD-DRUG INTERACTION MED
 ;;R^"860.9:",.01,"E"
 ;;D^FOOD-DRUG INTERACTION MED
 ;;R^"860.9:",.02,"E"
 ;;D^101.43
 ;;R^"860.9:",2,"E"
 ;;D^I $P($G(^ORD(100.98,$P($G(^ORD(101.43,+Y,0)),U,5),0)),U)="PHARMACY"
 ;;EOR^
 ;;KEY^860.9:^NPO
 ;;R^"860.9:",.01,"E"
 ;;D^NPO
 ;;R^"860.9:",.02,"E"
 ;;D^101.43
 ;;EOR^
 ;;KEY^860.9:^ONE TIME MED
 ;;R^"860.9:",.01,"E"
 ;;D^ONE TIME MED
 ;;R^"860.9:",.02,"E"
 ;;D^51.1
 ;;R^"860.9:",2,"E"
 ;;D^I $E($P(^(0),U,4),1,2)="PS"
 ;;EOR^
 ;;KEY^860.9:^PARTIAL THROMBOPLASTIN TIME
 ;;R^"860.9:",.01,"E"
 ;;D^PARTIAL THROMBOPLASTIN TIME
 ;;R^"860.9:",.02,"E"
 ;;D^101.43
 ;;EOR^
 ;;KEY^860.9:^PROTHROMBIN TIME
 ;;R^"860.9:",.01,"E"
 ;;D^PROTHROMBIN TIME
 ;;R^"860.9:",.02,"E"
 ;;D^101.43
 ;;EOR^
 ;;KEY^860.9:^SERUM CREATININE
 ;;R^"860.9:",.01,"E"
 ;;D^SERUM CREATININE
 ;;R^"860.9:",.02,"E"
 ;;D^60
 ;;EOR^
 ;;KEY^860.9:^SERUM SPECIMEN
 ;;R^"860.9:",.01,"E"
 ;;D^SERUM SPECIMEN
 ;;R^"860.9:",.02,"E"
 ;;D^61
 ;;EOR^
 ;;KEY^860.9:^SERUM UREA NITROGEN
 ;;R^"860.9:",.01,"E"
 ;;D^SERUM UREA NITROGEN
 ;;R^"860.9:",.02,"E"
 ;;D^60
 ;;EOR^
 ;;KEY^860.9:^WBC
 ;;R^"860.9:",.01,"E"
 ;;D^WBC
 ;;R^"860.9:",.02,"E"
 ;;D^60
 ;;EOR^
 ;;EOF^OCXS(860.9)^1
 ;;SOF^860.8  ORDER CHECK COMPILER FUNCTIONS
 ;;KEY^860.8:^CONVERT DATE FROM FILEMAN FORMAT TO OCX FORMAT
 ;;R^"860.8:",.01,"E"
 ;;D^CONVERT DATE FROM FILEMAN FORMAT TO OCX FORMAT
 ;;R^"860.8:",.02,"E"
 ;;D^DT2INT
 ;;R^"860.8:",1,1
 ;;D^  ;DT2INT(OCXDT) ;      This Local Extrinsic Function converts a date into an integer
 ;;R^"860.8:",1,2
 ;;D^  ; ; By taking the Years, Months, Days, Hours and Minutes converting
 ;;R^"860.8:",1,3
 ;;D^  ; ; Them into Seconds and then adding them all together into one big integer
 ;;R^"860.8:",100,1
 ;;D^  ;DT2INT(OCXDT) ;      This Local Extrinsic Function converts a date into an integer
 ;;R^"860.8:",100,2
 ;;D^  ; ; By taking the Years, Months, Days, Hours and Minutes converting
 ;;R^"860.8:",100,3
 ;;D^  ; ; Them into Seconds and then adding them all together into one big integer
 ;;R^"860.8:",100,4
 ;;D^  ; ;
 ;;R^"860.8:",100,5
 ;;D^  ; Q:'$L($G(OCXDT)) ""
 ;;R^"860.8:",100,6
 ;;D^  ; N OCXVAL S OCXVAL=0
 ;;R^"860.8:",100,7
 ;;D^  ; I (OCXDT?5N1","5N) Q (OCXDT*86400+$P(OCXDT,",",2))  ;  $H FORMAT
 ;;R^"860.8:",100,8
 ;;D^  ; I ($E(OCXDT,1)="T") D  Q OCXVAL  ; TODAY
 ;;R^"860.8:",100,9
 ;;D^  ; .S OCXVAL=$H*86400
 ;;R^"860.8:",100,10
 ;;D^  ; .S:(OCXDT["+") OCXVAL=OCXVAL+($P(OCXDT,"+",2)*86400)
 ;;R^"860.8:",100,11
 ;;D^  ; .S:(OCXDT["-") OCXVAL=OCXVAL-($P(OCXDT,"-",2)*86400)
 ;;R^"860.8:",100,12
 ;;D^  ; I ($E(OCXDT,1)="N") D  Q OCXVAL  ; NOW
 ;;R^"860.8:",100,13
 ;;D^  ; .S OCXVAL=$H*86400+$P($H,",",2)
 ;;R^"860.8:",100,14
 ;;D^  ; .S:(OCXDT["+") OCXVAL=OCXVAL+($P(OCXDT,"+",2)*86400)
 ;;R^"860.8:",100,15
 ;;D^  ; .S:(OCXDT["-") OCXVAL=OCXVAL-($P(OCXDT,"-",2)*86400)
 ;;R^"860.8:",100,16
 ;;D^  ; I +OCXDT,($L(OCXDT\1)=7) S OCXDT=($E(OCXDT,1,3)+1700)_$E(OCXDT,4,7)_$S((OCXDT["."):$P(OCXDT,".",2),1:"")  ;  CONVERT INTERNAL FILEMAN FORMAT TO HL7 FORMAT
 ;;R^"860.8:",100,17
 ;;D^  ; I +OCXDT,($L(OCXDT\1)>7) D  Q OCXVAL  ; HL7 FORMAT
 ;;R^"860.8:",100,18
 ;;D^  ; .S OCXVAL=($E(OCXDT,1,4)-1841*365) ; YEARS TO DAYS
 ;;R^"860.8:",100,19
 ;;D^  ; .S OCXVAL=OCXVAL+($E(OCXDT,1,4)\4-460)-($E(OCXDT,1,4)\200-9)+($E(OCXDT,1,4)\1000-1) ; ADJUST FOR LEAP YEARS
 ;;R^"860.8:",100,20
 ;;D^  ; .I '($E(OCXDT,1,4)#4),($E(OCXDT,1,4)#200),($E(OCXDT,5,6)<3) S OCXVAL=OCXVAL-1
 ;;R^"860.8:",100,21
 ;;D^  ; .I '($E(OCXDT,1,4)#1000),($E(OCXDT,5,6)<3) S OCXVAL=OCXVAL-1
 ;;R^"860.8:",100,22
 ;;D^  ; .S OCXVAL=OCXVAL+$P("000^031^059^090^120^151^181^212^243^273^304^334",U,$E(OCXDT,5,6)) ; MONTHS TO DAYS
 ;;R^"860.8:",100,23
 ;;D^  ; .S OCXVAL=OCXVAL+$E(OCXDT,7,8)-1  ; ADD DAYS
 ;;R^"860.8:",100,24
 ;;D^  ; .S OCXVAL=OCXVAL*86400  ; CONVERT TO SECONDS
 ;;R^"860.8:",100,25
 ;;D^  ; .S OCXVAL=OCXVAL+($E(OCXDT,9,10)*3600)+($E(OCXDT,11,12)*60)+$E(OCXDT,13,14)  ; ADD TIME
 ;;R^"860.8:",100,26
 ;;D^  ; Q OCXDT
 ;;R^"860.8:",100,27
 ;;D^  ; ;
 ;;EOR^
 ;;KEY^860.8:^CONVERT DATE FROM OCX FORMAT TO READABLE FORMAT
 ;;R^"860.8:",.01,"E"
 ;;D^CONVERT DATE FROM OCX FORMAT TO READABLE FORMAT
 ;;R^"860.8:",.02,"E"
 ;;D^INT2DT
 ;;R^"860.8:",1,1
 ;;D^  ;INT2DT(OCXDT,OCXF) ;      This Local Extrinsic Function converts an OCX internal format
 ;;R^"860.8:",1,2
 ;;D^  ; ; date into an Externl Format (Human Readable) date.   'OCXF=SHORT FORMAT OCXF=LONG FORMAT
 ;;R^"860.8:",1,3
 ;;D^  ; ;
 ;;R^"860.8:",100,1
 ;;D^  ;INT2DT(OCXDT,OCXF) ;      This Local Extrinsic Function converts an OCX internal format
 ;;R^"860.8:",100,2
 ;;D^  ; ; date into an Externl Format (Human Readable) date.   'OCXF=SHORT FORMAT OCXF=LONG FORMAT
 ;;R^"860.8:",100,3
 ;;D^  ; ;
 ;;R^"860.8:",100,4
 ;;D^  ; Q:'$L($G(OCXDT)) "" S OCXF=+$G(OCXF)
 ;;R^"860.8:",100,5
 ;;D^  ; N OCXYR,OCXLPYR,OCXMON,OCXDAY,OCXHR,OCXMIN,OCXSEC,OCXCYR
 ;;R^"860.8:",100,6
 ;;D^  ; S (OCXYR,OCXLPYR,OCXMON,OCXDAY,OCXHR,OCXMIN,OCXSEC,OCXAP)=""
 ;;R^"860.8:",100,7
 ;;D^  ; S OCXSEC=$E(OCXDT#60+100,2,3),OCXDT=OCXDT\60
 ;;R^"860.8:",100,8
 ;;D^  ; S OCXMIN=$E(OCXDT#60+100,2,3),OCXDT=OCXDT\60
 ;;R^"860.8:",100,9
 ;;D^  ; S OCXHR=$E(OCXDT#24+100,2,3),OCXDT=OCXDT\24
 ;;R^"860.8:",100,10
 ;;D^  ; S OCXCYR=($H\1461)*4+1841+(($H#1461)\365)
 ;;R^"860.8:",100,11
 ;;D^  ; S OCXYR=(OCXDT\1461)*4+1841,OCXDT=OCXDT#1461
 ;;R^"860.8:",100,12
 ;;D^  ; S OCXLPYR=(OCXDT\365),OCXDT=OCXDT-(OCXLPYR*365),OCXYR=OCXYR+OCXLPYR
 ;;R^"860.8:",100,13
 ;;D^  ; S OCXCNT="031^059^090^120^151^181^212^243^273^304^334^365"
 ;;R^"860.8:",100,14
 ;;D^  ; S:(OCXLPYR=3) OCXCNT="031^060^091^121^152^182^213^244^274^305^335^366"
 ;;R^"860.8:",100,15
 ;;D^  ; F OCXMON=1:1:12 Q:(OCXDT<$P(OCXCNT,U,OCXMON))
 ;;R^"860.8:",100,16
 ;;D^  ; S OCXDAY=OCXDT-$P(OCXCNT,U,OCXMON-1)+1
 ;;R^"860.8:",100,17
 ;;D^  ; I OCXF S OCXMON=$P("January^February^March^April^May^June^July^August^September^October^November^December",U,OCXMON)
 ;;R^"860.8:",100,18
 ;;D^  ; E  S OCXMON=$E(OCXMON+100,2,3)
 ;;R^"860.8:",100,19
 ;;D^  ; S OCXAP=$S('OCXHR:"Midnight",(OCXHR=12):"Noon",(OCXHR<12):"AM",1:"PM")
 ;;R^"860.8:",100,20
 ;;D^  ; I OCXF S OCXHR=OCXHR#12 S:'OCXHR OCXHR=12
 ;1;
 ;
