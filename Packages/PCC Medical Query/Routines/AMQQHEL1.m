AMQQHEL1 ; IHS/CMI/THL - CONTINUATION OF AMQQHELP ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
HELP W !!
 I $G(Z)="" W "Sorry, no help message available",*7,!! Q
 F %=1:1 S Y=$E($T(@X+%),4,99) Q:Y=""  D TRANS W Y,! I '(%#(IOSL-5)) W "<>" R X(1):DTIME W $C(13),"      ",$C(13)
 K X,Y,%,Z,I
 Q
 ;
DIAG ;
 ;;You may select one or more 222 or a group of 222 contained
 ;;within a 333 code range.  To select 222 one at a time, enter the 
 ;;name or EXACT 333 CODE.  If the entry is ambiguous, you will be asked to
 ;;select one choice from a group of possible choices.  Since all 222
 ;;are translated into 333 codes prior to the search, I suggest that you
 ;;check the 333 reference book to find out more about standard terminology.
 ;; 
 ;;To select a range of 222, enter the 333 code which corresponds
 ;;to the bottom of the range, followed by a minus sign, followed by
 ;;the code which marks the top of the range: e.g., '444-555'.
 ;; 
 ;;After you enter a 111 or range, you will be prompted for another.
 ;; 
 ;;You will be asked if you want to save your group of choices in a taxonomy file.
 ;;If you wish to save it, you will be prompted to name the taxonomy group.
 ;;If the name has already been used, you will be asked if you wish to
 ;;overwrite the entry. Once a taxonomy group has been named, it can be
 ;;recalled using the "square bracket syntax"; e.g., [BILL'S TAX GROUP]
 ;;Yes, taxonomy group names (in brackets) can be intermixed with 222 and
 ;;ranges.
 ;; 
 ;;Suppose you have selected a range of 222 or a taxonomy group, but
 ;;one or more of the group members is inappropriate.  You can "de-select" an
 ;;entry by typing a minus sign in front of it (e.g., '-444').
 ;;You may use the "minus sign" with ranges but not with square brackets.
 ;;
ANALYZE ;
 ;;You can "screen out" each 111 according to certain criteria.  Screening
 ;;criteria fall into one of 3 groups.
 ;; 
 ;;1) Criteria related to the VISIT on which the 111 was
 ;;recorded; e.g., TYPE, SERVICE CATEGORY, LOCATION
 ;; 
 ;;2) Criteria related to the 111 itself; e.g., 666
 ;; 
 ;;3) Criteria related to other attributes which bear a temporal relationship
 ;;to the visit on which the 111 was made; e.g., a BLOOD SUGAR taken on the
 ;;same visit as the 111, a BLOOD PRESSURE taken during the 3 month period
 ;;after the 111
 ;; 
 ;;   *****  ENTER "??" TO SEE A COMPLETE LISTING OF THE POSSIBLE CHOICES  *****
 ;
TRANS F I=1:1:6 S A=I_I_I F  Q:Y'[A  S Y=$P(Y,A)_$P(Z,U,I)_$P(Y,A,2,99)
 Q
 ;
