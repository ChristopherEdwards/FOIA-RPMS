APCDAUTL ; IHS/CMI/LAB - misc calls from pcc data entry templates ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
ST(PATIENT,DATE,STDA) ;EP - called from APCD ST (ADD) template to find parent entry 
 NEW X,ERR,E,B,S,STIEN,TEST
 S STIEN=""
 ;when reading is entered
 ;set vars for data fetcher, find last skin test placed within
 ;30 days of date of visit, make sure that one does not have
 ;a reading already
ST1 ;
 Q:$G(DATE)=""
 Q:$G(PATIENT)=""
 Q:$G(STDA)=""
 S TEST=$P(^AUPNVSK(STDA,0),U)
 S B=$$FMTE^XLFDT(DATE,"1D")
 S E=$$FMADD^XLFDT(DATE,-30)
 S E=$$FMTE^XLFDT(E,"1D")
 S X=PATIENT_"^SKIN `"_TEST_";DURING "_E_"-"_B
 S ERR=$$START1^APCLDF(X,"S(")
 I ERR!('$D(S))!('$O(S(0))) Q STIEN
 S X=99999999 F  S X=$O(S(X),-1) Q:X=""!(STIEN)  I +$P(S(X),U,4)'=STDA,$P(^AUPNVSK(+$P(S(X),U,4),0),U,4)="",$P(^(0),U,5)="" S STIEN=+$P(S(X),U,4)
 Q STIEN
