ACHSPOS2 ; IHS/ITSC/PMF - TMP DATA FOR DENIAL REASONS AND FORCE ENTRY ;   [ 10/19/2001  10:58 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 S $ZT="ERROR^"_$ZN
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,$ZN,"ENTERED")=NOW
 ;
 I $D(ACHSINST(ACHSVERS,"ERROR")) S ^ACHSINST(ACHSVERS,"ERROR","PREVIOUS ERRORS HAVE NOT BEEN CLEARED")=NOW S XPDABORT=1 Q
 ;
 ;WE ARE ADDING TO THIS FILE NO MATTER WHAT. ALSO KEEP THE OLD ENTRIES
 ;BUT DEACTIVATE THEM
 ;IF FILE CHECKSOK THEN FILE HAS ENTRIES DON'T OVERWRITE
 ;I $$CHECKSOK("") S ^ACHSINST(ACHSVERS,$ZN,"CHS DENIAL REASON DATA FOUND")=NOW W !?15,"'CHS DENIAL REASON' data found! Not overwriting!" Q
 ;
 ;
 N A,B,C
 F A=1:2 S B=$P($T(TAG+A),";;",2) Q:B=""  S @B=$P($T(TAG+(A+1)),";;",2)
 D ^ACHSPOS3     ;SET UP TMP DATA (CONTINUED) 
 ;
 ;DE-ACTIVATE OLD DENIAL REASONS
 S X="T" S %DT="EX" D ^%DT S FMDATE=Y  ;GET TODAY'S FILEMAN DATE
 W !?15,"Old Denial Reasons will be de-activated!"
 S IEN=0
 F  S IEN=$O(^ACHSDENS(IEN)) Q:+IEN=0  D
 .Q:$P($G(^ACHSDENS(IEN,10)),U)'=""  ;QUIT IF REASON ALREADY DEACTIVATED
 .S $P(^ACHSDENS(IEN,10),U)=FMDATE   ;SET 'INACTIVATION DATE'
 ;
 ;
 ;ADD THE DATA TO THE FILE
 D ENTER
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,$ZN,"FINISHED")=NOW
 ;
 Q
ENTER ;PLACE CODE FOR ENTRY TO ^ACHSDENS HERE
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,"ENTER^"_$ZN,"ENTERED")=NOW
 ;
 W !?15,"Adding CHS DENIAL REASON data now...."
 ;
 ;GET LAST DIEN USED FOR DENIAL REASONS
 S LASTDIEN=$O(^ACHSDENS(" "),-1)
 ;
 ;
 S X="^TMP("_$J_",""DEN"")"
 F  S X=$Q(@X) Q:X=""!(X'[("""DEN"""))  D
 .S NEWNODE=$P(X,",",4,99)                 ;GET THE NODE WE WANT TO SET
 .I NEWNODE="0)" S LASTDIEN=LASTDIEN+1     ;IF ITS THE 0 NODE INCREMENT
 .                                         ;THE IEN
 .;I $D(^ACHSDENS(LASTDIEN)) S LASTDIEN=LASTDIEN+1 Q
 .S GLOBAL="^ACHSDENS("_LASTDIEN_","_NEWNODE
 .S @GLOBAL=@X
 S DIK="^ACHSDENS(" D IXALL^DIK
 W !,"Done."
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,"ENTER^"_$ZN,"FINISHED")=NOW
 Q
 ;
 ;RESET 0 NODE AND RETURN NUMBER OF ENTRIES
CHECKSOK(X) ;
 I '$D(^ACHSDENS(0)) S ^ACHSDENS(0)="CHS DENIAL REASON^9002073^0^0"
 S XBCFIXFL=9002073
 D XBCFIXFL^XBCFIX
 Q $G(XBCFIXC)
 Q
 ;
ERROR S ^ACHSINST(ACHSVERS,"ERROR",$ZN,"ERROR TRAP CALLED")=NOW
 G ^%ET
 Q
 ;
TAG ;
 ;;^TMP($J,"DEN",14,0)
 ;;Alternate Resource Available^Alternate Resource Available
 ;;^TMP($J,"DEN",14,1,1,0)
 ;;Our records show that you have health care coverage/resources (such as private insurance, Medicare, Medicaid) available to pay for this
 ;;^TMP($J,"DEN",14,1,2,0)
 ;;medical care. [see 42 Code of Federal Regulations 36.61(c) (1990)]
 ;;^TMP($J,"DEN",14,20,0)
 ;;^9002073.01^2^2
 ;;^TMP($J,"DEN",14,20,1,0)
 ;;Other Coverage Available
 ;;^TMP($J,"DEN",14,20,1,1,1,0)
 ;;Any unpaid balances should be promptly submitted to the Indian Health Service Contract Health Service office for review.
 ;;^TMP($J,"DEN",14,20,2,0)
 ;;Would Have Been Eligible for Other Coverage
 ;;^TMP($J,"DEN",14,20,2,1,1,0)
 ;;You would have been eligible if you had applied and completed the application requirements.
 ;;^TMP($J,"DEN",14,20,3,0)
 ;;May be Eligible for Other Coverage
 ;;^TMP($J,"DEN",14,20,3,1,1,0)
 ;;You may be eligible if apply and complete the application requirements.
 ;;^TMP($J,"DEN",15,0)
 ;;Eligibility Not Established^Eligibility Not Established
 ;;^TMP($J,"DEN",15,1,1,0)
 ;;You have not provided evidence to prove that you are eligible for Contract Health Services (CHS). [see 42 Code of Federal Regulations 36.12 and 36.23 (1986)]
 ;;^TMP($J,"DEN",15,20,0)
 ;;^9002073.01^2^2
 ;;^TMP($J,"DEN",15,20,1,0)
 ;;Indian Descendency Not Established
 ;;^TMP($J,"DEN",15,20,1,1,1,0)
 ;;You did not provide your Certificate of Degree of Indian Blood (CDIB) and/or membership/descendency from a federally recognized tribe.
 ;;^TMP($J,"DEN",15,20,2,0)
 ;;Care for Non-Indian Pregnant Woman
 ;;^TMP($J,"DEN",15,20,2,1,1,0)
 ;;You did not provide a paternity form signed by the father and/or a marriage license.
 ;;^TMP($J,"DEN",16,0)
 ;;No Notification of Emergency Service Within 72 Hours^No Notification of Emergency Service Within 72 Hours
 ;;^TMP($J,"DEN",16,1,1,0)
 ;;You or someone acting on your behalf failed to notify an Indian Health Service official within 72 hours after the beginning of your emergency treatment [see 42 Code of Federal Regulations 36.24(c) (1986)]
 ;;^TMP($J,"DEN",17,0)
 ;;No Prior Approval for Non-Emergency Service^No Prior Approval for Non-Emergency Service
 ;;^TMP($J,"DEN",17,1,1,0)
 ;;You did not obtain prior approval for payment of Contract Health Services (CHS) from the Indian Health Services (IHS) authorizing official approval for this non-emergency care [Per 42 Code of Federal Regulations 36.24(b) (1986)].
 ;;^TMP($J,"DEN",18,0)
 ;;Care Not Within Medical Priority^Care Not Within Medical Priority
 ;;^TMP($J,"DEN",18,1,1,0)
 ;;The medical care you received is not within the CHS medical priorities. Medical priorities must be established when funding is limited. [Per 42 Code of Federal Regulations 36.23(e) (1986)].
