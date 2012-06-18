AQAQCONV ;IHS/ANMC/LJF - CONVERSION OF DATA TO NEW CREDENTIALS FILE; [ 07/27/92  5:41 PM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
START ;>>> start of MAIN ROUTINE <<<
 W !!,"DATA CONVERSION TO NEW CREDENTIALS FILE WILL NOW RUN..."
 ;
 I '$O(^AQAQ(0)) W !!,*7,?10,"NO DATA TO CONVERT-BYPASSING..." Q
 I $O(^AQAQC(0)) W !!,*7,?10,"CONVERSION ALREADY RUN-BYPASSING..." Q
 ;
 S U="^"
 ;
 W !!?10,"CONVERSION RUNNING..."
 ;**> loop thru old file; find entries; do conversions
 S AQAQX=0
 F  S AQAQX=$O(^AQAQ(AQAQX)) Q:AQAQX'=+AQAQX  D
 .;
 .;**> increment zero node
 .S $P(^AQAQC(0),U,3)=AQAQX,$P(^(0),U,4)=$P(^(0),U,4)+1
 .;
 .;**> convert single node data
 .D CONVERT1
 .;
 .;**> convert data in health status multiple
 .S AQAQY=0,^AQAQC(AQAQX,"H",0)="^9002165.03D^^"
 .F  S AQAQY=$O(^AQAQ(AQAQX,6,AQAQY)) Q:AQAQY'=+AQAQY  D
 ..S ^AQAQC(AQAQX,"H",AQAQY,0)=$G(^AQAQ(AQAQX,6,AQAQY,0))
 ..S $P(^AQAQC(AQAQX,"H",0),U,3)=AQAQY
 ..S $P(^AQAQC(AQAQX,"H",0),U,4)=$P(^(0),U,4)+1
 .;
 .;**> convert data in credentials approval multiple
 .S AQAQY=$O(^AQAQ(AQAQX,9,0)) I AQAQY=+AQAQY D CONVERT2
 .;
 .;**> convert med board certification data multiple
 .S AQAQY=0,AQAQP=$P(AQAQ0,U) K AQAQA
 .;sort old data by board and then by date into array
 .F  S AQAQY=$O(^AQAQ(AQAQX,1,AQAQY)) Q:AQAQY'=+AQAQY  D
 ..S AQAQS=$G(^AQAQ(AQAQX,1,AQAQY,0))
 ..Q:$P(AQAQS,U)=""  Q:$P(AQAQS,U,2)=""
 ..S AQAQA($P(AQAQS,U,2),$P(AQAQS,U))=$P(AQAQS,U,3)
 .;
 .;for each board set original certification plus recert. multiples
 .S AQAQB=0
 .F  S AQAQB=$O(AQAQA(AQAQB)) Q:AQAQB=""  D CONVERT3
 ;
 ;**> index file
 W !!?10,"FIRING CROSS-REFERENCES..."
 S DIU(0)="",DIK="^AQAQC(" D IXALL^DIK K DIU(0)
 ;
END W !!?10,"CONVERSION COMPLETE!!!"
 K AQAQ0,AQAQ2,AQAQ7,AQAQ11,AQAQP,AQAQDA,DIC,DIK,X,Y
 K AQAQX,AQAQY,AQAQA,AQAQB,AQAQC,AQAQS,AQAQD,AQAQCT Q
 ;
 ;>>> end of MAIN ROUTINE <<<
 ;
 ;
CONVERT1 ;***> SUBRTN to convert data from single nodes
 S AQAQ0=$G(^AQAQ(AQAQX,0))
 S AQAQ2=$G(^AQAQ(AQAQX,2))
 S AQAQ7=$G(^AQAQ(AQAQX,7))
 S AQAQ11=$G(^AQAQ(AQAQX,11))
 S $P(^AQAQC(AQAQX,0),U,1,3)=$P(AQAQ0,U,1,3)
 S $P(^(0),U,11)=$P(AQAQ0,U,4),$P(^(0),U,7)=$P(AQAQ0,U,5)
 S $P(^(0),U,5)=$P(AQAQ0,U,6),$P(^(0),U,6)=$P(AQAQ0,U,14)
 S $P(^(0),U,13)=$P(AQAQ0,U,9),$P(^(0),U,15)=$P(AQAQ0,U,11)
 S $P(^(0),U,14)=$P(AQAQ0,U,10)
 I $P(AQAQ0,U,13)="Y" S $P(^(0),U,17,18)="3^Y"
 S $P(^AQAQC(AQAQX,0),U,19)=AQAQ2
 S $P(^AQAQC(AQAQX,2),U,3)=$P(AQAQ7,U)
 S $P(^AQAQC(AQAQX,2),U,1,2)=$P(AQAQ11,U,2,3)
 S $P(^(2),U,4)=$P(AQAQ11,U)
 Q
 ;
 ;
CONVERT2 ;***> SUBRTN to move credentials approval data to reappointment multi
 S $P(^AQAQC(AQAQX,0),U,4)=$P($G(^AQAQ(AQAQX,9,AQAQY,0)),U)
 S ^AQAQC(AQAQX,"R",0)="^9002165.01D^^",AQAQY=0
 F  S AQAQY=$O(^AQAQ(AQAQX,9,AQAQY)) Q:AQAQY'=+AQAQY  D
 .S $P(^AQAQC(AQAQX,"R",AQAQY,0),U)=$E($P($G(^AQAQ(AQAQX,9,AQAQY,0)),U),1,5)_"00"
 .S $P(^AQAQC(AQAQX,"R",AQAQY,0),U,2)=$P($G(^AQAQ(AQAQX,9,AQAQY,0)),U)
 .S $P(^AQAQC(AQAQX,"R",0),U,3)=AQAQY
 .S $P(^AQAQC(AQAQX,"R",0),U,4)=$P(^(0),U,4)+1
 Q
 ;
 ;
CONVERT3 ;***> SUBRTN to move med board data to Med Board Certification file
 S AQAQD=$O(AQAQA(AQAQB,0)),DIC="^AQAQMB(",DIC(0)="L",X=AQAQB
 S DIC("DR")=".02///^S X=""`""_AQAQP;.03///^S X=AQAQD;.04///^S X=AQAQA(AQAQB,AQAQD)"
 D FILE^DICN S AQAQDA=+Y
 ;create recertification date multiples for that board
 S ^AQAQMB(AQAQDA,1,0)="^9002161.11D^^",AQAQCT=0
 F  S AQAQD=$O(AQAQA(AQAQB,AQAQD)) Q:AQAQD=""  D
 .S AQAQCT=AQAQCT+1,$P(^AQAQMB(AQAQDA,1,0),U,3)=AQAQCT
 .S $P(^AQAQMB(AQAQDA,1,0),U,4)=$P(^(0),U,4)+1
 .S ^AQAQMB(AQAQDA,1,AQAQCT,0)=AQAQD_U_AQAQA(AQAQB,AQAQD)
 Q
