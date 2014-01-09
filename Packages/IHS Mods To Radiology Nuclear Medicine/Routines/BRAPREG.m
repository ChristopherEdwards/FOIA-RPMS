BRAPREG ;IHS/BJI/DAY - Stuff Pregnance Status ; 13 Sep 2011  8:32 AM
 ;;5.0;Radiology/Nuclear Medicine;**1003**;Nov 01, 2010;Build 3
 ;
 ;
 ;Loop Rad/Nuc Med Patient File to stuff Pregnancy Status (Field 32)
 ;
 S BRADFN=0
 F  S BRADFN=$O(^RADPT(BRADFN)) Q:'BRADFN  D
 .;
 .I $P($G(^DPT(BRADFN,0)),U,2)'="F" Q
 .I $$AGE^AUPNPAT(BRADFN)<12 Q
 .I $$AGE^AUPNPAT(BRADFN)>55 Q
 .;
 .S BRADTI=""
 .F  S BRADTI=$O(^RADPT(BRADFN,"DT",BRADTI)) Q:BRADTI=""  D
 ..;
 ..S BRACNI=0
 ..F  S BRACNI=$O(^RADPT(BRADFN,"DT",BRADTI,"P",BRACNI)) Q:'BRACNI  D
 ...;
 ...S BRAZERO=$G(^RADPT(BRADFN,"DT",BRADTI,"P",BRACNI,0))
 ...;
 ...;Check Examination Status
 ...S X=$P(BRAZERO,U,3)
 ...S Y=$$GET1^DIQ(72,X,.01)
 ...;
 ...;Don't exclude COMPLETE because users can unverify reports later
 ...;I Y="COMPLETE" Q
 ...I Y="CANCELLED" Q
 ...;
 ...S $P(^RADPT(BRADFN,"DT",BRADTI,"P",BRACNI,0),U,32)="u"
 ;
 K BRADFN,BRADTI,BRACNI,BRAZERO
 Q
 ;
