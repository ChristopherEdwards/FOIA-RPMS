BEHODMA ;IHS/MSC/PLS - DIRECT Email support;30-Jun-2016 13:40;PLS
 ;;1.1;BEH COMPONENTS;**069001**;Mar 20, 2007
 ;Returns DIRECT email address for patient
 ; Input - Patient IEN (DFN)
 ;Output - String
PTEMADR(DATA,DFN) ;EP-
 S DATA=""
 D PHR^BPHRMUPM(DFN,,,.DATA)
 S DATA=$P(DATA,U,7)
 Q
 ;
