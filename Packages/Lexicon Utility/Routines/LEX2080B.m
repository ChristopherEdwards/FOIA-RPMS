LEX2080B ;ISL/KER - LEX*2.0*80 Pre/Post Install ;04/21/2014
 ;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 10
 ;
 Q
EN ; Main Entry Point
 D S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,EN^LEX2080C,FL^LEX2080A
 Q
S1 ; Subset #1
 I $D(^LEXT(757.2,1,0)) N DA,DIK S DA=1,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,1,0)="Lexicon^WRD"
 S ^LEXT(757.2,1,1)="^LEX(757.01,"
 S ^LEXT(757.2,1,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,1,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,1,5)="^^1^757^LEX"
 S ^LEXT(757.2,1,100,0)="^757.22^4^4^3130101^^^^"
 S ^LEXT(757.2,1,100,1,0)="This subset contains the entire Lexicon.  While it"
 S ^LEXT(757.2,1,100,2,0)="is not a true subset (i.e., part of the whole), it is"
 S ^LEXT(757.2,1,100,3,0)="defined here as the default when a more precise subset"
 S ^LEXT(757.2,1,100,4,0)="has not been selected."
 I $D(^LEXT(757.2,1,0)) N DA,DIK S DA=1,DIK="^LEXT(757.2," D IX1^DIK
 Q
S2 ; Subset #2
 I $D(^LEXT(757.2,2,0)) N DA,DIK S DA=2,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,2,0)="Nursing^NUR"
 S ^LEXT(757.2,2,1)="^LEX(757.21,"
 S ^LEXT(757.2,2,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,2,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,2,4)="ICD/NAN/NIC/OMA"
 S ^LEXT(757.2,2,100,0)="^^4^4^3130101^"
 S ^LEXT(757.2,2,100,1,0)="This subset contains terminology from the North American"
 S ^LEXT(757.2,2,100,2,0)="Nursing Diagnosis Association (NANDA), the Nursing "
 S ^LEXT(757.2,2,100,3,0)="Intervention Classification (NIC) and the Omaha Nursing"
 S ^LEXT(757.2,2,100,4,0)="Diagnosis classification systems. "
 I $D(^LEXT(757.2,2,0)) N DA,DIK S DA=2,DIK="^LEXT(757.2," D IX1^DIK
 Q
S3 ; Subset #3
 I $D(^LEXT(757.2,3,0)) N DA,DIK S DA=3,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,3,0)="Social Work^SOC"
 S ^LEXT(757.2,3,1)="^LEX(757.21,"
 S ^LEXT(757.2,3,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,3,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,3,4)="ICD/DS4/CPT/ICP"
 S ^LEXT(757.2,3,100,0)="^^2^2^3130101^^^"
 S ^LEXT(757.2,3,100,1,0)="This subset contains terminology relating to Social Work,"
 S ^LEXT(757.2,3,100,2,0)="and is taken from the SWIMS vocabulary."
 I $D(^LEXT(757.2,3,0)) N DA,DIK S DA=3,DIK="^LEXT(757.2," D IX1^DIK
 Q
S4 ; Subset #4
 I $D(^LEXT(757.2,4,0)) N DA,DIK S DA=4,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,4,0)="Problem List"
 S ^LEXT(757.2,4,1)="^LEX(757.01,"
 S ^LEXT(757.2,4,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,4,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,4,4)="ICD/ICP/10D/10P/CPT/DS4"
 S ^LEXT(757.2,4,5)="PL1^WRD^1^9000011^GMPL^1^0^3"
 S ^LEXT(757.2,4,6)="I $$SC^LEXU(Y,""BEH/DIS;999/64/66/73/74/77/82/169/170/171;ICD/ICP/10D/10P/CPT/DS4"",+($G(LEXVDT)))"
 S ^LEXT(757.2,4,7)="ICD/ICP/10D/10P/CPT/DS4"
 I $D(^LEXT(757.2,4,0)) N DA,DIK S DA=4,DIK="^LEXT(757.2," D IX1^DIK
 Q
