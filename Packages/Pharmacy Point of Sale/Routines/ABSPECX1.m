ABSPECX1 ; IHS/FCS/DRS - JWS 03:35 PM 6 Jun 1995 ;   [ 09/12/2002  10:00 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,42**;JUN 21, 2001;Build 15
 ;----------------------------------------------------------------------
 ;Create new Claim ID for Claim Submission file (9002313.02)
 ;
 ;Input Variables:   NRDEFIEN  - NCPDP Record Definitions IEN
 ;                               (9002313.92)
 ;
 ;Function Returns:  String:  C<YY>-<BBBBBB>-<NNNNN>
 ;                         C can also be P or other ORIGIN code.
 ;                         See remarks a few lines below about ORIGIN
 ;                   Where:   <YY> is the year
 ;                            <BBBBBB> is the BIN number of the payor
 ;                            <NNNNN> is a 5-digit sequence number
 ;----------------------------------------------------------------------
 ; Also called from old Alaska Medicaid batch method,
 ; regrettably still in use at one site, but we're going to
 ; phase it out someday.
 ;
 ;  ORIGIN argument added 08/23/2000
 ;     Can specify the leading character of the claim ID.
 ;     Defaults to "C".
 ;     Point of sale sends in "P"
 ;   09/20/2000 - can override by setting ABSPECX1("PREFIX")=letter
 ;     (Do this if you change the batch file to submit via POS)
 ;
 ;  Also changed 08/23/2000:  Sequence number is now 6 digits
 ;  and the first number assigned is 100000.  As of yesterday, ANMC
 ;  is already up to almost 40000.
 ;  Can't change length in the middle of the year or the $O(,-1) is
 ;  messed up.   So the code will adapt - if it finds 5-digit format
 ;  already there, it will assign new numbers with 5 digits.
 ;
CLAIMID(NRDEFIEN,ORIGIN) ;EP - Called from ABSPOSCE from ABSPOSCA from ABSPOSQG from ABSPOSQ2
 N BIN,SEQNUM,ROOT,LAST
 I '$D(ORIGIN) S ORIGIN="C"
 I $G(ABSPECX1("PREFIX"))?1U S ORIGIN=ABSPECX1("PREFIX")
 ;IHS/OIT/CASSEVER/RAN patch 42 03/30/2011 For new claims process
 ;Get and format BIN number for the electronic payor
 I NRDEFIEN=1 S BIN=$P(^ABSPEI(ABSP("Insurer","IEN"),100),U,16)
 ELSE  S BIN=$P($G(^ABSPF(9002313.92,NRDEFIEN,1)),U,1)
 S BIN=$$NFF^ABSPECFM(BIN,6)
 ;
 ;Establish the root for the claim id number
 S ROOT=ORIGIN_$E(DT,2,3)_"-"_BIN_"-" ; 11 characters long
 ;
 ;Get last claim id number with the same root
 S LAST=$O(^ABSPC("B",ROOT_"Z"),-1)
 ; Reversal claim ID?  Get rid of the suffix R#
 ; ABSP*1.0T7*6    could be #>9, in which case the old logic fails!
 ; ABSP*1.0T7*6    replaced the line that strips off the R#
 ;I $L(LAST)>6,LAST?.E1"R"1N S LAST=$E(LAST,1,$L(LAST)-2) ;ABSP*1.0T7*6
 I $L(LAST)>6,LAST?.E1"R"1.N S $P(LAST,"-",3)=+$P(LAST,"-",3) ;ABSP*1.0T7*6
 ;
 ;Set and format sequence number
 S SEQNUM=$S($E(LAST,1,11)=ROOT:(+$P(LAST,"-",3))+1,1:0)
 N SEQLEN
 ;  5 or 6 digit numbers?  Depends on what's there already? 
 ;  Six digits is what we really want, but upgrades will be trickier.
 ; New installs and ANMC 2001 will have 6 digits.
 ;
 I SEQNUM=0 S SEQLEN=6,SEQNUM=100000
 E  S SEQLEN=$L($P(LAST,"-",3))
 I SEQLEN<5 D IMPOSS^ABSPOSUE("DB,P","TI",LAST,,"SEQLEN<5",$T(+0)) ; internal error
 I SEQLEN>6 D IMPOSS^ABSPOSUE("DB,P","TI",LAST,,"SEQLEN>6",$T(+0)) ; internal error
 I $L(SEQNUM)=SEQLEN,SEQNUM?."9" D
 . D IMPOSS^ABSPOSUE("DB,P","T",LAST,,"OVERFLOWED!",$T(+0))
 I SEQLEN=5 S SEQNUM=$TR($J(SEQNUM,SEQLEN)," ","0") ; pad w/leading 0s
 I $L(SEQNUM)'=SEQLEN D  ; internal error
 . D IMPOSS^ABSPOSUE("DB,P","TI",LAST,SEQLEN,"length",$T(+0))
 ;
 Q ROOT_SEQNUM
