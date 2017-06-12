LEX2080C ;ISL/KER - LEX*2.0*80 Pre/Post Install ;04/21/2014
 ;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 10
 ;
 Q
EN ; Main Entry Point
 D S15,S16,S17,S18,S19,S20,S21,S22,S23,S24,S25,S26
 Q
S15 ; Subset #15
 I $D(^LEXT(757.2,15,0)) N DA,DIK S DA=15,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,15,0)="ICD, CPT and DSM Terminology"
 S ^LEXT(757.2,15,1)="^LEX(757.01,"
 S ^LEXT(757.2,15,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,15,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,15,4)="ICD/ICP/CPT/DS4"
 S ^LEXT(757.2,15,5)="VAC^WRD^0^757.03^VAC^0^1"
 S ^LEXT(757.2,15,6)="I $$SO^LEXU(Y,""ICD/ICP/CPT/DS4"",+($G(LEXVDT)))"
 S ^LEXT(757.2,15,7)="ICD/ICP/CPT/DS4"
 S ^LEXT(757.2,15,100,0)="^^4^4^3130101^^^^"
 S ^LEXT(757.2,15,100,1,0)="This subset is artifically created through the use of a"
 S ^LEXT(757.2,15,100,2,0)="filter which will limit the selection of a term to "
 S ^LEXT(757.2,15,100,3,0)="those classification systems commonly used by the VA."
 S ^LEXT(757.2,15,100,4,0)="These systems include ICD-9-CM, CPT-4, and DSM."
 I $D(^LEXT(757.2,15,0)) N DA,DIK S DA=15,DIK="^LEXT(757.2," D IX1^DIK
 Q
S16 ; Subset #16
 I $D(^LEXT(757.2,16,0)) N DA,DIK S DA=16,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,16,0)="Pharmacy (drug/form)"
 S ^LEXT(757.2,16,1)="^LEX(757.01,"
 S ^LEXT(757.2,16,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,16,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,16,5)="DG1^WRD^0^50.6^PSN^0^0"
 S ^LEXT(757.2,16,6)="I $$SRC^LEXU(Y,1)"
 S ^LEXT(757.2,16,100,0)="^^4^4^2971014^^^^"
 S ^LEXT(757.2,16,100,1,0)="This subset is artifically created through the use of a"
 S ^LEXT(757.2,16,100,2,0)="filter, only allowing the selection of terms which "
 S ^LEXT(757.2,16,100,3,0)="originally came from the VA National Drug File (NDF)."
 S ^LEXT(757.2,16,100,4,0)="It returns <drug name><form>."
 I $D(^LEXT(757.2,16,0)) N DA,DIK S DA=16,DIK="^LEXT(757.2," D IX1^DIK
 Q
S17 ; Subset #17
 I $D(^LEXT(757.2,17,0)) N DA,DIK S DA=17,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,17,0)="CPT/HCPCS Procedures"
 S ^LEXT(757.2,17,1)="^LEX(757.01,"
 S ^LEXT(757.2,17,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,17,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,17,4)="CPT/CPC"
 S ^LEXT(757.2,17,5)="CHP^WRD^0^81^CHP^0^1"
 S ^LEXT(757.2,17,6)="I $$SO^LEXU(Y,""CPT/CPC"",+($G(LEXVDT)))"
 S ^LEXT(757.2,17,7)="CPT/CPC"
 S ^LEXT(757.2,17,100,0)="^^5^5^2980221^^^"
 S ^LEXT(757.2,17,100,1,0)="This subset is artificially created through the use of a"
 S ^LEXT(757.2,17,100,2,0)="filter which will not permit the selection of a term"
 S ^LEXT(757.2,17,100,3,0)="which does not have a valid CPT-4 or HCPCS procedure "
 S ^LEXT(757.2,17,100,4,0)="code assigned (A code found in the Lexicon that is also"
 S ^LEXT(757.2,17,100,5,0)="in file 81, CPT Procedures)."
 I $D(^LEXT(757.2,17,0)) N DA,DIK S DA=17,DIK="^LEXT(757.2," D IX1^DIK
 Q
