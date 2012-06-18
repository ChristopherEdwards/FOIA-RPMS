BQITRACB ;PRXM/HC/ALA-Treatment Prompt for ACEI or ARB ; 22 May 2007  10:56 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
ACB(BQDFN,BQRM) ;EP - Ace Inhibitor or ARB CVD.TP-17
 ; Input
 ;   BQDFN - Patient IEN
 ;
 ; If it didn't meet the criteria of NOT on ACEI or ARB, then quit
 ;
 NEW ACT,X,COND,BQI,QFL,BN,LBN,LAST,DDESC,X1,X2,BI
 S ACT=0
 ;S X1=$$TAX^BQITRUTL("T-12M","BGP HYPERTENSION DXS",1,BQDFN,9000010.07)
 ;S X2=$$TAX^BQITRUTL("","BGP HYPERTENSION DXS",2,BQDFN,9000010.07,1,0)
 S X=$$TAX^BQITRUTL("","BGP HYPERTENSION DXS",2,BQDFN,9000010.07,1,0)
 I $P(X,U,1)=1 D
 . NEW BQVDTM,BQDATA,OK,BQVIS
 . ; I visit is blank, then this is an active problem
 . I $P(X,U,3)="",$P(X,U,4)'="" S ACT=ACT+1,COND(ACT)="HTN" Q
 . S BQVDTM=$$DATE^BQIUL1("T-12M"),BQDATA=$P(X,U,2),OK=0
 . F BI=1:1:$L(BQDATA) I $P(BQDATA,";",BI)'<BQVDTM S OK=1
 . I 'OK Q
 . S ACT=ACT+1,COND(ACT)="HTN"
 ;
 S X=$$BP^BQITRUTL("T-24M",BQDFN,140,90,"'<")
 I $P(X,U,1)=1 S ACT=ACT+1,COND(ACT)="High BP"
 ;
 D
 . S X=$$TAX^BQITRUTL("T-24M","BGP NEPHROPATHY CPTS",1,BQDFN,9000010.18)
 . I $P(X,U,1)=1 S ACT=ACT+1,COND(ACT)="Nephropathy" Q
 . S X=$$TAX^BQITRUTL("T-24M","BGP NEPHROPATHY PROCEDURES",1,BQDFN,9000010.08)
 . I $P(X,U,1)=1 S ACT=ACT+1,COND(ACT)="Nephropathy" Q
 . S X=$$TAX^BQITRUTL("T-24M","BGP NEPHROPATHY DXS",2,BQDFN,9000010.07,1,0)
 . I $P(X,U,1)=1 S ACT=ACT+1,COND(ACT)="Nephropathy" Q
 ;
 ;  Check for positive microalbuminuria tests in the last year
 D
 . S X=$$LAB^BQITRUTL("T-12M",0,BQDFN,"DM AUDIT MICROALBUMINURIA TAX","POS","=")
 . I $P(X,U,1)=1 S ACT=ACT+1,COND(ACT)="Positive microalbuminuria" Q
 . S X=$$LAB^BQITRUTL("T-12M",0,BQDFN,"BGP MICROALBUM LOINC CODES","POS","=")
 . I $P(X,U,1)=1 S ACT=ACT+1,COND(ACT)="Positive microalbuminuria"
 ;
 S X=$$LAB^BQITRUTL("T-12M",1,BQDFN,"BGP GPRA ESTIMATED GFR TAX",60,"<")
 I $P(X,U,1)=1 S ACT=ACT+1,COND(ACT)="Est GFR < 60"
 ;
 ;Update the remarks
 I ACT=0 K BQRM Q 0_U_"No applicable conditions"
 ;
 I ACT>0 D
 . S BN=0,DDESC=""
 . F  S BN=$O(BQRM(BN)) Q:BN=""  D
 .. I BQRM(BN)["|" D
 ... S LBN=$O(BQRM(BN)),LAST=BQRM(LBN)
 ... S BI=0 F  S BI=$O(COND(BI)) Q:BI=""  D
 .... S BQRM(BN)=$C(10)_"   "_COND(BI),BN=BN+1,DDESC=DDESC_COND(BI)_"; "
 . S BN=$O(BQRM(BN),-1)
 . I BN'="",BQRM(BN)'=LAST S BN=BN+1,BQRM(BN)=LAST
 Q 1_U_DDESC
