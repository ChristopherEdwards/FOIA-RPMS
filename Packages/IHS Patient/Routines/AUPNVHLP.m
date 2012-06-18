AUPNVHLP ; IHS/CMI/LAB - HELP FOR V FILES ; 22 Mar 2010  10:33 AM
 ;;2.0;IHS PCC SUITE;**2,4**;MAY 14, 2009
 ;
V4114 ;EP - help for file .41, field .14
 D EN^DDIOL("Asthma 'Control' is assessed at each visit and determines ongoing",,"!!")
 D EN^DDIOL("management.  Asthma control is defined as: a) well controlled, b) not",,"!")
 D EN^DDIOL("well controlled, or c) very poorly controlled, based on the patient's",,"!")
 D EN^DDIOL("current and recent symptoms, and the need for oral steroid treatment.",,"!")
 Q
INRG ;EP - help for file .51 field inr goal
 D EN^DDIOL("The INR Goal indicates the ratio at which anticoagulation therapy is",,"!")
 D EN^DDIOL("directed.  The INR goal is defined as a minimum INR value (range 2-3)",,"!")
 D EN^DDIOL("and maximum INR value (range 304).  You can use .5 integers, such as",,"!")
 D EN^DDIOL("2, 2.5, 3, 3.5, and 4.  An example is 2.5/4.",,"!")
 Q
INRDUR ;EP - help for file .51, field duration
 D EN^DDIOL("Indications for warfarin often have explicit durations of therapy that",,"!!")
 D EN^DDIOL("occur at 3 months, 6 months, or 1 year. The duration can also be indefinite.",,"!")
 D EN^DDIOL("You can enter 3, 6, or 1, which indicates t+91d, t+182d, t+365d. Enter IND or",,"!")
 D EN^DDIOL("leave this field blank to indicate an indefinite time period.",,"!")
 Q
DTSD ;EP - help for file .51, field start date
 Q
EN1(Y,DA) ;EP -  INPUT TRANSFORM FOR NAME (.01) FIELD OF QUALIFIER
 ; SUB-FILE OF V MEASUREMENT  FILE.
 ;   Input variables:  Y is entry in 120.52 being looked up
 ;                     DA is entry in V MEASUREMENT where Qualifier data
 ;                        is being selected.
 ;   Function value: 1 if can select this Qualifier, else 0.
 ;
 N GMRVFXN,GMRVTYP S GMRVFXN=0
 S GMRVTYP=$P($G(^AUPNVMSR(DA,0)),"^",1)
 I GMRVTYP>0,$D(^GMRD(120.52,"C",GMRVTYP,+Y)) S GMRVFXN=1
 Q GMRVFXN
 ;
