BZHRINDX ;NEW PROGRAM [ 07/29/1999  10:24 AM ]
 ;Remove space from PO# flds which have no PO#
 S X=0,Z=1
 F  S X=$O(^ASUMS(40007,1,X)) Q:X=""!(X="B")  D
 .S REC=^ASUMS(40007,1,X,0)
 .F Y=1:1:32 D  ;20,25,30 D
 ..I Y'=14 D                ;NOT THE VENDOR NAME FIELD
 ...S L=$L($P(REC,"^",Y))
 ...I L=1 S $P(REC,"^",Y)=$TR($P(REC,"^",Y)," ")
 .S ^ASUMS(40007,1,X,0)=REC
 Q
