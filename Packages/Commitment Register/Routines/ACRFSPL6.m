ACRFSPL6 ;IHS/OIRM/DSD/AEF - 650 Char DHR Record Layout [ 01/03/2003  9:54 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**5**;NOV 05, 2001
 ;
DATA(X,Y)          ;EP
 ;----- CREATE DHR RECORD DATA STRING
 ;
 ;      FORMATS 650 CHAR DHR DATA STRING FROM DHR DATA RECORDS FILE
 ;      CALLED BY ACRFSPL2
 ;
 ;      X = DATA TO BE FORMATTED
 ;      Y = COLOR^DATE^ID^SEQ^USERID^RECCOUNT
 ;      
 ;  
 N I,Z
 S $E(Z,1,8)=$$PAD^ACRFUTL($P(Y,U,5),"R",8,"")       ;1 User ID
 S I=$P(X,U,4)_$P(X,U,5)_$P(X,U,6)                   ;2 Action Code
 S:I="06119" I="06115"   ;ACR*2.1*5.01
 S $E(Z,9)=$S(I="":" ","05013^06115^19013^19817^19917"[I:"N","05014^05015^05024^05025^05017^19017^18114^19114^18124^18214^18214^19214^19927^23717^24219"[I:"A",1:" ") ;ACR*2.1*5.01
 S $E(Z,10,13)=$$PAD^ACRFUTL($P(X,U,4),"R",4,"")     ;3 Transaction Code
 S I=$P(X,U,3)                                       ;4 Accounting Date
 I I]"" S I=$E(I,4,5)_$E(I,6,7)_$E(I,2,3)
 S $E(Z,14,19)=$$PAD^ACRFUTL(I,"R",6,"")
 S $E(Z,20,21)=$$PAD^ACRFUTL($P(X,U,29),"R",2,"")    ;5 Fiscal Year
 S $E(Z,22,31)=$$PAD^ACRFUTL($P(X,U,7),"R",10,"")    ;6 Form Number
 S $E(Z,32,51)=$$PAD^ACRFUTL($P(X,U,8),"R",20,"")    ;7 Document Number
 S $E(Z,52,59)=$$PAD^ACRFUTL($P(X,U,13),"R",7,"")_" " ;8 CAN
 F I=60:1:89 S $E(Z,I)=" "                           ;9 CAN Desc.
 S $E(Z,90,93)=$$PAD^ACRFUTL($P(X,U,14),"R",4,"")    ;10 OCC
 F I=94:1:113 S $E(Z,I)=" "                          ;11 OC Short Desc.
 S $E(Z,114,129)=$$PAD^ACRFUTL($P(X,U,15),"L",16,0)  ;12 Amount
 S $E(Z,130)=$S($P(X,U,5)=1:"+",$P(X,U,5)=2:"-",1:" ") ;13 Sign on Amt.
 S $E(Z,131)=" "                                     ;14 PMS Sent Flag
 S $E(Z,132,151)=$$PAD^ACRFUTL($P(X,U,10),"R",20,"") ;15 Commit No.
 S $E(Z,152,171)=$$PAD^ACRFUTL($P(X,U,19),"R",20,"") ;16 Collection No.
 S $E(Z,172,191)=$$PAD^ACRFUTL($P(X,U,33),"R",20,"") ;17 Invoice No
 S $E(Z,192,211)=$$PAD^ACRFUTL($P(X,U,19),"R",20,"") ;18 Schedule No
 S $E(Z,212,223)=$$PAD^ACRFUTL($P(X,U,17),"R",12,"") ;19 Entity Ident No
 F I=224:1:258 S $E(Z,I)=" "                         ;20 Vendor Name
 F I=259:1:288 S $E(Z,I)=" "                         ;21 Vendor Address
 F I=289:1:343 S $E(Z,I)=" "                         ;22 Comment
 S $E(Z,344,349)=$$PAD^ACRFUTL($P(X,U,27),"R",6,"")  ;23 Begin Date
 S $E(Z,350,355)=$$PAD^ACRFUTL($P(X,U,28),"R",6,"")  ;24 End Date
 F I=356:1:364 S $E(Z,I)=" "                         ;25 Labor Hours
 S $E(Z,365)=" "                                     ;26 Sign on Hours
 F I=366:1:385 S $E(Z,I)=" "                         ;27 Agreement No
 F I=386:1:405 S $E(Z,I)=" "                         ;28 Project Number
 S $E(Z,406,407)="  "                                ;29 Phase
 S $E(Z,408,411)=$$PAD^ACRFUTL($P(X,U,24),"R",4,"")  ;30 GL Debit
 S $E(Z,412,415)=$$PAD^ACRFUTL($P(X,U,25),"R",4,"")  ;31 GL Credit
 S $E(Z,416)=" "                                     ;32 PMS Code
 S $E(Z,417)=" "                                     ;33 SysGen Code
 S $E(Z,418)=$$PAD^ACRFUTL($P(X,U,11),"R",1,"")      ;34 Geographic Code
 F I=419:1:430 S $E(Z,I)=" "                         ;35 Secondary EIN
 F I=431:1:465 S $E(Z,I)=" "                         ;36 2nd Vend Name
 F I=466:1:495 S $E(Z,I)=" "                         ;37 2nd Addr Line
 S $E(Z,496)=" "                                     ;38 Act/Law Code
 S $E(Z,497)=" "                                     ;39 Curr/Perm Code
 S $E(Z,498)=$$PAD^ACRFUTL($P(X,U,16),"R",1,"")      ;40 Gov/Non-Govt
 S $E(Z,499)=" "                                     ;41 Funded/UnFunded
 S $E(Z,500)=" "                                     ;42 Reserved Code
 S $E(Z,501,502)="  "                                ;43 Filler
 S $E(Z,503)=" "                                     ;44 Partial/Final
 S $E(Z,504)=" "                                     ;45 Est Accrual Flg
 S $E(Z,505,508)="AR  "                              ;46 Transaction Src
 F I=509:1:518 S $E(Z,I)=" "                         ;47 Agency Location
 S $E(Z,519,520)="  "                                ;48 PMS/Core Only
 S $E(Z,521,524)="    "                              ;49 Filler
 F I=525:1:547 S $E(Z,I)=" "                         ;50 Standing Entry
 S $E(Z,548,553)="      "                            ;51 Filler 
 F I=554:1:568 S $E(Z,I)=" "                         ;52 AcctRecTypeDesc
 S $E(Z,569,572)="    "                              ;53 Next Funct Code
 F I=573:1:650 S $E(Z,I)=" "                         ;54 Message Line
 ;
 S ^TMP("ACRDHR",$J,$P(Y,U),$P(Y,U,2),$P(Y,U,3),$P(Y,U,4),1)=$E(Z,1,130)
 S ^TMP("ACRDHR",$J,$P(Y,U),$P(Y,U,2),$P(Y,U,3),$P(Y,U,4),2)=$E(Z,131,260)
 S ^TMP("ACRDHR",$J,$P(Y,U),$P(Y,U,2),$P(Y,U,3),$P(Y,U,4),3)=$E(Z,261,390)
 S ^TMP("ACRDHR",$J,$P(Y,U),$P(Y,U,2),$P(Y,U,3),$P(Y,U,4),4)=$E(Z,391,520)
 S ^TMP("ACRDHR",$J,$P(Y,U),$P(Y,U,2),$P(Y,U,3),$P(Y,U,4),5)=$E(Z,521,650)
 S ^TMP("ACRDHR-EXP",$J,$P(Y,U,6),1)=$E(Z,1,130)
 S ^TMP("ACRDHR-EXP",$J,$P(Y,U,6),2)=$E(Z,131,260)
 S ^TMP("ACRDHR-EXP",$J,$P(Y,U,6),3)=$E(Z,261,390)
 S ^TMP("ACRDHR-EXP",$J,$P(Y,U,6),4)=$E(Z,391,520)
 S ^TMP("ACRDHR-EXP",$J,$P(Y,U,6),5)=$E(Z,521,650)
 Q
