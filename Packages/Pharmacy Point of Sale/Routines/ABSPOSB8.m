ABSPOSB8 ; IHS/FCS/DRS - some debugging assistance ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; Situation:  the insurance changes and the PINS node is no longer 
 ; valid - look for cases where the 9002313.57 primary insurance
 ; differs from the PCNDFN AUDIT INSURER
 ; This may be the seed of what eventually becomes a tool
 ; for "backsweeping", finding patients who do have insurance after all,
 ; even though they didn't have insurance at the time of the         
 ; original charge
FINDX(START57,END57)         ;
 I '$D(END57) S END57=$P(^ABSP(9002313.99,1,"BILLING"),U)
 N N57 F N57=START57:1:END57 D
 . N INS57,INSNAME,PCNDFN,AUDITINS
 . S INS57=$P($G(^ABSPTL(N57,7)),U)
 . I 'INS57 D  Q
 . . W "No primary insurance with N57=",N57,! ; should never happen
 . S INSNAME=$P(^AUTNINS(INS57,0),U)
 . S PCNDFN=$P(^ABSPTL(N57,0),U,3)
 . I 'PCNDFN Q  ; not posted
 . S AUDITINS=$P(^ABSBITMS(9002302,PCNDFN,0),U,3)
 . I INSNAME'=AUDITINS D
 . . W "Insurance mismatch on N57=",N57," posted to "
 . . W $P(^ABSBITMS(9002302,PCNDFN,"VCN"),U)," "
 . . W $P(^ABSBITMS(9002302,PCNDFN,0),U)," "
 . . W $P(^DPT($P(^(0),U,2),0),U)
 . . W !
 . . W "Pharmacy program picked ",INSNAME," but now it's ",AUDITINS,!
 . Q
 Q
