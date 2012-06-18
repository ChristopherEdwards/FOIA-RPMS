LRBLFIX ; IHS/DIR/FJE - FIX DISPOSITION X-REF 12:54 ; [ 8/14/92 ]
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 S DA=0 F  S DA=$O(^LRD(65,DA)) Q:'DA  I $P($G(^LRD(65,DA,4)),"^")]"" S A=^(0),B=$P(A,"^",4),C=$P(A,"^",6) K:B]""&(C]"") ^LRD(65,"AE",B,C,DA),^LRD(65,"AI",B,$P(A,"^"),C,DA) W "#"
AUFIX ;SET autopsy verification dates on old cases
 ;RELEASE AUTOPSY REPORTS
 W !!?10,"Releasing old Autopsy Reports ",!
 F LRDFN=0:0 S LRDFN=$O(^LR(LRDFN)) Q:'LRDFN  S Y=$P($G(^LR(LRDFN,"AU")),"^",3) I Y S $P(^("AU"),"^",15)=Y W "."
 Q
 ;If there is a disposition entered then the "AE" & "AI" x-references
 ;should be deleted.  Disposition is the 1st piece of subscript 4
 ; which is: $P(^LRD(65,DA,4),U,1)
