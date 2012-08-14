ACRFEXP6 ;IHS/OIRM/DSD/AEF - EXPORT TO ECS FILE [ 01/27/2005  1:36 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**2,15**;NOV 05, 2001
 ;
 ;ACR*2.1*15.01;NEW ROUTINE
 ;
 ; Called from ACRFEXP5 linetags because ACRFEXP5 got too big
 ;
 Q
 ;
REC02(ACRSCH,ACRALC)         ;EP
 ;----- AGENCY LOCATION CODE (ALC) CONTROL RECORD 02
 ;
 ;RECORD LAYOUT:
 ; 1-2  RECORD TYPE "02"   55-55  RECORD CODE
 ; 3-8  RECORD NUMBER      56-415 FILLER
 ; 9-22 SCHEDULE NO       416-423 ASAID
 ;23-35 FILLER            424-431 ACOID
 ;36-43 ALC               432-440 MAC
 ;44-54 FILLER
 ;
 ;INPUT:
 ;ACRSCH=TREAS SCHED N0
 ;ACRALC=AGENCY LOC CODE
 ;
 N Z
 S $E(Z,1,2)="02"
 S $E(Z,3,8)="000001"
 S $E(Z,9,22)=$$PAD^ACRFUTL(ACRSCH,"L",14,0)
 S $E(Z,23,35)=$$PAD^ACRFUTL("","R",13,"")
 S $E(Z,36,43)=$$PAD^ACRFUTL(ACRALC,"R",8,"")
 S $E(Z,44,54)=$$PAD^ACRFUTL("","R",11,"")
 S $E(Z,55)="&"
 S $E(Z,56,415)=$$PAD^ACRFUTL("","R",360,"")
 S $E(Z,416,423)=$$PAD^ACRFUTL("","R",8,"")
 S $E(Z,424,431)=$$PAD^ACRFUTL("","R",8,"")
 S $E(Z,432,440)=$$PAD^ACRFUTL("","R",9,"")
 ;
 W Z
 Q
 ;
REC03(ACRSCH,ACRADD1,ACRADD2,ACRADD3,ACRPHON)    ;EP
 ;----- AGENCY BILLING ADDRESS CONTROL RECORD 03
 ;
 ;RECORD LAYOUT:
 ; 1-2   RECORD TYPE "03"  106-130 ADDRESS 2
 ; 3-8   RECORD NUMBER     131-155 ADDRESS 3
 ; 9-22  SCHEDULE NUMBER   156-165 AGENCY TELEPHONE
 ;23-35  ZERO FILL         166-415 FILLER
 ;36-54  FILLER            416-423 ASAID
 ;55-55  RECORD CODE "A"   424-431 ACOID
 ;56-80  AGENCY NAME       432-440 MAC
 ;81-105 ADDRESS 1
 ;
 ;INPUT:
 ;ACRSCH =TREAS SCHED NO
 ;ACRADD1=ADDRESS LINE 1
 ;ACRADD2=ADDRESS LINE 2
 ;ACRADD3=ADDRESS LINE 3
 ;ACRPHON=PHONE NUMBER
 ;
 N Z
 S $E(Z,1,2)="03"
 S $E(Z,3,8)="000002"
 S $E(Z,9,22)=$$PAD^ACRFUTL(ACRSCH,"L",14,0)
 S $E(Z,23,35)=$$PAD^ACRFUTL(0,"R",13,0)
 S $E(Z,36,54)=$$PAD^ACRFUTL("","R",19,"")
 S $E(Z,55)="A"
 S $E(Z,56,80)=$$PAD^ACRFUTL("INDIAN HEALTH SERVICE","R",25,"")
 S $E(Z,81,105)=$$PAD^ACRFUTL(ACRADD1,"R",25,"")
 S $E(Z,106,130)=$$PAD^ACRFUTL(ACRADD2,"R",25,"")
 S $E(Z,131,155)=$$PAD^ACRFUTL(ACRADD3,"R",25,"")
 S $E(Z,156,165)=$$PAD^ACRFUTL(ACRPHON,"R",10,"")
 S $E(Z,166,415)=$$PAD^ACRFUTL("","R",250,"")
 S $E(Z,416,423)=$$PAD^ACRFUTL("","R",8,"")
 S $E(Z,424,431)=$$PAD^ACRFUTL("","R",8,"")
 S $E(Z,432,440)=$$PAD^ACRFUTL("","R",9,"")
 ;
 W Z
 Q
 ;
REC09(ACRPCNT,ACRSCH,ACRTAMT,ACRAPPN,ACRCNT)     ;EP
 ;----- SCHEDULE CONTROL RECORD 09
 ;
 ;RECORD LAYOUT:
 ;  1-2   RECORD TYPE "09"        189-201 APPROPRIATED AMT 5
 ;  3-8   RECORD NUMBER           202-217 ACCOUNT SYMBOL 6
 ;  9-22  SCHEDULE NUMBER         218-230 APPROPRIATED AMT 6
 ; 23-35  9 FILLER                231-246 ACCOUNT SYMBOL 7
 ; 36-42  SCHEDULE ITEM COUNT     247-259 APPROPRIATED AMT 7
 ; 43-55  SCHEDULE AMOUNT         260-275 ACCOUNT SYMBOL 8
 ; 56-56  RECORD CODE             276-288 APPROPRIATED AMT 8
 ; 57-72  ACCOUNT SYMBOL 1        289-304 ACCOUNT SYMBOL 9
 ; 73-85  APPROPRIATED AMT 1      305-317 APPROPRIATED AMT 9
 ; 86-101 ACCOUNT SYMBOL 2        318-333 ACCOUNT SYMBOL 10
 ;102-114 APPROPRIATED AMT 2      334-346 APPROPRIATED AMT 10
 ;115-130 ACCOUNT SYMBOL 3        347-415 FILLER
 ;131-143 APPROPRIATED AMT 3      416-423 ASAID
 ;144-159 ACCOUNT SYMBOL 4        424-431 ACOID
 ;160-172 APPROPRIATED AMT 4      432-440 MAC
 ;173-188 ACCOUNT SYMBOL 5
 ;
 ;INPUT:
 ;ACRPCNT=PAYMENT NUMBER
 ;ACRSCH =TREAS SCHED NO
 ;ACRTAMT=TOTAL AMOUNT OF PAYMENTS
 ;ACRAPPN=APPROPRIATION AMOUNTS
 ;
 ;RETURNS:
 ;ACRCNT = RECORD COUNT USED BY 99 RECORD
 ;
 N Z
 S ACRCNT=ACRPCNT+1
 S $E(Z,1,2)="09"
 S $E(Z,3,8)=$$PAD^ACRFUTL(ACRCNT,"L",6,0)
 S $E(Z,9,22)=$$PAD^ACRFUTL(ACRSCH,"L",14,0)
 S $E(Z,23,35)=$$PAD^ACRFUTL(9,"R",13,9)
 S $E(Z,36,42)=$$PAD^ACRFUTL(ACRPCNT,"L",7,0)
 S $E(Z,43,55)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL(ACRTAMT),".",""),"L",13,0)
 S $E(Z,56)="C"
 S $E(Z,57,72)=$$PAD^ACRFUTL($P($G(ACRAPPN(1)),U),"R",16,"")
 S $E(Z,73,85)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL($P($G(ACRAPPN(1)),U,2)),".",""),"L",13,0)
 S $E(Z,86,101)=$$PAD^ACRFUTL($P($G(ACRAPPN(2)),U),"R",16,"")
 S $E(Z,102,114)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL($P($G(ACRAPPN(2)),U,2)),".",""),"L",13,0)
 S $E(Z,115,130)=$$PAD^ACRFUTL($P($G(ACRAPPN(3)),U),"R",16,"")
 S $E(Z,131,143)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL($P($G(ACRAPPN(3)),U,2)),".",""),"L",13,0)
 S $E(Z,144,159)=$$PAD^ACRFUTL($P($G(ACRAPPN(4)),U),"R",16,"")
 S $E(Z,160,172)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL($P($G(ACRAPPN(4)),U,2)),".",""),"L",13,0)
 S $E(Z,173,188)=$$PAD^ACRFUTL($P($G(ACRAPPN(5)),U),"R",16,"")
 S $E(Z,189,201)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL($P($G(ACRAPPN(5)),U,2)),".",""),"L",13,0)
 S $E(Z,202,217)=$$PAD^ACRFUTL($P($G(ACRAPPN(6)),U),"R",16,"")
 S $E(Z,218,230)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL($P($G(ACRAPPN(6)),U,2)),".",""),"L",13,0)
 S $E(Z,231,246)=$$PAD^ACRFUTL($P($G(ACRAPPN(7)),U),"R",16,"")
 S $E(Z,247,259)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL($P($G(ACRAPPN(7)),U,2)),".",""),"L",13,0)
 S $E(Z,260,275)=$$PAD^ACRFUTL($P($G(ACRAPPN(8)),U),"R",16,"")
 S $E(Z,276,288)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL($P($G(ACRAPPN(8)),U,2)),".",""),"L",13,0)
 S $E(Z,289,304)=$$PAD^ACRFUTL($P($G(ACRAPPN(9)),U),"R",16,"")
 S $E(Z,305,317)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL($P($G(ACRAPPN(9)),U,2)),".",""),"L",13,0)
 S $E(Z,318,333)=$$PAD^ACRFUTL($P($G(ACRAPPN(10)),U),"R",16,"")
 S $E(Z,334,346)=$$PAD^ACRFUTL($TR($$DOL^ACRFUTL($P($G(ACRAPPN(10)),U,2)),".",""),"L",13,0)
 S $E(Z,347,415)=$$PAD^ACRFUTL("","R",69,"")
 S $E(Z,416,423)=$$PAD^ACRFUTL("","R",8,"")
 S $E(Z,424,431)=$$PAD^ACRFUTL("","R",8,"")
 S $E(Z,432,440)=$$PAD^ACRFUTL("","R",9,"")
 ;
 W Z
 Q
 ;
REC99(ACRCNT,ACRSCH)         ;EP
 ;----- SCHEDULE TRAILER RECORD 99
 ;
 ;RECORD LAYOUT:
 ; 1-2   RECORD TYPE "99"     416-423 ASAID
 ; 3-8   RECORD NUMBER        424-431 ACOID
 ; 9-22  SCHEDULE NUMBER      432-440 MAC
 ;23-415 FILLER
 ;
 ;INPUT:
 ;ACRCNT=RECORD COUNT
 ;ACRSCH=TREAS SCHED NO
 ;
 N Z
 S ACRCNT=ACRCNT+1
 S $E(Z,1,2)=99
 S $E(Z,3,8)=$$PAD^ACRFUTL(ACRCNT,"L",6,0)
 S $E(Z,9,22)=$$PAD^ACRFUTL(ACRSCH,"L",14,0)
 S $E(Z,23,415)=$$PAD^ACRFUTL("","R",393,"")
 S $E(Z,416,423)=$$PAD^ACRFUTL("","R",8,"")
 S $E(Z,424,431)=$$PAD^ACRFUTL("","R",8,"")
 S $E(Z,432,440)=$$PAD^ACRFUTL("","R",9,"")
 ;
 W Z
 Q