S18 ; Subset #18
 N DA,DIK S DA=18 I $D(^LEXT(757.2,DA,0)) S DIK="^LEXT(757.2," D ^DIK
 Q
S19 ; Subset #19
 N DA,DIK S DA=19 I $D(^LEXT(757.2,DA,0)) S DIK="^LEXT(757.2," D ^DIK
 Q
S20 ; Subset #20
 I $D(^LEXT(757.2,20,0)) N DA,DIK S DA=20,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,20,0)="Brest Imaging Rpt Data Sys BI-RADS"
 S ^LEXT(757.2,20,1)="^LEX(757.01,"
 S ^LEXT(757.2,20,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,20,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,20,4)="BI1"
 S ^LEXT(757.2,20,5)="BI1^WRD^0^71^RA^0^1^^0"
 S ^LEXT(757.2,20,6)="I +($$SO^LEXU(Y,""BIR"",+($G(LEXVDT))))>0"
 S ^LEXT(757.2,20,7)="BIR"
 S ^LEXT(757.2,20,100,0)="^757.22^3^3^3130101^^^^"
 S ^LEXT(757.2,20,100,1,0)="This subset is artificially created through the use of a"
 S ^LEXT(757.2,20,100,2,0)="filter which will not permit the selection of a term which"
 S ^LEXT(757.2,20,100,3,0)="does not have a valid BI-RAD code assigned."
 I $D(^LEXT(757.2,20,0)) N DA,DIK S DA=20,DIK="^LEXT(757.2," D IX1^DIK
 Q
S21 ; Subset #21
 I $D(^LEXT(757.2,21,0)) N DA,DIK S DA=21,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,21,0)="ICD-10 Diagnosis"
 S ^LEXT(757.2,21,1)="^LEX(757.01,"
 S ^LEXT(757.2,21,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,21,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,21,4)="10D"
 S ^LEXT(757.2,21,5)="10D^WRD^0^80^10D^0^1"
 S ^LEXT(757.2,21,6)="I $L($$ONE^LEXU(+Y,+($G(LEXVDT)),""10D""))"
 S ^LEXT(757.2,21,7)="10D"
 S ^LEXT(757.2,21,100,0)="^^3^3^3130101^"
 S ^LEXT(757.2,21,100,1,0)="This subset is artificially created through the use of a filter"
 S ^LEXT(757.2,21,100,2,0)="which will not permit the selection of a term which does not "
 S ^LEXT(757.2,21,100,3,0)="have a valid ICD-10 Diagnosis code assigned."
 I $D(^LEXT(757.2,21,0)) N DA,DIK S DA=21,DIK="^LEXT(757.2," D IX1^DIK
 Q
S22 ; Subset #22
 I $D(^LEXT(757.2,22,0)) N DA,DIK S DA=22,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,22,0)="ICD-10 Procedures"
 S ^LEXT(757.2,22,1)="^LEX(757.01,"
 S ^LEXT(757.2,22,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,22,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,22,4)="10P"
 S ^LEXT(757.2,22,5)="10P^WRD^0^80^10P^0^1"
 S ^LEXT(757.2,22,6)="I $L($$ONE^LEXU(+Y,+($G(LEXVDT)),""10P""))"
 S ^LEXT(757.2,22,7)="10P"
 S ^LEXT(757.2,22,100,0)="^^3^3^3120622^"
 S ^LEXT(757.2,22,100,1,0)="This subset is artificially created through the use of a filter"
 S ^LEXT(757.2,22,100,2,0)="which will not permit the selection of a term which does not "
 S ^LEXT(757.2,22,100,3,0)="have a valid ICD-10 Procedure code assigned."
 I $D(^LEXT(757.2,22,0)) N DA,DIK S DA=22,DIK="^LEXT(757.2," D IX1^DIK
 Q
