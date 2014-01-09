BARDMLP1 ;IHS/OIT/FCJ - 2 OF 2 ;DEBT MANAGEMENT PRINT LETTERS
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**22**;OCT 26, 2005;Build 38
 ;New routine 5-12-2011 for Debt Letter Management
 ;
 ;Routine to print letters
PRINT ;EP
 ;W @IOF  ;bar*1.8*22 SDR
 W $$EN^BARVDF("IOF")  ;bar*1.8*22 SDR
 K ^UTILITY($J,"W")  ;bar*1.8*22 SDR
 S DIWL=BARMRGL,DIWR=75
 S DIWF="W"  ;bar*1.8*22 SDR
 D HDR
 ;start old code bar*1.8*22 SDR
 ;S R=0
 ;F  S R=$O(^BAR(90052.03,BARPCP(CY),1,R)) Q:R'?1N.N  D
 ;.S X=^BAR(90052.03,BARPCP(CY),1,R,0)
 ;end old code start new code
 S BARR=0
 F  S BARR=$O(^BAR(90052.03,BARPCP(CY),1,BARR)) Q:BARR'?1N.N  D
 .S X=^BAR(90052.03,BARPCP(CY),1,BARR,0)
 .;end new code
 .I X["TODAY" D DT Q
 .I X["BARINS" D LTOP Q
 .I X["BARFAC" D LFAC Q
 .I X["BARSTF" D LBOT Q
 .I X["BARSIG" D LSIG Q
 .D ^DIWP
 Q
HDR ;PRINT HEADER 
 F I1=1:1:BARMRGT S X="" D ^DIWP,^DIWW
 ;S X=$P(^BAR(90052.03,BARPCP(CY),0),U,2) D ^DIWP,^DIWW  ;bar*1.8*22 SDR
 S X=$P(^BAR(90052.03,BARPCP(CY),0),U,2) D ^DIWP,^DIWW  ;bar*1.8*22 SDR
 Q
DT ;
 I BARRPT="R" S X="Date: "_BARDTP
 D ^DIWP
 Q
LTOP ;TOP OF LETTER
 S X=BARDM("INS_NM") D ^DIWP,^DIWW
 S X=BARDM("INS_STR") D ^DIWP,^DIWW
 ;S X=BARDM("INS_CTY")_", "_$P(^DIC(5,BARDM("INS_ST"),0),U,2)_"  "_BARDM("INS_ZP") D ^DIWP,^DIWW  ;bar*1.8*22 SDR
 S X=BARDM("INS_CTY")_", "_$S(BARDM("INS_ST")'="":$P(^DIC(5,BARDM("INS_ST"),0),U,2),1:"  ")_"  "_BARDM("INS_ZP") D ^DIWP,^DIWW  ;bar*1.8*22 SDR
 I BARDACG="AUTNINS(" S X="TIN: "_BARDM("INS_TX") D ^DIWP
 E  S X="" D ^DIWP
 S X="" D ^DIWP
 I BARDACG="AUTNINS(" D
 .;S X="Re: Policy Holder: "_BARDM("POL_HOLDER")_LEN  ;bar*1.8*22 SDR
 .S X="Re: Policy Holder: "_BARDM("POL_HOLDER")_BARLEN  ;bar*1.8*22 SDR
 .S X=$E(X,1,40)_" Policy #: "_BARDM("POL_NUM") D ^DIWP
 .;S X="    Patient: "_BARPAT_LEN  ;bar*1.8*22 SDR
 .S X="    Patient: "_BARPAT_BARLEN  ;bar*1.8*22 SDR
 .S X=$E(X,1,40)_" Date of Service: "_BARDM("DOS") D ^DIWP
 E  S BARDACG="AUPNPAT(" S X="Re: Date of Service: "_BARDM("DOS") D ^DIWP
 ;S X="    Bill Number: "_BARBILN_LEN S X=$E(X,1,40)_" Bill Amount: "_BARAMTO D ^DIWP  ;bar*1.8*22 SDR
 S X="    Bill Number: "_BARBILN_BARLEN S X=$E(X,1,40)_" Bill Amount: "_BARAMTO D ^DIWP  ;bar*1.8*22 SDR
 ;start new code bar*1.*22 SDR
 S X=""
 I BARPDOB="YES" D
 .S X="    Patient DOB: "_BARDOB_BARLEN D ^DIWP,^DIWW
 S X=""
 I BARPNPI="FACILITY" D
 .S X="    Facility NPI: "_BARNPIF
 I BARPNPI="PROVIDER" D
 .S X="    Provider NPI: "_BARNPIP
 I BARPNPI["BOTH" D
 .S X=$S(BARNPIP>0:"    Provider NPI: "_BARNPIP_BARLEN,1:"          "_BARLEN)
 .S X=$S(BARNPIF>0:$E(X,1,40)_" Facility NPI: "_BARNPIF,1:"")
 ;end new code bar*1.8*22 SDR
 I X'="" D ^DIWP
 ;end new code
 F I1=1:1:2 S X="" D ^DIWP
 ;I L="CYCLE 4" S X="Dear Area Claims Collection Officer:" D ^DIWP  ;bar*1.8*22 SDR
 I $G(BARL)="CYCLE 4" S X="Dear Area Claims Collection Officer:" D ^DIWP  ;bar*1.8*22 SDR
 ;start old code bar*1.8*22 SDR
 ;E  I BARMIN=0 S X="Dear "_BARDM("INS_NM")_":" D ^DIWP
 ;E  I BARMIN=1 S X="To the Guardian of "_BARDM("INS_NM")_":" D ^DIWP
 ;end old code start new code
 E  I BARMIN=1 S X="Dear "_BARDM("INS_NM")_":" D ^DIWP
 E  I BARMIN=0 S X="To the Guardian of "_BARDM("INS_NM")_":" D ^DIWP
 ;end new code
 Q
LFAC ;FAC SET
 S X="     "_BARFAC D ^DIWP
 S X="     "_BARAD1 D ^DIWP
 I BARAD2 S X="     "_BARAD2 D ^DIWP
 S X="     "_BARCTY_", "_$P(^DIC(5,BARST,0),U,2)_" "_BARZP D ^DIWP
 Q
LBOT ;BOTTEM OF LETTER
 ;I L="CYCLE 4" S X=$P(X,"BARPH",1)_BARPH_"."  ;bar*1.8*22 SDR
 I $G(BARL)="CYCLE 4" S X=$P(X,"BARPH",1)_BARPH_"."  ;bar*1.8*22 SDR
 E  S X=$P(X,"BARSTF",1)_BARSG_" at "_BARPH_"."
 D ^DIWP,^DIWW
 Q
LSIG ;SIGNATURE LINES
 S SG=$P(X,"BARSIG")
 S X=SG_BARSG D ^DIWP
 I $D(BARSG1) S X=SG_BARSG1 D ^DIWP
 I $D(BARSG2) S X=SG_BARSG2 D ^DIWP
 D ^DIWW
 Q
