APCLEIN ; IHS/CMI/LAB - INIT STUFF ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
ACC ;
 I '$D(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! S APCLQUIT="" Q
 I 'DUZ(2) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! S APCLQUIT="" Q
 W:$D(IOF) @IOF
 I '$D(APCLSORT) W $C(7),$C(7),!!,"Report Type Missing!!",! S APCLQUIT="" Q
 W !!,"This Option will search the Patient file for all patients registered",!,"at the Service Unit or the facility that you select.",!
 W "A Report will result which will give the following counts:",!
 W ?5,"- All Living Patients registered at the facility or SU selected",!
 W ?5,"- All Active Patients (patients who have had a visit",!?8,"within the 3 fiscal years prior to the 'as of' date specified).",!
 W "The report will be sorted by ",$S(APCLSORT="C":"COMMUNITY OF RESIDENCE",APCLSORT="T":"TRIBE OF MEMBERSHIP",1:"SERVICE UNIT OF RESIDENCE"),".",!!
 Q
 ;
PCT ;
 I '$D(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! S APCLQUIT="" Q
 I 'DUZ(2) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! S APCLQUIT="" Q
 I '$D(APCLSORT) W $C(7),$C(7),!!,"Report Type Missing!!",! S APCLQUIT="" Q
 W:$D(IOF) @IOF
 W !!,"This Option will search the Patient file for all patients registered",!,"at the Service Unit or the facility that you select.",!
 W "A Report will result which will give the following counts:",!
 W ?5,"- All Living Patients registered at the facility or SU selected",!
 W ?5,"- All Patients seen in the Visit Date Range specified",!
 W ?5,"- Total number of Visits by these patients",!
 W ?5,"- Total number of APC Visits by these patients",!
 W ?5,"- Total number of Primary Care Provider Visits by these patients",!
 W "The report will be sorted by ",$S(APCLSORT="C":"COMMUNITY OF RESIDENCE",APCLSORT="T":"TRIBE OF MEMBERSHIP",1:"SERVICE UNIT OF RESIDENCE"),".",!!
 Q