S5 ; Subset #5
 I $D(^LEXT(757.2,5,0)) N DA,DIK S DA=5,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,5,0)="Int'l Class Dis/Diag (ICD)"
 S ^LEXT(757.2,5,1)="^LEX(757.01,"
 S ^LEXT(757.2,5,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,5,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,5,4)="ICD/ICP"
 S ^LEXT(757.2,5,5)="PL2^WRD^^^^1^1^2"
 S ^LEXT(757.2,5,6)="I $$SO^LEXU(Y,""ICD"",+($G(LEXVDT)))"
 S ^LEXT(757.2,5,7)="ICD/ICP"
 S ^LEXT(757.2,5,100,0)="^^3^3^3130101^^^^"
 S ^LEXT(757.2,5,100,1,0)="This subset is artificially created through the use of a "
 S ^LEXT(757.2,5,100,2,0)="filter (not a physical subset), and contains only those "
 S ^LEXT(757.2,5,100,3,0)="expressions which are linked to an ICD classification code."
 I $D(^LEXT(757.2,5,0)) N DA,DIK S DA=5,DIK="^LEXT(757.2," D IX1^DIK
 Q
S6 ; Subset #6
 N DA,DIK S DA=6 I $D(^LEXT(757.2,DA,0)) S DIK="^LEXT(757.2," D ^DIK
 Q
S7 ; Subset #7
 N DA,DIK S DA=7 I $D(^LEXT(757.2,DA,0)) S DIK="^LEXT(757.2," D ^DIK
 Q
S8 ; Subset #8
 N DA,DIK S DA=8 I $D(^LEXT(757.2,DA,0)) S DIK="^LEXT(757.2," D ^DIK
 Q
S9 ; Subset #9
 I $D(^LEXT(757.2,9,0)) N DA,DIK S DA=9,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,9,0)="Immunologic^IMM"
 S ^LEXT(757.2,9,1)="^LEX(757.21,"
 S ^LEXT(757.2,9,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,9,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,9,4)="ICD/ICP/CPT"
 S ^LEXT(757.2,9,5)="^^^^^^1"
 S ^LEXT(757.2,9,7)="ICD/ICP/CPT"
 S ^LEXT(757.2,9,100,0)="^^3^3^3130101^^"
 S ^LEXT(757.2,9,100,1,0)="This subset contains expressions relating to immunizations"
 S ^LEXT(757.2,9,100,2,0)="and vaccines, including immunologic factors, indicators, "
 S ^LEXT(757.2,9,100,3,0)="reagents and pharmacologic substances."
 I $D(^LEXT(757.2,9,0)) N DA,DIK S DA=9,DIK="^LEXT(757.2," D IX1^DIK
 Q
S10 ; Subset #10
 I $D(^LEXT(757.2,10,0)) N DA,DIK S DA=10,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,10,0)="Dental^DEN"
 S ^LEXT(757.2,10,1)="^LEX(757.21,"
 S ^LEXT(757.2,10,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,10,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,10,100,0)="^^2^2^3130101^"
 S ^LEXT(757.2,10,100,1,0)="This Subset only contains expressions found in the field of"
 S ^LEXT(757.2,10,100,2,0)="dentistry, or that overlap general clinical specialities"
 I $D(^LEXT(757.2,10,0)) N DA,DIK S DA=10,DIK="^LEXT(757.2," D IX1^DIK
 Q
S11 ; Subset #11
 I $D(^LEXT(757.2,11,0)) N DA,DIK S DA=11,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,11,0)="Nursing Interventions"
 S ^LEXT(757.2,11,1)="^LEX(757.21,"
 S ^LEXT(757.2,11,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,11,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,11,4)="ICD/NAN/NIC/OMA"
 S ^LEXT(757.2,11,5)="NIC^NUR^^^^^1"
 S ^LEXT(757.2,11,6)="I $$SO^LEXU(Y,""NIC"",+($G(LEXVDT)))"
 S ^LEXT(757.2,11,7)="ICD/NAN/NIC/OMA"
 I $D(^LEXT(757.2,11,0)) N DA,DIK S DA=11,DIK="^LEXT(757.2," D IX1^DIK
 Q
