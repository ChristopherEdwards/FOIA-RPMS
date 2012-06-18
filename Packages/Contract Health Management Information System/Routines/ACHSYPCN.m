ACHSYPCN ; IHS/ITSC/PMF - ENTER DOCUMENTS (2/8)-(PT,HRN,FAC,EDOS,PRO) ;    [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
        ;;3.1T1;CONTRACT HEALTH MGMT SYSTEM;;DEC 20, 2000   
 ;
 ;simple util to count the number of patients for a facility
 ;in a given fiscal year
 ;
 ;ASK for facility
 ;ASK for a fiscal year
 ;
 ;FOR each document
 ;  IF it is the right fiscal year, THEN
 ;    get the patient number
 ;    IF the patient is not already counted, THEN
 ;       add one to count
 ;       place patient on list
 ;    endif
 ;  endif
 ;endfor
 ;
 ;Write count
 ;
 ;
 K ^TEMP("ACHSYPCN")
 S OK=0 D GETFAC Q:'OK
 ;
 W !!!!!!!,"Enter Fiscal Year final digit, for example",!,?4,"enter 1997 as 7:   " R FY:300
 I FY="" Q
 ;
 S (COUNT,DOC)=0 F XI=1:1 S DOC=$O(^ACHSF(FAC,"D",DOC)) Q:DOC=""  D
 . I XI#25=0 W " ."
 . S X=$G(^ACHSF(FAC,"D",DOC,0)),Y=$P(X,"^",22),Y2=$P(X,"^",14)
 . I Y2'=FY Q
 . I Y="" Q
 . I $D(^TEMP("ACHSYPCN",Y)) Q
 . S COUNT=COUNT+1
 . S ^TEMP("ACHSYPCN",Y)=""
 . Q
 ;
 W !!!,"Total patients = ",COUNT
 K ^TEMP("ACHSYPCN")
 Q
 ;
GETFAC ;
 W !!!!,"Enter Facility number:   "
 R R:300
 I R="" Q
 I R="Y" D  G GETFAC
 . W ! S FAC="" F  S FAC=$O(^ACHSF("B",FAC)) Q:FAC=""  W !,?4,FAC
 . W !
 . Q
 I '$D(^ACHSF("B",R)) W "  Invalid entry" G GETFAC
 S FAC=R,OK=1
 Q
