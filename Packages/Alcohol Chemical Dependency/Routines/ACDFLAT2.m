ACDFLAT2 ;IHS/ADC/EDE/KML - GENERATE FLAT RECORDS;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ; This routine generates flat ascii records from one cdmis visit.
 ;
FLAT(ACDVIEN,ACDARRAY) ; EP-SET FLAT RECORDS INTO ARRAY
 ; i $$flat^acdflat2(cdmis_visit_ien,.array_name) then flat records
 ; will be in array_name(n)=flat_record where n=1:1 and Q value will
 ; be the number of entries in array_name.
 ;
 ; fields set into array so flat record can be built left to right
 ; which is a must if any value shorter than specified by set $E
 ;
 NEW ACDFREC,ACDN0,ACDRCTR,X,Y
 S ACDRCTR=0
 G:'$D(^ACDVIS(ACDVIEN,0)) FLATX  ;      corrupt database or bad ptr
 S ACDN0=^ACDVIS(ACDVIEN,0)
 K ACDARRAY,ACDF ;             kill caller array + local field array
 S ACDF(1,6)=ACD6DIG ;                       asufac code
 S ACDF(7,13)=$P(ACDN0,U) ;                  visit date
 S Y=$P(ACDN0,U,2) ;                         component ptr
 S:Y ACDF(14,16)=$P($G(^ACDCOMP(Y,0)),U,2) ; component code
 S ACDF(17)=$P(ACDN0,U,7) ;                  component type
 S ACDF(18,19)=$P(ACDN0,U,4) ;               type contact
 S Y=$P(ACDN0,U,3) ;                         primary provider ptr
 S:Y ACDF(127,132)=$P($G(^VA(200,Y,9999999)),U,9) ; adc
 ;S:Y ACDF(127,132)=$P($G(^DIC(6,Y,9999999)),U,9) ; adc
 ;
 D PATIENT ;                           set patient related fields
 ;
 D FILESFT ;                           do file shift for rest of data
 ;
FLATX ; EXIT
 Q ACDRCTR
 ;
PATIENT ; PATIENT RELATED FIELDS
 NEW ACDPIEN
 S ACDPIEN=$P(ACDN0,U,5) ;                 patient pointer
 Q:'ACDPIEN  ;                             no patient pointer
 Q:'$D(^DPT(ACDPIEN,0))  ;                 corrupt database
 Q:'$D(^AUPNPAT(ACDPIEN,0))  ;             corrupt database
 S ACDF(20,31)=$$ENC^AUPNPAT(ACDPIEN) ;    patient id
 S ACDF(32)=$P(^DPT(ACDPIEN,0),U,2) ;      sex
 S ACDF(33,39)=$P(^DPT(ACDPIEN,0),U,3) ;   dob
 S Y=$P($G(^AUPNPAT(ACDPIEN,11)),U,17) ;   community ptr
 S:Y ACDF(40,46)=$P($G(^AUTTCOM(Y,0)),U,8) ; stctycom code
 S Y=$P($G(^AUPNPAT(ACDPIEN,11)),U,8) ;    tribe ptr
 S:Y ACDF(47,49)=$P($G(^AUTTTRI(Y,0)),U,2) ; tribe code
 ;
 NEW ACDVDT
 S ACDVDT=$P(ACDN0,U)
 S X=$$MCR^AUPNPAT(ACDPIEN,ACDVDT)
 S ACDF(50)=$S(X:"Y",1:"N") ;              medicare eligible
 S X=$$MCD^AUPNPAT(ACDPIEN,ACDVDT)
 S ACDF(51)=$S(X:"Y",1:"N") ;              medicaid eligible
 S X=$$PI^AUPNPAT(ACDPIEN,ACDVDT)
 S ACDF(52)=$S(X:"Y",1:"N") ;              private insurance
 Q
 ;
FILESFT ; SHIFT TO SUBORDINATE FILE FOR REST OF DATA
 D FILESFT^ACDFLAT3
 Q