S12 ; Subset #12
 I $D(^LEXT(757.2,12,0)) N DA,DIK S DA=12,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,12,0)="ICD-9 Diagnosis"
 S ^LEXT(757.2,12,1)="^LEX(757.01,"
 S ^LEXT(757.2,12,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,12,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,12,4)="ICD"
 S ^LEXT(757.2,12,5)="ICD^WRD^0^80^ICD^0^1"
 S ^LEXT(757.2,12,6)="I $L($$ICDONE^LEXU(+Y,+($G(LEXVDT))))"
 S ^LEXT(757.2,12,7)="ICD"
 S ^LEXT(757.2,12,100,0)="^^3^3^3130101^"
 S ^LEXT(757.2,12,100,1,0)="This subset is artificially created through the use of a filter"
 S ^LEXT(757.2,12,100,2,0)="which will not permit the selection of a term which does not "
 S ^LEXT(757.2,12,100,3,0)="have a valid ICD-9 Diagnosis code assigned."
 I $D(^LEXT(757.2,12,0)) N DA,DIK S DA=12,DIK="^LEXT(757.2," D IX1^DIK
 Q
S13 ; Subset #13
 I $D(^LEXT(757.2,13,0)) N DA,DIK S DA=13,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,13,0)="CPT Procedures"
 S ^LEXT(757.2,13,1)="^LEX(757.01,"
 S ^LEXT(757.2,13,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,13,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,13,4)="CPT"
 S ^LEXT(757.2,13,5)="CPT^WRD^0^81^CPT^0^1"
 S ^LEXT(757.2,13,6)="I $L($$CPTONE^LEXU(+Y,+($G(LEXVDT))))"
 S ^LEXT(757.2,13,7)="CPT"
 S ^LEXT(757.2,13,100,0)="^^4^4^3130101^^^^"
 S ^LEXT(757.2,13,100,1,0)="This subset is artificially created through the use of a"
 S ^LEXT(757.2,13,100,2,0)="filter which will not permit the selection of a term"
 S ^LEXT(757.2,13,100,3,0)="which does not have a valid CPT code assigned (CPT code"
 S ^LEXT(757.2,13,100,4,0)="in the Lexicon is also in file 81, CPT Procedures)."
 I $D(^LEXT(757.2,13,0)) N DA,DIK S DA=13,DIK="^LEXT(757.2," D IX1^DIK
 Q
S14 ; Subset #14
 I $D(^LEXT(757.2,14,0)) N DA,DIK S DA=14,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,14,0)="Mental Health (DSM)"
 S ^LEXT(757.2,14,1)="^LEX(757.01,"
 S ^LEXT(757.2,14,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,14,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,14,4)="DS4/ICD"
 S ^LEXT(757.2,14,5)="DSM^WRD^0^627.7^DSM^0^1"
 S ^LEXT(757.2,14,6)="I $$SO^LEXU(Y,""DS4"",+($G(LEXVDT)))"
 S ^LEXT(757.2,14,7)="DS4/ICD"
 S ^LEXT(757.2,14,100,0)="^^3^3^3130101^^^^"
 S ^LEXT(757.2,14,100,1,0)="This subset is artifically created through the use of a"
 S ^LEXT(757.2,14,100,2,0)="filter which will not permit the selection of a term"
 S ^LEXT(757.2,14,100,3,0)="which does not have a DSM code assigned."
 I $D(^LEXT(757.2,14,0)) N DA,DIK S DA=14,DIK="^LEXT(757.2," D IX1^DIK
 Q
