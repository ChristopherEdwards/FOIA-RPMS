BCH10P10 ;IHS/CMI/LAB - PATCH 10 [ 07/25/00  8:09 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**10**;OCT 28, 1996
 ;
 ;
 ;reflag all records dated after April 1, 2000 for re-export
 ;fix icd code in seizure disorder
 S DA=$O(^BCHTPROB("B","SEIZURE DISORDER",0))
 I DA S DIE="^BCHTPROB(",DR=".04///780.39" D ^DIE
 D ^XBFMK
 W !!,"Reflagging CHR Records for export...Hold on a moment..."
 NEW D,R,E
 S R=0,E=0 F  S R=$O(^BCHSITE(R)) Q:R'=+R  I $P($G(^BCHSITE(R,99)),U) S E=1
 Q:E
 S D=3000331.9999
 F  S D=$O(^BCHR("B",D)) Q:D'=+D  D
 .S R=0 F  S R=$O(^BCHR("B",D,R)) Q:R'=+R  D
 ..Q:'$D(^BCHR(R,0))
 ..S E=$P(^BCHR(R,0),U,17)
 ..I E]"",$D(^BCHR("AEX",E,R)) Q  ;already in xref
 ..S ^BCHR("AEX",DT,R)=""  ;set back in export xref
 ..Q
 .Q
 S R=0 F  S R=$O(^BCHSITE(R)) Q:R'=+R  S $P(^BCHSITE(R,99),U)=1
 Q