S23 ; Subset #23
 N DA,DIK S DA=23 I $D(^LEXT(757.2,DA,0)) S DIK="^LEXT(757.2," D ^DIK
 Q
S24 ; Subset #24
 I $D(^LEXT(757.2,24,0)) N DA,DIK S DA=24,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,24,0)="Encounter Forms"
 S ^LEXT(757.2,24,1)="^LEX(757.01,"
 S ^LEXT(757.2,24,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,24,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,24,4)="ICD/ICP/10D/10P/DS4"
 S ^LEXT(757.2,24,5)="EF1^WRD^^357^IBD^^1"
 S ^LEXT(757.2,24,6)="I $$SC^LEXU(Y,""BEH/DIS;999/64/66/73/74/77/82/169/170/171;ICD/ICP/10D/10P/DS4"",+($G(LEXVDT)))"
 S ^LEXT(757.2,24,7)="ICD/ICP/10D/10P/DS4"
 S ^LEXT(757.2,24,100,0)="^^4^4^3130101^^^^"
 S ^LEXT(757.2,24,100,1,0)="This subset is artificially created through the use of a"
 S ^LEXT(757.2,24,100,2,0)="filter (not a physical subset).  It is identical to the"
 S ^LEXT(757.2,24,100,3,0)="subset created for Problem List but without the use of"
 S ^LEXT(757.2,24,100,4,0)="Unresolved Narratives and User Defaults."
 I $D(^LEXT(757.2,24,0)) N DA,DIK S DA=24,DIK="^LEXT(757.2," D IX1^DIK
 Q
S25 ; Subset #25
 I $D(^LEXT(757.2,25,0)) N DA,DIK S DA=25,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,25,0)="Encounters Dx (ICD-9)"
 S ^LEXT(757.2,25,1)="^LEX(757.01,"
 S ^LEXT(757.2,25,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,25,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,25,4)="ICD"
 S ^LEXT(757.2,25,5)="EF2^WRD^^^^^1"
 S ^LEXT(757.2,25,6)="I $$SO^LEXU(Y,""ICD"",+($G(LEXVDT)))"
 S ^LEXT(757.2,25,7)="ICD"
 S ^LEXT(757.2,25,100,0)="^^3^3^3130101^^^^"
 S ^LEXT(757.2,25,100,1,0)="This subset is artificially created through the use of a "
 S ^LEXT(757.2,25,100,2,0)="filter (not a physical subset), and contains only those "
 S ^LEXT(757.2,25,100,3,0)="expressions which are linked to an ICD-9 Diagnosis code."
 I $D(^LEXT(757.2,25,0)) N DA,DIK S DA=26,DIK="^LEXT(757.2," D IX1^DIK
 Q
S26 ; Subset #26
 I $D(^LEXT(757.2,26,0)) N DA,DIK S DA=26,DIK="^LEXT(757.2," D IX2^DIK
 S ^LEXT(757.2,26,0)="Encounters Dx (ICD-10)"
 S ^LEXT(757.2,26,1)="^LEX(757.01,"
 S ^LEXT(757.2,26,2)="XTLK^LEXHLP"
 S ^LEXT(757.2,26,3)="XTLK^LEXPRNT"
 S ^LEXT(757.2,26,4)="10D"
 S ^LEXT(757.2,26,5)="EF3^WRD^^^^^1"
 S ^LEXT(757.2,26,6)="I $L($$ONE^LEXU(+Y,+($G(LEXVDT)),""10D""))"
 S ^LEXT(757.2,26,7)="10D"
 S ^LEXT(757.2,26,100,0)="^^3^3^3130101^^^^"
 S ^LEXT(757.2,26,100,1,0)="This subset is artificially created through the use of a "
 S ^LEXT(757.2,26,100,2,0)="filter (not a physical subset), and contains only those "
 S ^LEXT(757.2,26,100,3,0)="expressions which are linked to an ICD-10 Diagnosis code."
 I $D(^LEXT(757.2,26,0)) N DA,DIK S DA=26,DIK="^LEXT(757.2," D IX1^DIK
 Q
